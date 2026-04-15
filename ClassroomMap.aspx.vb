Imports System
Imports System.Collections.Generic
Imports System.Linq
Imports System.Text
Imports System.Web.UI

Partial Class ClassroomMap
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        AuthHelper.Require(Me, "Admin", "Dean", "Instructor")

        AddHandler btnLogout.Click, AddressOf btnLogout_Click

        If Not IsPostBack Then
            lblWelcome.Text = "Welcome, " & AuthHelper.GetFullName(Me) & "!"
            lblRoleBadge.Text = AuthHelper.GetRole(Me)
        End If

        BuildMap(ddlTime.SelectedValue, ddlDayType.SelectedValue)
    End Sub

    Private Sub btnLogout_Click(sender As Object, e As EventArgs)
        AuthHelper.ClearSession(Me)
        Response.Redirect("Login.aspx")
    End Sub

    Private Sub BuildMap(timeFilter As String, dayFilter As String)
        Dim sb As New StringBuilder()

        sb.AppendLine("<h3 class='floor-label'>Ground Floor</h3>")
        sb.AppendLine("<div class='map-grid'>")
        For Each rm In New String() {"101", "102", "103", "104", "105", "106", "107", "108", "109", "110", "111", "112"}
            AppendRoomCard(sb, rm, timeFilter, dayFilter)
        Next
        sb.AppendLine("</div>")

        sb.AppendLine("<h3 class='floor-label'>Floor 2</h3>")
        sb.AppendLine("<div class='map-grid'>")
        For Each rm In New String() {"205", "206 (LAB)", "207 (LAB)", "208", "209", "210", "211", "212"}
            AppendRoomCard(sb, rm, timeFilter, dayFilter)
        Next
        sb.AppendLine("</div>")

        sb.AppendLine("<h3 class='floor-label'>Floor 3</h3>")
        sb.AppendLine("<div class='map-grid'>")
        For Each rm In New String() {"301", "302", "303", "304", "305", "306", "307", "308", "309", "310", "311", "312"}
            AppendRoomCard(sb, rm, timeFilter, dayFilter)
        Next
        sb.AppendLine("</div>")

        litMap.Text = sb.ToString()
    End Sub

    Private Sub AppendRoomCard(sb As StringBuilder, rm As String, timeFilter As String, dayFilter As String)
        Dim allSchedules As List(Of Schedule) = Database.GetAllSchedules()
        Dim schedules = allSchedules.Where(Function(s) s.RoomNo = rm)

        If Not String.IsNullOrEmpty(timeFilter) Then
            schedules = schedules.Where(Function(s) s.TimeSlot = timeFilter)
        End If
        If Not String.IsNullOrEmpty(dayFilter) Then
            schedules = schedules.Where(Function(s) s.DayType = dayFilter)
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

        Dim safeRm As String = rm.Replace(" ", "_").Replace("(", "").Replace(")", "")
        Dim extraId As String = "extra_" & safeRm

        sb.AppendLine("<div class='" & cssClass & "'>")
        sb.AppendLine("<div class='room-number'>Room " & rm & "</div>")

        If isOccupied Then
            Dim mwfList = schedList.Where(Function(s) s.DayType = "MWF").ToList()
            Dim tthList = schedList.Where(Function(s) s.DayType = "TTH").ToList()

            If mwfList.Count > 0 Then
                sb.AppendLine("<div class='day-group'>")
                sb.AppendLine("<span class='day-badge mwf'>MWF</span>")
                Dim s = mwfList(0)
                sb.AppendLine("<div class='room-detail'><strong>" & s.TimeSlot & "</strong><br/>" &
                              s.SubjectCode & "<br/>" & s.CourseSection & "<br/><em>" & s.InstructorName & "</em></div>")
                sb.AppendLine("</div>")
            End If

            If tthList.Count > 0 Then
                sb.AppendLine("<div class='day-group'>")
                sb.AppendLine("<span class='day-badge tth'>TTH</span>")
                Dim s = tthList(0)
                sb.AppendLine("<div class='room-detail'><strong>" & s.TimeSlot & "</strong><br/>" &
                              s.SubjectCode & "<br/>" & s.CourseSection & "<br/><em>" & s.InstructorName & "</em></div>")
                sb.AppendLine("</div>")
            End If

            Dim totalRemaining As Integer = Math.Max(0, mwfList.Count - 1) + Math.Max(0, tthList.Count - 1)
            If totalRemaining > 0 Then
                sb.AppendLine("<div id='" & extraId & "' class='card-extra' style='display:none;'>")
                If mwfList.Count > 1 Then
                    For i As Integer = 1 To mwfList.Count - 1
                        Dim s = mwfList(i)
                        sb.AppendLine("<div class='day-group'><span class='day-badge mwf'>MWF</span>")
                        sb.AppendLine("<div class='room-detail'><strong>" & s.TimeSlot & "</strong><br/>" &
                                      s.SubjectCode & "<br/>" & s.CourseSection & "<br/><em>" & s.InstructorName & "</em></div></div>")
                    Next
                End If
                If tthList.Count > 1 Then
                    For i As Integer = 1 To tthList.Count - 1
                        Dim s = tthList(i)
                        sb.AppendLine("<div class='day-group'><span class='day-badge tth'>TTH</span>")
                        sb.AppendLine("<div class='room-detail'><strong>" & s.TimeSlot & "</strong><br/>" &
                                      s.SubjectCode & "<br/>" & s.CourseSection & "<br/><em>" & s.InstructorName & "</em></div></div>")
                    Next
                End If
                sb.AppendLine("</div>")
                sb.AppendLine("<button type='button' class='btn-toggle' onclick=""return toggleExtra('" & extraId & "', this)"">&#9660; Show more (" & totalRemaining & ")</button>")
            End If
        Else
            sb.AppendLine("<div class='room-detail free-text'>Available</div>")
        End If
        sb.AppendLine("</div>")
    End Sub
End Class
