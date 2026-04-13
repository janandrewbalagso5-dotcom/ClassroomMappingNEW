Imports System
Imports System.Collections.Generic
Imports System.Data.SqlClient
Imports System.Configuration

' ============================================================
'  Model Classes
' ============================================================

Public Class Subject
    Public Property SubjectID As Integer
    Public Property Code As String
    Public Property Description As String
    Public Property Units As Integer
    Public Property CourseCode As String
    Public Property YearLevel As String
    Public Property Section As String
    Public Property AddedByUserID As Integer
    Public Property AssignedInstructorID As Integer?
End Class

Public Class Instructor
    Public Property InstructorID As Integer
    Public Property UserID As Integer?
    Public Property Name As String
    Public Property Qualifications As String
    Public Property Position As String
    Public Property YearsExperience As Integer
    Public Property HEA As Boolean
    Public Property Department As String
    Public Property CourseCode As String
End Class

Public Class CourseSection
    Public Property SectionID As Integer
    Public Property CourseCode As String
    Public Property YearLevel As String
    Public Property Section As String
    Public ReadOnly Property DisplayName As String
        Get
            Return CourseCode & YearLevel & "-" & Section
        End Get
    End Property
End Class

Public Class Schedule
    Public Property ScheduleID As Integer
    Public Property RoomNo As String
    Public Property TimeSlot As String
    Public Property DayType As String
    Public Property SubjectCode As String
    Public Property CourseSection As String
    Public Property InstructorName As String
End Class

Public Class UserAccount
    Public Property UserID As Integer
    Public Property Username As String
    Public Property Password As String
    Public Property Role As String
    Public Property FullName As String
    Public Property Email As String
    Public Property Phone As String
    Public Property LinkedInstructorID As Integer?
    Public Property CourseCode As String
End Class

' ============================================================
'  Database Class
' ============================================================

