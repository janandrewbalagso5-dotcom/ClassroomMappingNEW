Imports System
Imports System.Collections.Generic
Imports System.Linq
Imports System.Text
Imports System.Web.UI

Partial Class ClassroomSchedule
    Inherits System.Web.UI.Page

    Private ReadOnly Property TimeSlots As String()
        Get
            Return Database.TimeSlots
        End Get
    End Property

    ' ── Role / User helpers ──
    Private ReadOnly Property CurrentRole As String
        Get
            Return AuthHelper.GetRole(Me)
        End Get
    End Property

    Private ReadOnly Property CurrentUserID As Integer
        Get
            Return AuthHelper.GetUserID(Me)
        End Get
    End Property

    ' ── Page Load ───
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        AuthHelper.Require(Me, "Admin", "Dean", "Instructor")

        ' Logout handler
        AddHandler btnLogout.Click, AddressOf btnLogout_Click

        If Not IsPostBack Then
            lblWelcome.Text = "Welcome, " & AuthHelper.GetFullName(Me) & "!"
            lblRoleBadge.Text = CurrentRole

            ' Dean cannot see Manage Users button
            ' btnUsers.Visible = (CurrentRole = "Admin")

            RenderBothGrids()
            InjectDropdownData()
        End If
    End Sub

    Protected Sub btnLogout_Click(sender As Object, e As EventArgs)
        AuthHelper.ClearSession(Me)
        Response.Redirect("Login.aspx")
    End Sub

    ' ── Grid Action (Save/Delete) ──
    Protected Sub btnCellAction_Click(sender As Object, e As EventArgs) Handles btnCellAction.Click
        Dim action As String = hfAction.Value
        Dim room As String = hfRoom.Value
        Dim time As String = hfTime.Value
        Dim dayType As String = hfDayType.Value

        If action = "delete" Then
            Dim id As Integer = 0
            Integer.TryParse(hfScheduleID.Value, id)
            If id > 0 Then
                Database.DeleteSchedule(id)
                lblMsg.Text = "🗑 entry removed."
                lblMsg.CssClass = "msg-success"
            End If
        ElseIf action = "save" Then
            Dim subject As String = hfSubject.Value
            Dim section As String = hfSection.Value
            Dim instructor As String = hfInstructor.Value
            Dim schedID As Integer = 0
            Integer.TryParse(hfScheduleID.Value, schedID)

            ' --- Conflict Detection ---
            Dim allSchedules = Database.GetAllSchedules()

            ' 1. Room conflict (same time/room/day)
            Dim rc = allSchedules.Find(Function(s) s.RoomNo = room AndAlso s.TimeSlot = time AndAlso s.DayType = dayType AndAlso s.ScheduleID <> schedID)
            If rc IsNot Nothing Then
                ShowConflict("Room " & room & " is already occupied by " & rc.SubjectCode & " (" & rc.CourseSection & ") at this time.")
                Return
            End If

            ' 2. Instructor conflict (same instructor teaching elsewhere)
            Dim ic = allSchedules.Find(Function(s) s.InstructorName = instructor AndAlso s.TimeSlot = time AndAlso s.DayType = dayType AndAlso s.ScheduleID <> schedID)
            If ic IsNot Nothing Then
                ShowConflict("Instructor " & instructor & " is already teaching " & ic.SubjectCode & " in Room " & ic.RoomNo & " at this time.")
                Return
            End If

            ' 3. Section conflict (same section having class elsewhere)
            Dim sc = allSchedules.Find(Function(s) s.CourseSection = section AndAlso s.TimeSlot = time AndAlso s.DayType = dayType AndAlso s.ScheduleID <> schedID)
            If sc IsNot Nothing Then
                ShowConflict("Section " & section & " already has a class (" & sc.SubjectCode & ") in Room " & sc.RoomNo & " at this time.")
                Return
            End If

            If schedID > 0 Then
                ' UPDATE
                Dim existing = Database.GetScheduleByID(schedID)
                If existing IsNot Nothing Then
                    existing.RoomNo = room
                    existing.TimeSlot = time
                    existing.DayType = dayType
                    existing.SubjectCode = subject
                    existing.CourseSection = section
                    existing.InstructorName = instructor
                    Database.UpdateSchedule(existing)
                End If
            Else
                ' INSERT
                Dim s As New Schedule With {
                    .RoomNo = room,
                    .TimeSlot = time,
                    .DayType = dayType,
                    .SubjectCode = subject,
                    .CourseSection = section,
                    .InstructorName = instructor
                }
                Database.AddSchedule(s)
            End If

            lblMsg.Text = "✔ schedule updated."
            lblMsg.CssClass = "msg-success"
        End If

        RenderBothGrids()
        InjectDropdownData()
    End Sub

    Private Sub ShowConflict(msg As String)
        lblMsg.Text = "❌ " & msg
        lblMsg.CssClass = "msg-error"
        ' We must re-render/re-inject so the page stays valid
        RenderBothGrids()
        InjectDropdownData()
    End Sub

    ' ── RENDER ─────────────────────────────────────────────────────────────

    Private Sub RenderBothGrids()
        Dim sb As New StringBuilder()
        sb.Append("<h3 class='floor-label'>Ground Floor</h3>")
        sb.Append(BuildGrid(New String() {"101", "102", "103", "104", "105", "106", "107", "108", "109", "110", "111", "112"}))

        sb.Append("<h3 class='floor-label'>Floor 2</h3>")
        sb.Append(BuildGrid(New String() {"205", "206 (LAB)", "207 (LAB)", "208", "209", "210", "211", "212"}))

        sb.Append("<h3 class='floor-label'>Floor 3</h3>")
        sb.Append(BuildGrid(New String() {"301", "302", "303", "304", "305", "306", "307", "308", "309", "310", "311", "312"}))

        litGrid.Text = sb.ToString()
    End Sub

    Private Function BuildGrid(rooms As String()) As String
        Dim allSchedules = Database.GetAllSchedules()
        Dim lookup As New Dictionary(Of String, Dictionary(Of String, Schedule))()

        For Each r In rooms
            lookup(r) = New Dictionary(Of String, Schedule)()
        Next

        For Each sched In allSchedules
            If lookup.ContainsKey(sched.RoomNo) Then
                lookup(sched.RoomNo)(sched.TimeSlot & "|" & sched.DayType) = sched
            End If
        Next

        Dim sb As New StringBuilder()
        sb.Append("<table class='sched-table'><thead><tr><th>Room</th>")
        For Each ts In TimeSlots
            sb.AppendFormat("<th colspan='2'>{0}</th>", ts)
        Next
        sb.Append("</tr><tr><th></th>")
        For Each ts In TimeSlots
            sb.Append("<th class='day-sub'>MWF</th><th class='day-sub'>TTH</th>")
        Next
        sb.Append("</tr></thead><tbody>")

        For Each rm In rooms
            sb.AppendFormat("<tr><td class='room-col'>Room {0}</td>", rm)
            For Each ts In TimeSlots
                ' MWF
                sb.Append(RenderCell(rm, ts, "MWF", lookup))
                ' TTH
                sb.Append(RenderCell(rm, ts, "TTH", lookup))
            Next
            sb.Append("</tr>")
        Next

        sb.Append("</tbody></table>")
        Return sb.ToString()
    End Function

    Private Function RenderCell(room As String, time As String, dayType As String, lookup As Dictionary(Of String, Dictionary(Of String, Schedule))) As String
        Dim key As String = time & "|" & dayType
        Dim s As Schedule = If(lookup(room).ContainsKey(key), lookup(room)(key), Nothing)
        Dim cellId As String = "c_" & room.Replace(" ", "").Replace("(", "").Replace(")", "") & "_" & time.Replace(":", "").Replace("-", "") & "_" & dayType

        Dim html As New StringBuilder("<td id='" & cellId & "' class='sched-cell'>")

        If s IsNot Nothing Then
            html.AppendFormat("<div class='cell-display occupied' onclick=""openEditor('{0}','{1}','{2}','{3}','{4}','{5}',{6},'{7}')"">",
                cellId, JsStr(room), JsStr(time), JsStr(s.SubjectCode), JsStr(s.CourseSection), JsStr(s.InstructorName), s.ScheduleID, dayType)
            html.AppendFormat("<strong>{0}</strong><br/>{1}<br/><em>{2}</em>",
                s.SubjectCode, s.CourseSection, s.InstructorName)
            html.Append("</div>")
        Else
            html.AppendFormat("<div class='cell-display free' onclick=""openEditor('{0}','{1}','{2}','','','',{3},'{4}')"">",
                cellId, JsStr(room), JsStr(time), 0, dayType)
            html.Append("<span class='plus'>+</span>")
            html.Append("</div>")
        End If

        ' The editor div (hidden by default)
        html.Append("<div class='cell-editor' style='display:none;'>")
        html.Append("<select class='sel-subj'><option value=''>— Subject —</option></select>")
        html.Append("<select class='sel-sec'><option value=''>— Section —</option></select>")
        html.Append("<select class='sel-inst'><option value=''>— Instr —</option></select>")
        html.Append("<div class='cell-actions'>")
        html.AppendFormat("<button type='button' class='btn-save' onclick=""saveCell('{0}','{1}',{2},'{3}','{4}')"">Save</button>",
            cellId, JsStr(room), If(s IsNot Nothing, s.ScheduleID, 0), JsStr(time), dayType)
        If s IsNot Nothing Then
            html.AppendFormat("<button type='button' class='btn-del' onclick=""clearCell('{0}','{1}','{2}',{3})"">🗑</button>",
                cellId, JsStr(room), JsStr(time), s.ScheduleID)
        End If
        html.AppendFormat("<button type='button' class='btn-can' onclick=""closeEditor('{0}')"">✕</button>", cellId)
        html.Append("</div></div>")

        html.Append("</td>")
        Return html.ToString()
    End Function

    ' ── JSON DATA INJECTION ────────────────────────────────────────────────

    Private Sub InjectDropdownData()
        Dim subjectJson As New StringBuilder("[")
        Dim instructorJson As New StringBuilder("[")
        Dim sectionJson As New StringBuilder("[")
        Dim instMapJson As New StringBuilder("{")

        Dim allSubjects As List(Of Subject) = Database.GetAllSubjects()
        Dim allSchedules As List(Of Schedule) = Database.GetAllSchedules()
        Dim allInstructors As List(Of Instructor) = Database.GetAllInstructors().OrderBy(Function(i) i.Name).ToList()

        ' ── Build instructorMap ───
        Dim mapSubjects As New Dictionary(Of String, HashSet(Of String))(StringComparer.OrdinalIgnoreCase)
        Dim mapSections As New Dictionary(Of String, HashSet(Of String))(StringComparer.OrdinalIgnoreCase)
        Dim mapSubjLabel As New Dictionary(Of String, String)(StringComparer.OrdinalIgnoreCase)

        For Each subj As Subject In allSubjects
            If Not mapSubjLabel.ContainsKey(subj.Code) Then
                mapSubjLabel(subj.Code) = subj.Code & " - " & subj.Description
            End If
            If subj.AssignedInstructorID.HasValue Then
                Dim inst = allInstructors.Find(Function(i) i.InstructorID = subj.AssignedInstructorID.Value)
                If inst IsNot Nothing Then
                    If Not mapSubjects.ContainsKey(inst.Name) Then mapSubjects(inst.Name) = New HashSet(Of String)(StringComparer.OrdinalIgnoreCase)
                    If Not mapSections.ContainsKey(inst.Name) Then mapSections(inst.Name) = New HashSet(Of String)(StringComparer.OrdinalIgnoreCase)
                    mapSubjects(inst.Name).Add(subj.Code)
                    If Not String.IsNullOrEmpty(subj.CourseCode) Then
                        mapSections(inst.Name).Add(BuildSectionLabel(subj.CourseCode, subj.YearLevel, subj.Section))
                    End If
                End If
            End If
        Next

        ' For Instructors, only show themselves and their own assignments
        If CurrentRole = "Instructor" Then
            Dim linkedID = AuthHelper.GetLinkedInstructorID(Me)
            Dim meInst = allInstructors.Find(Function(i) i.InstructorID = linkedID)
            If meInst IsNot Nothing Then
                instructorJson.AppendFormat("{{""value"":""{0}"",""label"":""{0}""}},", JsStr(meInst.Name))
                If mapSubjects.ContainsKey(meInst.Name) Then
                    For Each scode In mapSubjects(meInst.Name)
                        subjectJson.AppendFormat("{{""value"":""{0}"",""label"":""{1}""}},", JsStr(scode), JsStr(mapSubjLabel(scode)))
                    Next
                End If
                If mapSections.ContainsKey(meInst.Name) Then
                    For Each sname In mapSections(meInst.Name)
                        sectionJson.AppendFormat("""{0}"",", JsStr(sname))
                    Next
                End If
            End If
        Else
            ' Admin/Dean — Full Lists
            For Each scode In mapSubjLabel.Keys
                subjectJson.AppendFormat("{{""value"":""{0}"",""label"":""{1}""}},", JsStr(scode), JsStr(mapSubjLabel(scode)))
            Next
            For Each inst In allInstructors
                instructorJson.AppendFormat("{{""value"":""{0}"",""label"":""{0}""}},", JsStr(inst.Name))
            Next
            Dim sectionSet As New HashSet(Of String)(StringComparer.OrdinalIgnoreCase)
            For Each cs In Database.GetAllCourseSections() : sectionSet.Add(cs.DisplayName) : Next
            For Each s In allSubjects
                If s.CourseCode <> "" Then sectionSet.Add(BuildSectionLabel(s.CourseCode, s.YearLevel, s.Section))
            Next
            For Each sec In sectionSet.OrderBy(Function(x) x)
                sectionJson.AppendFormat("""{0}"",", JsStr(sec))
            Next
        End If

        ' Build the final instructorMap JSON
        For Each instName In mapSubjects.Keys
            instMapJson.AppendFormat("""{0}"":{{""subjects"":[", JsStr(instName))
            For Each scode In mapSubjects(instName)
                instMapJson.AppendFormat("{{""value"":""{0}"",""label"":""{1}""}},", JsStr(scode), JsStr(mapSubjLabel(scode)))
            Next
            If mapSubjects(instName).Count > 0 Then instMapJson.Length -= 1
            instMapJson.Append("],""sections"":[")
            For Each sname In mapSections(instName)
                instMapJson.AppendFormat("""{0}"",", JsStr(sname))
            Next
            If mapSections(instName).Count > 0 Then instMapJson.Length -= 1
            instMapJson.Append("]},")
        Next

        ' Final JSON cleanup
        If subjectJson.Length > 1 Then subjectJson.Length -= 1
        If instructorJson.Length > 1 Then instructorJson.Length -= 1
        If sectionJson.Length > 1 Then sectionJson.Length -= 1
        If instMapJson.Length > 1 Then instMapJson.Length -= 1
        subjectJson.Append("]")
        instructorJson.Append("]")
        sectionJson.Append("]")
        instMapJson.Append("}")

        Dim script As String = String.Format(
            "<script>var subjects={0}; var instructors={1}; var sections={2}; var instructorMap={3};</script>",
            subjectJson.ToString(), instructorJson.ToString(), sectionJson.ToString(), instMapJson.ToString())
        litScript.Text = script
    End Sub

    Private Function BuildSectionLabel(course As String, year As String, sec As String) As String
        Dim s As String = course & year
        If Not String.IsNullOrEmpty(sec) Then s &= "-" & sec
        Return s
    End Function

    Private Function JsStr(s As String) As String
        If s Is Nothing Then Return ""
        Return s.Replace("'", "\'").Replace("""", "\""")
    End Function

End Class
