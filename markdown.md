# Classroom Mapping System — Documentation

**Our Lady of the Pillar College – San Manuel Inc.**  
ASP.NET Web Forms Application (VB.NET + SQL Server)

## 1. Project Overview

The **Classroom Mapping System** is an internal academic web application for OLPC San Manuel. It allows staff to manage and visualize classroom schedules, track subject and instructor assignments, and generate teaching load reports — all with role-based access control. Students have a read-only view of room occupancy filtered to their own course's instructors.

**Key capabilities:**
- User self-registration for Instructor and Student roles (Admin/Dean accounts are admin-created only)
- Interactive classroom schedule grid (MWF and TTH) with inline editing and conflict detection
- Floor-by-floor room occupancy map — editable for staff, read-only for students
- Manage subjects, instructors, course sections, and user accounts
- Role-restricted editing (Admins/Deans full access; Instructors manage own entries; Students view-only)
- Printable teaching load reports per instructor

---

## 2. Architecture

```
┌─────────────────────────────────────┐
│          ASP.NET Web Forms          │
│  .aspx (markup) + .aspx.vb (logic)  │
└────────────────┬────────────────────┘
                 │
        ┌────────▼────────┐
        │   AuthHelper    │  Session management, role checks, redirects
        └────────┬────────┘
                 │
        ┌────────▼────────┐
        │    Database     │  Static data-access class, parameterized SQL
        └────────┬────────┘
                 │
        ┌────────▼────────┐
        │   SQL Server    │  ClassroomMappingDB
        │  NODE25\SQLSERVER25  (Web.config)
        └─────────────────┘
```

**Technology stack:**
- ASP.NET Web Forms (.NET Framework 4.8), VB.NET
- SQL Server with Windows Integrated Security (`System.Data.SqlClient`)
- SHA-256 password hashing (`System.Security.Cryptography`)
- Inline CSS with CSS custom properties (no external CSS framework)
- Google Fonts: Playfair Display + DM Sans

---

## 3. Configuration — `Web.config`

### Connection String

```xml
<add name="ClassroomMappingDB"
     connectionString="Data Source=NODE25\SQLSERVER25;
                       Initial Catalog=ClassroomMappingDB;
                       Integrated Security=True"
     providerName="System.Data.SqlClient" />
```

- **Server:** `NODE25\SQLSERVER25`
- **Database:** `ClassroomMappingDB`
- **Auth:** Windows Integrated Security (no username/password in config)

### Session Settings

```xml
<sessionState timeout="30" cookieless="false" mode="InProc" />
```

| Setting | Value | Effect |
|---|---|---|
| `timeout` | `30` | Session expires after 30 minutes of inactivity |
| `cookieless` | `false` | Session ID stored in a cookie, not the URL |
| `mode` | `InProc` | Session stored in the web server's memory |

### Cookie Security

```xml
<httpCookies httpOnlyCookies="true" requireSSL="false" />
```

- `httpOnlyCookies="true"` — blocks JavaScript from reading the session cookie (XSS protection)
- `requireSSL="false"` — should be changed to `true` when deploying to HTTPS in production

### Other Settings

- **Default document:** `Login.aspx` — unauthenticated users hitting the root URL land on the login page
- **Target framework:** `.NET 4.8`
- **`UnobtrusiveValidationMode`:** set to `None` to use classic ASP.NET validation without jQuery dependency
- **`System.Linq`** namespace is globally imported for all pages via `<pages><namespaces>`

---

## 4. Roles & Permissions

| Role          | Self-Register      | Edit Schedules   | Manage Subjects   | Manage Instructors | Manage Users | View Map |
|---------------|--------------------|------------------|-------------------|--------------------|--------------|----------|
| `Admin`       | No — admin-created | All entries      | All subjects      | Yes                | Yes | Yes (staff view) |
| `Dean`        | No — admin-created | All entries      | All subjects      | Yes                | No  | Yes (staff view) |
| `Instructor`  | Yes                | Own entries only | Own subjects only | No                 | No  | Yes (staff view) |
| `Student`     | Yes                | No               | No                | No                 | No  | Yes (read-only, course-filtered) |

