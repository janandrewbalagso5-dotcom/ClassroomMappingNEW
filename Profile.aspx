<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Profile.aspx.vb" Inherits="Profile" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>My Profile — CMS</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=DM+Sans:wght@300;400;500;600&family=Outfit:wght@500;600;700&display=swap" rel="stylesheet" />
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
        }

        html, body {
            height: 100%;
            font-family: 'DM Sans', sans-serif;
            background: var(--off-white);
            color: var(--navy);
        }

        /* ─── HEADER ─── */
        .header {
            position: sticky;
            top: 0;
            z-index: 100;
            background: rgba(13,31,76,0.92);
            backdrop-filter: blur(20px) saturate(180%);
            -webkit-backdrop-filter: blur(20px) saturate(180%);
            border-bottom: 1px solid rgba(255,255,255,0.10);
            box-shadow: 0 4px 24px rgba(13,31,76,0.18), inset 0 1px 0 rgba(255,255,255,0.10);
        }

        .header-inner {
            max-width: 1280px;
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
            border: 2px solid rgba(255,255,255,0.30);
            flex-shrink: 0;
        }

        .header-brand {
            font-family: 'Playfair Display', serif;
            font-size: 15px;
            color: rgba(255,255,255,0.92);
            line-height: 1.3;
            max-width: 200px;
        }

        .header-divider {
            width: 1px;
            height: 32px;
            background: rgba(255,255,255,0.15);
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
            color: rgba(255,255,255,0.78);
            border: none;
            padding: 7px 14px;
            border-radius: 8px;
            font-family: 'DM Sans', sans-serif;
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
            background: rgba(244,124,32,0.20);
            color: #ffa55a;
            border: 1px solid rgba(244,124,32,0.35);
            font-size: 11px;
            font-weight: 600;
            padding: 3px 11px;
            border-radius: 20px;
            letter-spacing: 0.05em;
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

        /* ─── HERO ─── */
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
            max-width: 1280px;
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

        /* ─── MAIN LAYOUT ─── */
        .main-content {
            max-width: 960px;
            margin: 0 auto;
            padding: 48px 32px 72px;
        }

        /* ─── PROFILE LAYOUT: left card + right form ─── */
        .profile-layout {
            display: grid;
            grid-template-columns: 280px 1fr;
            gap: 24px;
            align-items: start;
        }

        /* ─── LEFT: Identity Card ─── */
        .identity-card {
            background: var(--white);
            border: 1px solid var(--border);
            border-radius: 20px;
            box-shadow: var(--shadow-sm);
            overflow: hidden;
            animation: fadeUp 0.4s ease 0.05s both;
        }

        .identity-top {
            background: linear-gradient(160deg, var(--navy) 0%, var(--navy-mid) 100%);
            padding: 32px 24px 28px;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 12px;
            position: relative;
        }

            .identity-top::after {
                content: '';
                position: absolute;
                bottom: -1px;
                left: 0;
                right: 0;
                height: 20px;
                background: var(--white);
                clip-path: ellipse(55% 100% at 50% 100%);
            }

        .avatar-ring {
            width: 76px;
            height: 76px;
            border-radius: 50%;
            background: rgba(255,255,255,0.15);
            border: 2.5px solid rgba(255,255,255,0.3);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 34px;
            backdrop-filter: blur(8px);
        }

        .identity-name {
            font-family: 'Playfair Display', serif;
            font-size: 16px;
            font-weight: 700;
            color: #fff;
            text-align: center;
            line-height: 1.3;
        }

        .identity-username {
            font-size: 12px;
            color: rgba(255,255,255,0.55);
            text-align: center;
            margin-top: -6px;
        }

        .identity-role-badge {
            display: inline-block;
            background: rgba(244,124,32,0.22);
            color: #ffc56e;
            border: 1px solid rgba(244,124,32,0.4);
            font-size: 10.5px;
            font-weight: 700;
            padding: 3px 12px;
            border-radius: 20px;
            letter-spacing: 0.06em;
            text-transform: uppercase;
        }

        .identity-body {
            padding: 28px 22px 24px;
        }

        .identity-row {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            padding: 9px 0;
            border-bottom: 1px solid var(--off-white);
            font-size: 13px;
            gap: 10px;
        }

            .identity-row:last-child {
                border-bottom: none;
            }

            .identity-row .lbl {
                color: var(--text-muted);
                font-size: 12px;
                white-space: nowrap;
                padding-top: 1px;
            }

            .identity-row .val {
                font-weight: 600;
                color: var(--navy);
                text-align: right;
                font-size: 12.5px;
                word-break: break-word;
            }

        /* Instructor extra info */
        .instructor-section {
            margin-top: 14px;
            padding-top: 14px;
            border-top: 1px dashed var(--border);
        }

        .instructor-section-title {
            font-size: 10px;
            font-weight: 700;
            color: var(--text-muted);
            letter-spacing: 0.07em;
            text-transform: uppercase;
            margin-bottom: 10px;
        }

        /* ─── RIGHT: Password Form ─── */
        .pw-card {
            background: var(--white);
            border: 1px solid var(--border);
            border-radius: 20px;
            box-shadow: var(--shadow-sm);
            padding: 36px 36px 32px;
            animation: fadeUp 0.4s ease 0.1s both;
        }

        .pw-card-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 28px;
        }

        .pw-icon {
            width: 42px;
            height: 42px;
            border-radius: 12px;
            background: linear-gradient(135deg, var(--navy-light), var(--navy-mid));
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            flex-shrink: 0;
        }

        .pw-card-header h2 {
            font-family: 'Outfit', sans-serif;
            font-size: 18px;
            font-weight: 700;
            color: var(--navy);
        }

        .pw-card-header p {
            font-size: 12.5px;
            color: var(--text-muted);
            margin-top: 2px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 6px;
            margin-bottom: 16px;
        }

            .form-group label {
                font-size: 12.5px;
                font-weight: 600;
                color: var(--navy);
                letter-spacing: 0.01em;
            }

        .form-control {
            border: 1.5px solid var(--border);
            border-radius: 9px;
            padding: 10px 14px;
            font-family: 'DM Sans', sans-serif;
            font-size: 13.5px;
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

        .pw-hint {
            font-size: 11.5px;
            color: var(--text-muted);
            margin-bottom: 22px;
            padding: 10px 14px;
            background: var(--off-white);
            border-radius: 8px;
            border-left: 3px solid var(--border);
        }

        .btn-primary, input[type="submit"].btn-primary, button.btn-primary {
            background: linear-gradient(135deg, var(--navy-light), var(--navy-mid));
            color: #fff;
            border: none;
            padding: 11px 28px;
            border-radius: 10px;
            font-family: 'Outfit', sans-serif;
            font-size: 13.5px;
            font-weight: 600;
            cursor: pointer;
            transition: opacity 0.18s, transform 0.18s;
            letter-spacing: 0.02em;
        }

            .btn-primary:hover {
                opacity: 0.88;
                transform: translateY(-1px);
            }

        .msg-success {
            display: flex;
            align-items: center;
            gap: 8px;
            color: #1e7e45;
            font-size: 13px;
            font-weight: 500;
            background: #eafaf1;
            border: 1px solid #a9dfc0;
            border-radius: 8px;
            padding: 10px 14px;
            margin-top: 14px;
        }

            .msg-success::before {
                content: '✔';
                font-weight: 700;
            }

        .msg-error {
            display: flex;
            align-items: center;
            gap: 8px;
            color: var(--pink);
            font-size: 13px;
            font-weight: 500;
            background: var(--pink-pale);
            border: 1px solid #f5c0cf;
            border-radius: 8px;
            padding: 10px 14px;
            margin-top: 14px;
        }

            .msg-error::before {
                content: '✖';
                font-weight: 700;
            }

        /* ─── FOOTER ─── */
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

            .profile-layout {
                grid-template-columns: 1fr;
            }

            .pw-card {
                padding: 24px 20px;
            }
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
                    <asp:Button ID="btnHome" runat="server" Text="Home" CssClass="nav-btn" PostBackUrl="Default.aspx" />
                    <div class="user-bar">
                        <asp:Label ID="lblRoleBadge" runat="server" CssClass="role-badge"></asp:Label>
                        <asp:Button runat="server" Text="Profile" CssClass="nav-btn active" PostBackUrl="Profile.aspx" />
                        <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn-logout" />
                    </div>
                </nav>
            </div>
        </div>

        <!-- ═══ HERO ═══ -->
        <div class="hero">
            <div class="hero-ring"></div>
            <div class="hero-inner">
                <div class="hero-eyebrow">Account Settings</div>
                <h1 class="hero-title">My <span>Profile</span></h1>
                <p class="hero-sub">View your account details and update your password</p>
            </div>
        </div>

        <!-- ═══ MAIN CONTENT ═══ -->
        <div class="main-content">
            <div class="profile-layout">

                <!-- ── LEFT: Identity Card ── -->
                <div class="identity-card">
                    <div class="identity-top">
                        <div class="avatar-ring">&#128100;</div>
                        <div class="identity-name">
                            <asp:Label ID="lblFullName" runat="server" /></div>
                        <div class="identity-username">@<asp:Label ID="lblUsername" runat="server" /></div>
                        <span class="identity-role-badge">
                            <asp:Label ID="lblRole" runat="server" /></span>
                    </div>

                    <div class="identity-body">
                        <div class="identity-row">
                            <span class="lbl">Full Name</span>
                            <span class="val">
                                <asp:Label ID="lblInfoName" runat="server" /></span>
                        </div>
                        <div class="identity-row">
                            <span class="lbl">Username</span>
                            <span class="val">
                                <asp:Label ID="lblInfoUsername" runat="server" /></span>
                        </div>
                        <div class="identity-row">
                            <span class="lbl">Role</span>
                            <span class="val">
                                <asp:Label ID="lblInfoRole" runat="server" /></span>
                        </div>

                        <!-- Instructor-only extra info -->
                        <asp:Panel ID="pnlInstructorInfo" runat="server" Visible="false">
                            <div class="instructor-section">
                                <div class="instructor-section-title">Instructor Details</div>
                                <div class="identity-row">
                                    <span class="lbl">Position</span>
                                    <span class="val">
                                        <asp:Label ID="lblPosition" runat="server" /></span>
                                </div>
                                <div class="identity-row">
                                    <span class="lbl">Qualifications</span>
                                    <span class="val">
                                        <asp:Label ID="lblQualifications" runat="server" /></span>
                                </div>
                                <div class="identity-row">
                                    <span class="lbl">Experience</span>
                                    <span class="val">
                                        <asp:Label ID="lblYears" runat="server" /></span>
                                </div>
                                <div class="identity-row">
                                    <span class="lbl">HEA</span>
                                    <span class="val">
                                        <asp:Label ID="lblHEA" runat="server" /></span>
                                </div>
                            </div>
                        </asp:Panel>
                    </div>
                </div>

                <!-- ── RIGHT: Password Change ── -->
                <div class="pw-card">
                    <div class="pw-card-header">
                        <div class="pw-icon">🔒</div>
                        <div>
                            <h2>Change Password</h2>
                            <p>Keep your account secure with a strong password</p>
                        </div>
                    </div>

                    <p class="pw-hint">Password must be at least 6 characters long.</p>

                    <div class="form-group">
                        <label>Current Password</label>
                        <asp:TextBox ID="txtCurrentPw" runat="server" TextMode="Password" CssClass="form-control" placeholder="Enter your current password" />
                    </div>
                    <div class="form-group">
                        <label>New Password</label>
                        <asp:TextBox ID="txtNewPw" runat="server" TextMode="Password" CssClass="form-control" placeholder="Enter new password" />
                    </div>
                    <div class="form-group">
                        <label>Confirm New Password</label>
                        <asp:TextBox ID="txtConfirmPw" runat="server" TextMode="Password" CssClass="form-control" placeholder="Repeat new password" />
                    </div>

                    <asp:Button ID="btnChangePw" runat="server" Text="Update Password" CssClass="btn-primary" CausesValidation="false" />
                    <asp:Label ID="lblPwMsg" runat="server"></asp:Label>
                </div>

            </div>
        </div>

        <!-- ═══ FOOTER ═══ -->
        <div class="footer">
            <p>Classroom Mapping System &copy; 2026 &nbsp;·&nbsp; Our Lady of the Pillar College—San Manuel Inc.</p>
            <p>Developed by: <span>ME</span></p>
        </div>

    </form>
</body>
</html>
