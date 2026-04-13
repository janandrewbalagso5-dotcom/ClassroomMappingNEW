Imports System
Imports System.Linq
Imports System.Web.UI

Partial Class [Default]
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        AuthHelper.Require(Me, "Admin", "Dean", "Instructor")

        If Not IsPostBack Then
            Try
                Dim role As String = AuthHelper.GetRole(Me)
                Dim fullName As String = AuthHelper.GetFullName(Me)
                Dim userID As Integer = AuthHelper.GetUserID(Me)

                ' Welcome message
                lblWelcome.Text = "Welcome back, <strong>" & fullName & "</strong>!"
                lblRoleBadge.Text = role

                ' Counts from SQL
                lblScheduleCount.Text = Database.GetAllSchedules().Count & " Schedules"

                ' Role-based visibility
                Select Case role
                    Case "Admin", "Dean"
                        btnSubjects.Visible = True
                        btnInstructors.Visible = True
                        pnlSubjectsCard.Visible = True
                        pnlInstructorsCard.Visible = True
                        lblSubjectCount.Text = Database.GetAllSubjects().Count & " Subjects"
                        lblInstructorCount.Text = Database.GetAllInstructors().Count & " Instructors"

                    Case "Instructor"
                        btnSubjects.Visible = True
                        pnlSubjectsCard.Visible = True

                        ' Get instructor ID from user ID
                        Dim allInstructors As List(Of Instructor) = Database.GetAllInstructors()
                        Dim myInstr As Instructor = allInstructors.FirstOrDefault(Function(i) i.UserID.HasValue AndAlso i.UserID.Value = userID)
                        Dim myInstrID As Integer = 0
                        If myInstr IsNot Nothing Then
                            myInstrID = myInstr.InstructorID
                        End If

                        ' Count subjects where: assigned to me OR added by me
                        Dim allSubjects As List(Of Subject) = Database.GetAllSubjects()
                        Dim myCount As Integer = 0

                        For Each s As Subject In allSubjects
                            Dim assignedToMe As Boolean = s.AssignedInstructorID.HasValue AndAlso s.AssignedInstructorID.Value = myInstrID
                            Dim addedByMe As Boolean = (s.AddedByUserID = userID)
                            If assignedToMe OrElse addedByMe Then
                                myCount = myCount + 1
                            End If
                        Next

                        lblSubjectCount.Text = myCount & " Subjects"
                End Select


            Catch ex As Exception
                ' Show the real error so we can fix it
                Response.Clear()
                Response.Write("<h2 style='color:red'>ERROR ON DEFAULT.ASPX</h2>")
                Response.Write("<b>Message:</b> " & ex.Message & "<br/>")
                Response.Write("<b>Source:</b> " & ex.Source & "<br/>")
                Response.Write("<b>Stack:</b><pre>" & ex.StackTrace & "</pre>")
                Response.End()
            End Try
        End If
    End Sub

    Protected Sub btnLogout_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnLogout.Click
        AuthHelper.ClearSession(Me)
        Response.Redirect("Login.aspx")
    End Sub

End Class