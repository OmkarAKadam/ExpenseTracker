<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<title>Forgot Password</title>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<style>
    *{margin:0;padding:0;box-sizing:border-box;font-family:'Poppins',sans-serif;}

    body{
        background:linear-gradient(135deg,#0b0e15,#121826,#1a2234);
        height:100vh;display:flex;justify-content:center;align-items:center;color:white;
        animation:fadeIn .5s ease;
    }

    @keyframes fadeIn{from{opacity:0;}to{opacity:1;}}

    .box{
        width:380px;
        background:rgba(255,255,255,.08);
        padding:40px 35px;
        border-radius:20px;
        text-align:center;
        border:1.5px solid rgba(255,255,255,.14);
        backdrop-filter:blur(14px);
        box-shadow:0 0 55px rgba(0,0,0,.55);
        animation:slideUp .45s ease;
    }

    @keyframes slideUp{from{opacity:.4;transform:translateY(25px);}to{opacity:1;}}

    h2{
        font-size:26px;
        font-weight:600;
        margin-bottom:18px;
        color:#4da3ff;
        letter-spacing:.5px;
    }

    p{
        font-size:14px;
        opacity:.8;
        margin-bottom:20px;
    }

    input{
        width:100%;
        height:46px;
        margin-top:10px;
        padding:12px;
        border:none;
        border-radius:10px;
        background:rgba(255,255,255,.15);
        color:white;
        font-size:14px;
        transition:.25s;
    }

    input:focus{
        outline:none;
        background:rgba(255,255,255,.22);
        box-shadow:0 0 0 2px #4da3ff;
    }

    button{
        width:100%;
        padding:12px;
        margin-top:18px;
        border:none;
        border-radius:10px;
        background:linear-gradient(90deg,#4da3ff,#1c86ff);
        color:white;
        font-weight:600;
        font-size:16px;
        cursor:pointer;
        transition:.25s;
    }
    button:hover{
        opacity:.92;
        transform:translateY(-2px);
        box-shadow:0 4px 12px rgba(77,163,255,.35);
    }

    .back{
        margin-top:15px;
        display:block;
        font-size:13px;
        color:#4da3ff;
        text-decoration:none;
        transition:.25s;
    }
    .back:hover{color:#82c2ff;}
</style>
</head>

<body>

<div class="box">
    <h2>Forgot Password?</h2>
    <p>Enter your registered email. We'll send you an OTP to reset it.</p>

    <form action="SendResetOtpServlet" method="post">
        <input type="email" name="email" placeholder="Registered email" required>
        <button type="submit">Send OTP</button>
    </form>

    <a href="login.jsp" class="back">← Back to Login</a>
</div>

</body>
</html>
