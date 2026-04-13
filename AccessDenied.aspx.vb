Imports System
Imports System.Web.UI

Partial Class AccessDenied
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
    End Sub

    Protected Sub btnHome_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnHome.Click
        Dim role As String = AuthHelper.GetRole(Me)
        Select Case role
            Case "Student"
                Response.Redirect("StudentHome.aspx")
            Case "Admin", "Dean", "Instructor"
                Response.Redirect("Default.aspx")
            Case Else
                Response.Redirect("Login.aspx")
        End Select
    End Sub

End Class