**Instructor restrictions in detail:**
- Can only assign themselves as the instructor on a schedule entry.
- Can only assign subjects they either added (`AddedByUserID`) or were assigned to (`AssignedInstructorID`).
- Cannot edit or delete schedule entries belonging to other instructors.
- Dashboard subject count shows only their own subjects.
- Reports dropdown shows only themselves.
- Can only edit/delete subjects they personally added (not merely assigned ones).

**Student restrictions:**
- Lands on `StudentHome.aspx` instead of `Default.aspx` after login.
- Instructor dropdown on `StudentHome.aspx` is pre-filtered to instructors whose `CourseCode` matches the student's registered `CourseCode`.
- Cannot access any management pages; redirected to `AccessDenied.aspx` if attempted.

---

## 5. Database Layer — `Database.vb`

Single static class (`Database`) with a connection factory and CRUD methods for each entity. All queries use parameterized `SqlCommand` to prevent SQL injection.

**Connection:**
```vb
Database.GetConnection()
' Reads "ClassroomMappingDB" from Web.config ConnectionStrings
```

### Subjects

| Method                          | Description                  |
|---------------------------------|------------------------------|
| `GetAllSubjects()`              | Returns all subjects ordered by Code                         |
| `GetSubjectByID(id)`            | Lookup by primary key                                        |
| `GetSubjectByCode(code)`        | Lookup by subject code string                                |
| `GetSubjectsByInstructorID(id)` | Returns subjects where `AssignedInstructorID = id`           |
| `AddSubject(s)`                 | Inserts a new subject                                        |
| `UpdateSubject(s)`              | Updates all editable fields including `AssignedInstructorID` |
| `DeleteSubject(id)`             | Deletes by primary key                                       |

### Instructors

| Method | Description |
|---|---|
| `GetAllInstructors()` | Returns all instructors ordered by Name |
| `GetInstructorByID(id)` | Lookup by primary key |
| `GetInstructorByUserID(userID)` | Links a `UserAccount` to its `Instructor` record |
| `AddInstructor(i)` | Inserts a new instructor |
| `UpdateInstructor(i)` | Updates all fields |
| `DeleteInstructor(id)` | Deletes by primary key |

### Course Sections

| Method | Description |
|---|---|
| `GetAllCourseSections()` | Returns all sections ordered by course, year, section |
| `AddCourseSection(cs)` | Inserts a new section |
| `DeleteCourseSection(id)` | Deletes by primary key |

### Schedules

| Method | Description |
|---|---|
| `GetAllSchedules()` | Returns all schedules ordered by RoomNo, DayType, TimeSlot |
| `GetScheduleByID(id)` | Lookup by primary key |
| `GetSchedulesByInstructorName(name)` | Finds schedules by instructor name string (used for Reports) |
| `AddSchedule(s)` | Inserts a new schedule entry |
| `UpdateSchedule(s)` | Updates all editable fields |
| `DeleteSchedule(id)` | Deletes by primary key |

### User Accounts

| Method | Description |
|---|---|
| `GetAllUsers()` | Returns all users ordered by Role, FullName |
| `GetUserByID(id)` | Lookup by primary key |
| `GetUserByUsername(username)` | Lookup by username string |
| `GetUserByCredentials(username, password)` | Case-insensitive username + hashed password match for login |
| `AddUser(u)` | Inserts a new user account |
| `UpdateUser(u)` | Updates FullName, Email, Phone, Password only |
| `DeleteUser(id)` | Deletes by primary key |

---

## 6. Authentication Layer — `AuthHelper.vb`

Shared (static) helper class. Call `AuthHelper.Require(Me, ...)` at the top of every protected page's `Page_Load`.

### Methods

**`Require(page, ParamArray allowedRoles)`**  
Redirects to `Login.aspx` if not logged in. Redirects to `AccessDenied.aspx` if the user's role is not in `allowedRoles`. Passing no roles allows any logged-in user.

**`SetSession(page, user)`**  
Populates session after successful login. Stores: `UserID`, `Username`, `Role`, `FullName`, `Email`, `Phone`, `LinkedInstructorID` (stored as `0` instead of `Nothing` to avoid silent crashes), `CourseCode`.

**`ClearSession(page)`**  
Calls `Session.Clear()` and `Session.Abandon()`. Used on logout.

