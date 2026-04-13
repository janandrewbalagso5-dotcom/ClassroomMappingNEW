# Classroom Mapping System

**Our Lady of the Pillar College – San Manuel Inc.**  
ASP.NET Web Forms · VB.NET · SQL Server

---

## Overview

The **Classroom Mapping System (CMS)** is a role-based academic web application for OLPC San Manuel. It lets staff manage and visualize classroom schedules, track subject and instructor assignments, and generate printable teaching load reports. Students get a read-only view of room occupancy filtered to their own course's instructors.

**Core capabilities:**
- Role-based login with session management (Admin, Dean, Instructor, Student)
- Student self-registration; Admin/Dean accounts created by administrators only
- Interactive MWF and TTH classroom schedule grid with inline editing and conflict detection
- Floor-by-floor room occupancy map (editable for staff, read-only for students)
- Subject, instructor, course section, and user account management
- Printable teaching load report per instructor

---

## Architecture

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
        │  NODE25\SQLSERVER25
        └─────────────────┘
```

**Technology stack:** ASP.NET Web Forms (.NET 4.8), VB.NET, SQL Server (Windows Integrated Security), SHA-256 password hashing, inline CSS with Google Fonts (Playfair Display + DM Sans).

---

## Configuration — `Web.config`

The database connection targets `NODE25\SQLSERVER25`, database `ClassroomMappingDB`, using Windows Integrated Security (no stored username/password).

Sessions expire after **30 minutes of inactivity**, stored in-process (InProc). The session cookie uses `httpOnly=true` to block JavaScript access (XSS protection). `requireSSL` is currently `false` and should be changed to `true` before production deployment on HTTPS.

The default document is `Login.aspx`, so unauthenticated users hitting the root URL land on the login page. ASP.NET unobtrusive validation is disabled in favor of classic validators.

---

## Roles & Permissions

| Role | Self-Register | Edit Schedules | Manage Subjects | Manage Instructors | Manage Users | View Map |
|---|---|---|---|---|---|---|
| **Admin** | No | All entries | All | Yes | Yes | Staff view |
| **Dean** | No | All entries | All | Yes | No | Staff view |
| **Instructor** | Yes | Own entries only | Own subjects only | No | No | Staff view |
| **Student** | Yes | No | No | No | No | Read-only, course-filtered |

**Instructor restrictions in detail:**
- Can only assign themselves when creating a schedule entry
- Can only edit/delete subjects they personally added (`AddedByUserID`)
- Dashboard subject count shows only their own subjects
- Reports dropdown shows only themselves
- Cannot access any management pages outside of Subjects

**Student restrictions:**
- Lands on `StudentHome.aspx` instead of `Default.aspx` after login
- Instructor dropdown is pre-filtered to instructors whose `CourseCode` matches the student's registered course
- Redirected to `AccessDenied.aspx` if any management URL is accessed directly

---

## Database Layer — `Database.vb`

A single static class (`Database`) with a connection factory and CRUD methods for every entity. All queries use parameterized `SqlCommand` to prevent SQL injection.

### Tables & Methods

**UserAccounts** — `GetAllUsers`, `GetUserByID`, `GetUserByUsername`, `GetUserByCredentials`, `AddUser`, `UpdateUser`, `DeleteUser`

**Instructors** — `GetAllInstructors`, `GetInstructorByID`, `GetInstructorByUserID`, `AddInstructor` (returns new ID via `OUTPUT INSERTED`), `UpdateInstructor`, `DeleteInstructor`

**Subjects** — `GetAllSubjects`, `GetSubjectByID`, `GetSubjectByCode`, `GetSubjectsByInstructorID`, `AddSubject`, `UpdateSubject`, `DeleteSubject`

**Schedules** — `GetAllSchedules`, `GetScheduleByID`, `GetSchedulesByInstructorName`, `AddSchedule`, `UpdateSchedule`, `DeleteSchedule`

**CourseSections** — `GetAllCourseSections`, `AddCourseSection`, `DeleteCourseSection`

---

## Authentication — `AuthHelper.vb`

Shared (static) helper used by every protected page. Call `AuthHelper.Require(Me, "Admin", "Dean")` at the top of `Page_Load` to guard the page.

| Method | Purpose |
|---|---|
| `Require(page, allowedRoles)` | Redirects to `Login.aspx` if not logged in; to `AccessDenied.aspx` if role is not allowed. Empty roles = any logged-in user. |
| `SetSession(page, user)` | Stores `UserID`, `Username`, `Role`, `FullName`, `Email`, `Phone`, `LinkedInstructorID` (stored as `0` not `Nothing` to prevent silent crashes), `CourseCode` in session. |
| `ClearSession(page)` | Calls `Session.Clear()` and `Session.Abandon()`. Used on logout. |
| `GetRole / GetFullName / GetUserID / GetLinkedInstructorID` | Safe getters — return empty string or `0` if session key is missing. |

---

## Password Hashing

Passwords are stored and compared as **SHA-256 lowercase hex strings** (64 characters). The `HashPassword()` helper is duplicated in `Login_aspx.vb`, `SignUp_aspx.vb`, and `ManageUsers_aspx.vb` — it should ideally be moved to `AuthHelper.vb`.

```vb
Using sha As SHA256 = SHA256.Create()
    Dim bytes = sha.ComputeHash(Encoding.UTF8.GetBytes(plainText))
    ' Returns 64-char lowercase hex string
