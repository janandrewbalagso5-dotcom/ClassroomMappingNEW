Imports System
Imports System.Web.UI

Partial Class Profile
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        AuthHelper.Require(Me)  ' Any logged-in user
        lblRoleBadge.Text = AuthHelper.GetRole(Me)
        btnHome.PostBackUrl = If(AuthHelper.GetRole(Me) = "Student", "StudentHome.aspx", "Default.aspx")
        If Not IsPostBack Then LoadProfile()
    End Sub

    Private Sub LoadProfile()
        Dim userID As Integer = AuthHelper.GetUserID(Me)
        Dim user As UserAccount = Database.GetUserByID(userID)
        If user Is Nothing Then Return

        lblFullName.Text = user.FullName
        lblUsername.Text = user.Username
        lblRole.Text = user.Role
        lblInfoName.Text = user.FullName
        lblInfoUsername.Text = user.Username
        lblInfoRole.Text = user.Role

        If user.Role = "Instructor" AndAlso user.LinkedInstructorID > 0 Then
            Dim inst As Instructor = Database.GetInstructorByID(user.LinkedInstructorID)
            If inst IsNot Nothing Then
                pnlInstructorInfo.Visible = True
                lblPosition.Text = If(inst.Position, "—")
                lblQualifications.Text = If(inst.Qualifications, "—")
                lblYears.Text = inst.YearsExperience.ToString() & " years"
                lblHEA.Text = If(inst.HEA, "Yes", "No")
            End If
        End If
    End Sub



    Protected Sub btnChangePw_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnChangePw.Click
        Dim userID As Integer = AuthHelper.GetUserID(Me)
        Dim user As UserAccount = Database.GetUserByID(userID)
        If user Is Nothing Then Return

        Dim current As String = txtCurrentPw.Text.Trim()
        Dim newPw As String = txtNewPw.Text.Trim()
        Dim confirm As String = txtConfirmPw.Text.Trim()

        Dim currentHsh As String = AuthHelper.HashPassword(current)

        ' Verify current password using SHA-256
        If user.Password <> AuthHelper.HashPassword(txtCurrentPw.Text) Then
            lblPwMsg.Text = "Current password is incorrect."
            lblPwMsg.CssClass = "msg-error"
            Return
        End If

        If newPw.Length < 6 Then
            lblPwMsg.Text = "New password must be at least 6 characters."
            lblPwMsg.CssClass = "msg-error"
            Return
        End If

        If newPw <> confirm Then
            lblPwMsg.Text = "New passwords do not match."
            lblPwMsg.CssClass = "msg-error"
            Return
        End If

        ' Save hashed new password
        user.Password = AuthHelper.HashPassword(newPw)
        Database.UpdateUser(user)

        lblPwMsg.Text = "Password updated successfully."
        lblPwMsg.CssClass = "msg-success"
        txtCurrentPw.Text = ""
        txtNewPw.Text = ""
        txtConfirmPw.Text = ""
    End Sub

    Protected Sub btnLogout_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnLogout.Click
        AuthHelper.ClearSession(Me)
        Response.Redirect("Login.aspx")
    End Sub

End Class