**Getters** (return safe defaults if session value is missing):

| Method | Returns |
|---|---|
| `GetRole(page)` | `String` — role name or `""` |
| `GetFullName(page)` | `String` — full name or `""` |
| `GetUserID(page)` | `Integer` — UserID or `0` |
| `GetLinkedInstructorID(page)` | `Integer` — InstructorID or `0` |

---

## 7. Pages

### Login.aspx

**File:** `Login.aspx` + `Login_aspx.vb`  
**Access:** Public (redirects away if already logged in)

Handles user authentication. On fresh page load, if a session already exists the user is redirected immediately based on their role. The session check is deliberately skipped on postback to prevent the redirect from firing before `btnLogin_Click` executes.

**Login flow:**
1. User enters username, password, and selects a user type from `ddlRole`
2. Password is hashed with SHA-256 before comparison
3. `Database.GetUserByCredentials(username, hashedPassword)` is called
4. If the returned user's role does not match the selected role dropdown, login is rejected with "Incorrect user type selected"
5. On success, `AuthHelper.SetSession` is called and user is redirected by role

**Role redirects after login:**

| Role | Destination |
|---|---|
| Admin | `Default.aspx` |
| Dean | `Default.aspx` |
| Instructor | `Default.aspx` |
| Student | `StudentHome.aspx` |

---

### SignUp.aspx

**File:** `SignUp.aspx` + `SignUp_aspx.vb`  
**Access:** Public (redirects away if already logged in)

Self-registration page for Instructor and Student accounts only. Admin and Dean accounts are blocked from self-registration and must be created by a system administrator.

**Instructor registration flow:**
1. Validates required fields: qualifications dropdown, department dropdown, full name
2. Checks for duplicate username (`Database.GetUserByUsername`)
3. Checks for duplicate instructor name (`Database.GetAllInstructors`)
4. Derives `CourseCode` server-side from the department value using `GetCourseCodeFromDepartment()` — avoids relying on client-side hidden fields, making it tamper-resistant
5. Creates `UserAccount` record with hashed password and `Role = "Instructor"`
6. Re-fetches the created user to get the new `UserID`
7. Creates linked `Instructor` record with the same `UserID` and derived `CourseCode`
8. Re-fetches the created instructor and updates `UserAccount.LinkedInstructorID`
9. Redirects to `Login.aspx` after 2 seconds via a JavaScript `setTimeout`

**Student registration flow:**
1. Validates course dropdown (`ddlStudentCourse`)
2. Creates `UserAccount` with `Role = "Student"` and `CourseCode` from the dropdown value directly
3. The `CourseCode` is stored in `UserAccount.CourseCode` and carried into session — used by `StudentHome.aspx` to filter the instructor dropdown
4. Redirects to `Login.aspx`

**Password rules:** Minimum 6 characters; must match `txtConfirmPassword`.

---

### Default.aspx — Staff Dashboard

**File:** `Default.aspx` + `Default_aspx.vb`  
**Access:** Admin, Dean, Instructor

The landing page after login for staff roles. Displays a welcome message, role badge, and a grid of quick-access module cards.

**Role-based card visibility:**

| Card | Admin / Dean | Instructor |
|---|---|---|
| Classroom Schedule | Yes | Yes |
| Classroom Map | Yes | Yes |
| Subjects | Yes (all count) | Yes (own count only) |
| Instructors | Yes | No |
| Reports | Yes | Yes |
| My Profile | Yes | Yes |

**Instructor subject count logic:**  
Counts subjects where `AssignedInstructorID` matches the instructor's `InstructorID` OR `AddedByUserID` matches the current `UserID`.

**UI features:**
- Glassmorphism sticky header with logo and nav buttons
- Animated hero banner with CSS radial gradients and decorative rings
- Hover-animated cards with top-border gradient reveal
- Responsive CSS Grid layout (`auto-fill, minmax(240px, 1fr)`)

---

### StudentHome.aspx — Student Portal

**File:** `StudentHome.aspx` + `StudentHome_aspx.vb`  
**Access:** Student only

Read-only room occupancy map for students. Uses the same floor-by-floor card layout as `ClassroomMap.aspx` but adds a second filter (instructor) and scopes that instructor dropdown to the student's own course.

