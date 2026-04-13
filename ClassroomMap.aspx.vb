Imports System
Imports System.Linq
Imports System.Text
Imports System.Web.UI

Partial Class ClassroomMap
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        AuthHelper.Require(Me, "Admin", "Dean", "Instructor")

        Dim role As String = AuthHelper.GetRole(Me)
        Dim fullName As String = AuthHelper.GetFullName(Me)
        lblWelcome.Text = "Welcome back, <strong>" & fullName & "</strong>!"
        lblRoleBadge.Text = role

        If Not IsPostBack Then
            BuildMap("", "")
        End If
    End Sub

    Protected Sub ddlTime_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs) Handles ddlTime.SelectedIndexChanged
        BuildMap(ddlTime.SelectedValue, ddlDayType.SelectedValue)
    End Sub

    Protected Sub ddlDayType_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs) Handles ddlDayType.SelectedIndexChanged
        BuildMap(ddlTime.SelectedValue, ddlDayType.SelectedValue)
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

        If timeFilter <> "" Then
            schedules = schedules.Where(Function(s) s.TimeSlot = timeFilter)
        End If
        If dayFilter <> "" Then
            schedules = schedules.Where(Function(s) s.DayType = dayFilter)
        End If

        Dim schedList = schedules.OrderBy(Function(s) s.DayType).ThenBy(Function(s) s.TimeSlot).ToList()
        Dim isOccupied As Boolean = (schedList.Count > 0)
        Dim isLab As Boolean = rm.ToUpper().Contains("LAB")
        Dim totalCount As Integer = schedList.Count

        Dim cssClass As String = "map-room free"
        If isLab AndAlso isOccupied Then
            cssClass = "map-room occupied lab"
        ElseIf isLab Then
            cssClass = "map-room free lab"
        ElseIf isOccupied Then
            cssClass = "map-room occupied"
        End If

        Dim cardId As String = "card_" & rm.Replace(" ", "_").Replace("(", "").Replace(")", "")

        sb.AppendLine("<div class='" & cssClass & "'>")
        sb.AppendLine("<div class='room-number'>Room " & rm &
                      If(isOccupied, " <span class='sched-count'>" & totalCount &
                         " class" & If(totalCount > 1, "es", "") & "</span>", "") & "</div>")

        If isOccupied Then
            Dim mwfList = schedList.Where(Function(s) s.DayType = "MWF").ToList()
            Dim tthList = schedList.Where(Function(s) s.DayType = "TTH").ToList()
            Dim allItems As New List(Of String)

            If mwfList.Count > 0 Then
                Dim h As String = "<div class='day-group'><span class='day-badge mwf'>MWF</span>"
                For Each s In mwfList
                    h &= "<div class='room-detail'><strong>" & s.TimeSlot & "</strong><br/>" &
                         s.SubjectCode & "<br/>" & s.CourseSection & "<br/>" &
                         "<em>" & s.InstructorName & "</em></div>"
                Next
                h &= "</div>"
                allItems.Add(h)
            End If

            If tthList.Count > 0 Then
                Dim h As String = "<div class='day-group'><span class='day-badge tth'>TTH</span>"
                For Each s In tthList
                    h &= "<div class='room-detail'><strong>" & s.TimeSlot & "</strong><br/>" &
                         s.SubjectCode & "<br/>" & s.CourseSection & "<br/>" &
                         "<em>" & s.InstructorName & "</em></div>"
                Next
                h &= "</div>"
                allItems.Add(h)
            End If

            sb.AppendLine(allItems(0))

            If allItems.Count > 1 Then
                sb.AppendLine("<div id='extra_" & cardId & "' class='card-extra' style='display:none;'>")
                For i As Integer = 1 To allItems.Count - 1
                    sb.AppendLine(allItems(i))
                Next
                sb.AppendLine("</div>")
                sb.AppendLine("<button type='button' class='btn-toggle' " &
                              "onclick=""return toggleExtra('extra_" & cardId & "', this);"">&#9660; Show more</button>")
            End If
        Else
            sb.AppendLine("<div class='room-detail free-text'>Available</div>")
        End If

        sb.AppendLine("</div>")
    End Sub

    Protected Sub btnLogout_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnLogout.Click
        AuthHelper.ClearSession(Me)
        Response.Redirect("Login.aspx")
    End Sub

End Class