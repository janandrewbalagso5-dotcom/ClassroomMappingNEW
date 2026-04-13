Imports System
Imports System.Linq
Imports System.Web.UI

Partial Class Reports
    Inherits System.Web.UI.Page

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

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        AuthHelper.Require(Me, "Admin", "Dean", "Instructor")
        lblRoleBadge.Text = If(Session("Role"), "").ToString()

        If Not IsPostBack Then
            PopulateInstructorDropdown()

            If CurrentRole = "Instructor" Then
                Dim instr As Instructor = Database.GetAllInstructors() _
                    .FirstOrDefault(Function(i) i.UserID.HasValue AndAlso i.UserID.Value = CurrentUserID)
                If instr IsNot Nothing Then
                    Dim item = ddlInstructor.Items.FindByValue(instr.InstructorID.ToString())
                    If item IsNot Nothing Then
                        ddlInstructor.SelectedValue = instr.InstructorID.ToString()
                        GenerateReport()
                    End If
                End If
            End If
        End If
    End Sub

    Private Sub PopulateInstructorDropdown()
        ddlInstructor.Items.Clear()
        ddlInstructor.Items.Add(New System.Web.UI.WebControls.ListItem("-- Select Instructor --", "0"))

        Dim instructors As List(Of Instructor) = Database.GetAllInstructors().OrderBy(Function(i) i.Name).ToList()

        If CurrentRole = "Instructor" Then
            Dim myInstr As Instructor = instructors.FirstOrDefault(Function(i) i.UserID.HasValue AndAlso i.UserID.Value = CurrentUserID)
            If myInstr IsNot Nothing Then
                ddlInstructor.Items.Add(New System.Web.UI.WebControls.ListItem(myInstr.Name, myInstr.InstructorID.ToString()))
            End If
        Else
            For Each inst As Instructor In instructors
                ddlInstructor.Items.Add(New System.Web.UI.WebControls.ListItem(inst.Name, inst.InstructorID.ToString()))
            Next
        End If
    End Sub

    ' ── Auto-generate when instructor dropdown changes
    Protected Sub ddlInstructor_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs) Handles ddlInstructor.SelectedIndexChanged
        GenerateReport()
    End Sub

    Private Sub GenerateReport()
        Dim instrID As Integer = CInt(ddlInstructor.SelectedValue)
        If instrID = 0 Then
            pnlReport.Visible = False
            pnlInfo.Visible = True
            Return
        End If

        Dim inst As Instructor = Database.GetInstructorByID(instrID)
        If inst Is Nothing Then
            pnlReport.Visible = False
            pnlInfo.Visible = True
            Return
        End If

        lblInstructorName.Text = inst.Name.ToUpper()
        lblQualifications.Text = GetQualAbbr(inst.Qualifications)
        lblYearsTeaching.Text = inst.YearsExperience.ToString()
        lblSemesterTitle.Text = ddlSemester.SelectedValue & " S.Y. " & txtSY.Text.Trim()
        lblSigInstructor.Text = inst.Name.ToUpper() & GetSigSuffix(inst.Qualifications)

        ' ── Drive from schedules so each section row has full Days/Time/Room
        Dim instrSchedules As List(Of Schedule) = Database.GetSchedulesByInstructorName(inst.Name)

        Dim rows As New List(Of TeachingLoadRow)()
        For Each sch As Schedule In instrSchedules
            Dim subj As Subject = Database.GetSubjectByCode(sch.SubjectCode)
            rows.Add(New TeachingLoadRow() With {
                .Code = sch.SubjectCode,
                .Description = If(subj IsNot Nothing, subj.Description, sch.SubjectCode),
                .Days = sch.DayType,
                .HourSchedule = sch.TimeSlot,
                .RoomNo = sch.RoomNo,
                .Units = If(subj IsNot Nothing, subj.Units, 0),
                .NoOfStudents = ""
            })
        Next

        If rows.Count > 0 Then
            rptSubjects.DataSource = rows
            rptSubjects.DataBind()
            rptEmpty.DataSource = New List(Of String)()
            rptEmpty.DataBind()
        Else
            rptSubjects.DataSource = New List(Of TeachingLoadRow)()
            rptSubjects.DataBind()
            rptEmpty.DataSource = New List(Of String)() From {""}
            rptEmpty.DataBind()
        End If

        Dim totalUnits As Integer = rows.Sum(Function(r) r.Units)
        Dim noOfPrep As Integer = rows.Select(Function(r) r.Code.Trim().ToUpper()).Distinct().Count()

        lblTotalUnits.Text = totalUnits.ToString("0.00")
        lblNoOfPrep.Text = noOfPrep.ToString("0.00")

        pnlReport.Visible = True
        pnlInfo.Visible = False
    End Sub

    Private Function GetQualAbbr(qual As String) As String
        If String.IsNullOrWhiteSpace(qual) Then Return ""
        Dim startIdx As Integer = qual.IndexOf("(")
        Dim endIdx As Integer = qual.IndexOf(")")
        If startIdx > 0 AndAlso endIdx > startIdx Then
            Return qual.Substring(startIdx + 1, endIdx - startIdx - 1)
        End If
        Return qual
    End Function

    Private Function GetSigSuffix(qual As String) As String
        Dim abbr As String = GetQualAbbr(qual)
        If abbr = "" Then Return ""
        Return ", " & abbr
    End Function

    Protected Sub btnLogout_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnLogout.Click
        AuthHelper.ClearSession(Me)
        Response.Redirect("Login.aspx")
    End Sub

End Class

Public Class TeachingLoadRow
    Public Property Code As String
    Public Property Description As String
    Public Property Days As String
    Public Property HourSchedule As String
    Public Property RoomNo As String
    Public Property Units As Integer
    Public Property NoOfStudents As String
End Class