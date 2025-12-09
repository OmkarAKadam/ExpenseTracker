<%@ page contentType="text/html; charset=UTF-8" %>
<%
    String status = request.getParameter("status");
%>
<html>
<head>
    <title>Expense Tracker - Login</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<style>
    *{margin:0;padding:0;box-sizing:border-box;font-family:'Poppins',sans-serif;}

    body{
        height:100vh;
        background:linear-gradient(135deg,#0b0e15,#121826,#1a2234);
        display:flex;
        justify-content:center;
        align-items:center;
        color:white;
    }

    .wrapper{
        width:390px;
        background:rgba(255,255,255,.08);
        padding:50px 40px;
        border-radius:18px;
        backdrop-filter:blur(12px);
        border:1.5px solid rgba(255,255,255,.12);
        box-shadow:0 0 50px rgba(0,0,0,.55);
        animation:fade .4s ease;
    }

    @keyframes fade{from{opacity:.3;transform:translateY(15px);}to{opacity:1;}}

    .title{
        text-align:center;
        font-size:30px;
        font-weight:600;
        color:#4da3ff;
        letter-spacing:.5px;
    }

    .sub{
        text-align:center;
        font-size:14px;
        font-weight:300;
        margin-top:6px;
        opacity:.85;
        margin-bottom:22px;
    }

    .divider{
        width:100%;
        height:1px;
        background:rgba(255,255,255,.15);
        margin:15px 0 20px;
    }

    label{
        font-size:14px;
        font-weight:500;
        margin-top:15px;
        display:block;
    }

    input{
        width:100%;height:45px;
        margin-top:8px;
        background:rgba(255,255,255,.12);
        border:none;border-radius:8px;
        color:white;font-size:14px;padding:0 12px;
        transition:.25s;
    }
    input::placeholder{color:#c7c7c7;}
    input:focus{
        background:rgba(255,255,255,.18);
        box-shadow:0 0 0 2px #4da3ff;
        outline:none;
    }

    button{
        width:100%;margin-top:28px;height:48px;
        background:linear-gradient(90deg,#4da3ff,#1c86ff);
        border:none;border-radius:8px;
        font-size:17px;font-weight:600;
        color:white;cursor:pointer;
        transition:.25s;
    }
    button:hover{
        transform:translateY(-2px);
        opacity:.92;
    }

    .links{
        text-align:center;margin-top:20px;
    }
    .links a{
        color:#4da3ff;text-decoration:none;font-size:13px;
        margin:6px;transition:.2s;font-weight:400;
    }
    .links a:hover{color:#82c2ff;}

    .footer{
        text-align:center;margin-top:28px;
        font-size:11px;opacity:.5;
        letter-spacing:.4px;
    }
</style>
</head>

<body>

<div class="wrapper">

    <div class="title">Expense Tracker</div>
    <div class="sub">Sign in to manage your spending</div>

    <div class="divider"></div>

    <form action="LoginServlet" method="post">

        <label>Email Address</label>
        <input type="email" name="email" placeholder="you@example.com" required>

        <label>Password</label>
        <input type="password" name="password" placeholder="••••••••" required>
        <div style="text-align:right;margin-top:8px;">
            <a href="forgot-password.jsp" style="color:#4da3ff;font-size:13px;text-decoration:none;">Forgot Password?</a>
        </div>
        <button type="submit">Sign In</button>

        <div class="links">
            <p>Don't have an account? <a href="register.jsp">Create one</a></p>
            <p>Admin? <a href="admin-login.jsp">Sign in here</a></p>
        </div>
    </form>

    <div class="footer">v1.0 • Secure Login</div>
</div>


<script>
document.addEventListener("DOMContentLoaded", () => {
    const status = "<%= status == null ? "" : status %>";

    if(status === "registered"){
        Swal.fire({
            icon: "success",
            title: "Registration Successful!",
            text: "Login to continue",
            confirmButtonColor: "#4da3ff"
        });
    }

    if(status === "reset-done"){
        Swal.fire({
            icon: "success",
            title: "Password Reset Successfully!",
            text: "You can now sign in",
            confirmButtonColor: "#4da3ff"
        });
    }

    if(status === "invalid"){
        Swal.fire({
            icon: "error",
            title: "Invalid Login",
            text: "Wrong email or password",
            confirmButtonColor: "#ff4d4d"
        });
    }
});
</script>

</body>
</html>