**Filter controls:**

| Control | Type | Behaviour |
|---|---|---|
| `ddlTime` | AutoPostBack DropDownList | Filters map to a specific time slot |
| `ddlInstructor` | AutoPostBack DropDownList | Filters map to a specific instructor |
| `btnClearFilters` | Button | Resets both filters and reloads map |

Both dropdowns trigger `BuildMap(timeFilter, instructorFilter)` independently on change.

**Instructor dropdown population (`PopulateInstructorDropDown`):**
- Reads `Session("CourseCode")` set at registration (e.g., `"BSIT"`, `"BSCrim"`)
- Filters `Database.GetAllInstructors()` to those whose `Instructor.CourseCode` matches (case-insensitive)
- If no `CourseCode` is in session, falls back to showing all instructors
- Ordered alphabetically by name

**Room card rendering:**  
Same CSS classes and MWF/TTH grouping as `ClassroomMap.aspx`. The full schedule list is fetched once (`Database.GetAllSchedules()`) and passed into `AppendRoomCard` to avoid repeated DB calls per room.

**Student time slot options** (from the markup):
`7:30-8:30`, `8:30-9:30`, `9:30-10:30`, `10:30-11:30`, `1:00-2:00`, `2:00-3:00`, `3:00-4:00`

> **Note:** The student time slot list uses `1:00-2:00` format for afternoon slots, while the staff `ClassroomSchedule.aspx` uses `12:30-1:30` format. If these don't match the `TimeSlot` values stored in the database, the student time filter will return no results for afternoon slots.

**Header nav:** Students only see "Classroom Map" (links to `ClassroomMap.aspx`), "Profile", and "Logout". No management links are shown.

**Floors rendered:** Ground Floor (101–112), Floor 2 (205, 206 LAB, 207 LAB, 208–212), Floor 3 (301–312).

---

### ClassroomSchedule.aspx — Schedule Grid

**File:** `ClassroomSchedule.aspx` + `ClassroomSchedule_aspx.vb`  
**Access:** Admin, Dean, Instructor

Renders two interactive HTML tables (MWF and TTH) with rooms as columns and time slots as rows. Cells are clickable for inline editing.

**Rooms covered:**
- Ground Floor: 101–112
- Floor 2: 205, 206 (LAB), 207 (LAB), 208–212
- Floor 3: 301–311

**Time slots:** 7:30–8:30 through 4:30–5:30 (10 slots, 1-hour each)

**Cell states:**

| State | CSS Class | Behaviour |
|---|---|---|
| Free | `cell-free` | Shows "+ Assign" link if user can assign |
| Occupied (own) | `cell-occupied` | Shows subject/section/instructor + Edit link |
| Occupied (other — Instructor view) | `cell-occupied cell-other` | Shows info + locked label, no edit |

**Inline editor flow:**
1. User clicks "Assign" or "Edit" → `openEditor()` JS function runs
2. Dropdowns (`sel-subj`, `sel-sec`, `sel-inst`) are populated from JS arrays injected server-side
3. User clicks "Save" → `saveCell()` posts back via hidden fields (`hfAction`, `hfRoom`, `hfTime`, `hfSubject`, `hfSection`, `hfInstructor`, `hfDayType`, `hfScheduleID`)
4. `btnCellAction_Click` runs conflict checks then calls `Database.AddSchedule` or `Database.UpdateSchedule`

**Dropdown data injection (`InjectDropdownData`):**  
Builds three JavaScript arrays (`subjects`, `sections`, `instructors`) injected as a `<script>` block via `litScript`. For Instructors, arrays are filtered to their own subjects/sections only and the instructor array contains only themselves.

**Section label format:**  
`BuildSectionLabel(course, year, section)` → e.g., `BSIT1-A` or `BSIT2` (no section letter). Sections are sourced from both the `CourseSections` table and derived on-the-fly from the `Subjects` table.

---

### ClassroomMap.aspx — Room Map

**File:** `ClassroomMap.aspx` + `ClassroomMap_aspx.vb`  
**Access:** Admin, Dean, Instructor

Staff version of the room map. Renders a visual floor-by-floor grid of room cards filtered by time slot via `ddlTime` (AutoPostBack). Read-only display only — no editing from this page.

