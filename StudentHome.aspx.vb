Imports System
Imports System.Collections.Generic
Imports System.Linq
Imports System.Text
Imports System.Web.UI

Partial Class StudentHome
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load

        ' Auth guard
        If Session("UserID") Is Nothing Then
            Response.Redirect("Login.aspx")
            Return
        End If
        Dim sessionRole As String = If(Session("Role") IsNot Nothing, Session("Role").ToString().ToLower(), "")
        If sessionRole <> "student" Then
            Response.Redirect("AccessDenied.aspx")
            Return
        End If

        AddHandler btnLogout.Click, AddressOf BtnLogout_Click

        If Not IsPostBack Then
            Dim fullName As String = If(Session("FullName") IsNot Nothing, Session("FullName").ToString(), "Student")
            lblWelcome.Text = "Welcome, " & fullName & "!"

            Dim courseCode As String = If(Session("CourseCode") IsNot Nothing, Session("CourseCode").ToString(), "")
            Dim yearLevel As String = If(Session("YearLevel") IsNot Nothing, Session("YearLevel").ToString(), "")

            PopulateInstructorDropdown(courseCode, yearLevel)
        End If

        BuildMap(ddlTime.SelectedValue, ddlInstructor.SelectedValue)
    End Sub

    ' ── Logout ─────────────────────────────────────────────────────────────
    Private Sub BtnLogout_Click(sender As Object, e As EventArgs)
        Session.Clear()
        Response.Redirect("Login.aspx")
    End Sub

    ' ── Clear Filters ──────────────────────────────────────────────────────
    Protected Sub btnClearFilters_Click(sender As Object, e As EventArgs) Handles btnClearFilters.Click
        ddlTime.SelectedIndex = 0
        ddlInstructor.SelectedIndex = 0
        BuildMap("", "")
    End Sub

    ' ── Populate Instructor Dropdown ───────────────────────────────────────
    Private Sub PopulateInstructorDropdown(courseCode As String, yearLevel As String)
        ddlInstructor.Items.Clear()
        ddlInstructor.Items.Add(New System.Web.UI.WebControls.ListItem("-- All Instructors --", ""))

        If String.IsNullOrEmpty(courseCode) Then Return

        Dim allSchedules = Database.GetAllSchedules()

        Dim relevantInstructors = allSchedules _
            .Where(Function(sc) Not String.IsNullOrEmpty(sc.InstructorName) AndAlso
                                Not String.IsNullOrEmpty(sc.CourseSection) AndAlso
                                sc.CourseSection.ToUpper().StartsWith(courseCode.ToUpper())) _
            .Select(Function(sc) sc.InstructorName) _
            .Distinct() _
            .OrderBy(Function(n) n) _
            .ToList()

        For Each instrName In relevantInstructors
            ddlInstructor.Items.Add(New System.Web.UI.WebControls.ListItem(instrName, instrName))
        Next
    End Sub

    ' ── Build Map ──────────────────────────────────────────────────────────
    Private Sub BuildMap(timeFilter As String, instrFilter As String)
        Dim courseCode As String = If(Session("CourseCode") IsNot Nothing, Session("CourseCode").ToString(), "")

        Dim sb As New StringBuilder()

        sb.AppendLine("<h3 class='floor-label'>Ground Floor</h3>")
        sb.AppendLine("<div class='map-grid'>")
        For Each rm In New String() {"101", "102", "103", "104", "105", "106", "107", "108", "109", "110", "111", "112"}
            AppendRoomCard(sb, rm, timeFilter, instrFilter, courseCode)
        Next
        sb.AppendLine("</div>")

        sb.AppendLine("<h3 class='floor-label'>Floor 2</h3>")
        sb.AppendLine("<div class='map-grid'>")
        For Each rm In New String() {"205", "206 (LAB)", "207 (LAB)", "208", "209", "210", "211", "212"}
            AppendRoomCard(sb, rm, timeFilter, instrFilter, courseCode)
        Next
        sb.AppendLine("</div>")

        sb.AppendLine("<h3 class='floor-label'>Floor 3</h3>")
        sb.AppendLine("<div class='map-grid'>")
        For Each rm In New String() {"301", "302", "303", "304", "305", "306", "307", "308", "309", "310", "311", "312"}
            AppendRoomCard(sb, rm, timeFilter, instrFilter, courseCode)
        Next
        sb.AppendLine("</div>")

        litMap.Text = sb.ToString()
    End Sub

    ' ── Append Room Card ───────────────────────────────────────────────────
    Private Sub AppendRoomCard(sb As StringBuilder, rm As String, timeFilter As String, instrFilter As String, courseCode As String)
        Dim allSchedules As List(Of Schedule) = Database.GetAllSchedules()

        Dim schedules = allSchedules.Where(Function(s) s.RoomNo = rm)

        If Not String.IsNullOrEmpty(courseCode) Then
            schedules = schedules.Where(Function(s) Not String.IsNullOrEmpty(s.CourseSection) AndAlso
                                                     s.CourseSection.ToUpper().StartsWith(courseCode.ToUpper()))
        End If

        If Not String.IsNullOrEmpty(timeFilter) Then
            schedules = schedules.Where(Function(s) s.TimeSlot = timeFilter)
        End If

        If Not String.IsNullOrEmpty(instrFilter) Then
            schedules = schedules.Where(Function(s) s.InstructorName = instrFilter)
        End If

        Dim schedList = schedules.OrderBy(Function(s) s.DayType).ThenBy(Function(s) s.TimeSlot).ToList()

        Dim isOccupied As Boolean = (schedList.Count > 0)
        Dim isLab As Boolean = rm.ToUpper().Contains("LAB")

        Dim cssClass As String = "map-room free"
        If isLab AndAlso isOccupied Then
            cssClass = "map-room occupied lab"
        ElseIf isLab Then
            cssClass = "map-room free lab"
        ElseIf isOccupied Then
            cssClass = "map-room occupied"
        End If

        ' Unique ID for the collapse div (strip spaces/parentheses)
        Dim safeRm As String = rm.Replace(" ", "_").Replace("(", "").Replace(")", "")
        Dim extraId As String = "extra_" & safeRm

        sb.AppendLine("<div class='" & cssClass & "'>")
        sb.AppendLine("<div class='room-number'>Room " & rm & "</div>")

        If isOccupied Then
            Dim mwfList = schedList.Where(Function(s) s.DayType = "MWF").ToList()
            Dim tthList = schedList.Where(Function(s) s.DayType = "TTH").ToList()

            ' ── Always-visible: first MWF slot only ──────────────────────
            If mwfList.Count > 0 Then
                sb.AppendLine("<div class='day-group'>")
                sb.AppendLine("<span class='day-badge mwf'>MWF</span>")

                ' Show the FIRST MWF entry always
                Dim firstMwf = mwfList(0)
                sb.AppendLine("<div class='room-detail'>" &
                              "<strong>" & firstMwf.TimeSlot & "</strong><br/>" &
                              firstMwf.SubjectCode & "<br/>" &
                              firstMwf.CourseSection & "<br/>" &
                              "<em>" & firstMwf.InstructorName & "</em>" &
                              "</div>")
                sb.AppendLine("</div>")
            End If

            ' ── Always-visible: first TTH slot only ──────────────────────
            If tthList.Count > 0 Then
                sb.AppendLine("<div class='day-group'>")
                sb.AppendLine("<span class='day-badge tth'>TTH</span>")

                Dim firstTth = tthList(0)
                sb.AppendLine("<div class='room-detail'>" &
                              "<strong>" & firstTth.TimeSlot & "</strong><br/>" &
                              firstTth.SubjectCode & "<br/>" &
                              firstTth.CourseSection & "<br/>" &
                              "<em>" & firstTth.InstructorName & "</em>" &
                              "</div>")
                sb.AppendLine("</div>")
            End If

            ' ── Collapsible section: remaining slots ──────────────────────
            Dim remainingMwf = If(mwfList.Count > 1, mwfList.Skip(1).ToList(), New List(Of Schedule)())
            Dim remainingTth = If(tthList.Count > 1, tthList.Skip(1).ToList(), New List(Of Schedule)())
            Dim totalRemaining As Integer = remainingMwf.Count + remainingTth.Count

            If totalRemaining > 0 Then
                sb.AppendLine("<div id='" & extraId & "' class='card-extra' style='display:none;'>")

                If remainingMwf.Count > 0 Then
                    sb.AppendLine("<div class='day-group'>")
                    sb.AppendLine("<span class='day-badge mwf'>MWF</span>")
                    For Each s In remainingMwf
                        sb.AppendLine("<div class='room-detail'>" &
                                      "<strong>" & s.TimeSlot & "</strong><br/>" &
                                      s.SubjectCode & "<br/>" &
                                      s.CourseSection & "<br/>" &
                                      "<em>" & s.InstructorName & "</em>" &
                                      "</div>")
                    Next
                    sb.AppendLine("</div>")
                End If

                If remainingTth.Count > 0 Then
                    sb.AppendLine("<div class='day-group'>")
                    sb.AppendLine("<span class='day-badge tth'>TTH</span>")
                    For Each s In remainingTth
                        sb.AppendLine("<div class='room-detail'>" &
                                      "<strong>" & s.TimeSlot & "</strong><br/>" &
                                      s.SubjectCode & "<br/>" &
                                      s.CourseSection & "<br/>" &
                                      "<em>" & s.InstructorName & "</em>" &
                                      "</div>")
                    Next
                    sb.AppendLine("</div>")
                End If

                sb.AppendLine("</div>") ' end card-extra

                ' Toggle button — type="button" prevents ASP.NET form postback
                sb.AppendLine("<button type=""button"" class=""btn-toggle"" " &
                              "onclick=""return toggleExtra('" & extraId & "', this)"">" &
                              "&#9660; Show more (" & totalRemaining & ")</button>")
            End If

        Else
            sb.AppendLine("<div class='room-detail free-text'>Available</div>")
        End If

        sb.AppendLine("</div>") ' end map-room
    End Sub

End Class