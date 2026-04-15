Imports System
Imports System.Web.UI

Partial Class Login
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        ' FIX: Only check session on fresh load, NOT on postback
        ' Previously this ran on postback too, causing redirect before btnLogin_Click fired
        If Not IsPostBack Then
            If Session("UserID") IsNot Nothing Then
                RedirectByRole(Session("Role").ToString())
            End If
        End If
    End Sub

    Protected Sub btnLogin_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnLogin.Click
        lblError.Visible = False

        Dim username As String = txtUsername.Text.Trim()
        Dim password As String = txtPassword.Text.Trim()  ' Trim spaces — browser/autofill can add trailing space
        Dim selectedRole As String = ddlRole.SelectedValue

        If String.IsNullOrEmpty(username) Then
            ShowError("Please enter your username.")
            Return
        End If

        If selectedRole = "" Then
            ShowError("Please select a user type.")
            Return
        End If

        If String.IsNullOrEmpty(password) Then
            ShowError("Please enter your password.")
            Return
        End If

        Dim hashedInput As String = AuthHelper.HashPassword(password)

        Dim u As UserAccount = Database.GetUserByCredentials(username, hashedInput)

        If u Is Nothing Then
            ShowError("Invalid username or password.")
            Return
        End If

        If u.Role.ToLower() <> selectedRole.ToLower() Then
            ShowError("Incorrect user type selected for this account.")
            Return
        End If

        AuthHelper.SetSession(Me, u)
        RedirectByRole(u.Role)
    End Sub

    Private Sub ShowError(message As String)
        lblError.Text = message
        lblError.Visible = True
    End Sub

    Private Sub RedirectByRole(role As String)
        Select Case role
            Case "Admin", "Dean"
                Response.Redirect("Default.aspx")
            Case "Instructor"
                Response.Redirect("Default.aspx")
            Case "Student"
                Response.Redirect("StudentHome.aspx")
            Case Else
                Response.Redirect("Default.aspx")
        End Select
    End Sub

End Class