**Room card CSS classes:**

| Condition | Class |
|---|---|
| No schedules / no filter match | `map-room free` |
| Has schedules, not a lab | `map-room occupied` |
| Lab room, free | `map-room free lab` |
| Lab room, occupied | `map-room occupied lab` |

**Card content when occupied:**  
Schedules are grouped into MWF and TTH day-group sections, each showing time slot, subject code, course section, and instructor name.

**Floors rendered:** Ground Floor (101–112), Floor 2 (205, 206 LAB, 207 LAB, 208–212), Floor 3 (301–312).

---

### ManageSubjects.aspx

**File:** `ManageSubjects.aspx` + `ManageSubjects_aspx.vb`  
**Access:** Admin, Dean, Instructor

CRUD management for subjects. Uses a GridView (`gvSubjects`) bound to a `SubjectDisplay` helper class that resolves `AddedByUserID` and `AssignedInstructorID` to human-readable names.

**Role-based behaviour:**

| Feature | Admin / Dean | Instructor |
|---|---|---|
| See all subjects | Yes | No — own only |
| Filter by instructor | Yes (`ddlFilterInstructor`) | No |
| Assign subject to instructor | Yes (`ddlAssignInstructor`) | No |
| Add subject | Yes | Yes (sets `AddedByUserID = self`) |
| Edit subject | Yes | Own added subjects only |
| Delete subject | Yes | Own added subjects only |

**Course code resolution (`GetCourseCode`):**  
Checks `txtCustomCourse` first; if filled, it is used and added dynamically to `ddlCourse`. Otherwise uses the dropdown value. Allows entry of non-standard or unlisted course codes.

**`SubjectDisplay` helper class** (defined in `ManageSubjects_aspx.vb`):

| Property | Description |
|---|---|
| `SubjectID` | PK |
| `Code`, `Description`, `Units` | Subject fields |
| `CourseCode`, `YearLevel`, `Section` | Classification |
| `AddedByName` | Resolved from `UserAccounts.FullName`; "System" if `AddedByUserID = 0` |
| `AssignedInstructorName` | Resolved from `Instructors.Name`, or "Unassigned" |

---

### ManageInstructors.aspx

**File:** `ManageInstructors.aspx` + `ManageInstructors_aspx.vb`  
**Access:** Admin, Dean only

CRUD management for instructor records. Uses a GridView (`gvInstructors`) with a slide-down form panel (`pnlForm`) for adding and editing.

**Form fields:**

| Field | Control | Notes |
|---|---|---|
| Name | `txtName` | Text input |
| Qualifications | `ddlQualifications` | Dropdown (e.g., "Master of IT (MIT)") |
| Position | `ddlPosition` | Dropdown (e.g., "Instructor", "Assistant Professor") |
| Department | `ddlDepartment` | Dropdown (full program name) |
| Years Experience | `txtYears` | Integer; defaults to 0 if blank |
| Course Code | `txtCourseCode` | Text input — manually set, not derived |
| HEA | `chkHEA` | Checkbox |

**Grid row commands:** Edit populates the form panel using `FindByValue` for safe dropdown selection; Delete calls `Database.DeleteInstructor`.

**Note:** Instructors added here by Admin/Dean have `UserID = Nothing` until linked during `SignUp.aspx` registration. Instructors created via `SignUp.aspx` always have a linked `UserID`.

---

### ManageUsers.aspx

**File:** `ManageUsers.aspx` + `ManageUsers_aspx.vb`  
**Access:** Admin only

Admin-only user account management. Displays all users in a GridView with role-based count pills and a role filter.

**Features:**
- **Count pills** — live counts per role: All, Admin, Dean, Instructor, Student (updated after every action)
- **Role filter** — `ddlRoleFilter` (AutoPostBack) and clickable `LinkButton` pills both call `BindGrid(roleFilter)`
- **Edit** — populates a slide-down form (`pnlForm`) to update FullName, Email, Phone, and optionally reset password (hashed with SHA-256 if 6+ characters; blank preserves existing)
- **Delete** — permanently removes the user account
- **Self-edit guard** — attempting to edit own account redirects to `Profile.aspx`
- **Self-delete guard** — attempting to delete own account is blocked with an error