Public Class Database

    Public Shared Function GetConnection() As SqlConnection
        Dim connStr As String = ConfigurationManager.ConnectionStrings("ClassroomMappingDB").ConnectionString
        Return New SqlConnection(connStr)
    End Function

    ' ══════════════════════════════════════════
    '  SUBJECTS
    ' ══════════════════════════════════════════

    Public Shared Function GetAllSubjects() As List(Of Subject)
        Dim list As New List(Of Subject)
        Using conn = GetConnection()
            conn.Open()
            Dim cmd As New SqlCommand("SELECT * FROM Subjects ORDER BY Code", conn)
            Dim r = cmd.ExecuteReader()
            While r.Read()
                list.Add(MapSubject(r))
            End While
        End Using
        Return list
    End Function

    Public Shared Function GetSubjectByID(id As Integer) As Subject
        Using conn = GetConnection()
            conn.Open()
            Dim cmd As New SqlCommand("SELECT * FROM Subjects WHERE SubjectID = @id", conn)
            cmd.Parameters.AddWithValue("@id", id)
            Dim r = cmd.ExecuteReader()
            If r.Read() Then Return MapSubject(r)
        End Using
        Return Nothing
    End Function

    Public Shared Function GetSubjectByCode(code As String) As Subject
        Using conn = GetConnection()
            conn.Open()
            Dim cmd As New SqlCommand("SELECT * FROM Subjects WHERE Code = @code", conn)
            cmd.Parameters.AddWithValue("@code", code)
            Dim r = cmd.ExecuteReader()
            If r.Read() Then Return MapSubject(r)
        End Using
        Return Nothing
    End Function

    Public Shared Function GetSubjectsByInstructorID(instructorID As Integer) As List(Of Subject)
        Dim list As New List(Of Subject)
        Using conn = GetConnection()
            conn.Open()
            Dim cmd As New SqlCommand(
                "SELECT * FROM Subjects WHERE AssignedInstructorID = @id ORDER BY Code", conn)
            cmd.Parameters.AddWithValue("@id", instructorID)
            Dim r = cmd.ExecuteReader()
            While r.Read()
                list.Add(MapSubject(r))
            End While
        End Using
        Return list
    End Function

    Public Shared Sub AddSubject(s As Subject)
        Using conn = GetConnection()
            conn.Open()
            Dim sql As String =
                "INSERT INTO Subjects (Code, Description, Units, CourseCode, YearLevel, Section, AddedByUserID, AssignedInstructorID) " &
                "VALUES (@code, @desc, @units, @course, @year, @section, @addedBy, @assignedInstr)"
            Dim cmd As New SqlCommand(sql, conn)
            cmd.Parameters.AddWithValue("@code", If(s.Code, ""))
            cmd.Parameters.AddWithValue("@desc", If(s.Description, ""))
            cmd.Parameters.AddWithValue("@units", s.Units)
            cmd.Parameters.AddWithValue("@course", If(s.CourseCode, ""))
            cmd.Parameters.AddWithValue("@year", If(s.YearLevel, ""))
            cmd.Parameters.AddWithValue("@section", If(s.Section, ""))
            cmd.Parameters.AddWithValue("@addedBy", s.AddedByUserID)
            cmd.Parameters.AddWithValue("@assignedInstr",
                If(s.AssignedInstructorID.HasValue, CObj(s.AssignedInstructorID.Value), DBNull.Value))
            cmd.ExecuteNonQuery()
        End Using
    End Sub

    Public Shared Sub UpdateSubject(s As Subject)
        Using conn = GetConnection()
            conn.Open()
            Dim sql As String =
                "UPDATE Subjects SET Code=@code, Description=@desc, Units=@units, " &
                "CourseCode=@course, YearLevel=@year, Section=@section, " &
                "AssignedInstructorID=@assignedInstr " &
                "WHERE SubjectID=@id"
            Dim cmd As New SqlCommand(sql, conn)
            cmd.Parameters.AddWithValue("@code", If(s.Code, ""))
            cmd.Parameters.AddWithValue("@desc", If(s.Description, ""))
            cmd.Parameters.AddWithValue("@units", s.Units)
            cmd.Parameters.AddWithValue("@course", If(s.CourseCode, ""))
            cmd.Parameters.AddWithValue("@year", If(s.YearLevel, ""))
            cmd.Parameters.AddWithValue("@section", If(s.Section, ""))
            cmd.Parameters.AddWithValue("@assignedInstr",
                If(s.AssignedInstructorID.HasValue, CObj(s.AssignedInstructorID.Value), DBNull.Value))
            cmd.Parameters.AddWithValue("@id", s.SubjectID)
            cmd.ExecuteNonQuery()
        End Using
    End Sub

    Public Shared Sub DeleteSubject(id As Integer)
        Using conn = GetConnection()
            conn.Open()
            Dim cmd As New SqlCommand("DELETE FROM Subjects WHERE SubjectID = @id", conn)
            cmd.Parameters.AddWithValue("@id", id)
            cmd.ExecuteNonQuery()
        End Using
    End Sub

    Private Shared Function MapSubject(r As SqlDataReader) As Subject
        Return New Subject With {
            .SubjectID = CInt(r("SubjectID")),
            .Code = r("Code").ToString(),
            .Description = r("Description").ToString(),
            .Units = CInt(r("Units")),
            .CourseCode = r("CourseCode").ToString(),
            .YearLevel = r("YearLevel").ToString(),
            .Section = r("Section").ToString(),
            .AddedByUserID = CInt(r("AddedByUserID")),
            .AssignedInstructorID = If(IsDBNull(r("AssignedInstructorID")), Nothing,
                                       CType(CInt(r("AssignedInstructorID")), Integer?))
        }
    End Function

    ' ══════════════════════════════════════════
    '  INSTRUCTORS
    ' ══════════════════════════════════════════

    Public Shared Function GetAllInstructors() As List(Of Instructor)
        Dim list As New List(Of Instructor)
        Using conn = GetConnection()
            conn.Open()
            Dim cmd As New SqlCommand("SELECT * FROM Instructors ORDER BY Name", conn)
            Dim r = cmd.ExecuteReader()
            While r.Read()
                list.Add(MapInstructor(r))
            End While
        End Using
        Return list
    End Function

    Public Shared Function GetInstructorByID(id As Integer) As Instructor
        Using conn = GetConnection()
            conn.Open()
            Dim cmd As New SqlCommand("SELECT * FROM Instructors WHERE InstructorID = @id", conn)
            cmd.Parameters.AddWithValue("@id", id)
            Dim r = cmd.ExecuteReader()
            If r.Read() Then Return MapInstructor(r)
        End Using
        Return Nothing
    End Function

    Public Shared Function GetInstructorByUserID(userID As Integer) As Instructor
        Using conn = GetConnection()
            conn.Open()
            Dim cmd As New SqlCommand("SELECT * FROM Instructors WHERE UserID = @uid", conn)
            cmd.Parameters.AddWithValue("@uid", userID)
            Dim r = cmd.ExecuteReader()
            If r.Read() Then Return MapInstructor(r)
        End Using
        Return Nothing
    End Function

    ''' <summary>
    ''' Inserts a new Instructor and returns the generated InstructorID.
    ''' Uses OUTPUT INSERTED to get the new ID in one round-trip.
    ''' </summary>
    Public Shared Function AddInstructor(i As Instructor) As Integer
        Using conn = GetConnection()
            conn.Open()
            Dim sql As String =
                "INSERT INTO Instructors (UserID, Name, Qualifications, Position, YearsExperience, HEA, Department, CourseCode) " &
                "OUTPUT INSERTED.InstructorID " &
                "VALUES (@uid, @name, @qual, @pos, @yrs, @hea, @dept, @course)"
            Dim cmd As New SqlCommand(sql, conn)
            cmd.Parameters.AddWithValue("@uid", If(i.UserID.HasValue, CObj(i.UserID.Value), DBNull.Value))
            cmd.Parameters.AddWithValue("@name", If(i.Name, ""))
            cmd.Parameters.AddWithValue("@qual", If(i.Qualifications, ""))
            cmd.Parameters.AddWithValue("@pos", If(i.Position, ""))
            cmd.Parameters.AddWithValue("@yrs", i.YearsExperience)
            cmd.Parameters.AddWithValue("@hea", i.HEA)
            cmd.Parameters.AddWithValue("@dept", If(i.Department, ""))
            cmd.Parameters.AddWithValue("@course", If(i.CourseCode, ""))
            Return CInt(cmd.ExecuteScalar())
        End Using
    End Function

    Public Shared Sub UpdateInstructor(i As Instructor)
        Using conn = GetConnection()
            conn.Open()
            Dim sql As String =
                "UPDATE Instructors SET " &
                "UserID=@uid, Name=@name, Qualifications=@qual, Position=@pos, " &
                "YearsExperience=@yrs, HEA=@hea, Department=@dept, CourseCode=@course " &
                "WHERE InstructorID=@id"
            Dim cmd As New SqlCommand(sql, conn)
            cmd.Parameters.AddWithValue("@uid", If(i.UserID.HasValue, CObj(i.UserID.Value), DBNull.Value))
            cmd.Parameters.AddWithValue("@name", If(i.Name, ""))
            cmd.Parameters.AddWithValue("@qual", If(i.Qualifications, ""))
            cmd.Parameters.AddWithValue("@pos", If(i.Position, ""))
            cmd.Parameters.AddWithValue("@yrs", i.YearsExperience)
            cmd.Parameters.AddWithValue("@hea", i.HEA)
            cmd.Parameters.AddWithValue("@dept", If(i.Department, ""))
            cmd.Parameters.AddWithValue("@course", If(i.CourseCode, ""))
            cmd.Parameters.AddWithValue("@id", i.InstructorID)
            cmd.ExecuteNonQuery()
        End Using
    End Sub

    Public Shared Sub DeleteInstructor(id As Integer)
        Using conn = GetConnection()
            conn.Open()
            Dim cmd As New SqlCommand("DELETE FROM Instructors WHERE InstructorID = @id", conn)
            cmd.Parameters.AddWithValue("@id", id)
            cmd.ExecuteNonQuery()
        End Using
    End Sub

    Private Shared Function MapInstructor(r As SqlDataReader) As Instructor
        Return New Instructor With {
            .InstructorID = CInt(r("InstructorID")),
            .UserID = If(IsDBNull(r("UserID")), Nothing, CType(CInt(r("UserID")), Integer?)),
            .Name = If(IsDBNull(r("Name")), "", r("Name").ToString()),
            .Qualifications = If(IsDBNull(r("Qualifications")), "", r("Qualifications").ToString()),
            .Position = If(IsDBNull(r("Position")), "", r("Position").ToString()),
            .YearsExperience = If(IsDBNull(r("YearsExperience")), 0, CInt(r("YearsExperience"))),
            .HEA = If(IsDBNull(r("HEA")), False, CBool(r("HEA"))),
            .Department = If(IsDBNull(r("Department")), "", r("Department").ToString()),
            .CourseCode = If(IsDBNull(r("CourseCode")), "", r("CourseCode").ToString())
        }
    End Function

    ' ══════════════════════════════════════════
    '  COURSE SECTIONS
    ' ══════════════════════════════════════════

    Public Shared Function GetAllCourseSections() As List(Of CourseSection)
        Dim list As New List(Of CourseSection)
        Using conn = GetConnection()
            conn.Open()
            Dim cmd As New SqlCommand("SELECT * FROM CourseSections ORDER BY CourseCode, YearLevel, Section", conn)
            Dim r = cmd.ExecuteReader()
            While r.Read()
                list.Add(MapCourseSection(r))
            End While
        End Using
        Return list
    End Function

    Public Shared Sub AddCourseSection(cs As CourseSection)
        Using conn = GetConnection()
            conn.Open()
            Dim sql As String =
                "INSERT INTO CourseSections (CourseCode, YearLevel, Section) " &
                "VALUES (@course, @year, @section)"
            Dim cmd As New SqlCommand(sql, conn)
            cmd.Parameters.AddWithValue("@course", If(cs.CourseCode, ""))
            cmd.Parameters.AddWithValue("@year", If(cs.YearLevel, ""))
            cmd.Parameters.AddWithValue("@section", If(cs.Section, ""))
            cmd.ExecuteNonQuery()
        End Using
    End Sub

    Public Shared Sub DeleteCourseSection(id As Integer)
        Using conn = GetConnection()
            conn.Open()
            Dim cmd As New SqlCommand("DELETE FROM CourseSections WHERE SectionID = @id", conn)
            cmd.Parameters.AddWithValue("@id", id)
            cmd.ExecuteNonQuery()
        End Using
    End Sub

    Private Shared Function MapCourseSection(r As SqlDataReader) As CourseSection
        Return New CourseSection With {
            .SectionID = CInt(r("SectionID")),
            .CourseCode = r("CourseCode").ToString(),
            .YearLevel = r("YearLevel").ToString(),
            .Section = r("Section").ToString()
        }
    End Function

    ' ══════════════════════════════════════════
    '  SCHEDULES
    ' ══════════════════════════════════════════

    Public Shared Function GetAllSchedules() As List(Of Schedule)
        Dim list As New List(Of Schedule)
        Using conn = GetConnection()
            conn.Open()
            Dim cmd As New SqlCommand("SELECT * FROM Schedules ORDER BY RoomNo, DayType, TimeSlot", conn)
            Dim r = cmd.ExecuteReader()
            While r.Read()
                list.Add(MapSchedule(r))
            End While
        End Using
        Return list
    End Function

    Public Shared Function GetScheduleByID(id As Integer) As Schedule
        Using conn = GetConnection()
            conn.Open()
            Dim cmd As New SqlCommand("SELECT * FROM Schedules WHERE ScheduleID = @id", conn)
            cmd.Parameters.AddWithValue("@id", id)
            Dim r = cmd.ExecuteReader()
            If r.Read() Then Return MapSchedule(r)
        End Using
        Return Nothing
    End Function

    Public Shared Function GetSchedulesByInstructorName(instructorName As String) As List(Of Schedule)
        Dim list As New List(Of Schedule)
        Using conn = GetConnection()
            conn.Open()
            Dim cmd As New SqlCommand(
                "SELECT * FROM Schedules WHERE InstructorName = @name ORDER BY DayType, TimeSlot", conn)
            cmd.Parameters.AddWithValue("@name", If(instructorName, ""))
            Dim r = cmd.ExecuteReader()
            While r.Read()
                list.Add(MapSchedule(r))
            End While
        End Using
        Return list
    End Function

    Public Shared Sub AddSchedule(s As Schedule)
        Using conn = GetConnection()
            conn.Open()
            Dim sql As String =
                "INSERT INTO Schedules (RoomNo, TimeSlot, DayType, SubjectCode, CourseSection, InstructorName) " &
                "VALUES (@room, @time, @day, @subject, @section, @instructor)"
            Dim cmd As New SqlCommand(sql, conn)
            cmd.Parameters.AddWithValue("@room", If(s.RoomNo, ""))
            cmd.Parameters.AddWithValue("@time", If(s.TimeSlot, ""))
            cmd.Parameters.AddWithValue("@day", If(s.DayType, ""))
            cmd.Parameters.AddWithValue("@subject", If(s.SubjectCode, ""))
            cmd.Parameters.AddWithValue("@section", If(s.CourseSection, ""))
            cmd.Parameters.AddWithValue("@instructor", If(s.InstructorName, ""))
            cmd.ExecuteNonQuery()
        End Using
    End Sub

    Public Shared Sub UpdateSchedule(s As Schedule)
        Using conn = GetConnection()
            conn.Open()
            Dim sql As String =
                "UPDATE Schedules SET RoomNo=@room, TimeSlot=@time, DayType=@day, " &
                "SubjectCode=@subject, CourseSection=@section, InstructorName=@instructor " &
                "WHERE ScheduleID=@id"
            Dim cmd As New SqlCommand(sql, conn)
            cmd.Parameters.AddWithValue("@room", If(s.RoomNo, ""))
            cmd.Parameters.AddWithValue("@time", If(s.TimeSlot, ""))
            cmd.Parameters.AddWithValue("@day", If(s.DayType, ""))
            cmd.Parameters.AddWithValue("@subject", If(s.SubjectCode, ""))
            cmd.Parameters.AddWithValue("@section", If(s.CourseSection, ""))
            cmd.Parameters.AddWithValue("@instructor", If(s.InstructorName, ""))
            cmd.Parameters.AddWithValue("@id", s.ScheduleID)
            cmd.ExecuteNonQuery()
        End Using
    End Sub

    Public Shared Sub DeleteSchedule(id As Integer)
        Using conn = GetConnection()
            conn.Open()
            Dim cmd As New SqlCommand("DELETE FROM Schedules WHERE ScheduleID = @id", conn)
            cmd.Parameters.AddWithValue("@id", id)
            cmd.ExecuteNonQuery()
        End Using
    End Sub

    Private Shared Function MapSchedule(r As SqlDataReader) As Schedule
        Return New Schedule With {
            .ScheduleID = CInt(r("ScheduleID")),
            .RoomNo = If(IsDBNull(r("RoomNo")), "", r("RoomNo").ToString()),
            .TimeSlot = If(IsDBNull(r("TimeSlot")), "", r("TimeSlot").ToString()),
            .DayType = If(IsDBNull(r("DayType")), "", r("DayType").ToString()),
            .SubjectCode = If(IsDBNull(r("SubjectCode")), "", r("SubjectCode").ToString()),
            .CourseSection = If(IsDBNull(r("CourseSection")), "", r("CourseSection").ToString()),
            .InstructorName = If(IsDBNull(r("InstructorName")), "", r("InstructorName").ToString())
        }
    End Function

    ' ══════════════════════════════════════════
    '  USER ACCOUNTS
    ' ══════════════════════════════════════════

    Public Shared Function GetAllUsers() As List(Of UserAccount)
        Dim list As New List(Of UserAccount)
        Using conn = GetConnection()
            conn.Open()
            Dim cmd As New SqlCommand("SELECT * FROM UserAccounts ORDER BY Role, FullName", conn)
            Dim r = cmd.ExecuteReader()
            While r.Read()
                list.Add(MapUser(r))
            End While
        End Using
        Return list
    End Function

    Public Shared Function GetUserByID(id As Integer) As UserAccount
        Using conn = GetConnection()
            conn.Open()
            Dim cmd As New SqlCommand("SELECT * FROM UserAccounts WHERE UserID = @id", conn)
            cmd.Parameters.AddWithValue("@id", id)
            Dim r = cmd.ExecuteReader()
            If r.Read() Then Return MapUser(r)
        End Using
        Return Nothing
    End Function

    Public Shared Function GetUserByUsername(username As String) As UserAccount
        Using conn = GetConnection()
            conn.Open()
            Dim cmd As New SqlCommand("SELECT * FROM UserAccounts WHERE Username = @u", conn)
            cmd.Parameters.AddWithValue("@u", username)
            Dim r = cmd.ExecuteReader()
            If r.Read() Then Return MapUser(r)
        End Using
        Return Nothing
    End Function

    Public Shared Function GetUserByCredentials(username As String, password As String) As UserAccount
        Using conn = GetConnection()
            conn.Open()
            Dim cmd As New SqlCommand(
                "SELECT * FROM UserAccounts WHERE LOWER(Username) = LOWER(@u) AND Password = @p", conn)
            cmd.Parameters.AddWithValue("@u", username)
            cmd.Parameters.AddWithValue("@p", password)
            Dim r = cmd.ExecuteReader()
            If r.Read() Then Return MapUser(r)
        End Using
        Return Nothing
    End Function

    Public Shared Sub AddUser(u As UserAccount)
        Using conn = GetConnection()
            conn.Open()
            Dim sql As String =
                "INSERT INTO UserAccounts (Username, Password, Role, FullName, Email, Phone, LinkedInstructorID, CourseCode) " &
                "VALUES (@user, @pass, @role, @full, @email, @phone, @linked, @course)"
            Dim cmd As New SqlCommand(sql, conn)
            cmd.Parameters.AddWithValue("@user", If(u.Username, ""))
            cmd.Parameters.AddWithValue("@pass", If(u.Password, ""))
            cmd.Parameters.AddWithValue("@role", If(u.Role, ""))
            cmd.Parameters.AddWithValue("@full", If(u.FullName, ""))
            cmd.Parameters.AddWithValue("@email", If(u.Email, ""))
            cmd.Parameters.AddWithValue("@phone", If(u.Phone, ""))
            cmd.Parameters.AddWithValue("@linked",
                If(u.LinkedInstructorID.HasValue, CObj(u.LinkedInstructorID.Value), DBNull.Value))
            cmd.Parameters.AddWithValue("@course", If(u.CourseCode, ""))
            cmd.ExecuteNonQuery()
        End Using
    End Sub

    ''' <summary>
    ''' Updates all editable fields including LinkedInstructorID.
    ''' Previously this only updated FullName/Email/Phone/Password,
    ''' which caused LinkedInstructorID to never be persisted after account creation.
    ''' </summary>
    Public Shared Sub UpdateUser(u As UserAccount)
        Using conn = GetConnection()
            conn.Open()
            Dim sql As String =
                "UPDATE UserAccounts SET " &
                "FullName=@full, Email=@email, Phone=@phone, Password=@pass, " &
                "LinkedInstructorID=@linked, CourseCode=@course " &
                "WHERE UserID=@id"
            Dim cmd As New SqlCommand(sql, conn)
            cmd.Parameters.AddWithValue("@full", If(u.FullName, ""))
            cmd.Parameters.AddWithValue("@email", If(u.Email, ""))
            cmd.Parameters.AddWithValue("@phone", If(u.Phone, ""))
            cmd.Parameters.AddWithValue("@pass", If(u.Password, ""))
            cmd.Parameters.AddWithValue("@linked",
                If(u.LinkedInstructorID.HasValue, CObj(u.LinkedInstructorID.Value), DBNull.Value))
            cmd.Parameters.AddWithValue("@course", If(u.CourseCode, ""))
            cmd.Parameters.AddWithValue("@id", u.UserID)
            cmd.ExecuteNonQuery()
        End Using
    End Sub

    Public Shared Sub DeleteUser(id As Integer)
        Using conn = GetConnection()
            conn.Open()
            Dim cmd As New SqlCommand("DELETE FROM UserAccounts WHERE UserID = @id", conn)
            cmd.Parameters.AddWithValue("@id", id)
            cmd.ExecuteNonQuery()
        End Using
    End Sub

    Private Shared Function MapUser(r As SqlDataReader) As UserAccount
        Return New UserAccount With {
            .UserID = CInt(r("UserID")),
            .Username = If(IsDBNull(r("Username")), "", r("Username").ToString()),
            .Password = If(IsDBNull(r("Password")), "", r("Password").ToString()),
            .Role = If(IsDBNull(r("Role")), "", r("Role").ToString()),
            .FullName = If(IsDBNull(r("FullName")), "", r("FullName").ToString()),
            .Email = If(IsDBNull(r("Email")), "", r("Email").ToString()),
            .Phone = If(IsDBNull(r("Phone")), "", r("Phone").ToString()),
            .LinkedInstructorID = If(IsDBNull(r("LinkedInstructorID")), Nothing,
                                     CType(CInt(r("LinkedInstructorID")), Integer?)),
            .CourseCode = If(IsDBNull(r("CourseCode")), "", r("CourseCode").ToString())
        }
    End Function

End Class