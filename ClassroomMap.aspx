<%@ Page Language="VB" AutoEventWireup="false" CodeFile="ClassroomMap.aspx.vb" Inherits="ClassroomMap" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Classroom Map</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=DM+Sans:wght@300;400;500;600&family=Outfit:wght@600;700&display=swap" rel="stylesheet" />
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --navy:        #0d1f4c;
            --navy-mid:    #162660;
            --navy-light:  #1e3278;
            --white:       #ffffff;
            --off-white:   #f5f7fc;
            --orange:      #FFB300;
            --orange-pale: #FFD666;
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

        /* ─── HEADER ─── */
        .header {
            position: sticky; top: 0; z-index: 100;
            background: rgba(13, 31, 76, 0.90);
            backdrop-filter: blur(20px) saturate(180%);
            -webkit-backdrop-filter: blur(20px) saturate(180%);
            border-bottom: 1px solid rgba(255, 255, 255, 0.10);
            box-shadow: 0 4px 24px rgba(13, 31, 76, 0.18), inset 0 1px 0 rgba(255, 255, 255, 0.10);
        }
        .header-inner {
            max-width: 1680px; margin: 0 auto; padding: 0 32px;
            height: 72px; display: flex; align-items: center; gap: 18px;
        }
        .header-logo {
            height: 48px; width: 48px; border-radius: 50%; object-fit: cover;
            border: 2px solid rgba(255, 255, 255, 0.30); flex-shrink: 0;
            box-shadow: 0 0 0 4px rgba(255,255,255,0.06);
        }
        .header-brand {
            font-family: 'Playfair Display', serif; font-size: 15px;
            color: rgba(255, 255, 255, 0.92); line-height: 1.3; max-width: 200px;
            text-shadow: 0 1px 4px rgba(0,0,0,0.25);
        }
        .header-divider { width: 1px; height: 32px; background: rgba(255,255,255,0.15); flex-shrink: 0; }
        .header-nav { display: flex; align-items: center; gap: 4px; flex: 1; }

        .nav-btn, input[type="submit"].nav-btn, button.nav-btn {
            background: transparent; color: rgba(255,255,255,0.82); border: none;
            padding: 7px 14px; border-radius: 8px;
            font-family: 'Outfit', sans-serif; font-size: 13px; font-weight: 500;
            cursor: pointer; transition: background 0.2s, color 0.2s, box-shadow 0.2s;
            text-decoration: none; white-space: nowrap; letter-spacing: 0.01em;
        }
        .nav-btn:hover, input[type="submit"].nav-btn:hover, button.nav-btn:hover {
            background: rgba(255,255,255,0.12); color: #fff;
            box-shadow: inset 0 0 0 1px rgba(255,255,255,0.15);
        }
        .nav-btn.active {
            background: rgba(255,255,255,0.15); color: #fff;
            box-shadow: inset 0 0 0 1px rgba(255,255,255,0.20);
        }

        .user-bar { display: flex; align-items: center; gap: 10px; margin-left: auto; }
        .role-badge {
            background: rgba(244,124,32,0.20); color: #ffa55a;
            border: 1px solid rgba(244,124,32,0.35); font-size: 11px; font-weight: 600;
            padding: 3px 11px; border-radius: 20px; letter-spacing: 0.05em;
            text-transform: uppercase; backdrop-filter: blur(8px);
        }
        .btn-logout, input[type="submit"].btn-logout, button.btn-logout {
            background: rgba(232,72,122,0.18); color: #ffb3cb;
            border: 1px solid rgba(232,72,122,0.30); padding: 6px 16px; border-radius: 8px;
            font-family: 'DM Sans', sans-serif; font-size: 13px; font-weight: 500;
            cursor: pointer; transition: background 0.2s, color 0.2s, border-color 0.2s;
            backdrop-filter: blur(8px);
        }
        .btn-logout:hover, input[type="submit"].btn-logout:hover, button.btn-logout:hover {
            background: rgba(232,72,122,0.35); color: #fff; border-color: rgba(232,72,122,0.55);
        }

        /* ─── HERO ─── */
        .hero {
            background: linear-gradient(160deg, var(--navy) 0%, var(--navy-mid) 50%, #1a2f6e 100%);
            padding: 52px 32px 56px; position: relative; overflow: hidden;
        }
        .hero::before {
            content: ''; position: absolute; inset: 0;
            background:
                radial-gradient(ellipse 60% 70% at 80% 50%, rgba(244,124,32,0.12) 0%, transparent 65%),
                radial-gradient(ellipse 40% 50% at 20% 80%, rgba(232,72,122,0.1) 0%, transparent 60%);
            pointer-events: none;
        }
        .hero::after {
            content: ''; position: absolute; right: -80px; top: -80px;
            width: 380px; height: 380px; border-radius: 50%;
            border: 1.5px solid rgba(255,255,255,0.06); pointer-events: none;
        }
        .hero-ring {
            position: absolute; right: -20px; top: -20px;
            width: 260px; height: 260px; border-radius: 50%;
            border: 1.5px solid rgba(255,255,255,0.09); pointer-events: none;
        }
        .hero-inner { max-width: 1680px; margin: 0 auto; position: relative; }
        .hero-title {
            font-family: 'Playfair Display', serif;
            font-size: clamp(26px, 4vw, 40px); color: #fff; line-height: 1.2; margin-bottom: 10px;
        }
        .hero-title span { color: #FFB300; }
        .hero-sub { font-size: 15px; color: rgba(255,255,255,0.6); font-weight: 300; }

        /* ─── MAIN CONTENT ─── */
        .main-content { max-width: 1680px; margin: 0 auto; padding: 0 32px 60px; }

        .welcome-label {
            display: block; margin: 28px 0 6px;
            font-size: 13.5px; color: var(--text-muted); font-family: 'DM Sans', sans-serif;
        }
        .page-header { margin-bottom: 22px; }
        .page-header h2 {
            font-family: 'Outfit', sans-serif; font-size: 21px;
            color: var(--navy); font-weight: 700;
        }
        .page-header p { font-size: 13px; color: var(--text-muted); margin-top: 4px; }

        /* ─── FILTER BAR ─── */
        .filter-bar {
            display: flex; align-items: center; gap: 14px;
            background: var(--white); border: 1px solid var(--border);
            border-radius: 12px; padding: 14px 20px;
            box-shadow: var(--shadow-sm); margin-bottom: 28px;
        }
        .filter-bar label {
            font-size: 12px; font-weight: 700; color: var(--text-muted);
            letter-spacing: 0.06em; text-transform: uppercase; white-space: nowrap;
        }
        .form-control {
            border: 1.5px solid var(--border); border-radius: 8px; padding: 7px 12px;
            font-family: 'DM Sans', sans-serif; font-size: 13px; color: var(--navy);
            background: var(--off-white); outline: none;
            transition: border-color 0.18s, box-shadow 0.18s; min-width: 200px;
        }
        .form-control:focus { border-color: var(--navy-light); box-shadow: 0 0 0 3px rgba(30,50,120,0.08); background: #fff; }

        /* ─── FLOOR LABEL ─── */
        .floor-label {
            display: inline-flex; align-items: center; gap: 8px;
            background: var(--navy); color: #fff;
            font-family: 'Outfit', sans-serif; font-size: 13px; font-weight: 700;
            padding: 6px 18px; border-radius: 20px;
            margin: 24px 0 16px; letter-spacing: 0.03em;
        }

        /* ─── ROOM GRID (class emitted by VB: map-grid) ─── */
        .map-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 16px; margin-bottom: 8px;
        }

        /* ─── ROOM CARD (class emitted by VB: map-room) ─── */
        .map-room {
            background: var(--white); border: 1px solid var(--border);
            border-radius: 14px; overflow: hidden; box-shadow: var(--shadow-sm);
            transition: transform 0.2s ease, box-shadow 0.2s ease, border-color 0.2s;
            font-family: 'DM Sans', sans-serif;
        }
        .map-room:hover { transform: translateY(-3px); box-shadow: var(--shadow-md); border-color: transparent; }
        .map-room.occupied { border-color: #c5d3e8; }
        .map-room.lab      { border-color: #d4c5e8; }

        /* Room number header */
        .room-number {
            padding: 10px 14px 8px;
            background: var(--navy); border-bottom: 1px solid var(--border);
            font-family: 'Outfit', sans-serif; font-size: 13.5px; font-weight: 700; color: var(--off-white);
        }
        .map-room.occupied .room-number { background: var(--navy); border-color: #c5d3e8; }
        .map-room.lab      .room-number { background: var(--navy); border-color: #d4c5e8; }

        /* Day group block inside card */
        .day-group { padding: 10px 14px 4px; }

        /* MWF / TTH badges */
        .day-badge {
            display: inline-block; font-size: 10px; font-weight: 700;
            padding: 2px 9px; border-radius: 20px; letter-spacing: 0.05em;
            text-transform: uppercase; margin-bottom: 6px;
            font-family: 'Outfit', sans-serif;
        }
        .day-badge.mwf { background: rgba(30,50,120,0.12); color: var(--navy-light); }
        .day-badge.tth { background: rgba(232,72,122,0.12); color: var(--pink); }

        /* Schedule detail lines */
        .room-detail {
            font-size: 12px; color: var(--navy); line-height: 1.7; padding-bottom: 6px;
        }
        .room-detail strong { font-weight: 700; font-family: 'Outfit', sans-serif; }
        .room-detail em     { font-style: italic; color: var(--text-muted); font-size: 11.5px; }

        /* Available rooms */
        .room-detail.free-text {
            padding: 20px 14px; text-align: center;
            font-size: 12px; color: #b0bcd4; font-style: italic;
        }

        /* ─── COLLAPSE TOGGLE ─── */
        .sched-count {
            font-family: 'DM Sans', sans-serif; font-size: 11px; font-weight: 500;
            color: var(--text-muted); margin-left: 6px;
        }
        .card-extra { border-top: 1px dashed var(--border); margin-top: 4px; }
        .btn-toggle {
            display: block; width: 100%; padding: 7px 14px;
            background: var(--off-white); border: none; border-top: 1px solid var(--border);
            font-family: 'DM Sans', sans-serif; font-size: 12px; font-weight: 600;
            color: var(--navy-light); cursor: pointer; text-align: center;
            transition: background 0.15s; letter-spacing: 0.02em;
        }
        .btn-toggle:hover { background: #e4eaf7; }

        /* ─── LEGEND ─── */
        .legend { display: flex; gap: 18px; align-items: center; margin-top: 8px; margin-bottom: 20px; }
        .legend span {
            display: flex; align-items: center; gap: 7px;
            font-size: 12.5px; font-weight: 500; color: var(--text-muted);
        }
        .legend span::before { content: ''; display: inline-block; width: 12px; height: 12px; border-radius: 3px; }
        .legend-occupied::before { background: #c5d3e8; }
        .legend-free::before     { background: var(--border); }

        /* ─── FOOTER ─── */
        .footer {
            background: var(--navy); color: rgba(255,255,255,0.45);
            text-align: center; padding: 22px 32px; font-size: 12.5px; line-height: 1.8;
        }
        .footer span { color: var(--orange); font-weight: 600; }

        /* ─── ANIMATIONS ─── */
        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(18px); }
            to   { opacity: 1; transform: translateY(0); }
        }
        .hero-inner { animation: fadeUp 0.5s ease both; }

        /* ─── RESPONSIVE ─── */
        @media (max-width: 768px) {
            .header-inner { padding: 0 16px; gap: 10px; }
            .header-brand { display: none; }
            .hero { padding: 36px 16px 40px; }
            .main-content { padding: 0 16px 48px; }
            .map-grid { grid-template-columns: repeat(2, 1fr); }
        }
    </style>
<script type="text/javascript">
    function toggleExtra(id, btn) {
        event.preventDefault();
        event.stopPropagation();
        var el = document.getElementById(id);
        if (el.style.display === 'none') {
            el.style.display = 'block';
            btn.innerHTML = '&#9650; Show less';
        } else {
            el.style.display = 'none';
            btn.innerHTML = '&#9660; Show more';
        }
        return false;
    }
</script>
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
                <asp:Button runat="server"         Text="Home"      CssClass="nav-btn" PostBackUrl="Default.aspx" />
                <asp:Button runat="server"      Text="Schedule"     CssClass="nav-btn" PostBackUrl="ClassroomSchedule.aspx" />
                <asp:Button ID="btnSubjects" runat="server" Text="Subjects" CssClass="nav-btn" PostBackUrl="ManageSubjects.aspx" />
                <asp:Button ID="btnInstructors" runat="server"      Text="Instructors" CssClass="nav-btn" PostBackUrl="ManageInstructors.aspx" />
                <asp:Button runat="server" Text="Users"       CssClass="nav-btn" PostBackUrl="ManageUsers.aspx" />
                <asp:Button runat="server"         Text="Reports"   CssClass="nav-btn" PostBackUrl="Reports.aspx" />
            <div class="user-bar">
                <asp:Label  ID="lblRoleBadge" runat="server" CssClass="role-badge"></asp:Label>
                <asp:Button ID="btnProfile"   runat="server" Text="Profile" CssClass="nav-btn" PostBackUrl="Profile.aspx" />
                <asp:Button ID="btnLogout"    runat="server" Text="Logout"  CssClass="btn-logout" />
            </div>
        </nav>
        </div>
    </div>

 <!-- ═══ HERO BANNER ═══ -->
 <div class="hero">
     <div class="hero-ring"></div>
     <div class="hero-inner">
         <h1 class="hero-title">Classroom <span>Map</span></h1>
         <p class="hero-sub">Visual room occupancy overview by time slot</p>
     </div>
 </div>
         <!-- ═══ MAIN CONTENT ═══ -->
 <div class="main-content">
     <asp:Label ID="lblWelcome" runat="server" CssClass="welcome-label"></asp:Label>

     <div class="page-header">
         <h2>Room Occupancy Overview</h2>
         <p>Select a time slot to filter room availability</p>
     </div>

     <div class="filter-bar">
    <label>Time Slot:</label>
    <asp:DropDownList ID="ddlTime" runat="server" CssClass="form-control" AutoPostBack="true">
        <asp:ListItem Value="">-- All Time Slots --</asp:ListItem>
        <asp:ListItem>7:30-8:30</asp:ListItem>
        <asp:ListItem>8:30-9:30</asp:ListItem>
        <asp:ListItem>9:30-10:30</asp:ListItem>
        <asp:ListItem>10:30-11:30</asp:ListItem>
        <asp:ListItem>11:30-12:30</asp:ListItem>
        <asp:ListItem>12:30-1:30</asp:ListItem>
        <asp:ListItem>1:30-2:30</asp:ListItem>
        <asp:ListItem>2:30-3:30</asp:ListItem>
        <asp:ListItem>3:30-4:30</asp:ListItem>
        <asp:ListItem>4:30-5:30</asp:ListItem>
    </asp:DropDownList>

    <label>Day Type:</label>
    <asp:DropDownList ID="ddlDayType" runat="server" CssClass="form-control" AutoPostBack="true">
        <asp:ListItem Value="">-- All Days --</asp:ListItem>
        <asp:ListItem Value="MWF">MWF</asp:ListItem>
        <asp:ListItem Value="TTH">TTH</asp:ListItem>
    </asp:DropDownList>
</div>

     <div class="room-map">
         <asp:Literal ID="litMap" runat="server"></asp:Literal>
     </div>

     <div class="legend">
         <span class="legend-occupied">Occupied</span>
         <span class="legend-free">Available</span>
     </div>
 </div>
    </form>

   <!-- ═══ FOOTER ═══ -->
   <div class="footer">
    <p>Classroom Mapping System &copy; 2026 &nbsp;·&nbsp; Our Lady of the Pillar College—San Manuel Inc.</p>
            <p>Developed by: <span>Andrew </span> </p>
            <p>Designer: <span>Audrey </span> </p>
            <p>Data Gatherer: <span>Jack </span> </p>
</div>    
</body>
</html>