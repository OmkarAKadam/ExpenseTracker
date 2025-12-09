<%@ page contentType="text/html; charset=UTF-8" %>
<%
    String status = request.getParameter("status");
%>
<html>
<head>
    <title>Expense Tracker - Register</title>

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
        font-size:28px;
        font-weight:600;
        color:#4da3ff;
    }

    .sub{
        text-align:center;
        font-size:14px;
        font-weight:300;
        opacity:.85;
        margin-top:6px;
        margin-bottom:22px;
    }

    .divider{
        width:100%;
        height:1px;
        background:rgba(255,255,255,.15);
        margin:15px 0 22px;
    }

    label{
        font-weight:500;
        font-size:14px;
        margin-bottom:6px;
        display:block;
    }

    input{
        width:100%;
        height:45px;
        background:rgba(255,255,255,.12);
        border:none;
        color:white;
        border-radius:8px;
        padding:0 12px;
        margin-bottom:16px;
        transition:.25s;font-size:14px;
    }
    input:focus{
        background:rgba(255,255,255,.18);
        outline:none;
        box-shadow:0 0 0 2px #4da3ff;
    }
    input::placeholder{color:#cfcfcf;}

    button{
        width:100%;
        padding:12px;
        margin-top:10px;
        border:none;
        border-radius:8px;
        font-size:16px;
        font-weight:600;
        background:linear-gradient(90deg,#4da3ff,#1c86ff);
        color:white;
        cursor:pointer;
        transition:.25s;
    }
    button:hover{opacity:.9;transform:translateY(-2px);}

    .links{
        text-align:center;
        margin-top:22px;
        font-size:13px;
    }

    .links a{
        color:#4da3ff;
        text-decoration:none;
        margin-left:4px;
        transition:.2s;
    }
    .links a:hover{color:#82c2ff;}
</style>
</head>

<body>

<div class="wrapper">

    <div class="title">Create Account</div>
    <div class="sub">Join now & track your expenses smartly</div>

    <div class="divider"></div>

    <form action="RegisterServlet" method="post">

        <label>Name</label>
        <input type="text" name="name" placeholder="Your full name" required>

        <label>Email</label>
        <input type="email" name="email" placeholder="you@example.com" required>

        <label>Password</label>
        <input type="password" name="password" placeholder="Create strong password" required>

        <button type="submit">Register</button>

        <div class="links">
            Already have an account?
            <a href="login.jsp">Sign In</a>
        </div>

    </form>

</div>

<script>
document.addEventListener("DOMContentLoaded", ()=>{

    const status = "<%= status == null ? "" : status %>";

    if(status === "exists"){
        Swal.fire({
            icon:"warning",
            title:"Email Already Registered!",
            text:"Try logging in instead.",
            confirmButtonColor:"#ffcc00"
        });
    }

    if(status === "sent"){
        Swal.fire({
            icon:"success",
            title:"OTP Sent!",
            text:"Check your email to verify.",
            confirmButtonColor:"#4da3ff"
        });
    }

    if(status === "error"){
        Swal.fire({
            icon:"error",
            title:"Something Went Wrong!",
            text:"Please try again later.",
            confirmButtonColor:"#ff4d4d"
        });
    }

});
</script>

</body>
</html>
