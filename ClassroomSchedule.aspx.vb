Imports System.Data
Imports System.Text

Partial Class ClassroomSchedule
    Inherits System.Web.UI.Page

    Private ReadOnly Rooms As String() = {
        "101", "102", "103", "104", "105", "106", "107", "108", "109", "110", "111", "112",
        "205", "206 (LAB)", "207 (LAB)", "208", "209", "210", "211", "212",
        "301", "302", "303", "304", "305", "306", "307", "308", "309", "310", "311"
    }

    Private ReadOnly TimeSlots As String() = {
        "7:30-8:30", "8:30-9:30", "9:30-10:30", "10:30-11:30", "11:30-12:30",
        "12:30-1:30", "1:30-2:30", "2:30-3:30", "3:30-4:30", "4:30-5:30"
    }

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

        Dim role As String = AuthHelper.GetRole(Me)
        Dim fullName As String = AuthHelper.GetFullName(Me)

        lblRoleBadge.Text = role
        lblWelcome.Text = "Welcome back, <strong>" & fullName & "</strong>!"

        If Not IsPostBack Then
            RenderBothGrids()
            InjectDropdownData()
        End If
    End Sub

    ' ── Permission helpers ──
    Private Function CanEdit() As Boolean
        Return CurrentRole = "Admin" OrElse CurrentRole = "Dean"
    End Function

    Private Function CanAssign() As Boolean
        Return CurrentRole = "Admin" OrElse CurrentRole = "Dean"
    End Function

    ' ── Cell action postback ──
    Protected Sub btnCellAction_Click(sender As Object, e As EventArgs) Handles btnCellAction.Click

        If CurrentRole <> "Admin" AndAlso CurrentRole <> "Dean" Then
            lblMsg.Text = "Access denied. Only Administrators and Deans can modify schedules."
            lblMsg.CssClass = "msg-error"
            RenderBothGrids() : InjectDropdownData() : Return
        End If

        Dim action As String = hfAction.Value
        Dim room As String = hfRoom.Value
        Dim time As String = hfTime.Value
        Dim subject As String = hfSubject.Value
        Dim section As String = hfSection.Value
        Dim instructor As String = hfInstructor.Value
        Dim dayType As String = hfDayType.Value
        Dim schedID As Integer = 0
        Integer.TryParse(hfScheduleID.Value, schedID)

        Dim allSchedules As List(Of Schedule) = Database.GetAllSchedules()

        If action = "save" Then
            If schedID > 0 Then
                ' UPDATE existing
                Dim existing As Schedule = allSchedules.Find(Function(s) s.ScheduleID = schedID)
                If existing IsNot Nothing Then
                    Dim rc = allSchedules.Find(Function(s) s.RoomNo = room AndAlso s.TimeSlot = time AndAlso s.DayType = dayType AndAlso s.ScheduleID <> schedID)
                    Dim ic = allSchedules.Find(Function(s) s.InstructorName = instructor AndAlso s.TimeSlot = time AndAlso s.DayType = dayType AndAlso s.ScheduleID <> schedID)
                    Dim sc = allSchedules.Find(Function(s) s.CourseSection = section AndAlso s.TimeSlot = time AndAlso s.DayType = dayType AndAlso s.ScheduleID <> schedID)

                    If rc IsNot Nothing Then
                        lblMsg.Text = "CONFLICT: Room " & room & " is already occupied at " & time & " on " & dayType & " (" & rc.SubjectCode & " - " & rc.CourseSection & ")."
                        lblMsg.CssClass = "msg-error"
                    ElseIf ic IsNot Nothing Then
                        lblMsg.Text = "CONFLICT: " & instructor & " is already teaching at " & time & " on " & dayType & " in Room " & ic.RoomNo & " (" & ic.SubjectCode & ")."
                        lblMsg.CssClass = "msg-error"
                    ElseIf sc IsNot Nothing Then
                        lblMsg.Text = "CONFLICT: " & section & " already has a class at " & time & " on " & dayType & " (" & sc.SubjectCode & " in Room " & sc.RoomNo & ")."
                        lblMsg.CssClass = "msg-error"
                    Else
                        existing.TimeSlot = time
                        existing.SubjectCode = subject
                        existing.CourseSection = section
                        existing.InstructorName = instructor
                        existing.DayType = dayType
                        Database.UpdateSchedule(existing)
                        lblMsg.Text = "✔ Schedule updated."
                        lblMsg.CssClass = "msg-success"
                    End If
                End If
            Else
                ' INSERT new
                Dim rc = allSchedules.Find(Function(s) s.RoomNo = room AndAlso s.TimeSlot = time AndAlso s.DayType = dayType)
                Dim ic = allSchedules.Find(Function(s) s.InstructorName = instructor AndAlso s.TimeSlot = time AndAlso s.DayType = dayType)
                Dim sc = allSchedules.Find(Function(s) s.CourseSection = section AndAlso s.TimeSlot = time AndAlso s.DayType = dayType)

                If rc IsNot Nothing Then
                    lblMsg.Text = "CONFLICT: Room " & room & " is already occupied at " & time & " on " & dayType & " (" & rc.SubjectCode & " - " & rc.CourseSection & ")."
                    lblMsg.CssClass = "msg-error"
                ElseIf ic IsNot Nothing Then
                    lblMsg.Text = "CONFLICT: " & instructor & " is already teaching at " & time & " on " & dayType & " in Room " & ic.RoomNo & " (" & ic.SubjectCode & ")."
                    lblMsg.CssClass = "msg-error"
                ElseIf sc IsNot Nothing Then
                    lblMsg.Text = "CONFLICT: " & section & " already has a class at " & time & " on " & dayType & " (" & sc.SubjectCode & " in Room " & sc.RoomNo & ")."
                    lblMsg.CssClass = "msg-error"
                Else
                    Dim newSched As New Schedule With {
                        .RoomNo = room,
                        .TimeSlot = time,
                        .SubjectCode = subject,
                        .CourseSection = section,
                        .InstructorName = instructor,
                        .DayType = dayType
                    }
                    Database.AddSchedule(newSched)
                    lblMsg.Text = "✔ Schedule added."
                    lblMsg.CssClass = "msg-success"
                End If
            End If

        ElseIf action = "delete" Then
            Database.DeleteSchedule(schedID)
            lblMsg.Text = "🗑 Schedule removed."
            lblMsg.CssClass = "msg-success"
        End If

        RenderBothGrids()
        InjectDropdownData()
    End Sub

    ' ── Render both grids ──
    Private Sub RenderBothGrids()
        Dim sb As New StringBuilder
        sb.Append(RenderGrid("MWF"))
        sb.Append("<br/>")
        sb.Append(RenderGrid("TTH"))
        litGrid.Text = sb.ToString()
    End Sub

    ' ── Render one grid ──
    Private Function RenderGrid(dayType As String) As String
        Dim allSchedules As List(Of Schedule) = Database.GetAllSchedules()

        Dim lookup As New Dictionary(Of String, Dictionary(Of String, Schedule))
        For Each sched As Schedule In allSchedules
            If sched.DayType <> dayType Then Continue For
            If Not lookup.ContainsKey(sched.RoomNo) Then
                lookup(sched.RoomNo) = New Dictionary(Of String, Schedule)
            End If
            lookup(sched.RoomNo)(sched.TimeSlot) = sched
        Next

        Dim sb As New StringBuilder

        sb.AppendFormat("<h3 class='grid-day-header'>{0} Schedule</h3>", dayType)

        If CurrentRole <> "Admin" AndAlso CurrentRole <> "Dean" Then
            sb.Append("<p class='instructor-banner'>&#128274; You have <strong>read-only</strong> access to the schedule.</p>")
        End If

        sb.Append("<div class='table-responsive'>")
        sb.Append("<table class='schedule-grid'>")
        sb.Append("<thead><tr>")
        sb.Append("<th>Time</th>")
        For Each room As String In Rooms
            sb.AppendFormat("<th>{0}</th>", HtmlEncode(room))
        Next
        sb.Append("</tr></thead><tbody>")

        For Each ts As String In TimeSlots
            sb.AppendFormat("<tr><td class='room-label'>{0}</td>", HtmlEncode(ts))

            For Each room As String In Rooms
                Dim cellId As String = "cell_" & dayType & "_" & SafeId(room) & "_" & SafeId(ts)
                Dim hasData As Boolean = lookup.ContainsKey(room) AndAlso lookup(room).ContainsKey(ts)

                If hasData Then
                    Dim sched As Schedule = lookup(room)(ts)
                    Dim sid As String = sched.ScheduleID.ToString()
                    Dim subj As String = sched.SubjectCode
                    Dim sec As String = sched.CourseSection
                    Dim inst As String = sched.InstructorName

                    sb.AppendFormat("<td id='{0}' class='cell-occupied'>", cellId)
                    sb.Append("<div class='cell-display'>")
                    sb.Append("<div class='cell-info'>")
                    sb.AppendFormat("<strong>{0}</strong>", HtmlEncode(subj))
                    sb.AppendFormat("<br/>{0}<br/>{1}", HtmlEncode(sec), HtmlEncode(inst))
                    sb.Append("</div>")

                    If CanEdit() Then
                        sb.AppendFormat("<span class='toggle-edit' onclick=""openEditor('{0}','{1}','{2}','{3}','{4}','{5}','{6}','{7}')"">&#9998; Edit</span>",
                            cellId, JsStr(room), JsStr(ts), JsStr(subj), JsStr(sec), JsStr(inst), sid, dayType)
                        sb.Append("</div>")
                        sb.Append("<div class='cell-editor' style='display:none;'>")
                        sb.Append("<select class='sel-subj'></select>")
                        sb.Append("<select class='sel-sec'></select>")
                        sb.Append("<select class='sel-inst'></select>")
                        sb.Append("<div class='cell-editor-btns'>")
                        sb.AppendFormat("<button type='button' class='btn-save-cell' onclick=""saveCell('{0}','{1}','{2}','{3}','{4}')"">Save</button>",
                            cellId, JsStr(room), sid, JsStr(ts), dayType)
                        sb.AppendFormat("<button type='button' class='btn-clear-cell' onclick=""clearCell('{0}','{1}','{2}','{3}')"">Remove</button>",
                            cellId, JsStr(room), JsStr(ts), sid)
                        sb.AppendFormat("<button type='button' class='btn-cancel-cell' onclick=""closeEditor('{0}')"">Cancel</button>", cellId)
                        sb.Append("</div></div>")
                    Else
                        sb.Append("<span class='no-edit-label'>&#128274; Occupied</span>")
                        sb.Append("</div>")
                    End If

                    sb.Append("</td>")

                Else
                    sb.AppendFormat("<td id='{0}' class='cell-free'>", cellId)
                    sb.Append("<div class='cell-display'>")
                    sb.Append("<span class='cell-free-label'>Free</span><br/>")

                    If CanAssign() Then
                        sb.AppendFormat("<span class='toggle-edit' onclick=""openEditor('{0}','{1}','{2}','','','','0','{3}')"">&#43; Assign</span>",
                            cellId, JsStr(room), JsStr(ts), dayType)
                        sb.Append("</div>")
                        sb.Append("<div class='cell-editor' style='display:none;'>")
                        sb.Append("<select class='sel-subj'></select>")
                        sb.Append("<select class='sel-sec'></select>")
                        sb.Append("<select class='sel-inst'></select>")
                        sb.Append("<div class='cell-editor-btns'>")
                        sb.AppendFormat("<button type='button' class='btn-save-cell' onclick=""saveCell('{0}','{1}','0','{2}','{3}')"">Save</button>",
                            cellId, JsStr(room), JsStr(ts), dayType)
                        sb.AppendFormat("<button type='button' class='btn-cancel-cell' onclick=""closeEditor('{0}')"">Cancel</button>", cellId)
                        sb.Append("</div></div>")
                    Else
                        sb.Append("</div>")
                    End If

                    sb.Append("</td>")
                End If
            Next

            sb.Append("</tr>")
        Next

        sb.Append("</tbody></table></div>")
        Return sb.ToString()
    End Function
    Private Sub InjectDropdownData()
        Dim subjectJson As New StringBuilder("[")
        Dim instructorJson As New StringBuilder("[")
        Dim sectionJson As New StringBuilder("[")
        Dim instMapJson As New StringBuilder("{")

        If CurrentRole = "Admin" OrElse CurrentRole = "Dean" Then
            Dim allSubjects As List(Of Subject) = Database.GetAllSubjects()
            Dim allSchedules As List(Of Schedule) = Database.GetAllSchedules()
            Dim allInstructors As List(Of Instructor) = Database.GetAllInstructors().OrderBy(Function(i) i.Name).ToList()

            ' ── All subjects (for the full dropdown when no instructor filter is active) ──
            For Each subj As Subject In allSubjects.GroupBy(Function(s) s.Code).Select(Function(g) g.First())
                subjectJson.AppendFormat("{{""value"":""{0}"",""label"":""{0} - {1}""}},",
                    JsStr(subj.Code), JsStr(subj.Description))
            Next

            ' ── All instructors ──
            For Each inst As Instructor In allInstructors
                instructorJson.AppendFormat("{{""value"":""{0}"",""label"":""{0}""}},", JsStr(inst.Name))
            Next

            ' ── All sections (full list) ──
            Dim sectionSet As New List(Of String)
            For Each cs As CourseSection In Database.GetAllCourseSections()
                Dim lbl As String = cs.DisplayName
                If Not sectionSet.Contains(lbl) Then sectionSet.Add(lbl)
            Next
            For Each s As Subject In allSubjects
                If s.CourseCode <> "" AndAlso s.YearLevel <> "" Then
                    Dim lbl As String = BuildSectionLabel(s.CourseCode, s.YearLevel, s.Section)
                    If Not sectionSet.Contains(lbl) Then sectionSet.Add(lbl)
                End If
            Next
            For Each sec As String In sectionSet.OrderBy(Function(x) x)
                sectionJson.AppendFormat("""{0}"",", JsStr(sec))
            Next

            ' ── Build instructorMap ───
            Dim mapSubjects As New Dictionary(Of String, HashSet(Of String))(StringComparer.OrdinalIgnoreCase)
            Dim mapSections As New Dictionary(Of String, HashSet(Of String))(StringComparer.OrdinalIgnoreCase)

            ' Build subject code -> label lookup from the Subjects table
            Dim mapSubjLabel As New Dictionary(Of String, String)(StringComparer.OrdinalIgnoreCase)
            For Each subj As Subject In allSubjects
                If Not mapSubjLabel.ContainsKey(subj.Code) Then
                    mapSubjLabel(subj.Code) = subj.Code & " - " & subj.Description
                End If
            Next

            ' Populate maps from AssignedInstructorID on Subjects table
            For Each subj As Subject In allSubjects
                If Not subj.AssignedInstructorID.HasValue Then Continue For

                Dim assignedInstr As Instructor = allInstructors.FirstOrDefault(
        Function(i) i.InstructorID = subj.AssignedInstructorID.Value)
                If assignedInstr Is Nothing Then Continue For

                Dim instKey As String = assignedInstr.Name.Trim()

                If Not mapSubjects.ContainsKey(instKey) Then mapSubjects(instKey) = New HashSet(Of String)(StringComparer.OrdinalIgnoreCase)
                If Not mapSections.ContainsKey(instKey) Then mapSections(instKey) = New HashSet(Of String)(StringComparer.OrdinalIgnoreCase)

                If subj.Code <> "" Then mapSubjects(instKey).Add(subj.Code)

                ' Add section from the subject row itself
                If subj.CourseCode <> "" AndAlso subj.YearLevel <> "" Then
                    Dim secLbl As String = BuildSectionLabel(subj.CourseCode, subj.YearLevel, subj.Section)
                    mapSections(instKey).Add(secLbl)
                End If
            Next

            ' Also keep existing schedule entries in the map (so occupied cells still work)
            For Each sched As Schedule In allSchedules
                If sched.InstructorName Is Nothing OrElse sched.InstructorName.Trim() = "" Then Continue For
                Dim instKey As String = sched.InstructorName.Trim()

                If Not mapSubjects.ContainsKey(instKey) Then mapSubjects(instKey) = New HashSet(Of String)(StringComparer.OrdinalIgnoreCase)
                If Not mapSections.ContainsKey(instKey) Then mapSections(instKey) = New HashSet(Of String)(StringComparer.OrdinalIgnoreCase)

                If sched.SubjectCode <> "" Then mapSubjects(instKey).Add(sched.SubjectCode)
                If sched.CourseSection <> "" Then mapSections(instKey).Add(sched.CourseSection)
            Next

            ' Emit the map as JSON
            For Each inst As Instructor In allInstructors
                Dim instKey As String = inst.Name.Trim()
                Dim subjSet As HashSet(Of String) = If(mapSubjects.ContainsKey(instKey), mapSubjects(instKey), New HashSet(Of String)())
                Dim secSet As HashSet(Of String) = If(mapSections.ContainsKey(instKey), mapSections(instKey), New HashSet(Of String)())

                instMapJson.AppendFormat("""{0}"":{{", JsStr(instKey))

                ' subjects array
                instMapJson.Append("""subjects"":[")
                For Each code As String In subjSet.OrderBy(Function(x) x)
                    Dim lbl As String = If(mapSubjLabel.ContainsKey(code), mapSubjLabel(code), code)
                    instMapJson.AppendFormat("{{""value"":""{0}"",""label"":""{1}""}},", JsStr(code), JsStr(lbl))
                Next
                If subjSet.Count > 0 Then instMapJson.Length -= 1
                instMapJson.Append("],")

                ' sections array
                instMapJson.Append("""sections"":[")
                For Each sec As String In secSet.OrderBy(Function(x) x)
                    instMapJson.AppendFormat("""{0}"",", JsStr(sec))
                Next
                If secSet.Count > 0 Then instMapJson.Length -= 1
                instMapJson.Append("]")

                instMapJson.Append("},")
            Next
            If allInstructors.Count > 0 Then instMapJson.Length -= 1
        End If

        If subjectJson.Length > 1 Then subjectJson.Length -= 1
        If instructorJson.Length > 1 Then instructorJson.Length -= 1
        If sectionJson.Length > 1 Then sectionJson.Length -= 1
        subjectJson.Append("]")
        instructorJson.Append("]")
        sectionJson.Append("]")
        instMapJson.Append("}")

        litScript.Text =
            "<script type='text/javascript'>" &
            "var subjects=" & subjectJson.ToString() & ";" &
            "var instructors=" & instructorJson.ToString() & ";" &
            "var sections=" & sectionJson.ToString() & ";" &
            "var instructorMap=" & instMapJson.ToString() & ";" &
            "</script>"
    End Sub

    ' ── Build a section label ──
    Private Function BuildSectionLabel(course As String, year As String, section As String) As String
        Dim base As String = course.Trim() & year.Trim()
        If section IsNot Nothing AndAlso section.Trim() <> "" Then
            Return base & "-" & section.Trim()
        End If
        Return base
    End Function

    ' ── Utility helpers ──
    Private Function JsStr(s As String) As String
        If s Is Nothing Then Return ""
        Return s.Replace("\", "\\").Replace("'", "\'").Replace("""", "\""") _
                .Replace(Chr(13), "").Replace(Chr(10), "")
    End Function

    Private Function SafeId(s As String) As String
        Return System.Text.RegularExpressions.Regex.Replace(s, "[^A-Za-z0-9]", "_")
    End Function

    Private Function HtmlEncode(s As String) As String
        Return System.Web.HttpUtility.HtmlEncode(If(s, ""))
    End Function

    Protected Sub btnLogout_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnLogout.Click
        AuthHelper.ClearSession(Me)
        Response.Redirect("Login.aspx")
    End Sub

End Class