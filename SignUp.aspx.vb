Imports System
Imports System.Web.UI

Partial Class SignUp
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Session("UserID") IsNot Nothing Then
            Dim role As String = Session("Role").ToString()
            If role = "Student" Then
                Response.Redirect("StudentHome.aspx")
            Else
                Response.Redirect("Default.aspx")
            End If
        End If
    End Sub

    Protected Sub btnSignUp_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnSignUp.Click

        ' Hard-coded to Student — instructor registration removed
        Dim selectedRole As String = "Student"

        If txtPassword.Text <> txtConfirmPassword.Text Then
            ShowError("Passwords do not match.")
            Return
        End If
        If txtPassword.Text.Trim().Length < 6 Then
            ShowError("Password must be at least 6 characters.")
            Return
        End If

        ' Course required for students
        If ddlStudentCourse.SelectedValue = "" Then
            ShowError("Please select your course/program.")
            Return
        End If

        Dim username As String = txtUsername.Text.Trim().ToLower()
        Dim existing As UserAccount = Database.GetUserByUsername(username)
        If existing IsNot Nothing Then
            ShowError("Username """ & txtUsername.Text.Trim() & """ is already taken. Please choose another.")
            Return
        End If

        Dim phone As String = txtPhone.Text.Trim()
        If phone = "" Then phone = "0000000000"

        Try
            Dim newUser As New UserAccount()
            newUser.Username = username
            newUser.Password = AuthHelper.HashPassword(txtPassword.Text.Trim())
            newUser.Role = selectedRole
            newUser.FullName = txtFullName.Text.Trim()
            newUser.Email = txtEmail.Text.Trim()
            newUser.Phone = phone
            newUser.LinkedInstructorID = Nothing
            newUser.CourseCode = ddlStudentCourse.SelectedValue
            Database.AddUser(newUser)

            lblMsg.Text = "Account created successfully! Redirecting to login..."
            lblMsg.CssClass = "msg-success"
            lblMsg.Visible = True
            btnSignUp.Enabled = False
            ClientScript.RegisterStartupScript(Me.GetType(), "redirect",
                "setTimeout(function(){ window.location='Login.aspx'; }, 2000);", True)

        Catch ex As Exception
            ShowError("Registration failed: " & ex.Message)
        End Try
    End Sub

    Private Sub ShowError(msg As String)
        lblMsg.Text = msg
        lblMsg.CssClass = "msg-error"
        lblMsg.Visible = True
    End Sub

End Class
