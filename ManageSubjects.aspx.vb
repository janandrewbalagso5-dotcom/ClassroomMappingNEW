Imports System
Imports System.Linq
Imports System.Web.UI

Partial Class ManageSubjects
    Inherits System.Web.UI.Page

    ' ── Role / User helpers ───────────────────────────────────────────────
    Private ReadOnly Property CurrentRole As String
        Get
            Return AuthHelper.GetRole(Me)
        End Get
    End Property

    Private ReadOnly Property CurrentUserID As Integer
        Get
            Return AuthHelper.GetUserID(Me)
        End Get
    End Property

    Private ReadOnly Property CurrentInstructorID As Integer
        Get
            Dim instr As Instructor = Database.GetAllInstructors() _
                .FirstOrDefault(Function(i) i.UserID.HasValue AndAlso i.UserID.Value = CurrentUserID)
            If instr IsNot Nothing Then
                Return instr.InstructorID
            End If
            Return 0
        End Get
    End Property

    Private ReadOnly Property IsAdminOrDean As Boolean
        Get
            Return CurrentRole = "Admin" OrElse CurrentRole = "Dean"
        End Get
    End Property

    ' ── Page Load ─────────────────────────────────────────────────────────
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        AuthHelper.Require(Me, "Admin", "Dean", "Instructor")
        lblRoleBadge.Text = If(Session("Role"), "").ToString()

        If Not IsPostBack Then
            If IsAdminOrDean Then
                pnlFilter.Visible = True
                PopulateInstructorFilter()
            End If
            BindGrid()
        End If
    End Sub

    ' ── Populate instructor filter dropdown (Admin/Dean) ──────────────────
    ' Now lists instructors by InstructorID so the filter can match
    ' AssignedInstructorID correctly.
    Private Sub PopulateInstructorFilter()
        ddlFilterInstructor.Items.Clear()
        ddlFilterInstructor.Items.Add(New System.Web.UI.WebControls.ListItem("-- All Instructors --", "0"))
        For Each inst As Instructor In Database.GetAllInstructors().OrderBy(Function(i) i.Name)
            ddlFilterInstructor.Items.Add(New System.Web.UI.WebControls.ListItem(inst.Name, inst.InstructorID.ToString()))
        Next
    End Sub

    ' ── Populate assign-to-instructor dropdown (Admin/Dean) ───────────────
    Private Sub PopulateAssignInstructor()
        ddlAssignInstructor.Items.Clear()
        ddlAssignInstructor.Items.Add(New System.Web.UI.WebControls.ListItem("-- Unassigned --", "0"))
        For Each inst As Instructor In Database.GetAllInstructors().OrderBy(Function(i) i.Name)
            ddlAssignInstructor.Items.Add(New System.Web.UI.WebControls.ListItem(inst.Name, inst.InstructorID.ToString()))
        Next
    End Sub

    ' ── Bind grid ─────────────────────────────────────────────────────────
    Private Sub BindGrid()
        Dim allSubjects As List(Of Subject) = Database.GetAllSubjects()
        Dim allUsers As List(Of UserAccount) = Database.GetAllUsers()
        Dim allInstructors As List(Of Instructor) = Database.GetAllInstructors()

        ' Determine which subjects to show
        Dim filtered As List(Of Subject)
        If CurrentRole = "Instructor" Then
            ' Show subjects assigned to this instructor OR added by this user
            Dim myInstrID As Integer = CurrentInstructorID
            filtered = allSubjects.Where(Function(s)
                                             Return (s.AssignedInstructorID.HasValue AndAlso s.AssignedInstructorID.Value = myInstrID) _
                                                    OrElse s.AddedByUserID = CurrentUserID
                                         End Function).ToList()
        ElseIf IsAdminOrDean AndAlso ddlFilterInstructor.SelectedValue <> "0" Then
            ' FIX: filter by AssignedInstructorID (not AddedByUserID)
            Dim filterInstrID As Integer = CInt(ddlFilterInstructor.SelectedValue)
            filtered = allSubjects.Where(Function(s) _
                s.AssignedInstructorID.HasValue AndAlso s.AssignedInstructorID.Value = filterInstrID).ToList()
        Else
            filtered = allSubjects
        End If

        ' Build display rows (resolve names)
        Dim result = filtered.Select(Function(s)
                                         Dim addedByUser As UserAccount = allUsers.FirstOrDefault(Function(u) u.UserID = s.AddedByUserID)
                                         Dim assignedInstr As Instructor = allInstructors.FirstOrDefault(Function(i) s.AssignedInstructorID.HasValue AndAlso i.InstructorID = s.AssignedInstructorID.Value)
                                         Return New SubjectDisplay() With {
                                             .SubjectID = s.SubjectID,
                                             .Code = s.Code,
                                             .Description = s.Description,
                                             .Units = s.Units,
                                             .CourseCode = s.CourseCode,
                                             .YearLevel = s.YearLevel,
                                             .Section = If(s.Section, ""),
                                             .AddedByName = If(addedByUser IsNot Nothing, addedByUser.FullName, If(s.AddedByUserID = 0, "System", "Unknown")),
                                             .AssignedInstructorName = If(assignedInstr IsNot Nothing, assignedInstr.Name, "Unassigned")
                                         }
                                     End Function).ToList()

        gvSubjects.DataSource = result
        gvSubjects.DataBind()
    End Sub

    ' ── Filter instructor dropdown changed ────────────────────────────────
    Protected Sub ddlFilterInstructor_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs) Handles ddlFilterInstructor.SelectedIndexChanged
        BindGrid()
    End Sub

    Protected Sub btnClearFilter_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnClearFilter.Click
        ddlFilterInstructor.SelectedIndex = 0
        BindGrid()
    End Sub

    ' ── Add button ────────────────────────────────────────────────────────
    Protected Sub btnAdd_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnAdd.Click
        ClearForm()
        pnlForm.Visible = True
        lblMsg.Text = ""
    End Sub

    ' ── Clear form helper ─────────────────────────────────────────────────
    Private Sub ClearForm()
        hfSubjectID.Value = "0"
        txtCode.Text = ""
        txtDescription.Text = ""
        txtUnits.Text = ""
        txtCustomCourse.Text = ""
        ddlCourse.SelectedValue = ""
        ddlYearLevel.SelectedValue = ""
        ddlSection.SelectedValue = ""

        If IsAdminOrDean Then
            pnlAssignInstructor.Visible = True
            PopulateAssignInstructor()
            ddlAssignInstructor.SelectedValue = "0"
        Else
            pnlAssignInstructor.Visible = False
        End If
    End Sub

    ' ── Resolve course code (dropdown vs custom text) ─────────────────────
    Private Function GetCourseCode() As String
        Dim custom As String = txtCustomCourse.Text.Trim().ToUpper()
        If custom <> "" Then
            If ddlCourse.Items.FindByValue(custom) Is Nothing Then
                ddlCourse.Items.Add(New System.Web.UI.WebControls.ListItem(custom, custom))
            End If
            ddlCourse.SelectedValue = custom
            Return custom
        End If
        Return ddlCourse.SelectedValue
    End Function

    ' ── Save button ───────────────────────────────────────────────────────
    Protected Sub btnSave_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnSave.Click
        Dim id As Integer = CInt(hfSubjectID.Value)
        Dim courseCode As String = GetCourseCode()

        If courseCode = "" Then
            lblMsg.Text = "Please select or enter a course."
            lblMsg.CssClass = "msg-error"
            Return
        End If

        Dim sectionValue As String = If(ddlSection.SelectedValue = "", Nothing, ddlSection.SelectedValue)
        Dim assignedID As Integer? = Nothing

        ' Only Admin/Dean can assign subjects to instructors
        If IsAdminOrDean Then
            Dim raw As Integer = CInt(ddlAssignInstructor.SelectedValue)
            If raw > 0 Then assignedID = raw
        End If

        If id = 0 Then
            ' ── ADD new subject ──
            Dim s As New Subject()
            s.Code = txtCode.Text.Trim()
            s.Description = txtDescription.Text.Trim()
            s.Units = If(txtUnits.Text.Trim() = "", 3, CInt(txtUnits.Text))
            s.CourseCode = courseCode
            s.YearLevel = ddlYearLevel.SelectedValue
            s.Section = sectionValue
            s.AddedByUserID = CurrentUserID
            s.AssignedInstructorID = assignedID
            Database.AddSubject(s)
            lblMsg.Text = "✔ Subject added successfully!"
            lblMsg.CssClass = "msg-success"
        Else
            ' ── UPDATE existing subject ──
            Dim subj As Subject = Database.GetSubjectByID(id)
            If subj IsNot Nothing Then
                ' Instructors can only edit subjects they added
                If CurrentRole = "Instructor" AndAlso subj.AddedByUserID <> CurrentUserID Then
                    lblMsg.Text = "You can only edit subjects you added."
                    lblMsg.CssClass = "msg-error"
                    pnlForm.Visible = False
                    BindGrid()
                    Return
                End If
                subj.Code = txtCode.Text.Trim()
                subj.Description = txtDescription.Text.Trim()
                subj.Units = If(txtUnits.Text.Trim() = "", 3, CInt(txtUnits.Text))
                subj.CourseCode = courseCode
                subj.YearLevel = ddlYearLevel.SelectedValue
                subj.Section = sectionValue
                subj.AssignedInstructorID = assignedID
                Database.UpdateSubject(subj)
                lblMsg.Text = "✔ Subject updated successfully!"
                lblMsg.CssClass = "msg-success"
            End If
        End If

        txtCustomCourse.Text = ""
        pnlForm.Visible = False
        BindGrid()
    End Sub

    ' ── Cancel button ─────────────────────────────────────────────────────
    Protected Sub btnCancel_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancel.Click
        txtCustomCourse.Text = ""
        pnlForm.Visible = False
        lblMsg.Text = ""
    End Sub

    ' ── Grid row commands (Edit / Delete) ─────────────────────────────────
    Protected Sub gvSubjects_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvSubjects.RowCommand
        Dim rowIndex As Integer = CInt(e.CommandArgument)
        Dim id As Integer = CInt(gvSubjects.DataKeys(rowIndex).Value)
        Dim subj As Subject = Database.GetSubjectByID(id)

        If e.CommandName = "EditRow" Then
            If subj IsNot Nothing Then
                If CurrentRole = "Instructor" AndAlso subj.AddedByUserID <> CurrentUserID Then
                    lblMsg.Text = "You can only edit subjects you added."
                    lblMsg.CssClass = "msg-error"
                    BindGrid()
                    Return
                End If

                hfSubjectID.Value = subj.SubjectID.ToString()
                txtCode.Text = subj.Code
                txtDescription.Text = subj.Description
                txtUnits.Text = subj.Units.ToString()
                ddlCourse.SelectedValue = If(subj.CourseCode, "")
                ddlYearLevel.SelectedValue = If(subj.YearLevel, "")
                ddlSection.SelectedValue = If(subj.Section, "")

                If IsAdminOrDean Then
                    pnlAssignInstructor.Visible = True
                    PopulateAssignInstructor()
                    Dim assignVal As String = If(subj.AssignedInstructorID.HasValue,
                        subj.AssignedInstructorID.Value.ToString(), "0")
                    Dim item = ddlAssignInstructor.Items.FindByValue(assignVal)
                    If item IsNot Nothing Then ddlAssignInstructor.SelectedValue = assignVal
                Else
                    pnlAssignInstructor.Visible = False
                End If

                pnlForm.Visible = True
                lblMsg.Text = ""
                BindGrid()
            End If

        ElseIf e.CommandName = "DeleteRow" Then
            If subj IsNot Nothing Then
                If CurrentRole = "Instructor" AndAlso subj.AddedByUserID <> CurrentUserID Then
                    lblMsg.Text = "You can only delete subjects you added."
                    lblMsg.CssClass = "msg-error"
                    BindGrid()
                    Return
                End If
                Database.DeleteSubject(id)
                lblMsg.Text = "🗑 Subject deleted."
                lblMsg.CssClass = "msg-success"
                BindGrid()
            End If
        End If
    End Sub

    ' ── Logout ────────────────────────────────────────────────────────────
    Protected Sub btnLogout_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnLogout.Click
        AuthHelper.ClearSession(Me)
        Response.Redirect("Login.aspx")
    End Sub

End Class

' ── Helper class for GridView display ─────────────────────────────────────
Public Class SubjectDisplay
    Public Property SubjectID As Integer
    Public Property Code As String
    Public Property Description As String
    Public Property Units As Integer
    Public Property CourseCode As String
    Public Property YearLevel As String
    Public Property Section As String
    Public Property AddedByName As String
    Public Property AssignedInstructorName As String
End Class