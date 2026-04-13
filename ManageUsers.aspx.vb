Imports System
Imports System.Web.UI
Imports System.Security.Cryptography
Imports System.Text
Imports System.Linq

Partial Class ManageUsers
    Inherits System.Web.UI.Page

    '  PAGE LOAD — Admin and Dean
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        AuthHelper.Require(Me, "Admin", "Dean")

        lblRoleBadge.Text = If(Session("Role") IsNot Nothing, Session("Role").ToString(), "")
        AddHandler btnLogout.Click, AddressOf btnLogout_Click

        If Not IsPostBack Then
            pnlMsg.Visible = False
            pnlAddForm.Visible = False
            pnlForm.Visible = False
            BindGrid("")
            UpdateCountPills()
        End If
    End Sub

    '  ROLE BADGE CSS
    Public Function GetRoleBadgeClass(role As String) As String
        Select Case role.ToLower()
            Case "admin" : Return "badge badge-admin"
            Case "dean" : Return "badge badge-dean"
            Case "instructor" : Return "badge badge-instructor"
            Case "student" : Return "badge badge-student"
            Case Else : Return "badge"
        End Select
    End Function

    '  BIND GRID
    Private Sub BindGrid(roleFilter As String)
        Dim allUsers As List(Of UserAccount) = Database.GetAllUsers()
        If roleFilter <> "" Then
            allUsers = allUsers.Where(Function(u) u.Role.ToLower() = roleFilter.ToLower()).ToList()
        End If
        gvUsers.DataSource = allUsers
        gvUsers.DataBind()
    End Sub

    Private Sub UpdateCountPills()
        Dim allUsers As List(Of UserAccount) = Database.GetAllUsers()
        lblCountAll.Text = allUsers.Count.ToString()
        lblCountAdmin.Text = allUsers.Where(Function(u) u.Role = "Admin").Count().ToString()
        lblCountDean.Text = allUsers.Where(Function(u) u.Role = "Dean").Count().ToString()
        lblCountInstructor.Text = allUsers.Where(Function(u) u.Role = "Instructor").Count().ToString()
        lblCountStudent.Text = allUsers.Where(Function(u) u.Role = "Student").Count().ToString()
    End Sub

    '  SHOW ADD FORM
    Protected Sub btnShowAdd_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnShowAdd.Click
        pnlAddForm.Visible = True
        pnlForm.Visible = False
        pnlMsg.Visible = False
        txtAddFullName.Text = ""
        txtAddUsername.Text = ""
        txtAddPassword.Text = ""
        txtAddEmail.Text = ""
        txtAddPhone.Text = ""
        txtAddYears.Text = "0"
        chkAddHEA.Checked = False
        ddlAddRole.SelectedValue = "Instructor"
        ddlAddQualification.SelectedIndex = 0
        ddlAddPosition.SelectedValue = "Instructor"
        ddlAddDepartment.SelectedIndex = 0
    End Sub

    Private Function HashPassword(plainText As String) As String
        Using sha As SHA256 = SHA256.Create()
            Dim bytes As Byte() = sha.ComputeHash(Encoding.UTF8.GetBytes(plainText))
            Dim sb As New StringBuilder()
            For Each b As Byte In bytes
                sb.Append(b.ToString("x2"))
            Next
            Return sb.ToString()
        End Using
    End Function

    '  SAVE NEW USER
    Protected Sub btnAddSave_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnAddSave.Click
        If Not Page.IsValid Then Return

        Dim username As String = txtAddUsername.Text.Trim()
        Dim password As String = txtAddPassword.Text.Trim()
        Dim fullName As String = txtAddFullName.Text.Trim()
        Dim role As String = ddlAddRole.SelectedValue
        Dim email As String = txtAddEmail.Text.Trim()
        Dim phone As String = txtAddPhone.Text.Trim()

        ' Dean cannot create Admin accounts
        If AuthHelper.GetRole(Me) = "Dean" AndAlso role = "Admin" Then
            ShowMessage("Deans cannot create Administrator accounts.", True)
            Return
        End If

        If password.Length < 6 Then
            ShowMessage("Password must be at least 6 characters.", True)
            Return
        End If

        ' Check for duplicate username
        Dim existing As UserAccount = Database.GetAllUsers().FirstOrDefault(Function(u) u.Username.ToLower() = username.ToLower())
        If existing IsNot Nothing Then
            ShowMessage("Username '" & username & "' is already taken. Please choose another.", True)
            Return
        End If

        If phone = "" Then phone = "0000000000"

        Dim newUser As New UserAccount()
        newUser.Username = username
        newUser.FullName = fullName
        newUser.Password = HashPassword(password)
        newUser.Role = role
        newUser.Email = email
        newUser.Phone = phone

        Try
            Database.AddUser(newUser)

            ' If Instructor — also create linked Instructor record
            If role = "Instructor" Then
                Dim years As Integer = 0
                Integer.TryParse(txtAddYears.Text.Trim(), years)

                Dim newInst As New Instructor()
                newInst.Name = fullName
                newInst.Qualifications = ddlAddQualification.SelectedValue
                newInst.Position = ddlAddPosition.SelectedValue
                newInst.Department = ddlAddDepartment.SelectedValue
                newInst.CourseCode = ddlAddDepartment.SelectedValue  ' keep both in sync
                newInst.YearsExperience = years
                newInst.HEA = chkAddHEA.Checked

                ' Link UserID — fetch the just-created user to get their ID
                Dim created As UserAccount = Database.GetAllUsers().FirstOrDefault(Function(u) u.Username.ToLower() = username.ToLower())
                If created IsNot Nothing Then
                    newInst.UserID = created.UserID

                    ' AddInstructor now returns the new InstructorID via OUTPUT INSERTED
                    Dim instrID As Integer = Database.AddInstructor(newInst)

                    ' Save the link back to the user record
                    created.LinkedInstructorID = instrID
                    Database.UpdateUser(created)
                End If
            End If

            ShowMessage("✔ Account created for <strong>" & fullName & "</strong> (" & role & ") — Username: <strong>" & username & "</strong>", False)
            pnlAddForm.Visible = False
        Catch ex As Exception
            ShowMessage("Failed to create account: " & ex.Message, True)
        End Try

        BindGrid(ddlRoleFilter.SelectedValue)
        UpdateCountPills()
    End Sub

    '  CANCEL ADD
    Protected Sub btnAddCancel_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnAddCancel.Click
        pnlAddForm.Visible = False
    End Sub

    '  DROPDOWN FILTER
    Protected Sub ddlRoleFilter_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs) Handles ddlRoleFilter.SelectedIndexChanged
        pnlMsg.Visible = False
        pnlForm.Visible = False
        BindGrid(ddlRoleFilter.SelectedValue)
        UpdateCountPills()
    End Sub

    Protected Sub FilterPill_Click(sender As Object, e As EventArgs)
        Dim lb As LinkButton = DirectCast(sender, LinkButton)
        Dim role As String = lb.CommandArgument
        ddlRoleFilter.SelectedValue = role
        pnlMsg.Visible = False
        pnlForm.Visible = False
        BindGrid(role)
        UpdateCountPills()
    End Sub

    '  LOGOUT
    Private Sub btnLogout_Click(sender As Object, e As EventArgs)
        Session.Clear()
        Session.Abandon()
        Response.Redirect("Login.aspx")
    End Sub

    '  SHOW ALERT
    Private Sub ShowMessage(msg As String, isError As Boolean)
        lblMsg.Text = msg
        alertBox.Attributes("class") = If(isError, "alert alert-error", "alert alert-success")
        pnlMsg.Visible = True
    End Sub

    '  GRID — ROW EDITING
    Protected Sub gvUsers_RowEditing(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewEditEventArgs) Handles gvUsers.RowEditing
        Dim id As Integer = CInt(gvUsers.DataKeys(e.NewEditIndex).Value)
        Dim u As UserAccount = Database.GetUserByID(id)

        If u IsNot Nothing Then
            If u.UserID = AuthHelper.GetUserID(Me) Then
                ShowMessage("To edit your own account, use the Profile page.", True)
                gvUsers.EditIndex = -1
                BindGrid(ddlRoleFilter.SelectedValue)
                Return
            End If
            If AuthHelper.GetRole(Me) = "Dean" AndAlso u.Role = "Admin" Then
                ShowMessage("Deans cannot edit Administrator accounts.", True)
                gvUsers.EditIndex = -1
                BindGrid(ddlRoleFilter.SelectedValue)
                Return
            End If

            hfUserID.Value = u.UserID.ToString()
            txtFullName.Text = u.FullName
            txtEmail.Text = u.Email
            txtPhone.Text = u.Phone
            txtNewPassword.Text = ""
            pnlForm.Visible = True
            pnlAddForm.Visible = False
            pnlMsg.Visible = False
        End If

        gvUsers.EditIndex = -1
        BindGrid(ddlRoleFilter.SelectedValue)
    End Sub

    '  SAVE EDIT
    Protected Sub btnSave_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnSave.Click
        If Not Page.IsValid Then Return

        Dim id As Integer = CInt(hfUserID.Value)
        Dim u As UserAccount = Database.GetUserByID(id)

        If u IsNot Nothing Then
            If AuthHelper.GetRole(Me) = "Dean" AndAlso u.Role = "Admin" Then
                ShowMessage("Deans cannot modify Administrator accounts.", True)
                Return
            End If

            u.FullName = txtFullName.Text.Trim()
            u.Email = txtEmail.Text.Trim()
            u.Phone = txtPhone.Text.Trim()

            Dim newPass As String = txtNewPassword.Text.Trim()

            If newPass.Length >= 6 Then
                u.Password = HashPassword(newPass)
            End If

            Try
                Database.UpdateUser(u)
                ShowMessage("✔ User updated successfully.", False)
            Catch ex As Exception
                ShowMessage("Update failed: " & ex.Message, True)
            End Try
        End If

        pnlForm.Visible = False
        BindGrid(ddlRoleFilter.SelectedValue)
        UpdateCountPills()
    End Sub

    Protected Sub btnCancel_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancel.Click
        pnlForm.Visible = False
    End Sub

    '  GRID — ROW DELETING
    Protected Sub gvUsers_RowDeleting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeleteEventArgs) Handles gvUsers.RowDeleting
        Dim id As Integer = CInt(gvUsers.DataKeys(e.RowIndex).Value)

        If id = AuthHelper.GetUserID(Me) Then
            ShowMessage("You cannot delete your own account.", True)
            BindGrid(ddlRoleFilter.SelectedValue)
            Return
        End If

        Dim target As UserAccount = Database.GetUserByID(id)
        If target IsNot Nothing AndAlso AuthHelper.GetRole(Me) = "Dean" AndAlso target.Role = "Admin" Then
            ShowMessage("Deans cannot delete Administrator accounts.", True)
            BindGrid(ddlRoleFilter.SelectedValue)
            Return
        End If

        Try
            Database.DeleteUser(id)
            ShowMessage("🗑 User deleted.", False)
        Catch ex As Exception
            ShowMessage("Delete failed: " & ex.Message, True)
        End Try

        BindGrid(ddlRoleFilter.SelectedValue)
        UpdateCountPills()
    End Sub

    Protected Sub gvUsers_RowCancelingEdit(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCancelEditEventArgs) Handles gvUsers.RowCancelingEdit
        gvUsers.EditIndex = -1
        BindGrid(ddlRoleFilter.SelectedValue)
    End Sub

    Protected Sub gvUsers_RowUpdating(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewUpdateEventArgs) Handles gvUsers.RowUpdating
        gvUsers.EditIndex = -1
        BindGrid(ddlRoleFilter.SelectedValue)
    End Sub

End Class