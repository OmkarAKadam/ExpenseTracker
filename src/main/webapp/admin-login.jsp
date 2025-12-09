<%@ page contentType="text/html; charset=UTF-8" %>
<html>
<head>
<title>Admin Login - Expense Tracker</title>

<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">

<style>
    *{margin:0;padding:0;box-sizing:border-box;font-family:'Poppins',sans-serif;}

    body{
        height:100vh;
        background:linear-gradient(135deg,#180d0d,#1d1414,#231717);
        display:flex;
        justify-content:center;
        align-items:center;
        color:white;
    }

    .wrapper{
        width:400px;
        background:rgba(255,255,255,.08);
        padding:50px 40px;
        border-radius:18px;
        backdrop-filter:blur(14px);
        border:1.5px solid rgba(255,255,255,.15);
        box-shadow:0 0 50px rgba(0,0,0,.6);
        animation:fade .4s ease;
    }

    @keyframes fade{from{opacity:.4;transform:translateY(15px);}to{opacity:1;}}

    .title{
        text-align:center;
        font-size:30px;
        font-weight:600;
        color:#ff5757;
        letter-spacing:.5px;
    }

    .sub{
        text-align:center;
        font-size:14px;
        opacity:.8;
        margin-top:6px;margin-bottom:22px;
    }

    .divider{
        height:1px;width:100%;
        background:rgba(255,255,255,.15);
        margin-bottom:25px;
    }

    label{
        font-size:14px;font-weight:500;
        margin-bottom:6px;
        display:block;
        margin-top:15px;
    }

    input{
        width:100%;height:46px;
        background:rgba(255,255,255,.12);
        border:none;border-radius:8px;
        padding:0 12px;color:white;
        font-size:14px;margin-bottom:14px;
        transition:.25s;
    }
    input::placeholder{color:#d7d7d7;}
    input:focus{
        background:rgba(255,255,255,.18);
        box-shadow:0 0 0 2px #ff5757;
        outline:none;
    }

    button{
        width:100%;height:48px;
        margin-top:20px;
        background:linear-gradient(90deg,#ff4f4f,#ff2d2d);
        border:none;border-radius:8px;
        font-size:16px;
        font-weight:600;color:white;
        cursor:pointer;
        transition:.3s;
    }
    button:hover{
        opacity:.9;
        transform:translateY(-2px);
    }

    .links{text-align:center;margin-top:22px;font-size:13px;}
    .links a{
        text-decoration:none;
        color:#ff5757;
        transition:.2s;
    }
    .links a:hover{color:#ff8888;}
</style>
</head>

<body>

<div class="wrapper">

    <div class="title">Admin Login</div>
    <div class="sub">Restricted system access</div>

    <div class="divider"></div>

    <form action="AdminLoginServlet" method="post">

        <label>Email</label>
        <input type="email" name="email" placeholder="admin@example.com" required>

        <label>Password</label>
        <input type="password" name="password" placeholder="••••••••" required>

        <button type="submit">Access Admin Panel</button>

        <div class="links">
            <a href="login.jsp">← User Login</a>
        </div>
    </form>

</div>

</body>
</html>
