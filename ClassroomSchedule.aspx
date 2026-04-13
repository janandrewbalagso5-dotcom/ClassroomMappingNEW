<%@ Page Language="VB" AutoEventWireup="false" CodeFile="ClassroomSchedule.aspx.vb" Inherits="ClassroomSchedule" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Classroom Schedule - CMS</title>
    <link rel="stylesheet" type="text/css" href="styles/style.css" />
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=DM+Sans:wght@300;400;500;600&family=Outfit:wght@600;700&display=swap" rel="stylesheet" />
    <style>
         *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

 :root {
     --navy:        #0d1f4c;
     --navy-mid:    #162660;
     --navy-light:  #1e3278;
     --white:       #ffffff;
     --off-white:   #f5f7fc;
     --orange:      #f4df20;
     --orange-pale: #f3ea72;
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

 /* HEADER */
.header {
    position: sticky; top: 0; z-index: 100;
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
    height: 48px; width: 48px;
    border-radius: 50%;
    object-fit: cover;
    border: 2.5px solid rgba(255,255,255,0.35);
    flex-shrink: 0;
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
    color: rgba(255,255,255,0.82);
    border: none;
    padding: 7px 14px;
    border-radius: 7px;
    font-family: 'DM Sans', sans-serif;
    font-size: 13px;
    font-weight: 500;
    cursor: pointer;
    transition: background 0.18s, color 0.18s;
    text-decoration: none;
    white-space: nowrap;
}
.nav-btn:hover, input[type="submit"].nav-btn:hover, button.nav-btn:hover {
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
     color: #ffa55a;
     border: 1px solid rgba(244,124,32,0.4);
     font-size: 11px;
     font-weight: 600;
     padding: 3px 11px;
     border-radius: 20px;
     letter-spacing: 0.04em;
     text-transform: uppercase;
 }
 .btn-logout, input[type="submit"].btn-logout, button.btn-logout {
     background: rgba(232,72,122,0.18); color: #ffb3cb;
     border: 1px solid rgba(232,72,122,0.30); padding: 6px 16px; border-radius: 8px;
     font-family: 'Outfit', sans-serif; font-size: 13px; font-weight: 600;
     cursor: pointer; transition: background 0.2s, color 0.2s, border-color 0.2s;
     backdrop-filter: blur(8px);
 }
 .btn-logout:hover, input[type="submit"].btn-logout:hover, button.btn-logout:hover {
     background: rgba(232,72,122,0.35); color: #fff; border-color: rgba(232,72,122,0.55);
 }

        /* ─── MAIN CONTENT ─── */
.main-content {
    max-width: 1680px; margin: 0 auto; padding: 0 32px 60px;
}

        /* ─── WELCOME / PAGE HEADER ─── */
.welcome-label {
    display: block; margin: 28px 0 6px;
    font-size: 13.5px; color: var(--text-muted); font-family: 'DM Sans', sans-serif;
}
.page-title {
    font-family: 'Outfit', sans-serif;
    font-size: 21px; color: var(--navy); font-weight: 700; margin-bottom: 4px;
    display: flex; align-items: center; gap: 8px;
}
.page-title svg { flex-shrink: 0; }
.page-subtitle { font-size: 13px; color: var(--text-muted); margin-bottom: 24px; }

/* HERO */

.hero {
    background: linear-gradient(160deg, var(--navy) 0%, var(--navy-mid) 50%, #1a2f6e 100%);
    padding: 48px 32px 52px; position: relative; overflow: hidden;
}
.hero::before {
    content: ''; position: absolute; inset: 0;
    background:
        radial-gradient(ellipse 60% 70% at 80% 50%, rgba(244,124,32,0.12) 0%, transparent 65%),
        radial-gradient(ellipse 40% 50% at 20% 80%, rgba(232,72,122,0.10) 0%, transparent 60%);
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
.hero-inner {
    max-width: 1630px; margin: 0 auto;
    position: relative; animation: fadeUp 0.5s ease both;
}
.hero-eyebrow {
    display: inline-flex; align-items: center; gap: 8px;
    background: rgba(244,124,32,0.18); color: var(--orange);
    border: 1px solid rgba(244,124,32,0.3); border-radius: 20px;
    padding: 4px 14px; font-size: 11.5px; font-weight: 600;
    letter-spacing: 0.06em; text-transform: uppercase; margin-bottom: 16px;
}
.hero-eyebrow::before {
    content: ''; width: 6px; height: 6px;
    border-radius: 50%; background: var(--orange); flex-shrink: 0;
}
.hero-title {
    font-family: 'Playfair Display', serif;
    font-size: clamp(24px, 4vw, 38px); color: #fff;
    line-height: 1.2; margin-bottom: 8px;
}
.hero-title span { color: #FFB300; }
.hero-sub { font-size: 14px; color: rgba(255,255,255,0.6); font-weight: 300; }

  /* ─── MESSAGES ─── */
  .msg-success {
      display: block; background: #e8f5e9; color: #2e7d32;
      border: 1px solid #a5d6a7; border-radius: 10px;
      padding: 11px 18px; font-size: 13px; margin-bottom: 20px; font-weight: 500;
  }
  .msg-error {
      display: block; background: #fdecea; color: #c62828;
      border: 1px solid #f5c6c6; border-radius: 10px;
      padding: 11px 18px; font-size: 13px; margin-bottom: 20px; font-weight: 500;
  }

 /* ── Sticky Time Column ── */
 .schedule-grid {
     width: 100%;
     border-collapse: separate;
     border-spacing: 0;
     background: var(--white); border-radius: 14px; 
 }
  .schedule-grid thead tr th {
     background: var(--navy);
     color: rgba(255,255,255,0.92);
     font-family: 'Outfit', sans-serif;
     font-size: 12px; font-weight: 700;
     letter-spacing: 0.04em; text-transform: uppercase;
     padding: 13px 10px; text-align: center;
     border-bottom: 2px solid var(--navy-mid);
     white-space: nowrap;
 }

 /* Freeze the Time header cell */
 .schedule-grid thead tr th:first-child {
     background: var(--navy-mid);
     position: sticky;
     left: 0;
     z-index: 3;
     border-right: 2px solid rgba(255,255,255,0.12);
 }

 /* Freeze the Time data cells */
 .schedule-grid tbody tr td:first-child,
 .schedule-grid tbody tr td.room-label {
     position: sticky;
     left: 0;
     z-index: 2;
     background: var(--navy);
     background: #eef2f9 !important;
     box-shadow: 1px 0 3px;
     font-weight: 700;
     color: #1e3a5f;
     border-right: 2px solid #c5d3e8;
     white-space: nowrap;
     min-width: 90px;
 }

 /* ─── SECTION HEADER (MWF / TTH) ─── */
.grid-day-header {
    font-family: 'Outfit', sans-serif;
    font-size: 18px; font-weight: 700; color: var(--navy);
    margin: 32px 0 14px;
    padding-left: 14px;
    border-left: 4px solid var(--navy-light);
}

 /* Keep the table wrapper scrollable */
 .table-responsive {
     overflow-x: auto;
     position: relative;
 }

 .header-icon { vertical-align: middle; margin-right: 6px; }
 .page-title-icon { vertical-align: middle; margin-right: 8px; }
 .nav-btn-icon { vertical-align: middle; margin-right: 4px; }

 /* FOOTER */

.footer {
    background: var(--navy);
    color: rgba(255,255,255,0.45);
    text-align: center;
    padding: 22px 32px;
    font-size: 12.5px;
    line-height: 1.8;
}
.footer span { color: var(--orange); font-weight: 600; }

/* ANIMATIONS */

@keyframes fadeUp {
    from { opacity: 0; transform: translateY(16px); }
    to   { opacity: 1; transform: translateY(0); }
}
.hero-inner { animation: fadeUp 0.5s ease both; }

/* RESPONSIVE */

@media (max-width: 768px) {
    .header-inner { padding: 0 16px; gap: 10px; }
    .header-brand { display: none; }
    .hero { padding: 32px 16px 40px; }
    .main-content { padding: 20px 16px 48px; }
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
                <asp:Button runat="server"         Text="Home"      CssClass="nav-btn" PostBackUrl="Default.aspx" />
                <asp:Button runat="server"         Text="Map"       CssClass="nav-btn" PostBackUrl="ClassroomMap.aspx" />
                <asp:Button ID="btnSubjects" runat="server" Text="Subjects" CssClass="nav-btn" PostBackUrl="ManageSubjects.aspx" />
                <asp:Button runat="server" Text="Instructors" CssClass="nav-btn active" PostBackUrl="ManageInstructors.aspx" />
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

 <!-- HERO BANNER -->
 <div class="hero">
     <div class="hero-ring"></div>
     <div class="hero-inner">
         <h1 class="hero-title">Classroom <span>Schedule</span></h1>
         <p class="hero-sub">View and manage MWF &amp; TTH class schedules per classroom</p>
     </div>
 </div>

        <div class="main-content">
             <asp:Label ID="lblWelcome" runat="server"
                style="display:block;margin:28px 0 6px;font-size:13.5px;color:#7a8bb5;font-family:'DM Sans',sans-serif;"></asp:Label>
            <h1 class="page-title">
                <svg class="page-title-icon" xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"
                     fill="none" stroke="#3a5a8c" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
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
                Schedule Grid by Room
            </h1>
            <p class="page-subtitle">View and manage MWF &amp; TTH class schedules per classroom.</p>

            <asp:Label ID="lblMsg" runat="server" CssClass="msg-success"></asp:Label>

            <%-- Hidden fields for cell postback --%>
            <asp:HiddenField ID="hfRoom"       runat="server" />
            <asp:HiddenField ID="hfTime"       runat="server" />
            <asp:HiddenField ID="hfSubject"    runat="server" />
            <asp:HiddenField ID="hfSection"    runat="server" />
            <asp:HiddenField ID="hfInstructor" runat="server" />
            <asp:HiddenField ID="hfAction"     runat="server" />
            <asp:HiddenField ID="hfScheduleID" runat="server" />
            <asp:HiddenField ID="hfDayType"    runat="server" />
            <asp:Button ID="btnCellAction" runat="server" Text="" Style="display:none;" />


            <div class="table-responsive">
                <asp:Literal ID="litGrid" runat="server"></asp:Literal>
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

    <asp:Literal ID="litScript" runat="server"></asp:Literal>

    <script type="text/javascript">

        // subjects, instructors, sections, instructorMap — injected by server

        // ── Editor open/close ────────────────────────────────────────────
        // curInst is the EXISTING instructor on an occupied cell ('' for free cells)
        function openEditor(cellId, room, time, curSubj, curSec, curInst, schedID, dayType) {
            var cell = document.getElementById(cellId);
            var ed = cell.querySelector('.cell-editor');
            if (!ed) return;

            // ── Subject dropdown ──────────────────────────────────────────
            var st = ed.querySelector('.sel-subj');
            st.innerHTML = '<option value="">— Select Subject —</option>';
            var subjList = (curInst && instructorMap[curInst] && instructorMap[curInst].subjects.length > 0)
                ? instructorMap[curInst].subjects : subjects;
            subjList.forEach(function (s) {
                var o = document.createElement('option');
                o.value = s.value; o.text = s.label;
                if (s.value === curSubj) o.selected = true;
                st.appendChild(o);
            });

            // ── Section dropdown ──────────────────────────────────────────
            var ss = ed.querySelector('.sel-sec');
            ss.innerHTML = '<option value="">— Select Section —</option>';
            var secList = (curInst && instructorMap[curInst] && instructorMap[curInst].sections.length > 0)
                ? instructorMap[curInst].sections : sections;
            secList.forEach(function (s) {
                var o = document.createElement('option');
                o.value = s; o.text = s;
                if (s === curSec) o.selected = true;
                ss.appendChild(o);
            });

            // ── Instructor dropdown (full list, pre-select existing) ──────
            var si = ed.querySelector('.sel-inst');
            si.innerHTML = '<option value="">— Select Instructor —</option>';
            instructors.forEach(function (s) {
                var o = document.createElement('option');
                o.value = s.value; o.text = s.label;
                if (s.value === curInst) o.selected = true;
                si.appendChild(o);
            });

            // When instructor changes inside the editor, re-filter subject & section live
            si.onchange = function () {
                var chosenInst = si.value;
                var prevSubj = st.value;
                var prevSec = ss.value;

                st.innerHTML = '<option value="">— Select Subject —</option>';
                var newSubjList = (chosenInst && instructorMap[chosenInst] && instructorMap[chosenInst].subjects.length > 0)
                    ? instructorMap[chosenInst].subjects : subjects;
                newSubjList.forEach(function (s) {
                    var o = document.createElement('option');
                    o.value = s.value; o.text = s.label;
                    if (s.value === prevSubj) o.selected = true;
                    st.appendChild(o);
                });
                if (st.value !== prevSubj) st.value = '';

                ss.innerHTML = '<option value="">— Select Section —</option>';
                var newSecList = (chosenInst && instructorMap[chosenInst] && instructorMap[chosenInst].sections.length > 0)
                    ? instructorMap[chosenInst].sections : sections;
                newSecList.forEach(function (s) {
                    var o = document.createElement('option');
                    o.value = s; o.text = s;
                    if (s === prevSec) o.selected = true;
                    ss.appendChild(o);
                });
                if (ss.value !== prevSec) ss.value = '';
            };

            ed.style.display = 'block';
            cell.querySelector('.cell-display').style.display = 'none';
        }

        function closeEditor(cellId) {
            var cell = document.getElementById(cellId);
            cell.querySelector('.cell-editor').style.display = 'none';
            cell.querySelector('.cell-display').style.display = 'block';
        }

        function saveCell(cellId, room, schedID, time, dayType) {
            var cell = document.getElementById(cellId);
            var ed = cell.querySelector('.cell-editor');
            var subj = ed.querySelector('.sel-subj').value;
            var sec = ed.querySelector('.sel-sec').value;
            var inst = ed.querySelector('.sel-inst').value;
            if (!subj || !inst) { alert('Please select a Subject and Instructor.'); return; }
            setHidden('hfRoom', room);
            setHidden('hfTime', time);
            setHidden('hfSubject', subj);
            setHidden('hfSection', sec);
            setHidden('hfInstructor', inst);
            setHidden('hfAction', 'save');
            setHidden('hfScheduleID', schedID);
            setHidden('hfDayType', dayType);
            document.getElementById('<%= btnCellAction.ClientID %>').click();
        }

        function clearCell(cellId, room, time, schedID) {
            if (!confirm('Remove this schedule entry?')) return;
            setHidden('hfRoom',       room);
            setHidden('hfTime',       time);
            setHidden('hfAction',     'delete');
            setHidden('hfScheduleID', schedID);
            document.getElementById('<%= btnCellAction.ClientID %>').click();
        }

        function setHidden(id, val) { document.getElementById(id).value = val; }
    </script>
</body>
</html>