**`GetRoleBadgeClass(role)`** — public helper method used in GridView TemplateField binding to return the correct CSS badge class per role.

---

### Reports.aspx

**File:** `Reports.aspx` + `Reports_aspx.vb`  
**Access:** Admin, Dean, Instructor

Generates a **Teaching Load** report for a selected instructor, formatted for printing. Includes instructor metadata, a subject/schedule table, totals, and a signature block.

**Report generation flow:**
1. Select instructor from `ddlInstructor` and enter semester/school year
2. Click "Generate" → `GenerateReport()` runs
3. Fetches `Instructor` record by ID
4. Fetches all `Subjects` where `AssignedInstructorID = instrID`
5. Fetches `Schedules` via `Database.GetSchedulesByInstructorName(inst.Name)`
6. Matches each subject to a schedule entry by `SubjectCode` (case-insensitive, trimmed)
7. Binds results to `rptSubjects` Repeater; if no subjects, `rptEmpty` shows a placeholder row
8. Totals: `lblTotalUnits` (sum of units) and `lblNoOfPrep` (subject count), both formatted to 2 decimal places

**Instructor role auto-select:**  
If the logged-in user is an Instructor, their record is auto-selected on page load and the report is generated immediately without requiring a button click.

**`TeachingLoadRow` class** (defined in `Reports_aspx.vb`):

| Property | Source |
|---|---|
| `Code` | `Subject.Code` |
| `Description` | `Subject.Description` |
| `Days` | `Schedule.DayType` (blank if no schedule match) |
| `HourSchedule` | `Schedule.TimeSlot` (blank if no match) |
| `RoomNo` | `Schedule.RoomNo` (blank if no match) |
| `Units` | `Subject.Units` |
| `NoOfStudents` | `Schedule.CourseSection` (used as section identifier) |

**Helper methods:**
- `GetQualAbbr(qual)` — extracts abbreviation inside parentheses, e.g., `"Master of IT (MIT)"` → `"MIT"`
- `GetSigSuffix(qual)` — formats as `", MIT"` for the instructor signature block

---

### Profile.aspx

**File:** `Profile.aspx` + `Profile_aspx.vb`  
**Access:** Any logged-in user (Admin, Dean, Instructor, Student)

Displays the current user's profile information and provides a password change form.

**Displayed fields:** FullName, Username, Role. For Instructor accounts with `LinkedInstructorID > 0`, a panel (`pnlInstructorInfo`) is shown with Position, Qualifications, Years Experience, and HEA status.

**Home button routing:**
- `Student` → `StudentHome.aspx`
- All other roles → `Default.aspx`

**Password change (`btnChangePw_Click`):**
1. Fetches user from DB by session `UserID`
2. Compares `txtCurrentPw.Text` directly to `user.Password`
3. Validates new password length (min 6 chars) and confirmation match
4. Saves updated password via `Database.UpdateUser`

> ⚠️ See Known Notes — there is a bug in step 2. The stored password is a SHA-256 hash but the input is compared as plaintext.

---

### AccessDenied.aspx

**File:** `AccessDenied.aspx` + `AccessDenied_aspx.vb`  
**Access:** Any (no auth check on load)

Displays an access-denied message. `btnHome_Click` redirects based on role:
- `Student` → `StudentHome.aspx`
- `Admin`, `Dean`, `Instructor` → `Default.aspx`
- Unauthenticated → `Login.aspx`

---

## 8. Data Models

All core models are defined in `Database.vb`. Helper display classes are defined in their respective page code-behind files.

### `Subject`
| Property | Type | Notes |
|---|---|---|
| `SubjectID` | `Integer` | PK |
| `Code` | `String` | Subject code (e.g., "IT101") |
| `Description` | `String` | Full subject name |
| `Units` | `Integer` | Credit units |
| `CourseCode` | `String` | e.g., "BSIT" |
| `YearLevel` | `String` | e.g., "1", "2" |
| `Section` | `String` | e.g., "A", "" |
| `AddedByUserID` | `Integer` | FK → UserAccounts |
| `AssignedInstructorID` | `Integer?` | FK → Instructors (nullable) |

