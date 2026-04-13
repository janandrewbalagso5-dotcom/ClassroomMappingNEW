<%@ Page Language="VB" AutoEventWireup="false" CodeFile="ManageSubjects.aspx.vb" Inherits="ManageSubjects" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Manage Subjects — CMS</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet" />
    <style>
        *, *::before, *::after {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        :root {
            --navy: #0d1f4c;
            --navy-mid: #162660;
            --navy-light: #1e3278;
            --white: #ffffff;
            --off-white: #f5f7fc;
            --orange: #FFB300;
            --orange-pale: #FFD666;
            --pink: #e8487a;
            --pink-pale: #fce4ed;
            --text-muted: #7a8bb5;
            --border: #dce3f5;
            --shadow-sm: 0 2px 12px rgba(13,31,76,0.07);
            --shadow-md: 0 6px 28px rgba(13,31,76,0.13);
            --shadow-lg: 0 16px 48px rgba(13,31,76,0.18);
        }

        html {
            height: 100%;
        }

        body {
            min-height: 100%;
            font-family: 'DM Sans', sans-serif;
            background: var(--off-white);
            color: var(--navy);
            display: flex;
            flex-direction: column;
        }

        form#form1 {
            flex: 1;
            display: flex;
            flex-direction: column;
        }

        .main-content {
            flex: 1;
        }

        /* HEADER */
        .header {
            position: sticky;
            top: 0;
            z-index: 100;
            background: rgba(13, 31, 76, 0.90);
            backdrop-filter: blur(20px) saturate(180%);
            -webkit-backdrop-filter: blur(20px) saturate(180%);
            border-bottom: 1px solid rgba(255,255,255,0.10);
            box-shadow: 0 4px 24px rgba(13,31,76,0.18), inset 0 1px 0 rgba(255,255,255,0.10);
        }

        .header-inner {
            max-width: 1680px;
            margin: 0 auto;
            padding: 0 32px;
            height: 72px;
            display: flex;
            align-items: center;
            gap: 18px;
        }

        .header-logo {
            height: 48px;
            width: 48px;
            border-radius: 50%;
            object-fit: cover;
            border: 2.5px solid rgba(255,255,255,0.35);
            flex-shrink: 0;
        }

        .header-brand {
            font-family: 'Playfair Display', serif;
            font-size: 15px;
            color: #fff;
            line-height: 1.3;
            max-width: 200px;
        }

        .header-divider {
            width: 1px;
            height: 32px;
            background: rgba(255,255,255,0.2);
            flex-shrink: 0;
        }

        .header-nav {
            display: flex;
            align-items: center;
            gap: 4px;
            flex: 1;
            flex-wrap: wrap;
        }

        .nav-btn, input[type="submit"].nav-btn, button.nav-btn {
            background: transparent;
            color: rgba(255,255,255,0.82);
            border: none;
            padding: 7px 14px;
            border-radius: 8px;
            font-family: 'Outfit', sans-serif;
            font-size: 13px;
            font-weight: 500;
            cursor: pointer;
            transition: background 0.2s, color 0.2s, box-shadow 0.2s;
            text-decoration: none;
            white-space: nowrap;
            letter-spacing: 0.01em;
        }

            .nav-btn:hover, input[type="submit"].nav-btn:hover, button.nav-btn:hover {
                background: rgba(255,255,255,0.12);
                color: #fff;
                box-shadow: inset 0 0 0 1px rgba(255,255,255,0.15);
            }

            .nav-btn.active {
                background: rgba(255,255,255,0.15);
                color: #fff;
                box-shadow: inset 0 0 0 1px rgba(255,255,255,0.20);
            }

        .user-bar {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-left: auto;
        }

        .role-badge {
            background: rgba(244,124,32,0.25);
            color: var(--orange);
            border: 1px solid rgba(244,124,32,0.4);
            font-size: 11px;
            font-weight: 600;
            padding: 3px 11px;
            border-radius: 20px;
            letter-spacing: 0.04em;
            text-transform: uppercase;
        }

        .btn-logout, input[type="submit"].btn-logout, button.btn-logout {
            background: rgba(232,72,122,0.18);
            color: #ffb3cb;
            border: 1px solid rgba(232,72,122,0.30);
            padding: 6px 16px;
            border-radius: 8px;
            font-family: 'DM Sans', sans-serif;
            font-size: 13px;
            font-weight: 500;
            cursor: pointer;
            transition: background 0.2s, color 0.2s, border-color 0.2s;
            backdrop-filter: blur(8px);
        }

            .btn-logout:hover, input[type="submit"].btn-logout:hover, button.btn-logout:hover {
                background: rgba(232,72,122,0.35);
                color: #fff;
                border-color: rgba(232,72,122,0.55);
            }
        /* HERO */
        .hero {
            background: linear-gradient(160deg, var(--navy) 0%, var(--navy-mid) 50%, #1a2f6e 100%);
            padding: 52px 32px 56px;
            position: relative;
            overflow: hidden;
        }

            .hero::before {
                content: '';
                position: absolute;
                inset: 0;
                background: radial-gradient(ellipse 60% 70% at 80% 50%, rgba(244,124,32,0.12) 0%, transparent 65%), radial-gradient(ellipse 40% 50% at 20% 80%, rgba(232,72,122,0.1) 0%, transparent 60%);
                pointer-events: none;
            }

            .hero::after {
                content: '';
                position: absolute;
                right: -80px;
                top: -80px;
                width: 380px;
                height: 380px;
                border-radius: 50%;
                border: 1.5px solid rgba(255,255,255,0.06);
                pointer-events: none;
            }

        .hero-ring {
            position: absolute;
            right: -20px;
            top: -20px;
            width: 260px;
            height: 260px;
            border-radius: 50%;
            border: 1.5px solid rgba(255,255,255,0.09);
            pointer-events: none;
        }

        .hero-inner {
            max-width: 1580px;
            margin: 0 auto;
            position: relative;
            animation: fadeUp 0.5s ease both;
        }

        .hero-title {
            font-family: 'Playfair Display', serif;
            font-size: clamp(26px, 4vw, 40px);
            color: #fff;
            line-height: 1.2;
            margin-bottom: 10px;
        }

            .hero-title span {
                color: #FFB300;
            }

        .hero-sub {
            font-size: 15px;
            color: rgba(255,255,255,0.6);
            font-weight: 300;
        }

        /* MAIN */
        .main-content {
            max-width: 1680px;
            margin: 0 auto;
            padding: 40px 32px 60px;
        }

        .toolbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 24px;
            flex-wrap: wrap;
            gap: 12px;
        }

            .toolbar h2 {
                font-family: 'Outfit', sans-serif;
                font-size: 22px;
                color: var(--navy);
                font-weight: 700;
            }

            .toolbar p {
                font-size: 13px;
                color: var(--text-muted);
                margin-top: 3px;
            }

        .btn-primary, input[type="submit"].btn-primary, button.btn-primary {
            background: linear-gradient(135deg, var(--navy-light), var(--navy-mid));
            color: #fff;
            border: none;
            padding: 9px 20px;
            border-radius: 9px;
            font-family: 'Outfit', sans-serif;
            font-size: 13px;
            font-weight: 700;
            cursor: pointer;
            transition: opacity 0.18s, transform 0.18s;
            white-space: nowrap;
        }

            .btn-primary:hover {
                opacity: 0.88;
                transform: translateY(-1px);
            }

        .btn-secondary, input[type="submit"].btn-secondary, button.btn-secondary {
            background: var(--off-white);
            color: var(--navy);
            border: 1.5px solid var(--border);
            padding: 8px 18px;
            border-radius: 9px;
            font-family: 'Outfit', sans-serif;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.18s;
        }

            .btn-secondary:hover {
                background: var(--border);
            }

        .filter-bar {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 16px;
            flex-wrap: wrap;
            padding: 16px 20px;
            background: var(--white);
            border: 1px solid var(--border);
            border-radius: 12px;
            box-shadow: var(--shadow-sm);
        }

            .filter-bar label {
                font-weight: 600;
                font-size: 13px;
                color: var(--navy);
            }

        .form-panel {
            background: var(--white);
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 32px;
            margin-bottom: 28px;
            box-shadow: var(--shadow-sm);
            animation: fadeUp 0.35s ease both;
        }

            .form-panel h3 {
                font-family: 'Outfit', sans-serif;
                font-size: 18px;
                color: var(--navy);
                margin-bottom: 22px;
                font-weight: 700;
            }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 18px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

            .form-group label {
                font-size: 13px;
                font-weight: 600;
                color: var(--navy);
            }

        .form-control {
            border: 1.5px solid var(--border);
            border-radius: 8px;
            padding: 8px 12px;
            font-family: 'DM Sans', sans-serif;
            font-size: 13px;
            color: var(--navy);
            background: var(--off-white);
            outline: none;
            transition: border-color 0.18s, box-shadow 0.18s;
            width: 100%;
        }

            .form-control:focus {
                border-color: var(--navy-light);
                box-shadow: 0 0 0 3px rgba(30,50,120,0.08);
                background: #fff;
            }

        .val-error {
            color: var(--pink);
            font-size: 12px;
            margin-top: 2px;
        }

        .form-actions {
            display: flex;
            gap: 10px;
            margin-top: 22px;
        }

        .msg-success {
            color: #27ae60;
            font-size: 13px;
            display: block;
            margin-bottom: 14px;
            font-weight: 500;
            padding: 10px 14px;
            background: #f0faf4;
            border-radius: 8px;
            border-left: 3px solid #27ae60;
        }

        .msg-error {
            color: var(--pink);
            font-size: 13px;
            display: block;
            margin-bottom: 14px;
            font-weight: 500;
            padding: 10px 14px;
            background: var(--pink-pale);
            border-radius: 8px;
            border-left: 3px solid var(--pink);
        }

        /* Instructor assign highlight */
        .assign-group label {
            color: var(--navy-light);
        }

        .assign-group .form-control {
            border-color: rgba(30,50,120,0.3);
            background: #f0f4ff;
        }

        .grid-wrapper {
            background: var(--white);
            border: 1px solid var(--border);
            border-radius: 16px;
            overflow-x: auto;
            box-shadow: var(--shadow-sm);
        }

        .grid {
            width:auto;
            min-width: 900px;
            border-collapse: collapse;
            font-size: 13.5px;
        }

            .grid th {
                background: linear-gradient(135deg, var(--navy) 0%, var(--navy-mid) 100%);
                color: rgba(255,255,255,0.9);
                padding: 13px 16px;
                text-align: left;
                font-weight: 600;
                font-size: 12px;
                letter-spacing: 0.04em;
                text-transform: uppercase;
                white-space: nowrap;
            }

            .grid td {
                padding: 12px 16px;
                border-bottom: 1px solid var(--border);
                color: var(--navy);
                vertical-align: middle;
                white-space: nowrap;
            }

            .grid tr:last-child td {
                border-bottom: none;
            }

            .grid tr:hover td {
                background: var(--off-white);
            }

        .grid-link-edit {
            color: #2563eb;
            font-weight: 600;
            text-decoration: none;
        }

            .grid-link-edit:hover {
                text-decoration: underline;
            }

        .grid-link-delete {
            color: #dc2626;
            font-weight: 600;
            text-decoration: none;
        }

            .grid-link-delete:hover {
                text-decoration: underline;
            }

        .badge-assigned {
            background: rgba(39,174,96,0.12);
            color: #1e7e45;
            border: 1px solid rgba(39,174,96,0.3);
            font-size: 11px;
            font-weight: 600;
            padding: 2px 10px;
            border-radius: 20px;
            white-space: nowrap;
        }

        .badge-unassigned {
            background: var(--orange-pale);
            color: #b35a00;
            border: 1px solid rgba(244,124,32,0.3);
            font-size: 11px;
            font-weight: 600;
            padding: 2px 10px;
            border-radius: 20px;
        }

        #sectionNote {
            font-size: 11px;
            color: #888;
            margin-top: 3px;
            display: none;
        }

        /* FOOTER */
        .footer {
            background: var(--navy);
            color: rgba(255,255,255,0.45);
            text-align: center;
            padding: 22px 32px;
            font-size: 12.5px;
            line-height: 1.8;
        }

            .footer span {
                color: var(--orange);
                font-weight: 600;
            }

        @keyframes fadeUp {
            from {
                opacity: 0;
                transform: translateY(18px);
            }

            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @media (max-width: 768px) {
            .header-inner {
                padding: 0 16px;
                gap: 10px;
            }

            .header-brand {
                display: none;
            }

            .hero {
                padding: 36px 16px 40px;
            }

            .main-content {
                padding: 24px 16px 48px;
            }
        }
    </style>

    <script type="text/javascript">
        function toggleCustomCourse() {
            var row = document.getElementById('customCourseRow');
            var ddl = document.getElementById('<%= ddlCourse.ClientID %>');
           var link = document.getElementById('toggleCourseLink');
           var rfv = document.getElementById('<%= rfvCourse.ClientID %>');
           if (row.style.display === 'none' || row.style.display === '') {
               row.style.display = 'block'; ddl.style.display = 'none';
               link.innerText = '← Back to dropdown'; ValidatorEnable(rfv, false);
           } else {
               row.style.display = 'none'; ddl.style.display = 'block';
               link.innerText = '+ Add new course'; ValidatorEnable(rfv, true);
               document.getElementById('<%= txtCustomCourse.ClientID %>').value = '';
            }
        }
        function onCustomCourseType() {
            ValidatorEnable(document.getElementById('<%= rfvCourse.ClientID %>'), false);
        }
       // Removed onYearLevelChange - no longer needed
    </script>
</head>
<body>
    <form id="form1" runat="server">

        <!-- HEADER -->
        <div class="header">
            <div class="header-inner">
                <img src="styles/logo.png" alt="OLPC Logo" class="header-logo" />
                <span class="header-brand">Our Lady of the Pillar College — San Manuel Inc.</span>
                <div class="header-divider"></div>
                <nav class="header-nav">
                    <asp:Button runat="server" Text="Home" CssClass="nav-btn" PostBackUrl="Default.aspx" />
                    <asp:Button runat="server" Text="Schedule" CssClass="nav-btn" PostBackUrl="ClassroomSchedule.aspx" />
                    <asp:Button runat="server" Text="Map" CssClass="nav-btn" PostBackUrl="ClassroomMap.aspx" />
                    <asp:Button runat="server" Text="Instructors" CssClass="nav-btn" PostBackUrl="ManageInstructors.aspx" />
                    <asp:Button runat="server" Text="Users" CssClass="nav-btn" PostBackUrl="ManageUsers.aspx" />
                    <asp:Button runat="server" Text="Reports" CssClass="nav-btn" PostBackUrl="Reports.aspx" />
                    <div class="user-bar">
                        <asp:Label ID="lblRoleBadge" runat="server" CssClass="role-badge"></asp:Label>
                        <asp:Button ID="btnProfile" runat="server" Text="Profile" CssClass="nav-btn" PostBackUrl="Profile.aspx" />
                        <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn-logout" />
                    </div>
                </nav>
            </div>
        </div>

        <!-- HERO -->
        <div class="hero">
            <div class="hero-ring"></div>
            <div class="hero-inner">
                <h1 class="hero-title">Manage <span>Subjects</span></h1>
                <p class="hero-sub">Manage subject codes, descriptions, units &amp; instructor assignments</p>
            </div>
        </div>

        <!-- MAIN CONTENT -->
        <div class="main-content">

            <div class="toolbar">
                <div>
                    <h2>Subjects</h2>
                    <p>Code / Description / Units / Course / Year Level / Assigned Instructor</p>
                </div>
                <asp:Button ID="btnAdd" runat="server" Text="+ Add Subject" CssClass="btn-primary" />
            </div>

            <asp:Label ID="lblMsg" runat="server" CssClass="msg-success"></asp:Label>

            <!-- Filter bar — visible to Admin/Dean only -->
            <asp:Panel ID="pnlFilter" runat="server" Visible="false" CssClass="filter-bar">
                <label>Filter by Instructor:</label>
                <asp:DropDownList ID="ddlFilterInstructor" runat="server" CssClass="form-control"
                    AutoPostBack="true" Width="220px">
                </asp:DropDownList>
                <asp:Button ID="btnClearFilter" runat="server" Text="Clear Filter"
                    CssClass="btn-secondary" CausesValidation="false" />
            </asp:Panel>

            <!-- Form panel -->
            <asp:Panel ID="pnlForm" runat="server" CssClass="form-panel" Visible="false">
                <h3>Subject Details</h3>
                <div class="form-grid">
                    <asp:HiddenField ID="hfSubjectID" runat="server" Value="0" />

                    <div class="form-group">
                        <label>Subject Code:</label>
                        <asp:TextBox ID="txtCode" runat="server" CssClass="form-control" placeholder="e.g. IT101"></asp:TextBox>
                        <asp:RequiredFieldValidator ControlToValidate="txtCode" runat="server"
                            ErrorMessage="Code required." CssClass="val-error" Display="Dynamic" />
                    </div>

                    <div class="form-group">
                        <label>Description:</label>
                        <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" placeholder="Subject name"></asp:TextBox>
                        <asp:RequiredFieldValidator ControlToValidate="txtDescription" runat="server"
                            ErrorMessage="Description required." CssClass="val-error" Display="Dynamic" />
                    </div>

                    <div class="form-group">
                        <label>Units:</label>
                        <asp:TextBox ID="txtUnits" runat="server" CssClass="form-control" placeholder="3"></asp:TextBox>
                        <asp:RangeValidator ControlToValidate="txtUnits" runat="server"
                            MinimumValue="1" MaximumValue="6" Type="Integer"
                            ErrorMessage="Units must be 1–6." CssClass="val-error" Display="Dynamic" />
                    </div>

                    <div class="form-group">
                        <label>
                            Course:
                        <span id="toggleCourseLink" style="font-weight: normal; font-size: 11px; color: #2563eb; cursor: pointer; margin-left: 8px;"
                            onclick="toggleCustomCourse()">+ Add new course</span>
                        </label>
                        <asp:DropDownList ID="ddlCourse" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select Course --</asp:ListItem>
                            <asp:ListItem Value="BSIT">BSIT</asp:ListItem>
                            <asp:ListItem Value="BSBAMM">BSBAMM</asp:ListItem>
                            <asp:ListItem Value="BSBAFM">BSBAFM</asp:ListItem>
                            <asp:ListItem Value="BSedME">BSed - Major in English</asp:ListItem>
                            <asp:ListItem Value="BSedMF">BSed - Major in Filipino</asp:ListItem>
                            <asp:ListItem Value="BSedMM">BSed - Major in Mathematics</asp:ListItem>
                            <asp:ListItem Value="BSedMS">BSed - Major in Science</asp:ListItem>
                            <asp:ListItem Value="BSA">BSA</asp:ListItem>
                            <asp:ListItem Value="BSCrim">BSCrim</asp:ListItem>
                            <asp:ListItem Value="BSEE">BSEE</asp:ListItem>
                            <asp:ListItem Value="BSHM">BSHM</asp:ListItem>
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="rfvCourse" ControlToValidate="ddlCourse"
                            runat="server" ErrorMessage="Course required." CssClass="val-error"
                            InitialValue="" Display="Dynamic" />
                        <div id="customCourseRow" style="display: none; margin-top: 6px;">
                            <asp:TextBox ID="txtCustomCourse" runat="server" CssClass="form-control"
                                placeholder="e.g. BSBAFM, BS-ELED" Style="margin-bottom: 4px;"
                                onkeyup="onCustomCourseType()"></asp:TextBox>
                            <small style="color: #888;">Type the course code and click Save.</small>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Year Level:</label>
                        <asp:DropDownList ID="ddlYearLevel" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Select Year --</asp:ListItem>
                            <asp:ListItem Value="1">1st Year</asp:ListItem>
                            <asp:ListItem Value="2">2nd Year</asp:ListItem>
                            <asp:ListItem Value="3">3rd Year</asp:ListItem>
                            <asp:ListItem Value="4">4th Year</asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="form-group">
                        <label>Section: <small style="font-weight: normal; color: #888;">(Optional)</small></label>
                        <asp:DropDownList ID="ddlSection" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- No Section --</asp:ListItem>
                            <asp:ListItem Value="A">A</asp:ListItem>
                            <asp:ListItem Value="B">B</asp:ListItem>
                            <asp:ListItem Value="C">C</asp:ListItem>
                            <asp:ListItem Value="D">D</asp:ListItem>
                        </asp:DropDownList>
                        <!-- Removed RequiredFieldValidator - section is now optional -->
                    </div>

                    <!-- ASSIGN INSTRUCTOR — visible to Admin/Dean only (controlled in code-behind) -->
                    <asp:Panel ID="pnlAssignInstructor" runat="server" Visible="false" CssClass="form-group assign-group">
                        <label>Assign to Instructor:</label>
                        <asp:DropDownList ID="ddlAssignInstructor" runat="server" CssClass="form-control">
                            <asp:ListItem Value="0">-- Unassigned --</asp:ListItem>
                        </asp:DropDownList>
                        <small style="color: var(--text-muted); font-size: 11px;">Instructor will see this subject in their dashboard &amp; teaching load.</small>
                    </asp:Panel>

                </div>
                <div class="form-actions">
                    <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="btn-primary" />
                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn-secondary" CausesValidation="false" />
                </div>
            </asp:Panel>

            <!-- Grid -->
            <div class="grid-wrapper">
                <asp:GridView ID="gvSubjects" runat="server" CssClass="grid"
                    AutoGenerateColumns="false"
                    EmptyDataText="No subjects found."
                    DataKeyNames="SubjectID">
                    <Columns>
                        <asp:BoundField DataField="SubjectID" HeaderText="ID" />
                        <asp:BoundField DataField="Code" HeaderText="Code" />
                        <asp:BoundField DataField="Description" HeaderText="Description" />
                        <asp:BoundField DataField="Units" HeaderText="Units" />
                        <asp:BoundField DataField="CourseCode" HeaderText="Course" />
                        <asp:BoundField DataField="YearLevel" HeaderText="Year" />
                        <asp:BoundField DataField="Section" HeaderText="Section" />
                        <asp:BoundField DataField="AddedByName" HeaderText="Added By" />
                        <asp:TemplateField HeaderText="Assigned To">
                            <ItemTemplate>
                                <%# If(Eval("AssignedInstructorName").ToString() = "Unassigned",
                                "<span class=""badge-unassigned"">Unassigned</span>",
                                "<span class=""badge-assigned"">" & Server.HtmlEncode(Eval("AssignedInstructorName").ToString()) & "</span>") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:ButtonField CommandName="EditRow" Text="✏️ Edit" ButtonType="Link" HeaderText="" ControlStyle-CssClass="grid-link-edit" />
                        <asp:ButtonField CommandName="DeleteRow" Text="🗑️ Delete" ButtonType="Link" HeaderText="" ControlStyle-CssClass="grid-link-delete" />
                    </Columns>
                </asp:GridView>
            </div>
        </div>

        <!-- FOOTER -->
        <div class="footer">
            <p>Classroom Mapping System &copy; 2026 &nbsp;·&nbsp; Our Lady of the Pillar College—San Manuel Inc.</p>
            <p>Developed by: <span>Andrew </span> </p>
            <p>Designer: <span>Audrey </span> </p>
            <p>Data Gatherer: <span>Jack </span> </p>
        </div>

    </form>
</body>
</html>
