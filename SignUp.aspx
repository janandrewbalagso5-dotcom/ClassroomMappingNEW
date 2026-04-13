<%@ Page Language="VB" AutoEventWireup="false" CodeFile="SignUp.aspx.vb" Inherits="SignUp" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Sign Up - Classroom Mapping System</title>
    <link rel="stylesheet" type="text/css" href="styles/style.css" />
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800&family=Poppins:wght@400;600;700&display=swap" rel="stylesheet" />
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
            --orange: #f4df20;
            --orange-pale: #f3ea72;
            --pink: #e8487a;
            --pink-pale: #fce4ed;
            --text-muted: #7a8bb5;
            --border: #dce3f5;
            --shadow-card: 0 32px 80px rgba(13,31,76,0.22), 0 8px 24px rgba(13,31,76,0.12);
        }

        html, body {
            min-height: 100%;
            font-family: 'DM Sans', sans-serif;
            overflow-x: hidden;
        }

        .page {
            min-height: 100vh;
            width: 100%;
            background: linear-gradient(to bottom, var(--navy) 0%, var(--navy-mid) 18%, #2a3f80 35%, #6878b0 50%, #b8c2df 59%, #e2e7f4 64%, var(--navy-light) 100%, var(--navy) 80%);
            display: flex;
            flex-direction: column;
            align-items: center;
            position: relative;
            overflow: hidden;
            padding-bottom: 48px;
        }

        .blob {
            position: absolute;
            border-radius: 50%;
            pointer-events: none;
        }

        .blob-1 {
            width: 600px;
            height: 600px;
            background: radial-gradient(circle, rgba(244,124,32,0.12) 0%, transparent 65%);
            top: -100px;
            left: -160px;
        }

        .blob-2 {
            width: 480px;
            height: 480px;
            background: radial-gradient(circle, rgba(232,72,122,0.1) 0%, transparent 65%);
            top: 60px;
            right: -140px;
        }

        .blob-3 {
            width: 400px;
            height: 400px;
            background: radial-gradient(circle, rgba(30,50,120,0.06) 0%, transparent 65%);
            bottom: -80px;
            left: 50%;
            transform: translateX(-50%);
        }

        .ring {
            position: absolute;
            border-radius: 50%;
            border: 1.5px solid rgba(255,255,255,0.08);
            pointer-events: none;
        }

        .ring-1 {
            width: 700px;
            height: 700px;
            top: -280px;
            left: -200px;
        }

        .ring-2 {
            width: 460px;
            height: 460px;
            top: -80px;
            right: -180px;
        }

        .topbar {
            width: 100%;
            max-width: 1100px;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 16px;
            padding: 44px 40px 0;
            position: relative;
            z-index: 10;
            animation: fadeDown 0.5s ease both;
        }

        .school-logo {
            width: 96px;
            height: 96px;
            border-radius: 50%;
            object-fit: cover;
            border: 3.5px solid rgba(255,255,255,0.45);
            box-shadow: 0 8px 32px rgba(0,0,0,0.28);
        }

        .school-name {
            font-family: 'Playfair Display', serif;
            font-size: 18px;
            color: rgba(255,255,255,0.95);
            line-height: 1.45;
            text-align: center;
            max-width: 360px;
            font-weight: 600;
        }

        .hero-block {
            text-align: center;
            margin-top: 36px;
            margin-bottom: 28px;
            position: relative;
            z-index: 10;
            animation: fadeDown 0.5s 0.08s ease both;
            opacity: 0;
        }

        .hero-title {
            font-family: 'Playfair Display', serif;
            font-size: clamp(26px, 3.8vw, 42px);
            color: #fff;
            line-height: 1.18;
            margin-bottom: 10px;
        }

            .hero-title em {
                font-style: normal;
                color: var(--pink);
            }

        .hero-sub {
            font-size: 14px;
            color: rgba(255,255,255,0.55);
            font-weight: 300;
        }

        .signup-card {
            background: rgba(255,255,255,0.92);
            backdrop-filter: blur(18px);
            -webkit-backdrop-filter: blur(18px);
            border: 1px solid rgba(255,255,255,0.7);
            border-radius: 24px;
            box-shadow: var(--shadow-card);
            padding: 44px 52px 42px;
            width: 100%;
            max-width: 680px;
            position: relative;
            z-index: 10;
            animation: fadeUp 0.5s 0.18s ease both;
            opacity: 0;
        }

        .card-header {
            margin-bottom: 28px;
        }

            .card-header h1 {
                font-family: 'Playfair Display', serif;
                font-size: 26px;
                color: var(--navy);
                font-weight: 700;
                margin-bottom: 5px;
            }

            .card-header p {
                font-size: 13px;
                color: var(--text-muted);
                font-weight: 300;
            }

        /* Student-only notice banner */
        .student-only-notice {
            display: flex;
            align-items: center;
            gap: 10px;
            background: var(--orange-pale);
            color: #7a4010;
            border-left: 3.5px solid var(--orange);
            border-radius: 10px;
            padding: 11px 15px;
            font-size: 12.5px;
            line-height: 1.5;
            margin-bottom: 22px;
        }

            .student-only-notice strong {
                color: #5a2e00;
            }

        .section-divider {
            display: flex;
            align-items: center;
            gap: 12px;
            margin: 22px 0 14px;
        }

            .section-divider:first-of-type {
                margin-top: 0;
            }

        .sd-label {
            font-size: 10.5px;
            font-weight: 600;
            color: var(--navy-light);
            letter-spacing: 0.09em;
            text-transform: uppercase;
            white-space: nowrap;
        }

        .sd-line {
            flex: 1;
            height: 1.5px;
            background: var(--border);
        }

        .sd-dot {
            width: 7px;
            height: 7px;
            border-radius: 50%;
            flex-shrink: 0;
        }

            .sd-dot.orange {
                background: var(--orange);
            }

        .form-cols {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 0 20px;
        }

        .form-cols-inner {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 0 20px;
        }

        .form-group.full {
            grid-column: 1 / -1;
        }

        .form-group {
            margin-bottom: 14px;
        }

            .form-group label {
                display: block;
                font-size: 10.5px;
                font-weight: 600;
                color: var(--navy);
                letter-spacing: 0.07em;
                text-transform: uppercase;
                margin-bottom: 7px;
            }

        .input-wrap {
            position: relative;
        }

        .input-icon {
            position: absolute;
            left: 13px;
            top: 50%;
            transform: translateY(-50%);
            pointer-events: none;
            opacity: 0.3;
            transition: opacity 0.2s;
        }

        .input-wrap:focus-within .input-icon {
            opacity: 1;
        }

            .input-wrap:focus-within .input-icon svg {
                stroke: var(--navy-light);
            }

        .signup-card input[type=text],
        .signup-card input[type=password],
        .form-control,
        .signup-card select {
            width: 100%;
            padding: 11px 13px 11px 32px;
            border: 1.5px solid var(--border);
            border-radius: 10px;
            font-size: 13px;
            font-family: 'DM Sans', sans-serif;
            background: var(--off-white);
            color: var(--navy);
            transition: border-color 0.2s, box-shadow 0.2s, background 0.2s;
            appearance: none;
            -webkit-appearance: none;
            outline: none;
        }

            .signup-card input[type=text]:focus,
            .signup-card input[type=password]:focus,
            .form-control:focus,
            .signup-card select:focus {
                border-color: var(--navy-light);
                background: var(--white);
                box-shadow: 0 0 0 3.5px rgba(30,50,120,0.09);
            }

        .no-icon {
            padding-left: 13px !important;
        }

        .toggle-pw {
            position: absolute;
            right: 13px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            cursor: pointer;
            padding: 0;
            color: var(--text-muted);
            display: flex;
            align-items: center;
            transition: color 0.2s;
        }

            .toggle-pw:hover {
                color: var(--navy);
            }

        .val-error {
            display: block;
            color: var(--pink);
            font-size: 11.5px;
            margin-top: 4px;
            font-weight: 500;
        }

        .btn-signup, input[type="submit"].btn-signup {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, var(--navy-light), var(--navy));
            color: #fff;
            border: none;
            border-radius: 11px;
            font-size: 14px;
            font-family: 'DM Sans', sans-serif;
            font-weight: 600;
            letter-spacing: 0.04em;
            cursor: pointer;
            margin-top: 24px;
            position: relative;
            overflow: hidden;
            transition: box-shadow 0.22s, transform 0.14s;
        }

            .btn-signup:hover {
                box-shadow: 0 10px 32px rgba(13,31,76,0.28);
                transform: translateY(-2px);
            }

            .btn-signup:active {
                transform: translateY(0);
            }

        .msg-error {
            display: block;
            background: #fff0f3;
            color: #c0274e;
            border: 1px solid #f7b8cb;
            border-radius: 9px;
            padding: 10px 14px;
            font-size: 13px;
            text-align: center;
            margin-top: 14px;
        }

        .msg-success {
            display: block;
            background: #edfbf6;
            color: #0f7a55;
            border: 1px solid #9de8cb;
            border-radius: 9px;
            padding: 10px 14px;
            font-size: 13px;
            text-align: center;
            margin-top: 14px;
        }

        .divider {
            display: flex;
            align-items: center;
            gap: 12px;
            margin: 22px 0 16px;
            font-size: 12px;
            color: var(--text-muted);
        }

            .divider::before, .divider::after {
                content: '';
                flex: 1;
                height: 1px;
                background: var(--border);
            }

        .signin-row {
            text-align: center;
            font-size: 13px;
            color: var(--text-muted);
        }

            .signin-row a {
                color: var(--navy-light);
                font-weight: 600;
                text-decoration: none;
                border-bottom: 1.5px solid transparent;
                transition: border-color 0.18s, color 0.18s;
            }

                .signin-row a:hover {
                    color: var(--pink);
                    border-color: var(--pink);
                }

        .page-footer {
            font-size: 11.5px;
            color: rgba(13,31,76,1.5);
            text-align: center;
            padding: 20px 20px 0;
            position: relative;
            z-index: 10;
        }

        @keyframes fadeDown {
            from {
                opacity: 0;
                transform: translateY(-16px);
            }

            to {
                opacity: 1;
                transform: translateY(0);
            }
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

        @media (max-width: 720px) {
            .signup-card {
                padding: 32px 22px 28px;
            }

            .form-cols, .form-cols-inner {
                grid-template-columns: 1fr;
            }

            .hero-title {
                font-size: 26px;
            }

            .topbar {
                padding: 24px 20px 0;
            }
        }
    </style>
    <script type="text/javascript">
        // Auto-format Student ID as ###-##-#### (e.g. 231-08-0007)
        function formatStudentID(input) {
            // Strip everything except digits
            var digits = input.value.replace(/\D/g, '');

            // Insert dashes at positions 3 and 5
            var formatted = '';
            if (digits.length <= 3) {
                formatted = digits;
            } else if (digits.length <= 5) {
                formatted = digits.slice(0, 3) + '-' + digits.slice(3);
            } else {
                formatted = digits.slice(0, 3) + '-' + digits.slice(3, 5) + '-' + digits.slice(5, 9);
            }

            input.value = formatted;
        }

        function togglePw(inputId, iconId) {
            var input = document.getElementById(inputId);
            var icon = document.getElementById(iconId);
            if (!input) return;
            if (input.type === 'password') {
                input.type = 'text';
                icon.innerHTML =
                    '<path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94"/>' +
                    '<path d="M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19"/>' +
                    '<line x1="1" y1="1" x2="23" y2="23"/>';
            } else {
                input.type = 'password';
                icon.innerHTML =
                    '<path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>';
            }
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="page">
            <div class="blob blob-1"></div>
            <div class="blob blob-2"></div>
            <div class="blob blob-3"></div>
            <div class="ring ring-1"></div>
            <div class="ring ring-2"></div>

            <div class="topbar">
                <img src="styles/logo.png" alt="OLPC Logo" class="school-logo" />
                <span class="school-name">Our Lady of the Pillar College—San Manuel Inc.</span>
            </div>

            <div class="hero-block">
                <h class="hero-title">Join the <em>Classroom</em> Community</h>
                <p class="hero-sub">Academic Information System</p>
            </div>

            <div class="signup-card">

                <div class="card-header">
                    <h1>Create account</h1>
                    <p>Register for the Classroom Mapping System</p>
                </div>

                <%-- Hidden — always "Student" --%>
                <asp:HiddenField ID="hdnRole" runat="server" Value="Student" />

                <!-- Account Information -->
                <div class="section-divider">
                    <span class="sd-label">Account Information</span>
                    <span class="sd-line"></span>
                </div>

                <div class="form-cols">
                    <div class="form-group">
                        <label>Full Name</label>
                        <div class="input-wrap">
                            <span class="input-icon">
                                <svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#0d1f4c" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
                                    <circle cx="12" cy="7" r="4" />
                                </svg>
                            </span>
                            <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control" placeholder="e.g. Michael Jackson" />
                        </div>
                        <asp:RequiredFieldValidator ControlToValidate="txtFullName" runat="server" ErrorMessage="Full name is required." CssClass="val-error" />
                    </div>

                    <div class="form-group">
                        <label>Username</label>
                        <div class="input-wrap">
                            <span class="input-icon">
                                <svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#0d1f4c" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
                                    <circle cx="12" cy="7" r="4" />
                                </svg>
                            </span>
                            <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="Choose a username" />
                        </div>
                        <asp:RequiredFieldValidator ControlToValidate="txtUsername" runat="server" ErrorMessage="Username is required." CssClass="val-error" />
                    </div>

                    <div class="form-group">
                        <label>Password</label>
                        <div class="input-wrap">
                            <span class="input-icon">
                                <svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#0d1f4c" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <rect x="3" y="11" width="18" height="11" rx="2" ry="2" />
                                    <path d="M7 11V7a5 5 0 0 1 10 0v4" />
                                </svg>
                            </span>
                            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="At least 6 characters" />
                            <button type="button" class="toggle-pw" onclick="togglePw('<%= txtPassword.ClientID %>','eyePw1')">
                                <svg id="eyePw1" xmlns="http://www.w3.org/2000/svg" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z" />
                                    <circle cx="12" cy="12" r="3" />
                                </svg>
                            </button>
                        </div>
                        <asp:RequiredFieldValidator ControlToValidate="txtPassword" runat="server" ErrorMessage="Password is required." CssClass="val-error" />
                    </div>

                    <div class="form-group">
                        <label>Confirm Password</label>
                        <div class="input-wrap">
                            <span class="input-icon">
                                <svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#0d1f4c" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <rect x="3" y="11" width="18" height="11" rx="2" ry="2" />
                                    <path d="M7 11V7a5 5 0 0 1 10 0v4" />
                                </svg>
                            </span>
                            <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Re-enter password" />
                            <button type="button" class="toggle-pw" onclick="togglePw('<%= txtConfirmPassword.ClientID %>','eyePw2')">
                                <svg id="eyePw2" xmlns="http://www.w3.org/2000/svg" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z" />
                                    <circle cx="12" cy="12" r="3" />
                                </svg>
                            </button>
                        </div>
                        <asp:RequiredFieldValidator ControlToValidate="txtConfirmPassword" runat="server" ErrorMessage="Please confirm your password." CssClass="val-error" />
                    </div>
                </div>

                <div class="form-group">
                    <label>Email (Optional)</label>
                    <div class="input-wrap">
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="e.g. juan@email.com" />
                    </div>
                </div>

                <div class="form-group">
                    <label>Phone (Optional)</label>
                    <div class="input-wrap">
                        <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" placeholder="e.g. 09xxxxxxxxx" />
                    </div>
                </div>

                <!-- Student Details -->
                <div class="section-divider">
                    <span class="sd-dot orange"></span>
                    <span class="sd-label">Student Details</span>
                    <span class="sd-line"></span>
                </div>

                <div class="form-cols-inner">
                    <div class="form-group">
                        <label>Student ID</label>
                        <div class="input-wrap">
                            <asp:TextBox ID="txtStudentID" runat="server" CssClass="form-control" placeholder="e.g. 231-08-0007"
                                oninput="formatStudentID(this)" MaxLength="11" />
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Course / Program</label>
                        <div class="input-wrap">
                            <asp:DropDownList ID="ddlStudentCourse" runat="server" CssClass="form-control">
                                <asp:ListItem Value="">-- Select Course --</asp:ListItem>
                                <asp:ListItem Value="BSEd-English">BSEd — Major in English</asp:ListItem>
                                <asp:ListItem Value="BSEd-Filipino">BSEd — Major in Filipino</asp:ListItem>
                                <asp:ListItem Value="BSEd-Mathematics">BSEd — Major in Mathematics</asp:ListItem>
                                <asp:ListItem Value="BSEd-Science">BSEd — Major in Science</asp:ListItem>
                                <asp:ListItem Value="BSA">BS Accountancy</asp:ListItem>
                                <asp:ListItem Value="FM">BSBA — Financial Management</asp:ListItem>
                                <asp:ListItem Value="BSBAMM">BSBA — Marketing Management</asp:ListItem>
                                <asp:ListItem Value="BSCrim">BS Criminology</asp:ListItem>
                                <asp:ListItem Value="BEEd">BEEd</asp:ListItem>
                                <asp:ListItem Value="BSHM">BS Hospitality Management</asp:ListItem>
                                <asp:ListItem Value="BSIT">BS Information Technology</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Year Level</label>
                        <div class="input-wrap">
                            <asp:DropDownList ID="ddlYearLevel" runat="server" CssClass="form-control">
                                <asp:ListItem Value="">-- Select Year Level --</asp:ListItem>
                                <asp:ListItem Value="1">1st Year</asp:ListItem>
                                <asp:ListItem Value="2">2nd Year</asp:ListItem>
                                <asp:ListItem Value="3">3rd Year</asp:ListItem>
                                <asp:ListItem Value="4">4th Year</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Section</label>
                        <div class="input-wrap">
                            <asp:DropDownList ID="ddlStudentSection" runat="server" CssClass="form-control">
                                <asp:ListItem Value="">-- Select Section --</asp:ListItem>
                                <asp:ListItem Value="A">A</asp:ListItem>
                                <asp:ListItem Value="B">B</asp:ListItem>
                                <asp:ListItem Value="C">C</asp:ListItem>
                                <asp:ListItem Value="D">D</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                </div>

                <asp:Button ID="btnSignUp" runat="server" Text="Create Account →" CssClass="btn-signup" />
                <asp:Label ID="lblMsg" runat="server" Visible="false"></asp:Label>

                <div class="divider">or</div>
                <div class="signin-row">
                    Already have an account? <a href="Login.aspx">Sign in here</a>
                </div>

            </div>

            <div class="page-footer">
                Classroom Mapping System &copy; 2026 &nbsp;·&nbsp; Our Lady of the Pillar College — San Manuel Inc.
            </div>

        </div>
    </form>
</body>
</html>
