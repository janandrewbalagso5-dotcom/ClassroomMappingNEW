Imports System
Imports System.Web
Imports System.Web.UI

Public Class AuthHelper

    ''' <summary>Call at top of Page_Load on every protected page.</summary>
    ''' <param name="page">Pass Me (the current page)</param>
    ''' <param name="allowedRoles">Roles that may access this page. Empty = any logged-in user.</param>
    Public Shared Sub Require(page As Page, ParamArray allowedRoles() As String)
        Dim session = page.Session

        ' Not logged in
        If session("UserID") Is Nothing Then
            page.Response.Redirect("Login.aspx")
            Return
        End If

        ' Role check
        If allowedRoles.Length > 0 Then
            Dim role As String = session("Role").ToString()
            Dim allowed As Boolean = False
            For Each r As String In allowedRoles
                If r.ToLower() = role.ToLower() Then
                    allowed = True
                    Exit For
                End If
            Next
            If Not allowed Then
                page.Response.Redirect("AccessDenied.aspx")
            End If
        End If
    End Sub

    ''' <summary>Returns current user's role, or empty string if not logged in.</summary>
    Public Shared Function GetRole(page As Page) As String
        If page.Session("Role") Is Nothing Then Return ""
        Return page.Session("Role").ToString()
    End Function

    ''' <summary>Returns current user's FullName.</summary>
    Public Shared Function GetFullName(page As Page) As String
        If page.Session("FullName") Is Nothing Then Return ""
        Return page.Session("FullName").ToString()
    End Function

    ''' <summary>Returns current UserID.</summary>
    Public Shared Function GetUserID(page As Page) As Integer
        If page.Session("UserID") Is Nothing Then Return 0
        Return CInt(page.Session("UserID"))
    End Function

    ''' <summary>Returns current LinkedInstructorID (Instructor role only). Returns 0 if not set.</summary>
    Public Shared Function GetLinkedInstructorID(page As Page) As Integer
        If page.Session("LinkedInstructorID") Is Nothing Then Return 0
        If page.Session("LinkedInstructorID") = 0 Then Return 0
        Return CInt(page.Session("LinkedInstructorID"))
    End Function

    ''' <summary>
    ''' Call this in Login.aspx.vb after verifying credentials.
    ''' Stores all needed user info into Session.
    ''' </summary>
    Public Shared Sub SetSession(page As Page, user As UserAccount)
        page.Session("UserID") = user.UserID
        page.Session("Username") = user.Username
        page.Session("Role") = user.Role
        page.Session("FullName") = user.FullName
        page.Session("Email") = user.Email
        page.Session("Phone") = user.Phone

        ' FIX: Store 0 instead of Nothing/null for LinkedInstructorID
        ' Storing a null Nullable(Of Integer) into Session causes silent crashes
        page.Session("LinkedInstructorID") = If(user.LinkedInstructorID.HasValue, user.LinkedInstructorID.Value, 0S)
        page.Session("CourseCode") = If(user.CourseCode, "")
    End Sub

    ''' <summary>Clears all session data. Call on logout.</summary>
    Public Shared Sub ClearSession(page As Page)
        page.Session.Clear()
        page.Session.Abandon()
    End Sub

End Class