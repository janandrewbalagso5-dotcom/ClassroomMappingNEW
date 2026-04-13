<%@ Page Language="VB" AutoEventWireup="false" CodeFile="AccessDenied.aspx.vb" Inherits="AccessDenied" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Access Denied</title>
    <link rel="stylesheet" type="text/css" href="styles/style.css" />
    <style>
        body { background:#eef2f7; display:flex; align-items:center; justify-content:center; min-height:100vh; margin:0; }
        .denied-box { background:#fff; border-radius:12px; box-shadow:0 4px 24px rgba(0,0,0,0.12);
                      padding:48px; text-align:center; max-width:420px; }
        .denied-box .icon { font-size:56px; margin-bottom:16px; }
        .denied-box h2   { color:#c0392b; margin-bottom:8px; }
        .denied-box p    { color:#666; margin-bottom:24px; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="denied-box">
            <div class="icon">&#128683;</div>
            <h2>Access Denied</h2>
            <p>You do not have permission to view this page.</p>
            <asp:Button ID="btnHome" runat="server" Text="Go to Home" CssClass="btn-primary" />
        </div>
    </form>
</body>
</html>