### `Instructor`
| Property | Type | Notes |
|---|---|---|
| `InstructorID` | `Integer` | PK |
| `UserID` | `Integer?` | FK → UserAccounts (nullable if added manually by Admin) |
| `Name` | `String` | Display name — also used as a key in Schedules and Reports |
| `Qualifications` | `String` | Full string e.g., "Master of IT (MIT)" |
| `Position` | `String` | e.g., "Instructor", "Assistant Professor" |
| `YearsExperience` | `Integer` | |
| `HEA` | `Boolean` | Highest Educational Attainment flag (Yes/No) |
| `Department` | `String` | Full department/program name |
| `CourseCode` | `String` | Program abbreviation e.g., "BSIT" — used to filter the student instructor dropdown |

### `CourseSection`
| Property | Type | Notes |
|---|---|---|
| `SectionID` | `Integer` | PK |
| `CourseCode` | `String` | e.g., "BSIT" |
| `YearLevel` | `String` | |
| `Section` | `String` | |
| `DisplayName` | `String` (read-only) | Computed: `CourseCode & YearLevel & "-" & Section` |

### `Schedule`
| Property | Type | Notes |
|---|---|---|
| `ScheduleID` | `Integer` | PK |
| `RoomNo` | `String` | e.g., "101", "206 (LAB)" |
| `TimeSlot` | `String` | e.g., "7:30-8:30" |
| `DayType` | `String` | "MWF" or "TTH" |
| `SubjectCode` | `String` | |
| `CourseSection` | `String` | Derived label e.g., "BSIT1-A" |
| `InstructorName` | `String` | Stored as name string — not a FK |

### `UserAccount`
| Property | Type | Notes |
|---|---|---|
| `UserID` | `Integer` | PK |
| `Username` | `String` | Lowercased on login comparison |
| `Password` | `String` | SHA-256 hex string (64 chars) |
| `Role` | `String` | "Admin", "Dean", "Instructor", "Student" |
| `FullName` | `String` | |
| `Email` | `String` | |
| `Phone` | `String` | |
| `LinkedInstructorID` | `Integer?` | FK → Instructors (nullable) |
| `CourseCode` | `String` | Populated for Student role; blank for Instructor (course lives on Instructors table) |

### `SubjectDisplay` *(ManageSubjects_aspx.vb)*
Display-only class for GridView binding with resolved FK names (`AddedByName`, `AssignedInstructorName`).

### `TeachingLoadRow` *(Reports_aspx.vb)*
Flattened row joining `Subject` and matched `Schedule` data for the teaching load Repeater.

---

## 9. Session Variables

Set by `AuthHelper.SetSession()` after successful login. All pages read these via `AuthHelper` getters.

| Key | Type | Description |
|---|---|---|
| `UserID` | `Integer` | Primary key of logged-in user |
| `Username` | `String` | Login username |
| `Role` | `String` | "Admin", "Dean", "Instructor", or "Student" |
| `FullName` | `String` | Display name |
| `Email` | `String` | |
| `Phone` | `String` | |
| `LinkedInstructorID` | `Integer` | `0` if none — never stored as `Nothing` |
| `CourseCode` | `String` | `""` if none; for Students this drives the instructor filter on `StudentHome.aspx` |

Session expires after **30 minutes of inactivity** (configured in `Web.config`).

---

## 10. Password Hashing

Passwords are hashed using **SHA-256** (lowercase hex output) in `Login.aspx`, `SignUp.aspx`, and `ManageUsers.aspx` via a `HashPassword()` helper defined locally in each file.

```vb
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
```

Passwords are stored as 64-character lowercase hex strings in the `UserAccounts` table.

> **Refactor suggestion:** `HashPassword` is duplicated in three files. It should be moved to `AuthHelper.vb` as a `Public Shared Function HashPassword(plainText As String) As String`.

---

## 11. Conflict Detection Logic

Applied in `ClassroomSchedule_aspx.vb` → `btnCellAction_Click` before saving. Checks run for both INSERT (new) and UPDATE (edit), with the current record excluded from UPDATE checks.

Three conflicts are detected:

1. **Room conflict** — same `RoomNo` + `TimeSlot` + `DayType` already exists
2. **Instructor conflict** — same `InstructorName` + `TimeSlot` + `DayType` already teaching elsewhere
3. **Section conflict** — same `CourseSection` + `TimeSlot` + `DayType` already has a class

