<%@ Page Language="VB" AutoEventWireup="false" CodeFile="ManageUsers.aspx.vb" Inherits="ManageUsers" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Manage Users — CMS</title>
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
            --pink: #e8487a;
            --pink-pale: #fce4ed;
            --text-muted: #7a8bb5;
            --border: #dce3f5;
            --shadow-sm: 0 2px 12px rgba(13,31,76,0.07);
        }

        html, body {
            height: 100%;
            font-family: 'DM Sans', sans-serif;
            background: var(--off-white);
            color: var(--navy);
        }

        .header {
            position: sticky;
            top: 0;
            z-index: 100;
            background: rgba(13,31,76,0.92);
            backdrop-filter: blur(20px) saturate(180%);
            border-bottom: 1px solid rgba(255,255,255,0.10);
            box-shadow: 0 4px 24px rgba(13,31,76,0.18);
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
            transition: background 0.2s, color 0.2s;
            text-decoration: none;
            white-space: nowrap;
        }

            .nav-btn:hover {
                background: rgba(255,255,255,0.12);
                color: #fff;
            }

            .nav-btn.active {
                background: rgba(255,255,255,0.15);
                color: #fff;
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
            transition: background 0.2s, color 0.2s;
        }

            .btn-logout:hover {
                background: rgba(232,72,122,0.35);
                color: #fff;
            }

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
            font-size: clamp(26px,4vw,40px);
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

        .main-content {
            max-width: 1280px;
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

        .filter-bar {
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 16px 20px;
            margin-bottom: 20px;
            background: var(--white);
            border: 1px solid var(--border);
            border-radius: 12px;
            box-shadow: var(--shadow-sm);
            flex-wrap: wrap;
        }

            .filter-bar label {
                font-size: 13px;
                font-weight: 600;
                color: var(--navy);
                white-space: nowrap;
            }

        .filter-select {
            border: 1.5px solid var(--border);
            border-radius: 8px;
            padding: 7px 12px;
            font-family: 'DM Sans', sans-serif;
            font-size: 13px;
            color: var(--navy);
            background: var(--off-white);
            outline: none;
            cursor: pointer;
            transition: border-color 0.18s;
            min-width: 180px;
        }

            .filter-select:focus {
                border-color: var(--navy-light);
                background: #fff;
            }

        .role-counts {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
            margin-left: auto;
        }

        .count-pill {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 3px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
            border: 1.5px solid transparent;
            transition: opacity 0.18s;
            text-decoration: none;
        }

            .count-pill:hover {
                opacity: 0.8;
            }

        .pill-all {
            background: #eef2ff;
            color: var(--navy-light);
            border-color: var(--border);
        }

        .pill-admin {
            background: rgba(232,72,122,0.12);
            color: var(--pink);
            border: 1px solid rgba(232,72,122,0.3);
        }

        .pill-dean {
            background: rgba(244,124,32,0.12);
            color: var(--orange);
            border: 1px solid rgba(244,124,32,0.3);
        }

        .pill-instructor {
            background: rgba(30,50,120,0.10);
            color: var(--navy-light);
            border: 1px solid rgba(30,50,120,0.2);
        }

        .pill-student {
            background: rgba(39,174,96,0.10);
            color: #1e7e45;
            border: 1px solid rgba(39,174,96,0.25);
        }

        .alert {
            padding: 13px 18px;
            border-radius: 10px;
            font-size: 13.5px;
            font-weight: 500;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .alert-success {
            background: #eafaf1;
            color: #1e7e45;
            border: 1px solid #a9dfc0;
        }

        .alert-error {
            background: var(--pink-pale);
            color: var(--pink);
            border: 1px solid #f5c0cf;
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
                margin-bottom: 6px;
                font-weight: 700;
            }

            .form-panel .form-subtitle {
                font-size: 13px;
                color: var(--text-muted);
                margin-bottom: 22px;
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
        }

        .hint-text {
            font-size: 11.5px;
            color: var(--text-muted);
            margin-top: 3px;
        }

        .form-actions {
            display: flex;
            gap: 10px;
            margin-top: 22px;
            flex-wrap: wrap;
        }

        .btn-primary, input[type="submit"].btn-primary, button.btn-primary {
            background: linear-gradient(135deg, var(--navy-light), var(--navy-mid));
            color: #fff;
            border: none;
            padding: 9px 20px;
            border-radius: 9px;
            font-family: 'DM Sans', sans-serif;
            font-size: 13px;
            font-weight: 600;
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
            font-family: 'DM Sans', sans-serif;
            font-size: 13px;
            font-weight: 500;
            cursor: pointer;
            transition: background 0.18s;
        }

            .btn-secondary:hover {
                background: var(--border);
            }

        .btn-add {
            background: linear-gradient(160deg, var(--navy) 0%, var(--navy-mid) 50%, #1a2f6e 100%);
            color: #fff;
            border: none;
            padding: 9px 20px;
            border-radius: 9px;
            font-family: 'DM Sans', sans-serif;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: opacity 0.18s, transform 0.18s;
            white-space: nowrap;
        }

            .btn-add:hover {
                opacity: 0.88;
                transform: translateY(-1px);
            }

        /* Add form accent */
        .form-panel.add-panel {
            border-left: 4px solid #27ae60;
        }

        .form-panel.edit-panel {
            border-left: 4px solid var(--navy-light);
        }

        .badge {
            display: inline-block;
            padding: 2px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 0.04em;
            text-transform: uppercase;
        }

        .badge-admin {
            background: rgba(232,72,122,0.12);
            color: var(--pink);
            border: 1px solid rgba(232,72,122,0.3);
        }

        .badge-dean {
            background: rgba(244,124,32,0.12);
            color: var(--orange);
            border: 1px solid rgba(244,124,32,0.3);
        }

        .badge-instructor {
            background: rgba(30,50,120,0.10);
            color: var(--navy-light);
            border: 1px solid rgba(30,50,120,0.2);
        }

        .badge-student {
            background: rgba(39,174,96,0.10);
            color: #1e7e45;
            border: 1px solid rgba(39,174,96,0.25);
        }

        .grid-wrapper {
            background: var(--white);
            border: 1px solid var(--border);
            border-radius: 16px;
            overflow-x: auto;
            box-shadow: var(--shadow-sm);
        }

        .grid {
            width: 100%;
            min-width: 750px;
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
                padding: 13px 16px;
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

            .grid th:last-child, .grid td:last-child {
                position: sticky;
                right: 0;
                background: var(--white);
                box-shadow: -2px 0 8px rgba(13,31,76,0.06);
                z-index: 1;
            }

            .grid th:last-child {
                background: var(--navy-mid);
            }

            .grid a {
                font-weight: 600;
                text-decoration: none;
                margin-right: 8px;
                display: inline-block;
            }

                .grid a:hover {
                    text-decoration: underline;
                }

        .grid-link-edit {
            color: #2563eb !important;
        }

        .grid-link-delete {
            color: #dc2626 !important;
        }

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

            .role-counts {
                margin-left: 0;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">

        <div class="header">
            <div class="header-inner">
                <img src="styles/logo.png" alt="OLPC Logo" class="header-logo" />
                <span class="header-brand">Our Lady of the Pillar College — San Manuel Inc.</span>
                <div class="header-divider"></div>
                <nav class="header-nav">
                    <asp:Button runat="server" Text="Home" CssClass="nav-btn" PostBackUrl="Default.aspx" />
                    <asp:Button runat="server" Text="Schedule" CssClass="nav-btn" PostBackUrl="ClassroomSchedule.aspx" />
                    <asp:Button runat="server" Text="Map" CssClass="nav-btn" PostBackUrl="ClassroomMap.aspx" />
                    <asp:Button runat="server" Text="Subjects" CssClass="nav-btn" PostBackUrl="ManageSubjects.aspx" />
                    <asp:Button runat="server" Text="Instructors" CssClass="nav-btn" PostBackUrl="ManageInstructors.aspx" />
                    <asp:Button runat="server" Text="Reports" CssClass="nav-btn" PostBackUrl="Reports.aspx" />
                    <div class="user-bar">
                        <asp:Label ID="lblRoleBadge" runat="server" CssClass="role-badge"></asp:Label>
                        <asp:Button ID="btnProfile" runat="server" Text="Profile" CssClass="nav-btn" PostBackUrl="Profile.aspx" />
                        <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn-logout" />
                    </div>
                </nav>
            </div>
        </div>

        <div class="hero">
            <div class="hero-ring"></div>
            <div class="hero-inner">
                <h1 class="hero-title">Manage <span>Users</span></h1>
                <p class="hero-sub">Create, edit and manage user accounts</p>
            </div>
        </div>

        <div class="main-content">

            <asp:Panel ID="pnlMsg" runat="server" Visible="false">
                <div id="alertBox" runat="server" class="alert alert-success">
                    <asp:Label ID="lblMsg" runat="server"></asp:Label>
                </div>
            </asp:Panel>

            <div class="toolbar">
                <div>
                    <h2>User Accounts</h2>
                    <p>Username / Full Name / Role / Email / Phone</p>
                </div>
                <asp:Button ID="btnShowAdd" runat="server" Text="+ Add User" CssClass="btn-add" CausesValidation="false" />
            </div>

            <!-- ─── ADD USER FORM ─── -->
            <asp:Panel ID="pnlAddForm" runat="server" CssClass="form-panel add-panel" Visible="false">
                <h3>Create New User</h3>
                <p class="form-subtitle">Fill in the details below to create a new account.</p>
                <div class="form-grid">
                    <div class="form-group">
                        <label>Full Name:</label>
                        <asp:TextBox ID="txtAddFullName" runat="server" CssClass="form-control" placeholder="e.g. Juan Dela Cruz"></asp:TextBox>
                        <asp:RequiredFieldValidator ControlToValidate="txtAddFullName" runat="server" ValidationGroup="AddUser"
                            ErrorMessage="Full name required." CssClass="val-error" Display="Dynamic" />
                    </div>
                    <div class="form-group">
                        <label>Username:</label>
                        <asp:TextBox ID="txtAddUsername" runat="server" CssClass="form-control" placeholder="e.g. jdelacruz"></asp:TextBox>
                        <asp:RequiredFieldValidator ControlToValidate="txtAddUsername" runat="server" ValidationGroup="AddUser"
                            ErrorMessage="Username required." CssClass="val-error" Display="Dynamic" />
                    </div>
                    <div class="form-group">
                        <label>Password:</label>
                        <asp:TextBox ID="txtAddPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Min. 6 characters"></asp:TextBox>
                        <asp:RequiredFieldValidator ControlToValidate="txtAddPassword" runat="server" ValidationGroup="AddUser"
                            ErrorMessage="Password required." CssClass="val-error" Display="Dynamic" />
                    </div>
                    <div class="form-group">
                        <label>Role:</label>
                        <asp:DropDownList ID="ddlAddRole" runat="server" CssClass="form-control"
                            onchange="toggleInstructorFields(this.value)">
                            <asp:ListItem Value="Instructor">Instructor</asp:ListItem>
                            <asp:ListItem Value="Dean">Dean</asp:ListItem>
                            <asp:ListItem Value="Student">Student</asp:ListItem>
                            <asp:ListItem Value="Admin">Admin</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="form-group">
                        <label>Email:</label>
                        <asp:TextBox ID="txtAddEmail" runat="server" CssClass="form-control" placeholder="e.g. juan@school.edu"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label>Phone:</label>
                        <asp:TextBox ID="txtAddPhone" runat="server" CssClass="form-control" placeholder="e.g. 09xxxxxxxxx"></asp:TextBox>
                    </div>
                </div>

                <%-- Instructor-only section — shown/hidden by JS --%>
                <div id="instructorSection" style="margin-top: 22px; padding: 20px 22px; background: #f0f4ff; border: 1.5px solid #c5d3e8; border-radius: 12px; display: block;">
                    <div style="font-size: 11px; font-weight: 700; color: #7a8bb5; letter-spacing: 0.06em; text-transform: uppercase; margin-bottom: 16px;">
                        &#9679; Instructor Details
                    </div>
                    <div class="form-grid">
                        <div class="form-group">
                            <label>Qualifications:</label>
                            <asp:DropDownList ID="ddlAddQualification" runat="server" CssClass="form-control">
                                <asp:ListItem Value="">-- Select Qualification --</asp:ListItem>
                                <asp:ListItem Value="Bachelor's Degree">Bachelor's Degree</asp:ListItem>
                                <asp:ListItem Value="Bachelor of Secondary Education (BSEd)">Bachelor of Secondary Education (BSEd)</asp:ListItem>
                                <asp:ListItem Value="Bachelor in Elementary Education (BEEd)">Bachelor in Elementary Education (BEEd)</asp:ListItem>
                                <asp:ListItem Value="Bachelor of Science in Accountancy (BSA)">Bachelor of Science in Accountancy (BSA)</asp:ListItem>
                                <asp:ListItem Value="Bachelor of Science in Business Administration (BSBA)">Bachelor of Science in Business Administration (BSBA)</asp:ListItem>
                                <asp:ListItem Value="Bachelor of Science in Criminology (BSCrim)">Bachelor of Science in Criminology (BSCrim)</asp:ListItem>
                                <asp:ListItem Value="Bachelor of Science in Hospitality Management (BSHM)">Bachelor of Science in Hospitality Management (BSHM)</asp:ListItem>
                                <asp:ListItem Value="Bachelor of Science in Information Technology (BSIT)">Bachelor of Science in Information Technology (BSIT)</asp:ListItem>
                                <asp:ListItem Value="Licensed Professional Teacher">LPT</asp:ListItem>
                                <asp:ListItem Value="Juris Doctor (JD)">Juris Doctor (JD)</asp:ListItem>
                                <asp:ListItem Value="Master's Degree">Master's Degree</asp:ListItem>
                                <asp:ListItem Value="Master in Information Technology (MIT)">Master in Information Technology (MIT)</asp:ListItem>
                                <asp:ListItem Value="Master of Arts in Education (MAEd)">Master of Arts in Education (MAEd)</asp:ListItem>
                                <asp:ListItem Value="Master of Science in Computer Science (MSCS)">Master of Science in Computer Science (MSCS)</asp:ListItem>
                                <asp:ListItem Value="Master of Business Administration (MBA)">Master of Business Administration (MBA)</asp:ListItem>
                                <asp:ListItem Value="Master of Science in Criminology (MSCrim)">Master of Science in Criminology (MSCrim)</asp:ListItem>
                                <asp:ListItem Value="Doctorate Degree (PhD)">Doctorate Degree (PhD)</asp:ListItem>
                                <asp:ListItem Value="PhD in Computer Science">PhD in Computer Science</asp:ListItem>
                                <asp:ListItem Value="PhD in Education">PhD in Education</asp:ListItem>
                                <asp:ListItem Value="PhD in Business Administration">PhD in Business Administration</asp:ListItem>
                                <asp:ListItem Value="PhD in Criminology">PhD in Criminology</asp:ListItem>
                                <asp:ListItem Value="PhD in Information Technology">PhD in Information Technology</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="form-group">
                            <label>Position:</label>
                            <asp:DropDownList ID="ddlAddPosition" runat="server" CssClass="form-control">
                                <asp:ListItem Value="Instructor">Instructor</asp:ListItem>
                                <asp:ListItem Value="Coordinator">Coordinator</asp:ListItem>
                                <asp:ListItem Value="Assistant Professor">Assistant Professor</asp:ListItem>
                                <asp:ListItem Value="Associate Professor">Associate Professor</asp:ListItem>
                                <asp:ListItem Value="Professor">Professor</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="form-group">
                            <label>Department:</label>
                            <asp:DropDownList ID="ddlAddDepartment" runat="server" CssClass="form-control">
                                <asp:ListItem Value="">-- Select Department --</asp:ListItem>
                                <asp:ListItem Value="BSEd — Major in English">BSEd — Major in English</asp:ListItem>
                                <asp:ListItem Value="BSEd — Major in Filipino">BSEd — Major in Filipino</asp:ListItem>
                                <asp:ListItem Value="BSEd — Major in Mathematics">BSEd — Major in Mathematics</asp:ListItem>
                                <asp:ListItem Value="BSEd — Major in Science">BSEd — Major in Science</asp:ListItem>
                                <asp:ListItem Value="BS Accountancy">BS Accountancy</asp:ListItem>
                                <asp:ListItem Value="BSBA — Financial Management">BSBA — Financial Management</asp:ListItem>
                                <asp:ListItem Value="BSBA — Marketing Management">BSBA — Marketing Management</asp:ListItem>
                                <asp:ListItem Value="BS Criminology">BS Criminology</asp:ListItem>
                                <asp:ListItem Value="BEEd">BEEd</asp:ListItem>
                                <asp:ListItem Value="BS Hospitality Management">BS Hospitality Management</asp:ListItem>
                                <asp:ListItem Value="BS Information Technology">BS Information Technology</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="form-group">
                            <label>Years of Experience:</label>
                            <asp:TextBox ID="txtAddYears" runat="server" CssClass="form-control" Text="0" placeholder="0"></asp:TextBox>
                        </div>
                        <div class="form-group" style="justify-content: flex-end; padding-bottom: 4px;">
                            <label>&nbsp;</label>
                            <div style="display: flex; align-items: center; gap: 10px; padding: 8px 0;">
                                <asp:CheckBox ID="chkAddHEA" runat="server" />
                                <label style="font-weight: 500; color: #555; font-size: 13px; margin: 0;">HEA (Higher Education Award)</label>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="form-actions">
                    <asp:Button ID="btnAddSave" runat="server" Text="Create Account" CssClass="btn-primary" ValidationGroup="AddUser" />
                    <asp:Button ID="btnAddCancel" runat="server" Text="Cancel" CssClass="btn-secondary" CausesValidation="false" />
                </div>
            </asp:Panel>

            <script type="text/javascript">
                function toggleInstructorFields(role) {
                    var sec = document.getElementById('instructorSection');
                    if (sec) sec.style.display = (role === 'Instructor') ? 'block' : 'none';
                }
                // Run on page load to sync with server-side default
                window.addEventListener('load', function () {
                    var ddl = document.getElementById('<%= ddlAddRole.ClientID %>');
                if (ddl) toggleInstructorFields(ddl.value);
            });
            </script>

            <!-- ─── EDIT USER FORM ─── -->
            <asp:Panel ID="pnlForm" runat="server" CssClass="form-panel edit-panel" Visible="false">
                <h3>Edit User</h3>
                <p class="form-subtitle">Update account details. Leave password blank to keep the current one.</p>
                <asp:HiddenField ID="hfUserID" runat="server" Value="0" />
                <div class="form-grid">
                    <div class="form-group">
                        <label>Full Name:</label>
                        <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control"></asp:TextBox>
                        <asp:RequiredFieldValidator ControlToValidate="txtFullName" runat="server" ValidationGroup="EditUser"
                            ErrorMessage="Full name required." CssClass="val-error" Display="Dynamic" />
                    </div>
                    <div class="form-group">
                        <label>Email:</label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="e.g. juan@email.com"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label>Phone:</label>
                        <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" placeholder="e.g. 09xxxxxxxxx"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label>New Password: <span class="hint-text">(leave blank to keep current)</span></label>
                        <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password" CssClass="form-control"></asp:TextBox>
                    </div>
                </div>
                <div class="form-actions">
                    <asp:Button ID="btnSave" runat="server" Text="Save Changes" CssClass="btn-primary" ValidationGroup="EditUser" />
                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn-secondary" CausesValidation="false" />
                </div>
            </asp:Panel>

            <div class="filter-bar">
                <label>Filter by Role:</label>
                <asp:DropDownList ID="ddlRoleFilter" runat="server" CssClass="filter-select" AutoPostBack="true">
                    <asp:ListItem Value="">All Users</asp:ListItem>
                    <asp:ListItem Value="Admin">Admin</asp:ListItem>
                    <asp:ListItem Value="Dean">Dean</asp:ListItem>
                    <asp:ListItem Value="Instructor">Instructor</asp:ListItem>
                    <asp:ListItem Value="Student">Student</asp:ListItem>
                </asp:DropDownList>
                <div class="role-counts">
                    <asp:LinkButton ID="lbAll" runat="server" CssClass="count-pill pill-all" CommandArgument="" OnClick="FilterPill_Click">
                        <asp:Label ID="lblCountAll" runat="server"></asp:Label>
                        All</asp:LinkButton>
                    <asp:LinkButton ID="lbAdmin" runat="server" CssClass="count-pill pill-admin" CommandArgument="Admin" OnClick="FilterPill_Click">
                        <asp:Label ID="lblCountAdmin" runat="server"></asp:Label>
                        Admin</asp:LinkButton>
                    <asp:LinkButton ID="lbDean" runat="server" CssClass="count-pill pill-dean" CommandArgument="Dean" OnClick="FilterPill_Click">
                        <asp:Label ID="lblCountDean" runat="server"></asp:Label>
                        Dean</asp:LinkButton>
                    <asp:LinkButton ID="lbInstructor" runat="server" CssClass="count-pill pill-instructor" CommandArgument="Instructor" OnClick="FilterPill_Click">
                        <asp:Label ID="lblCountInstructor" runat="server"></asp:Label>
                        Instructor</asp:LinkButton>
                    <asp:LinkButton ID="lbStudent" runat="server" CssClass="count-pill pill-student" CommandArgument="Student" OnClick="FilterPill_Click">
                        <asp:Label ID="lblCountStudent" runat="server"></asp:Label>
                        Student</asp:LinkButton>
                </div>
            </div>

            <div class="grid-wrapper">
                <asp:GridView ID="gvUsers" runat="server" CssClass="grid"
                    AutoGenerateColumns="false"
                    EmptyDataText="No users found for this role."
                    DataKeyNames="UserID">
                    <Columns>
                        <asp:BoundField DataField="UserID" HeaderText="ID" />
                        <asp:BoundField DataField="Username" HeaderText="Username" />
                        <asp:BoundField DataField="FullName" HeaderText="Full Name" />
                        <asp:TemplateField HeaderText="Role">
                            <ItemTemplate>
                                <span class='<%# DirectCast(GetRoleBadgeClass(DataBinder.Eval(Container.DataItem, "Role").ToString()), String) %>'>
                                    <%# DataBinder.Eval(Container.DataItem, "Role") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="Email" HeaderText="Email" />
                        <asp:BoundField DataField="Phone" HeaderText="Phone" />
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <asp:LinkButton runat="server" CommandName="Edit" CssClass="grid-link-edit" Text="Edit" />
                                <asp:LinkButton runat="server" CommandName="Delete" CssClass="grid-link-delete" Text="Delete"
                                    OnClientClick="return confirm('Delete this user account? This cannot be undone.');" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>

        </div>

        <div class="footer">
            <p>Classroom Mapping System &copy; 2026 &nbsp;·&nbsp; Our Lady of the Pillar College—San Manuel Inc.</p>
            <p>Developed by: <span>Andrew </span> </p>
            <p>Designer: <span>Audrey </span> </p>
            <p>Data Gatherer: <span>Jack </span> </p>
        </div>

    </form>
</body>
</html>
