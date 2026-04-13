<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Reports.aspx.vb" Inherits="Reports" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Reports — Teaching Load — CMS</title>
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
        }

        html, body {
            height: 100%;
            font-family: 'DM Sans', sans-serif;
            background: var(--off-white);
            color: var(--navy);
        }

        /* HEADER */
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
                background: radial-gradient(ellipse 60% 70% at 80% 50%, rgba(244,124,32,0.12) 0%, transparent 65%);
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
            max-width: 1630px;
            margin: 0 auto;
            position: relative;
            animation: fadeUp 0.5s ease both;
        }

        .hero-eyebrow {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: rgba(244,124,32,0.18);
            color: var(--orange);
            border: 1px solid rgba(244,124,32,0.3);
            border-radius: 20px;
            padding: 4px 14px;
            font-size: 11.5px;
            font-weight: 600;
            letter-spacing: 0.06em;
            text-transform: uppercase;
            margin-bottom: 18px;
        }

            .hero-eyebrow::before {
                content: '';
                width: 6px;
                height: 6px;
                border-radius: 50%;
                background: var(--orange);
                flex-shrink: 0;
            }

        .hero-title {
            font-family: 'Playfair Display', serif;
            font-size: clamp(26px,4vw,40px);
            color: #fff;
            line-height: 1.2;
            margin-bottom: 10px;
        }

            .hero-title span {
                color: var(--orange);
            }

        .hero-sub {
            font-size: 15px;
            color: rgba(255,255,255,0.6);
            font-weight: 300;
        }

        /* MAIN */
        .main-content {
            max-width: 1100px;
            margin: 0 auto;
            padding: 40px 32px 60px;
        }

        /* Report Controls */
        .report-controls {
            background: var(--white);
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 28px 32px;
            margin-bottom: 28px;
            box-shadow: var(--shadow-sm);
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
            align-items: flex-end;
        }

        .rc-group {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

            .rc-group label {
                font-size: 13px;
                font-weight: 600;
                color: var(--navy);
            }

            .rc-group select, .rc-group input[type="text"] {
                border: 1.5px solid var(--border);
                border-radius: 8px;
                padding: 8px 12px;
                font-family: 'DM Sans', sans-serif;
                font-size: 13px;
                color: var(--navy);
                background: var(--off-white);
                outline: none;
                min-width: 200px;
                transition: border-color 0.18s, box-shadow 0.18s;
            }

                .rc-group select:focus, .rc-group input:focus {
                    border-color: var(--navy-light);
                    box-shadow: 0 0 0 3px rgba(30,50,120,0.08);
                    background: #fff;
                }

        .btn-generate {
            background: linear-gradient(135deg, var(--navy-light), var(--navy-mid));
            color: #fff;
            border: none;
            padding: 10px 24px;
            border-radius: 9px;
            font-family: 'DM Sans', sans-serif;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: opacity 0.18s, transform 0.18s;
            white-space: nowrap;
        }

            .btn-generate:hover {
                opacity: 0.88;
                transform: translateY(-1px);
            }

        .btn-print {
            background: #27ae60;
            color: #fff;
            border: none;
            padding: 10px 24px;
            border-radius: 9px;
            font-family: 'DM Sans', sans-serif;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: opacity 0.18s;
            white-space: nowrap;
        }

            .btn-print:hover {
                opacity: 0.88;
            }

        .msg-info {
            padding: 14px 18px;
            background: var(--orange-pale);
            color: #7a3e00;
            border: 1px solid rgba(244,124,32,0.3);
            border-radius: 10px;
            font-size: 13px;
            margin-bottom: 20px;
        }

        /* ── TEACHING LOAD DOCUMENT ── */
        .tl-doc {
            background: #fff;
            border: 1px solid #bbb;
            padding: 36px 44px;
            max-width: 860px;
            margin: 0 auto;
            box-shadow: 0 4px 24px rgba(0,0,0,0.10);
            font-family: Arial, sans-serif;
        }

        /* Header */
        .tl-header {
            text-align: center;
            margin-bottom: 10px;
        }

        .tl-header-row {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 14px;
        }

        .tl-logo {
            height: 56px;
            width: 56px;
            border-radius: 50%;
            object-fit: cover;
        }

        .tl-school-info {
            text-align: center;
        }

        .tl-school-name {
            font-size: 15px;
            font-family: "MedievalSharp";
            font-weight: 700;
            text-transform: uppercase;
            line-height: 1.3;
        }

        .tl-school-sub {
            font-size: 10.5px;
            line-height: 1.6;
        }

        .tl-school-email a {
            color: inherit;
        }

        .tl-divider {
            border: none;
            border-top: 2px solid #000;
            margin: 10px 0 6px;
        }

        .tl-title {
            text-align: center;
            font-size: 15px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: .06em;
            margin: 8px 0 4px;
        }

        .tl-semester {
            text-align: center;
            font-size: 12px;
            margin-bottom: 14px;
        }

        .tl-meta {
            display: flex;
            justify-content: space-between;
            font-size: 12px;
            margin-bottom: 14px;
        }

        .tl-meta-left {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }

        .tl-meta-right {
            display: flex;
            flex-direction: column;
            gap: 5px;
            text-align: right;
        }

        .tl-section-label {
            font-size: 12px;
            font-weight: 700;
            text-decoration: underline;
            margin: 10px 0 6px;
        }

        .tl-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 11px;
            margin-bottom: 10px;
        }

            .tl-table th {
                background: #e8e8e8;
                border: 1px solid #555;
                padding: 5px 7px;
                text-align: center;
                font-weight: 700;
                text-transform: uppercase;
                font-size: 10px;
                line-height: 1.3;
            }

            .tl-table td {
                border: 1px solid #555;
                padding: 5px 7px;
                text-align: center;
                vertical-align: middle;
            }

                .tl-table td.left {
                    text-align: left;
                }

            .tl-table .totals td {
                font-weight: 700;
                background: #f5f5f5;
            }

            .tl-table .label-right td {
                text-align: right;
            }

        .tl-prepared {
            display: flex;
            justify-content: space-between;
            font-size: 11px;
            margin: 6px 0 28px;
        }

        .tl-sigs {
            display: flex;
            justify-content: space-between;
            font-size: 12px;
        }

        .tl-sig-block {
            display: flex;
            flex-direction: column;
            gap: 2px;
        }

        .tl-sig-name {
            font-weight: 700;
            text-transform: uppercase;
            border-bottom: 1.5px solid #000;
            padding-top: 4px;
            margin-top: 18px;
        }

        .tl-sig-title {
            font-size: 11px;
            color: #555;
        }

        .tl-empty {
            text-align: center;
            color: #999;
            font-style: italic;
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

        /* PRINT STYLES */
        @media print {
            .header, .hero, .report-controls, .footer, .btn-print {
                display: none !important;
            }

            .main-content {
                padding: 0 !important;
            }

            .tl-doc {
                border: none !important;
                box-shadow: none !important;
                padding: 8px !important;
                max-width: 100% !important;
            }

            body {
                background: #fff !important;
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

            .tl-doc {
                padding: 20px 16px;
            }

            .report-controls {
                flex-direction: column;
            }
        }
    </style>
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
                    <asp:Button runat="server" Text="Subjects" CssClass="nav-btn" PostBackUrl="ManageSubjects.aspx" />
                    <asp:Button runat="server" Text="Instructors" CssClass="nav-btn" PostBackUrl="ManageInstructors.aspx" />
                    <asp:Button runat="server" Text="Users" CssClass="nav-btn" PostBackUrl="ManageUsers.aspx" />
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
                <h1 class="hero-title">Teaching <span>Load Report</span></h1>
                <p class="hero-sub">Auto-generated actual teaching load document per instructor</p>
            </div>
        </div>

        <!-- MAIN CONTENT -->
        <div class="main-content">

            <!-- Controls -->
            <div class="report-controls">
                <div class="rc-group">
                    <label>Instructor:</label>
                    <%-- Change ddlInstructor to add AutoPostBack --%>
                    <asp:DropDownList ID="ddlInstructor" runat="server" CssClass="form-control" AutoPostBack="true">
                        <asp:ListItem Value="0">-- Select Instructor --</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="rc-group">
                    <label>Semester:</label>
                    <asp:DropDownList ID="ddlSemester" runat="server" CssClass="form-control">
                        <asp:ListItem Value="1st Semester">1st Semester</asp:ListItem>
                        <asp:ListItem Value="2nd Semester" Selected="True">2nd Semester</asp:ListItem>
                        <asp:ListItem Value="Summer">Summer</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="rc-group">
                    <label>School Year:</label>
                    <asp:TextBox ID="txtSY" runat="server" placeholder="e.g. 2025 - 2026"
                        Text="2025 - 2026" Style="border: 1.5px solid var(--border); border-radius: 8px; padding: 8px 12px; font-family: 'DM Sans',sans-serif; font-size: 13px; min-width: 180px; outline: none; background: var(--off-white);"></asp:TextBox>
                </div>
                <button type="button" class="btn-print" onclick="window.print()">Print</button>
            </div>

            <!-- Info message (shown when no report yet) -->
            <asp:Panel ID="pnlInfo" runat="server" Visible="true">
                <div class="msg-info">Select an instructor and click <strong>Generate Report</strong> to produce the teaching load document.</div>
            </asp:Panel>

            <!-- Teaching Load Document -->
            <asp:Panel ID="pnlReport" runat="server" Visible="false">
                <div class="tl-doc" id="tlDoc">

                    <!-- School Header -->
                    <div class="tl-header">
                        <div class="tl-header-row">
                            <img src="styles/logo.png" alt="OLPC Logo" class="tl-logo" />
                            <div class="tl-school-info">
                                <div class="tl-school-name">Our Lady of the Pillar College – San Manuel, Inc.</div>
                                <div class="tl-school-sub">DISTRICT 3, SAN MANUEL, ISABELA, PHILIPPINES</div>
                                <div class="tl-school-sub">E-mail: <a href="mailto:nuestrasenioradelpilar@gmail.com">nuestrasenioradelpilar@gmail.com</a></div>
                            </div>
                        </div>
                    </div>

                    <hr class="tl-divider" />

                    <div class="tl-title">ACTUAL TEACHING LOAD</div>
                    <div class="tl-semester">
                        <asp:Label ID="lblSemesterTitle" runat="server"></asp:Label>
                    </div>

                    <div class="tl-meta">
                        <div class="tl-meta-left">
                            <div>Name of Instructor: &nbsp;<strong><asp:Label ID="lblInstructorName" runat="server"></asp:Label></strong></div>
                            <div>Educ. Qualifications: &nbsp;<strong><asp:Label ID="lblQualifications" runat="server"></asp:Label></strong></div>
                        </div>
                        <div class="tl-meta-right">
                            <div>Years of Teaching in OLPC SMI: &nbsp;<asp:Label ID="lblYearsTeaching" runat="server"></asp:Label></div>
                        </div>
                    </div>

                    <div class="tl-section-label">COLLEGE</div>

                    <table class="tl-table">
                        <thead>
                            <tr>
                                <th style="width: 90px;">Subject Code</th>
                                <th>Course Title</th>
                                <th style="width: 70px;">Days</th>
                                <th style="width: 110px;">Hour Schedule</th>
                                <th style="width: 70px;">Room No.</th>
                                <th style="width: 55px;">Units</th>
                                <th style="width: 80px;">No. of Students</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="rptSubjects" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td><%# Eval("Code") %></td>
                                        <td class="left"><%# Eval("Description") %></td>
                                        <td><%# Eval("Days") %></td>
                                        <td><%# Eval("HourSchedule") %></td>
                                        <td><%# Eval("RoomNo") %></td>
                                        <td><%# Eval("Units") %></td>
                                        <td></td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                            <asp:Repeater ID="rptEmpty" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td colspan="7" class="tl-empty">No subjects assigned to this instructor yet.</td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                        <tfoot>
                            <tr class="totals">
                                <td colspan="5" style="text-align: right; font-weight: 700;">TOTAL UNITS</td>
                                <td style="font-weight: 700;">
                                    <asp:Label ID="lblTotalUnits" runat="server"></asp:Label></td>
                                <td></td>
                            </tr>
                            <tr class="totals">
                                <td colspan="5" style="text-align: right; font-weight: 700;">NO. OF PREPARATION</td>
                                <td style="font-weight: 700;">
                                    <asp:Label ID="lblNoOfPrep" runat="server"></asp:Label></td>
                                <td></td>
                            </tr>
                        </tfoot>
                    </table>

                    <div class="tl-prepared">
                        <span>Prepared by:</span>
                        <span>Verified by:</span>
                    </div>

                    <div class="tl-sigs">
                        <div class="tl-sig-block">
                            <div class="tl-sig-name">
                                <asp:Label ID="lblSigInstructor" runat="server"></asp:Label></div>
                            <div class="tl-sig-title">Signature over Printed Name</div>
                        </div>
                        <div class="tl-sig-block" style="text-align: right;">
                            <div class="tl-sig-name">KEVIN LESTER G. TAGUBA</div>
                            <div class="tl-sig-title">Registrar</div>
                        </div>
                    </div>

                </div>
            </asp:Panel>

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