Each conflict produces a specific descriptive error message in `lblMsg` naming the conflicting room, subject, and section. On success, a checkmark confirmation is shown. On delete, a trash icon confirmation is shown.

---

## 12. Department & CourseCode Mapping

Defined in `SignUp_aspx.vb → GetCourseCodeFromDepartment()`. Maps the full department display string to a short `CourseCode` used across the system. The mapping is case-insensitive and performed server-side only — not derivable from client input.

| Department (full display name) | CourseCode |
|---|---|
| Bachelor of Secondary Education (BSEd) — Major in English | `BSEd` |
| Bachelor in Secondary Education Major in Filipino | `BSEd` |
| Bachelor in Secondary Education Major in Mathematics | `BSEd` |
| Bachelor in Secondary Education Major in Science | `BSEd` |
| Bachelor of Science in Accountancy | `BSA` |
| Bachelor of Science in Business Administration — Major in Financial Management | `FM` |
| Bachelor of Science in Business Administration — Major in Marketing Management | `BSBAMM` |
| Bachelor of Science in Criminology | `BSCrim` |
| Bachelor in Elementary Education | `BEEd` |
| Bachelor of Science in Hospitality Management | `BSHM` |
| Bachelor of Science in Information Technology | `BSIT` |

This same set of `CourseCode` values is used in the Student registration dropdown (`ddlStudentCourse`) and stored in `UserAccount.CourseCode` to drive the instructor filter on `StudentHome.aspx`.

---

## 13. Known Notes & Comments

- **`Profile.aspx` password change bug:** `btnChangePw_Click` compares `txtCurrentPw.Text` (plaintext) directly to `user.Password` (a SHA-256 hash). This means the check will always fail for any normally registered user. The fix is to hash the input before comparing: `If HashPassword(txtCurrentPw.Text) <> user.Password Then`.

- **`HashPassword` is duplicated** across `Login_aspx.vb`, `SignUp_aspx.vb`, and `ManageUsers_aspx.vb`. It should be refactored into `AuthHelper.vb` as a single shared method.

- **Student time slot mismatch risk:** `StudentHome.aspx` uses afternoon time labels like `1:00-2:00`, while `ClassroomSchedule.aspx` uses `12:30-1:30`. If the database stores the staff-entered format, the student time filter will return no results for those afternoon slots. Both pages should use identical `TimeSlot` string values.

- **`LinkedInstructorID` null handling:** Storing a `Nothing` Nullable(Of Integer) in Session caused silent runtime crashes. It is now always stored as integer `0`. Documented with a comment in `AuthHelper.SetSession`.

- **Instructor–Schedule link is by name string**, not a foreign key. If an instructor's name is changed in `ManageInstructors.aspx`, existing `Schedule.InstructorName` values will not update, breaking schedule display and Reports matching for that instructor.

- **`Database.UpdateUser`** only updates `FullName`, `Email`, `Phone`, and `Password`. It does not allow changing `Role`, `Username`, or `LinkedInstructorID` through application pages — those require direct database access.

- **Login session check on postback:** An earlier bug had the already-logged-in redirect running on every request including postbacks, causing the redirect to fire before `btnLogin_Click`. Fixed by wrapping the check in `If Not IsPostBack`.

- **Admin/Dean self-registration is blocked** in `SignUp.aspx`. These accounts must be seeded directly into the database or created by an existing Admin via `ManageUsers.aspx`.

- **`ManageUsers.aspx` is Admin-only.** Deans have full access to subjects and instructors but cannot manage user accounts.

- **`requireSSL="false"` in `Web.config`** should be set to `true` before deploying to a production HTTPS environment, as noted in the config comment.

- **`HEA` field** on `Instructor` stands for Highest Educational Attainment. It is stored as a boolean Yes/No flag; the full qualification string is stored separately in `Qualifications`.

- **Reports match subjects to schedules by `SubjectCode`** using a trimmed, case-insensitive string comparison. If a subject code in `Subjects` does not exactly match the `SubjectCode` stored in `Schedules`, the Days/Time/Room columns will appear blank in the generated report.