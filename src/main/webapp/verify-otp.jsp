<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
    HttpSession s = request.getSession();
    String email = (String) s.getAttribute("email");
    if(email == null){
        response.sendRedirect("register.jsp");
        return;
    }

    String status = request.getParameter("status"); // read from servlet redirect
%>

<html>
<head>
<title>Verify OTP</title>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">

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
        padding:45px 40px;
        border-radius:18px;
        backdrop-filter:blur(12px);
        border:1.5px solid rgba(255,255,255,.12);
        box-shadow:0 0 50px rgba(0,0,0,.55);
        animation:fade .4s ease;
        text-align:center;
    }

    @keyframes fade{from{opacity:.3;transform:translateY(15px);}to{opacity:1;}}

    h2{font-size:26px;font-weight:600;color:#4da3ff;margin-bottom:10px;}

    .email-text{
        font-size:14px;opacity:.8;margin-bottom:20px;
    }
    .email-text span{color:#4da3ff;font-weight:500;}

    input{
        width:100%;height:45px;background:rgba(255,255,255,.12);border:none;color:white;
        border-radius:8px;padding:0 12px;margin-bottom:18px;font-size:15px;
    }
    input:focus{background:rgba(255,255,255,.18);outline:none;box-shadow:0 0 0 2px #4da3ff;}

    button{
        width:100%;padding:12px;border:none;font-size:16px;font-weight:600;
        border-radius:8px;background:linear-gradient(90deg,#4da3ff,#1c86ff);
        color:white;cursor:pointer;transition:.25s;margin-bottom:10px;
    }
    button:hover{opacity:.9;transform:translateY(-2px);}

    .links{
        margin-top:12px;font-size:13px;color:#ddd;
    }
    .links a{color:#4da3ff;text-decoration:none;font-weight:500;}
    .links a:hover{color:#82c2ff;}
</style>
</head>

<body>

<div class="wrapper">

    <h2>Verify OTP</h2>
    <p class="email-text">OTP sent to <span><%=email%></span></p>

    <form action="VerifyOtpServlet" method="post">
        <input type="text" name="otp" maxlength="6" placeholder="Enter 6-digit OTP" required>
        <button type="submit">Verify</button>
    </form>

    <div class="links">
        Didn’t receive? <a href="ResendOtpServlet">Resend OTP</a><br>
        <a href="forgot-password.jsp">Forgot Password?</a>
    </div>

</div>


<script>
document.addEventListener("DOMContentLoaded", () => {
    const status = "<%=status==null?"":status%>";

    if(status === "invalid") {
        Swal.fire({icon:"error",title:"Invalid OTP",text:"Try again"});
    }
    if(status === "sent") {
        Swal.fire({icon:"success",title:"OTP Sent",text:"Check your email"});
    }
    if(status === "done") {
        Swal.fire({icon:"success",title:"Verified!",text:"Redirecting..."});
        setTimeout(()=>{ window.location="login.jsp"; },900);
    }
});
</script>

</body>
</html>
