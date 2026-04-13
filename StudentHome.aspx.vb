Imports System
Imports System.Collections.Generic
Imports System.Linq
Imports System.Text
Imports System.Web.UI

Partial Class StudentHome
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Session("UserID") Is Nothing OrElse Session("Role").ToString().ToLower() <> "student" Then
            Response.Redirect("Login.aspx")
            Return
        End If

        AddHandler btnLogout.Click, AddressOf BtnLogout_Click

        If Not IsPostBack Then
            lblWelcome.Text = "Welcome, " & If(Session("FullName") IsNot Nothing, Session("FullName").ToString(), "Student") & "!"
            PopulateInstructorDropdown()
        End If

        BuildMap(ddlTime.SelectedValue, ddlDayType.SelectedValue, ddlInstructor.SelectedValue)
    End Sub

    Private Sub BtnLogout_Click(sender As Object, e As EventArgs)
        Session.Clear()
        Response.Redirect("Login.aspx")
    End Sub

    Protected Sub btnClearFilters_Click(sender As Object, e As EventArgs) Handles btnClearFilters.Click
        ddlTime.SelectedIndex = 0
        ddlDayType.SelectedIndex = 0
        ddlInstructor.SelectedIndex = 0
        BuildMap("", "", "")
    End Sub

    Private Sub PopulateInstructorDropdown()
        ddlInstructor.Items.Clear()
        ddlInstructor.Items.Add(New System.Web.UI.WebControls.ListItem("-- All Instructors --", ""))
        Dim courseCode As String = If(Session("CourseCode") IsNot Nothing, Session("CourseCode").ToString(), "")
        If String.IsNullOrEmpty(courseCode) Then Return

        Dim relevantInstructors = Database.GetAllSchedules() _
            .Where(Function(sc) Not String.IsNullOrEmpty(sc.InstructorName) AndAlso
                                Not String.IsNullOrEmpty(sc.CourseSection) AndAlso
                                sc.CourseSection.ToUpper().StartsWith(courseCode.ToUpper())) _
            .Select(Function(sc) sc.InstructorName) _
            .Distinct().OrderBy(Function(n) n).ToList()

        For Each instrName In relevantInstructors
            ddlInstructor.Items.Add(New System.Web.UI.WebControls.ListItem(instrName, instrName))
        Next
    End Sub

    Private Sub BuildMap(timeFilter As String, dayFilter As String, instrFilter As String)
        Dim courseCode As String = If(Session("CourseCode") IsNot Nothing, Session("CourseCode").ToString(), "")
        Dim sb As New StringBuilder()

        sb.AppendLine("<h3 class='floor-label'>Ground Floor</h3><div class='map-grid'>")
        For Each rm In New String() {"101", "102", "103", "104", "105", "106", "107", "108", "109", "110", "111", "112"}
            AppendRoomCard(sb, rm, timeFilter, dayFilter, instrFilter, courseCode)
        Next
        sb.AppendLine("</div><h3 class='floor-label'>Floor 2</h3><div class='map-grid'>")
        For Each rm In New String() {"205", "206 (LAB)", "207 (LAB)", "208", "209", "210", "211", "212"}
            AppendRoomCard(sb, rm, timeFilter, dayFilter, instrFilter, courseCode)
        Next
        sb.AppendLine("</div><h3 class='floor-label'>Floor 3</h3><div class='map-grid'>")
        For Each rm In New String() {"301", "302", "303", "304", "305", "306", "307", "308", "309", "310", "311", "312"}
            AppendRoomCard(sb, rm, timeFilter, dayFilter, instrFilter, courseCode)
        Next
        sb.AppendLine("</div>")
        litMap.Text = sb.ToString()
    End Sub

    Private Sub AppendRoomCard(sb As StringBuilder, rm As String, timeFilter As String, dayFilter As String, instrFilter As String, courseCode As String)
        Dim schedules = Database.GetAllSchedules().Where(Function(s) s.RoomNo = rm)
        If Not String.IsNullOrEmpty(courseCode) Then
            schedules = schedules.Where(Function(s) Not String.IsNullOrEmpty(s.CourseSection) AndAlso s.CourseSection.ToUpper().StartsWith(courseCode.ToUpper()))
        End If
        If Not String.IsNullOrEmpty(timeFilter) Then schedules = schedules.Where(Function(s) s.TimeSlot = timeFilter)
        If Not String.IsNullOrEmpty(dayFilter) Then schedules = schedules.Where(Function(s) s.DayType = dayFilter)
        If Not String.IsNullOrEmpty(instrFilter) Then schedules = schedules.Where(Function(s) s.InstructorName = instrFilter)

        Dim schedList = schedules.OrderBy(Function(s) s.DayType).ThenBy(Function(s) s.TimeSlot).ToList()
        Dim isOccupied As Boolean = (schedList.Count > 0)
        Dim isLab As Boolean = rm.ToUpper().Contains("LAB")
        Dim cssClass As String = "map-room free"
        If isOccupied Then cssClass = "map-room occupied" & If(isLab, " lab", "") Else If(isLab) Then cssClass = "map-room free lab"

        Dim safeRm As String = rm.Replace(" ", "_").Replace("(", "").Replace(")", "")
        Dim extraId As String = "extra_" & safeRm

        sb.AppendLine("<div class='" & cssClass & "'><div class='room-number'>Room " & rm & "</div>")
        If isOccupied Then
            Dim mwfList = schedList.Where(Function(s) s.DayType = "MWF").ToList()
            Dim tthList = schedList.Where(Function(s) s.DayType = "TTH").ToList()
            If mwfList.Count > 0 Then
                Dim s = mwfList(0)
                sb.AppendLine("<div class='day-group'><span class='day-badge mwf'>MWF</span><div class='room-detail'><strong>" & s.TimeSlot & "</strong><br/>" & s.SubjectCode & "<br/>" & s.CourseSection & "<br/><em>" & s.InstructorName & "</em></div></div>")
            End If
            If tthList.Count > 0 Then
                Dim s = tthList(0)
                sb.AppendLine("<div class='day-group'><span class='day-badge tth'>TTH</span><div class='room-detail'><strong>" & s.TimeSlot & "</strong><br/>" & s.SubjectCode & "<br/>" & s.CourseSection & "<br/><em>" & s.InstructorName & "</em></div></div>")
            End If
            Dim totalRemaining As Integer = Math.Max(0, mwfList.Count - 1) + Math.Max(0, tthList.Count - 1)
            If totalRemaining > 0 Then
                sb.AppendLine("<div id='" & extraId & "' class='card-extra' style='display:none;'>")
                If mwfList.Count > 1 Then
                    For i As Integer = 1 To mwfList.Count - 1
                        Dim s = mwfList(i)
                        sb.AppendLine("<div class='day-group'><span class='day-badge mwf'>MWF</span><div class='room-detail'><strong>" & s.TimeSlot & "</strong><br/>" & s.SubjectCode & "<br/>" & s.CourseSection & "<br/><em>" & s.InstructorName & "</em></div></div>")
                    Next
                End If
                If tthList.Count > 1 Then
                    For i As Integer = 1 To tthList.Count - 1
                        Dim s = tthList(i)
                        sb.AppendLine("<div class='day-group'><span class='day-badge tth'>TTH</span><div class='room-detail'><strong>" & s.TimeSlot & "</strong><br/>" & s.SubjectCode & "<br/>" & s.CourseSection & "<br/><em>" & s.InstructorName & "</em></div></div>")
                    Next
                End If
                sb.AppendLine("</div><button type='button' class='btn-toggle' onclick=""return toggleExtra('" & extraId & "', this)"">&#9660; Show more (" & totalRemaining & ")</button>")
            End If
        Else
            sb.AppendLine("<div class='room-detail free-text'>Available</div>")
        End If
        sb.AppendLine("</div>")
    End Sub
End Class
