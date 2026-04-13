<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="Default" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Classroom Mapping System — OLPC San Manuel</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=DM+Sans:wght@300;400;500;600&family=Outfit:wght@600;700&display=swap" rel="stylesheet" />
      <style>
      @font-face {
          font-family: 'Cascadia Code';
          src: url('https://cdn.jsdelivr.net/npm/@fontsource/cascadia-code@4.2.1/files/cascadia-code-latin-400-normal.woff2') format('woff2');
          font-weight: 400; font-style: normal;
      }
      @font-face {
          font-family: 'Cascadia Code';
          src: url('https://cdn.jsdelivr.net/npm/@fontsource/cascadia-code@4.2.1/files/cascadia-code-latin-600-normal.woff2') format('woff2');
          font-weight: 600; font-style: normal;
      }
      @font-face {
          font-family: 'Cascadia Code';
          src: url('https://cdn.jsdelivr.net/npm/@fontsource/cascadia-code@4.2.1/files/cascadia-code-latin-700-normal.woff2') format('woff2');
          font-weight: 700; font-style: normal;
      }
      </style>
     <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --navy:        #0d1f4c;
            --navy-mid:    #162660;
            --navy-light:  #1e3278;
            --white:       #ffffff;
            --off-white:   #f5f7fc;
            --orange:      #f47c20;
            --orange-pale: #fde8d0;
            --pink:        #e8487a;
            --pink-pale:   #fce4ed;
            --text-muted:  #7a8bb5;
            --border:      #dce3f5;
            --shadow-sm:   0 2px 12px rgba(13,31,76,0.07);
            --shadow-md:   0 6px 28px rgba(13,31,76,0.13);
            --shadow-lg:   0 16px 48px rgba(13,31,76,0.18);
        }

        html, body {
            height: 100%;
            font-family: 'DM Sans', sans-serif;
            background: var(--off-white);
            color: var(--navy);
        }

        /* ─── HEADER — GLASSMORPHISM ─── */
        .header {
            position: sticky;
            top: 0;
            z-index: 100;
            background: rgba(13, 31, 76, 0.90);
            backdrop-filter: blur(20px) saturate(180%);
            -webkit-backdrop-filter: blur(20px) saturate(180%);
            border-bottom: 1px solid rgba(255, 255, 255, 0.10);
            box-shadow:
                0 4px 24px rgba(13, 31, 76, 0.18),
                inset 0 1px 0 rgba(255, 255, 255, 0.10);
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
            height: 48px; width: 48px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid rgba(255, 255, 255, 0.30);
            flex-shrink: 0;
            box-shadow: 0 0 0 4px rgba(255,255,255,0.06);
        }

        .header-brand {
            font-family: 'Playfair Display', serif;
            font-size: 15px;
            color: rgba(255, 255, 255, 0.92);
            line-height: 1.3;
            max-width: 200px;
            text-shadow: 0 1px 4px rgba(0,0,0,0.25);
        }

        .header-divider {
            width: 1px; height: 32px;
            background: rgba(255, 255, 255, 0.15);
            flex-shrink: 0;
        }

        .header-nav {
            display: flex;
            align-items: center;
            gap: 4px;
            flex: 1;
        }

        .nav-btn, input[type="submit"].nav-btn, button.nav-btn {
            background: transparent;
            color: rgba(255, 255, 255, 0.78);
            border: none;
            padding: 7px 14px;
            border-radius: 8px;
            font-family: 'Outfit', sans-serif;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s, color 0.2s, box-shadow 0.2s;
            text-decoration: none;
            white-space: nowrap;
            letter-spacing: 0.01em;
        }
        .nav-btn:hover, input[type="submit"].nav-btn:hover, button.nav-btn:hover {
            background: rgba(255, 255, 255, 0.13);
            color: #fff;
            box-shadow: inset 0 0 0 1px rgba(255,255,255,0.15);
        }
        .nav-btn.active {
            background: rgba(255, 255, 255, 0.15);
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
            background: rgba(244, 124, 32, 0.20);
            color: #ffa55a;
            border: 1px solid rgba(244, 124, 32, 0.35);
            font-size: 11px;
            font-weight: 600;
            padding: 3px 11px;
            border-radius: 20px;
            letter-spacing: 0.05em;
            text-transform: uppercase;
            backdrop-filter: blur(8px);
        }

        .btn-logout, input[type="submit"].btn-logout, button.btn-logout {
            background: rgba(232, 72, 122, 0.18);
            color: #ffb3cb;
            border: 1px solid rgba(232, 72, 122, 0.30);
            padding: 6px 16px;
            border-radius: 8px;
            font-family: 'Outfit', sans-serif; font-size: 13px; font-weight: 500;
            cursor: pointer;
            transition: background 0.2s, color 0.2s, border-color 0.2s;
            backdrop-filter: blur(8px);
        }
        .btn-logout:hover, input[type="submit"].btn-logout:hover, button.btn-logout:hover {
            background: rgba(232, 72, 122, 0.35);
            color: #fff;
            border-color: rgba(232, 72, 122, 0.55);
        }

        /* ─── HERO BANNER ─── */
        .hero {
            background: linear-gradient(160deg, var(--navy) 0%, var(--navy-mid) 50%, #1a2f6e 100%);
            padding: 52px 32px 56px;
            position: relative;
            overflow: hidden;
        }

        .hero::before {
            content: '';
            position: absolute; inset: 0;
            background:
                radial-gradient(ellipse 60% 70% at 80% 50%, rgba(244,124,32,0.12) 0%, transparent 65%),
                radial-gradient(ellipse 40% 50% at 20% 80%, rgba(232,72,122,0.1) 0%, transparent 60%);
            pointer-events: none;
        }

        .hero::after {
            content: '';
            position: absolute;
            right: -80px; top: -80px;
            width: 380px; height: 380px;
            border-radius: 50%;
            border: 1.5px solid rgba(255,255,255,0.06);
            pointer-events: none;
        }

        .hero-ring {
            position: absolute;
            right: -20px; top: -20px;
            width: 260px; height: 260px;
            border-radius: 50%;
            border: 1.5px solid rgba(255,255,255,0.09);
            pointer-events: none;
        }

        .hero-inner {
            max-width: 1580px;
            margin: 0 auto;
            position: relative;
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
            width: 6px; height: 6px;
            border-radius: 50%;
            background: var(--orange);
            flex-shrink: 0;
        }

        .hero-title {
            font-family: 'Playfair Display', serif;
            font-size: clamp(26px, 4vw, 40px);
            color: #fff;
            line-height: 1.2;
            margin-bottom: 10px;
        }

        .hero-title span { color: #FFB300; }

        .hero-sub {
            font-size: 15px;
            color: rgba(255,255,255,0.6);
            font-weight: 300;
        }

        /* ─── MAIN CONTENT ─── */
        .main-content {
            max-width: 1280px;
            margin: 0 auto;
            padding: 0 32px 60px;
        }

        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 22px;
        }

        /* Makes asp:Panel wrapper invisible to grid so .card slots correctly */
        .grid-passthrough {
            display: contents;
        }

        /* ─── CARD ─── */
        .card {
            background: var(--white);
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 32px 26px 26px;
            cursor: pointer;
            position: relative;
            overflow: hidden;
            transition: transform 0.22s ease, box-shadow 0.22s ease, border-color 0.22s;
            box-shadow: var(--shadow-sm);
        }

        .card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 3px;
            background: linear-gradient(90deg, var(--navy-light), var(--pink));
            opacity: 0;
            transition: opacity 0.22s;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-lg);
            border-color: transparent;
        }

        .card:hover::before { opacity: 1; }

        .card::after {
            content: '';
            position: absolute;
            bottom: -30px; right: -30px;
            width: 100px; height: 100px;
            border-radius: 50%;
            background: radial-gradient(circle, rgba(13,31,76,0.04) 0%, transparent 70%);
            transition: transform 0.3s;
        }

        .card:hover::after { transform: scale(1.4); }

        .card-icon {
            width: 58px; height: 58px;
            border-radius: 14px;
            display: flex; align-items: center; justify-content: center;
            margin-bottom: 18px;
            background: var(--off-white);
            transition: background 0.2s;
        }

        .card:hover .card-icon { background: linear-gradient(135deg, var(--orange-pale), var(--pink-pale)); }
        .card:hover .card-icon svg { stroke: var(--pink); }

        .card h2 {
            font-family: 'Outfit', serif;
            font-size: 17px;
            color: var(--navy);
            margin-bottom: 8px;
            font-weight: 700;
        }

        .card p {
            font-size: 13px;
            color: var(--text-muted);
            line-height: 1.6;
            font-weight: 300;
        }

        .badge {
            display: inline-block;
            margin-top: 14px;
            background: var(--orange-pale);
            color: var(--orange);
            border: 1px solid rgba(244,124,32,0.25);
            padding: 3px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .card.card-schedule .card-icon { background: #e8f0fb; }
        .card.card-map      .card-icon { background: #fce4ed; }
        .card.card-subjects .card-icon { background: #fde8d0; }
        .card.card-instruct .card-icon { background: #e8f0fb; }
        .card.card-reports  .card-icon { background: #fde8d0; }
        .card.card-profile  .card-icon { background: #fce4ed; }

        /* ─── FOOTER ─── */
        .footer {
            background: var(--navy);
            color: rgba(255,255,255,0.45);
            text-align: center;
            padding: 22px 32px;
            font-size: 12.5px;
            line-height: 1.8;
        }

        .footer span { color: var(--orange); font-weight: 600; }

        /* ─── ANIMATIONS ─── */
        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(18px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        .hero-inner { animation: fadeUp 0.5s ease both; }
        .card { animation: fadeUp 0.45s ease both; }
        .card:nth-child(1) { animation-delay: 0.05s; }
        .card:nth-child(2) { animation-delay: 0.10s; }
        .card:nth-child(3) { animation-delay: 0.15s; }
        .card:nth-child(4) { animation-delay: 0.20s; }
        .card:nth-child(5) { animation-delay: 0.25s; }
        .card:nth-child(6) { animation-delay: 0.30s; }

        /* ─── RESPONSIVE ─── */
        @media (max-width: 768px) {
            .header-inner { padding: 0 16px; gap: 10px; }
            .header-brand { display: none; }
            .hero { padding: 36px 16px 40px; }
            .main-content { padding: 0 16px 48px; }
        }
    </style>
</head>
<body>
<form id="form1" runat="server">

    <!-- ═══ HEADER ═══ -->
    <div class="header">
        <div class="header-inner">
            <img src="styles/logo.png" alt="OLPC Logo" class="header-logo" />
            <span class="header-brand">Our Lady of the Pillar College — San Manuel Inc.</span>
            <div class="header-divider"></div>
            <nav class="header-nav">
                <asp:Button ID="btnSchedule"    runat="server" Text="Schedule"    CssClass="nav-btn" PostBackUrl="ClassroomSchedule.aspx" />
                <asp:Button ID="btnMap"         runat="server" Text="Map"         CssClass="nav-btn" PostBackUrl="ClassroomMap.aspx" />
                <asp:Button ID="btnSubjects"    runat="server" Text="Subjects"    CssClass="nav-btn" PostBackUrl="ManageSubjects.aspx"   Visible="false" />
                <asp:Button ID="btnInstructors" runat="server" Text="Instructors" CssClass="nav-btn" PostBackUrl="ManageInstructors.aspx" Visible="false" />
                <asp:Button runat="server" Text="Users"       CssClass="nav-btn" PostBackUrl="ManageUsers.aspx" />
                <asp:Button ID="btnReports"     runat="server" Text="Reports"     CssClass="nav-btn" PostBackUrl="Reports.aspx" />
                <div class="user-bar">
                    <asp:Label   ID="lblRoleBadge" runat="server" CssClass="role-badge"></asp:Label>
                    <asp:Button  ID="btnProfile"   runat="server" Text="Profile"   CssClass="nav-btn"   PostBackUrl="Profile.aspx" />
                    <asp:Button  ID="btnLogout"    runat="server" Text="Logout"    CssClass="btn-logout" />
                </div>
            </nav>
        </div>
    </div>

    <!-- ═══ HERO ═══ -->
    <div class="hero">
        <div class="hero-ring"></div>
        <div class="hero-inner">
            <h1 class="hero-title">Classroom <span>Mapping</span> System</h1>
            <p class="hero-sub">Academic Information System</p>
        </div>
    </div>

    <!-- ═══ MAIN CONTENT ═══ -->
    <div class="main-content">
        <asp:Label ID="lblWelcome" runat="server"
            style="display:block;margin:28px 0 6px;font-size:13.5px;color:#7a8bb5;font-family:'DM Sans',sans-serif;"></asp:Label>

        <div style="margin-bottom:22px;">
            <h3 style="font-family:'Outfit',san-serif;font-size:21px;color:#0d1f4c;font-weight:700;">Quick Access</h3>
            <p style="font-size:13px;color:#7a8bb5;margin-top:4px;">Select a module to get started</p>
        </div>

        <div class="dashboard-grid">

            <%-- Classroom Schedule --%>
            <div class="card card-schedule" onclick="window.location='ClassroomSchedule.aspx'">
                <div class="card-icon">
                    <svg xmlns="http://www.w3.org/2000/svg" width="26" height="26" viewBox="0 0 24 24"
                         fill="none" stroke="#1e3278" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"/>
                        <line x1="16" y1="2" x2="16" y2="6"/>
                        <line x1="8"  y1="2" x2="8"  y2="6"/>
                        <line x1="3"  y1="10" x2="21" y2="10"/>
                        <line x1="8"  y1="14" x2="8"  y2="14" stroke-width="2.5"/>
                        <line x1="12" y1="14" x2="12" y2="14" stroke-width="2.5"/>
                        <line x1="16" y1="14" x2="16" y2="14" stroke-width="2.5"/>
                        <line x1="8"  y1="18" x2="8"  y2="18" stroke-width="2.5"/>
                        <line x1="12" y1="18" x2="12" y2="18" stroke-width="2.5"/>
                    </svg>
                </div>
                <h2>Classroom Schedule</h2>
                <p>View and manage MWF &amp; TTH class schedules per room</p>
                <asp:Label ID="lblScheduleCount" runat="server" CssClass="badge"></asp:Label>
            </div>

            <%-- Classroom Map --%>
            <div class="card card-map" onclick="window.location='ClassroomMap.aspx'">
                <div class="card-icon">
                    <svg xmlns="http://www.w3.org/2000/svg" width="26" height="26" viewBox="0 0 24 24"
                         fill="none" stroke="#e8487a" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M21 10c0 7-9 13-9 13S3 17 3 10a9 9 0 0 1 18 0z"/>
                        <circle cx="12" cy="10" r="3"/>
                    </svg>
                </div>
                <h2>Classroom Map</h2>
                <p>Visual room occupancy overview by time slot</p>
            </div>

            <%-- Subjects --%>
            <asp:Panel ID="pnlSubjectsCard" runat="server" Visible="false">
                <div class="card card-subjects" onclick="window.location='ManageSubjects.aspx'">
                    <div class="card-icon">
                        <svg xmlns="http://www.w3.org/2000/svg" width="26" height="26" viewBox="0 0 24 24"
                             fill="none" stroke="#f47c20" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/>
                            <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/>
                            <line x1="9" y1="7"  x2="15" y2="7"/>
                            <line x1="9" y1="11" x2="15" y2="11"/>
                            <line x1="9" y1="15" x2="12" y2="15"/>
                        </svg>
                    </div>
                    <h2>Subjects</h2>
                    <p>Manage subjects, codes, descriptions &amp; units</p>
                    <asp:Label ID="lblSubjectCount" runat="server" CssClass="badge"></asp:Label>
                </div>
            </asp:Panel>

            <%-- Instructors --%>
            <asp:Panel ID="pnlInstructorsCard" runat="server" Visible="false">
                <div class="card card-instruct" onclick="window.location='ManageInstructors.aspx'">
                    <div class="card-icon">
                        <svg xmlns="http://www.w3.org/2000/svg" width="26" height="26" viewBox="0 0 24 24"
                             fill="none" stroke="#1e3278" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
                            <circle cx="9" cy="7" r="4"/>
                            <path d="M23 21v-2a4 4 0 0 0-3-3.87"/>
                            <path d="M16 3.13a4 4 0 0 1 0 7.75"/>
                        </svg>
                    </div>
                    <h2>Instructors</h2>
                    <p>Manage instructor info, qualifications &amp; position</p>
                    <asp:Label ID="lblInstructorCount" runat="server" CssClass="badge"></asp:Label>
                </div>
            </asp:Panel>

            <%-- Reports --%>
            <div class="card card-reports" onclick="window.location='Reports.aspx'">
                <div class="card-icon">
                    <svg xmlns="http://www.w3.org/2000/svg" width="26" height="26" viewBox="0 0 24 24"
                         fill="none" stroke="#f47c20" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="18" y1="20" x2="18" y2="10"/>
                        <line x1="12" y1="20" x2="12" y2="4"/>
                        <line x1="6"  y1="20" x2="6"  y2="14"/>
                        <line x1="2"  y1="20" x2="22" y2="20"/>
                    </svg>
                </div>
                <h2>Reports</h2>
                <p>Class schedule per course/year level &amp; teaching load</p>
            </div>

            <%-- My Profile --%>
            <div class="card card-profile" onclick="window.location='Profile.aspx'">
                <div class="card-icon">
                    <svg xmlns="http://www.w3.org/2000/svg" width="26" height="26" viewBox="0 0 24 24"
                         fill="none" stroke="#e8487a" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                        <circle cx="12" cy="7" r="4"/>
                    </svg>
                </div>
                <h2>My Profile</h2>
                <p>View and update your profile information</p>
            </div>

        </div>
    </div>

    <!-- ═══ FOOTER ═══ -->
    <div class="footer">
        <p>Classroom Mapping System &copy; 2026 &nbsp;·&nbsp; Our Lady of the Pillar College—San Manuel Inc.</p>
            <p>Developed by: <span>Andrew </span> </p>
            <p>Designer: <span>Audrey </span> </p>
            <p>Data Gatherer: <span>Jack </span> </p>
    </div>
</form>
</body>
</html>
