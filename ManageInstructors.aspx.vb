Imports System
Imports System.Web.UI

Partial Class ManageInstructors
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        AuthHelper.Require(Me, "Admin", "Dean")
        lblRoleBadge.Text = If(Session("Role"), "").ToString()
        AddHandler btnLogout.Click, AddressOf btnLogout_Click
        If Not IsPostBack Then
            BindGrid()
            pnlMsg.Visible = False
        End If
    End Sub

    Private Sub btnLogout_Click(sender As Object, e As EventArgs)
        Session.Clear()
        Session.Abandon()
        Response.Redirect("Login.aspx")
    End Sub

    Private Sub BindGrid()
        gvInstructors.DataSource = Database.GetAllInstructors()
        gvInstructors.DataBind()
    End Sub

    Private Sub ShowMessage(msg As String, isError As Boolean)
        lblMsg.Text = msg
        alertBox.Attributes("class") = If(isError, "alert alert-error", "alert alert-success")
        pnlMsg.Visible = True
    End Sub

    Private Sub ClearForm()
        hfInstructorID.Value = "0"
        txtName.Text = ""
        ddlQualifications.SelectedIndex = 0
        ddlDepartment.SelectedIndex = 0
        txtYears.Text = "0"
        ddlCourseCode.SelectedIndex = 0   ' ← changed
        chkHEA.Checked = False
        ddlPosition.SelectedIndex = 0
    End Sub

    Protected Sub btnAdd_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnAdd.Click
        ClearForm()
        pnlForm.Visible = True
        pnlMsg.Visible = False
    End Sub

    Protected Sub btnCancel_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancel.Click
        pnlForm.Visible = False
        ClearForm()
    End Sub

    Protected Sub btnSave_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnSave.Click
        If Not Page.IsValid Then Return

        Dim id As Integer = CInt(hfInstructorID.Value)
        Dim yearsRaw As String = txtYears.Text.Trim()
        Dim years As Integer = If(yearsRaw = "" OrElse Not Integer.TryParse(yearsRaw, 0), 0, CInt(yearsRaw))

        Try
            If id = 0 Then
                Dim i As New Instructor()
                i.UserID = Nothing
                i.Name = txtName.Text.Trim()
                i.Qualifications = ddlQualifications.SelectedValue   ' ← dropdown
                i.Position = ddlPosition.SelectedValue
                i.YearsExperience = years
                i.HEA = chkHEA.Checked
                i.Department = ddlDepartment.SelectedValue        ' ← dropdown
                i.CourseCode = ddlCourseCode.SelectedValue
                Database.AddInstructor(i)
                ShowMessage("✔ Instructor added successfully.", False)
            Else
                Dim inst As Instructor = Database.GetInstructorByID(id)
                If inst IsNot Nothing Then
                    inst.Name = txtName.Text.Trim()
                    inst.Qualifications = ddlQualifications.SelectedValue   ' ← dropdown
                    inst.Position = ddlPosition.SelectedValue
                    inst.YearsExperience = years
                    inst.HEA = chkHEA.Checked
                    inst.Department = ddlDepartment.SelectedValue        ' ← dropdown
                    inst.CourseCode = ddlCourseCode.SelectedValue
                    Database.UpdateInstructor(inst)
                    ShowMessage("✔ Instructor updated successfully.", False)
                Else
                    ShowMessage("Instructor not found.", True)
                End If
            End If
        Catch ex As Exception
            ShowMessage("Error: " & ex.Message, True)
        End Try

        pnlForm.Visible = False
        ClearForm()
        BindGrid()
    End Sub

    Protected Sub gvInstructors_RowEditing(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewEditEventArgs) Handles gvInstructors.RowEditing
        Dim id As Integer = CInt(gvInstructors.DataKeys(e.NewEditIndex).Value)
        Dim inst As Instructor = Database.GetInstructorByID(id)

        If inst IsNot Nothing Then
            hfInstructorID.Value = inst.InstructorID.ToString()
            txtName.Text = inst.Name
            txtYears.Text = inst.YearsExperience.ToString()
            Dim courseItem = ddlCourseCode.Items.FindByValue(inst.CourseCode)
            ddlCourseCode.SelectedValue = If(courseItem IsNot Nothing, inst.CourseCode, "")
            chkHEA.Checked = inst.HEA

            ' Set qualifications dropdown safely
            Dim qualItem = ddlQualifications.Items.FindByValue(inst.Qualifications)
            ddlQualifications.SelectedValue = If(qualItem IsNot Nothing, inst.Qualifications, "")

            ' Set department dropdown safely
            Dim deptItem = ddlDepartment.Items.FindByValue(inst.Department)
            ddlDepartment.SelectedValue = If(deptItem IsNot Nothing, inst.Department, "")

            ' Set position dropdown safely
            Dim posItem = ddlPosition.Items.FindByValue(inst.Position)
            ddlPosition.SelectedValue = If(posItem IsNot Nothing, inst.Position, "Instructor")

            pnlForm.Visible = True
            pnlMsg.Visible = False
        End If

        gvInstructors.EditIndex = -1
        BindGrid()
    End Sub

    Protected Sub gvInstructors_RowDeleting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeleteEventArgs) Handles gvInstructors.RowDeleting
        Dim id As Integer = CInt(gvInstructors.DataKeys(e.RowIndex).Value)
        Try
            Database.DeleteInstructor(id)
            ShowMessage("🗑 Instructor deleted.", False)
        Catch ex As Exception
            ShowMessage("Delete failed: " & ex.Message, True)
        End Try
        BindGrid()
    End Sub

    Protected Sub gvInstructors_RowCancelingEdit(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCancelEditEventArgs) Handles gvInstructors.RowCancelingEdit
        gvInstructors.EditIndex = -1
        BindGrid()
    End Sub

    Protected Sub gvInstructors_RowUpdating(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewUpdateEventArgs) Handles gvInstructors.RowUpdating
        gvInstructors.EditIndex = -1
        BindGrid()
    End Sub

End Class