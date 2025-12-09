<%@ page contentType="text/html; charset=UTF-8" %>
<%
    if(session.getAttribute("allowReset")==null){
        response.sendRedirect("forgot-password.jsp");
        return;
    }
%>

<html>
<head>
<title>Create New Password</title>
<style>
    body{background:#0b0e15;height:100vh;display:flex;justify-content:center;align-items:center;color:white;font-family:'Poppins';}
    .box{background:rgba(255,255,255,.1);padding:35px;border-radius:14px;width:360px;text-align:center;}
    input{width:100%;padding:12px;margin:12px 0;border:none;border-radius:8px;background:rgba(255,255,255,.2);color:white;}
    button{width:100%;padding:12px;background:#4da3ff;border:none;border-radius:8px;font-size:15px;font-weight:600;}
</style>
</head>
<body>

<div class="box">
    <h3>Create New Password</h3>
    <form action="UpdatePasswordServlet" method="post">
        <input type="password" name="pass" placeholder="New password" required>
        <button type="submit" style="color: white">Update Password</button>
    </form>
</div>

</body>
</html>