End Using
```

---

## Pages

### Login.aspx

Public page. Redirects away if a session already exists (check skipped on postback to avoid redirect firing before `btnLogin_Click`).

**Login flow:**
1. User enters username, password, and selects a user type from the dropdown
2. Password is SHA-256 hashed before comparison
3. `Database.GetUserByCredentials(username, hashedPassword)` is called
4. If the user's stored role doesn't match the selected dropdown value, login is rejected with "Incorrect user type selected"
5. On success, `AuthHelper.SetSession` is called and user is redirected by role

**Post-login destinations:**

| Role | Redirects to |
|---|---|
| Admin / Dean / Instructor | `Default.aspx` |
| Student | `StudentHome.aspx` |

---

### SignUp.aspx

Public self-registration page. Admin and Dean accounts cannot self-register — only Student and Instructor roles are allowed here.

**Student flow:** Validates course selection, hashes password, saves `UserAccount` with `Role = "Student"` and `CourseCode` from the dropdown. Redirects to `Login.aspx` after 2 seconds.

**Instructor flow:**
1. Validates required fields and checks for duplicate username
2. Creates `UserAccount` with `Role = "Instructor"` and hashed password
3. Re-fetches the just-created user to get their auto-generated `UserID`
4. Creates a linked `Instructor` record with the same `UserID`
5. Re-fetches the instructor to get its new `InstructorID`
6. Updates `UserAccount.LinkedInstructorID` to link both records

Password must be at least 6 characters and must match the confirm field.

---

### Default.aspx — Staff Dashboard

**Access:** Admin, Dean, Instructor

Landing page for staff. Displays a welcome message and quick-access module cards. Card visibility and counts are role-based:

| Card | Admin / Dean | Instructor |
|---|---|---|
| Classroom Schedule | ✓ (total count) | ✓ |
| Classroom Map | ✓ | ✓ |
| Subjects | ✓ (all count) | ✓ (own count only) |
| Instructors | ✓ (total count) | ✗ |
| Reports | ✓ | ✓ |
| My Profile | ✓ | ✓ |

Instructor subject count: subjects where `AssignedInstructorID` matches the instructor's ID **or** `AddedByUserID` matches their `UserID`.

---

### StudentHome.aspx — Student Portal

**Access:** Student only

Read-only room occupancy map. Same floor-by-floor card layout as `ClassroomMap.aspx` but with an additional instructor filter scoped to the student's own course.

**Filters:** Time slot, Day type (MWF/TTH), and Instructor (all AutoPostBack). A "Clear Filters" button resets all three. Each filter change rebuilds the map by calling `BuildMap(timeFilter, instructorFilter)`.

**Instructor dropdown population:** Reads `Session("CourseCode")` set at registration and filters the instructor list to those whose `Instructor.CourseCode` matches.

**Floors rendered:** Ground Floor (101–112), Floor 2 (205–212 including two LAB rooms), Floor 3 (301–312).

---

### ClassroomSchedule.aspx — Schedule Grid

**Access:** Admin, Dean, Instructor

Two interactive HTML tables (MWF and TTH) with rooms as columns and time slots as rows. Cells are clickable for inline editing by Admins and Deans; Instructors see a read-only banner.

**Rooms:** 30 rooms across three floors. **Time slots:** 7:30–8:30 through 4:30–5:30 (10 hourly slots).

**Cell states:**

| State | Behaviour |
|---|---|
| Free | Shows "+ Assign" link if user can assign |
| Occupied | Shows subject / section / instructor + "Edit" link if user can edit |
| Occupied (Instructor view) | Shows info with a locked label, no edit |

**Inline editing flow:**
1. Click "Assign" or "Edit" → `openEditor()` JavaScript populates three dropdowns (subject, section, instructor)
2. Instructor dropdown selection dynamically re-filters the subject and section dropdowns client-side using the `instructorMap` JSON injected by the server
3. Click "Save" → hidden fields carry `hfAction`, `hfRoom`, `hfTime`, `hfSubject`, `hfSection`, `hfInstructor`, `hfDayType`, `hfScheduleID` to `btnCellAction_Click`
4. Server runs conflict checks, then calls `AddSchedule` or `UpdateSchedule`

**Conflict detection (three checks, applied to both INSERT and UPDATE):**
- **Room conflict** — same `RoomNo + TimeSlot + DayType` already exists
- **Instructor conflict** — instructor already teaching at that `TimeSlot + DayType` in another room
- **Section conflict** — same `CourseSection` already has a class at that `TimeSlot + DayType`

Each conflict produces a specific error message naming the conflicting room, subject, and section.

**Dropdown data injection (`InjectDropdownData`):** Server-side builds `subjects[]`, `sections[]`, `instructors[]`, and `instructorMap{}` JSON arrays injected via a `<script>` block in `litScript`. For Instructors, arrays are filtered to their own subjects/sections only and `instructors[]` contains only themselves.

---

### ClassroomMap.aspx — Room Map

**Access:** Admin, Dean, Instructor

Staff version of the room occupancy map. Filter by time slot and day type using AutoPostBack dropdowns. Read-only — no editing from this page.

Room cards display MWF and TTH groups separately. Cards with more than one day group show a "Show more / Show less" toggle button (JavaScript `toggleExtra()`). Available rooms display "Available" in muted italic text.

**Room card CSS states:** `map-room free`, `map-room occupied`, `map-room free lab`, `map-room occupied lab`.

---

### ManageSubjects.aspx

**Access:** Admin, Dean, Instructor

CRUD management for subjects. Uses a GridView bound to a `SubjectDisplay` helper class that resolves `AddedByUserID` → user full name and `AssignedInstructorID` → instructor name.

**Role differences:**

| Feature | Admin / Dean | Instructor |
|---|---|---|
| See all subjects | ✓ | Own only |
| Filter by instructor | ✓ (`ddlFilterInstructor`) | ✗ |
| Assign to instructor | ✓ (`ddlAssignInstructor`) | ✗ |
| Add subject | ✓ | ✓ |
| Edit / Delete | ✓ | Own added subjects only |

Course code input supports either the standard dropdown **or** a free-text custom course field — toggled by a JavaScript link, allowing non-standard course codes to be entered.

---

### ManageInstructors.aspx

**Access:** Admin, Dean only

CRUD management for instructor records. A slide-down form panel (`pnlForm`) handles both add and edit. Fields include Name, Qualifications (dropdown), Position (dropdown), Department (dropdown), Years of Experience, Course Code, and HEA checkbox.

When Admin/Dean adds an instructor here without linking to a user, `UserID` is `NULL`. This record gets linked to a `UserAccount` later when the instructor self-registers via `SignUp.aspx`.

A JavaScript `syncCourse()` function automatically selects the matching `CourseCode` dropdown when the Department dropdown changes, keeping both fields in sync.

---

### ManageUsers.aspx

**Access:** Admin only

Full user account management. Features:

- **Role count pills** — clickable live counts (All / Admin / Dean / Instructor / Student) that also act as filters
- **Role filter dropdown** — AutoPostBack `ddlRoleFilter`
- **Add User form** — creates a `UserAccount`; if role is Instructor, also creates a linked `Instructor` record using the same flow as `SignUp.aspx`
- **Edit form** — updates FullName, Email, Phone; optionally resets password (must be 6+ characters; blank preserves existing)
- **Delete** — permanently removes the account
- **Guards** — cannot edit or delete own account; Deans cannot create, edit, or delete Admin accounts

---

### Reports.aspx

**Access:** Admin, Dean, Instructor

Generates a printable **Actual Teaching Load** document per instructor, formatted to match the school's official form with a signature block.

**Report generation flow:**
1. Select instructor from `ddlInstructor` (Instructors see only themselves and the report auto-generates on page load)
2. Select semester and enter school year
3. `GenerateReport()` fetches the instructor record, then fetches all schedules by instructor name via `Database.GetSchedulesByInstructorName`
4. Each schedule row is matched to its subject via `SubjectCode` to pull `Description` and `Units`
5. Results bind to `rptSubjects` Repeater; if none, `rptEmpty` shows a placeholder row
6. Total units (sum) and number of preparations (distinct subject codes) are displayed, formatted to 2 decimal places
7. A "Print" button calls `window.print()` — print CSS hides the header, hero, controls, and footer, leaving only the document

---

### Profile.aspx

**Access:** Any logged-in user

Displays username, full name, and role. For Instructor accounts with a linked `InstructorID`, an additional panel shows Position, Qualifications, Years of Experience, and HEA status.

The Home button routes to `StudentHome.aspx` for Students and `Default.aspx` for all other roles.

**Password change:** Verifies the current password, validates minimum length (6 chars) and confirmation match, then saves the new SHA-256 hash via `Database.UpdateUser`.

---

### AccessDenied.aspx

Displayed when a user tries to access a page their role doesn't permit. The "Go to Home" button redirects to the appropriate home page based on role, or to `Login.aspx` if the session is gone.

---

## Data Models

All core models are in `Database.vb`. Helper display classes are in their page code-behind files.

### `UserAccount`
Stores login credentials and identity. `Password` is always a 64-char SHA-256 hex string. `LinkedInstructorID` links Instructor accounts to their `Instructors` record. `CourseCode` is populated for Students and drives the instructor filter on `StudentHome.aspx`.

### `Instructor`
Stores academic/professional details. `UserID` is nullable — Admins can add instructor records without a linked login account. `Name` is used as a string key in `Schedules` and `Reports` (not a FK — see Known Notes).

### `Subject`
Stores subject metadata. `AssignedInstructorID` is nullable; when set, it defines which instructor's Teaching Load and subject lists include this subject.

### `Schedule`
Stores a single classroom booking: room, time slot, day type (MWF or TTH), subject code, course section label, and instructor name string.

### `CourseSection`
Stores valid course-section combinations (e.g., BSIT Year 1 Section A). Used to populate section dropdowns on the schedule page alongside sections derived on-the-fly from the Subjects table.

---

## Session Variables

Set by `AuthHelper.SetSession()` after login. All expire after 30 minutes of inactivity.

| Key | Type | Description |
|---|---|---|
| `UserID` | Integer | PK of logged-in user |
| `Username` | String | Login username |
| `Role` | String | Admin / Dean / Instructor / Student |
| `FullName` | String | Display name |
| `Email` / `Phone` | String | Contact info |
| `LinkedInstructorID` | Integer | `0` if none (never stored as `Nothing`) |
| `CourseCode` | String | `""` if none; drives Student instructor filter |

---

## Department → CourseCode Mapping

Used in SignUp to derive the short `CourseCode` from the full department name. This mapping is server-side only.

| Department | CourseCode |
|---|---|
| BSEd — Major in English / Filipino / Mathematics / Science | `BSEd` |
| BS Accountancy | `BSA` |
| BSBA — Financial Management | `FM` |
| BSBA — Marketing Management | `BSBAMM` |
| BS Criminology | `BSCrim` |
| BEEd | `BEEd` |
| BS Hospitality Management | `BSHM` |
| BS Information Technology | `BSIT` |

---

## Known Issues & Notes

FIX **Profile.aspx password change bug** — `btnChangePw_Click` currently compares the entered current password as plaintext against the stored SHA-256 hash, so it will always fail. The fix is to hash the input first: `If HashPassword(txtCurrentPw.Text) <> user.Password Then`.

**`HashPassword` is duplicated** in `Login_aspx.vb`, `SignUp_aspx.vb`, and `ManageUsers_aspx.vb`. It should be moved to `AuthHelper.vb` as a single shared method.

**Student time slot mismatch** — `StudentHome.aspx` uses labels like `1:00-2:00` for afternoon slots while `ClassroomSchedule.aspx` stores `12:30-1:30`. If these don't match the database values, the student time filter will return no results for afternoon slots.

**Instructor–Schedule link is by name string**, not a foreign key. Renaming an instructor in `ManageInstructors.aspx` will break schedule display and Reports matching for that instructor's existing records.

**`LinkedInstructorID` stored as `0` (not `Nothing`)** — storing a null `Nullable(Of Integer)` in Session caused silent runtime crashes. It is now always stored as `0`. Documented in `AuthHelper.SetSession`.

**Admin/Dean self-registration is blocked** — these accounts must be seeded directly into the database or created by an existing Admin via `ManageUsers.aspx`.

**`requireSSL="false"` in `Web.config`** must be changed to `true` before deploying to a production HTTPS environment.

**`HEA` field** on `Instructor` stands for Highest Educational Attainment (stored as a boolean Yes/No flag; the full qualification string is stored separately in `Qualifications`).
**`HEA` field** on `Instructor` stands for Highest Educational Attainment (stored as a boolean Yes/No flag; the full qualification string is stored separately in `Qualifications`).