<%@ page contentType="text/html; charset=UTF-8" %>
<%
    String email = (String)session.getAttribute("resetEmail");
    if(email==null){ response.sendRedirect("forgot-password.jsp"); return; }
    String status=request.getParameter("status");
%>

<html>
<head>
<title>Verify Reset OTP</title>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<style>
    body{
        background:#0b0e15;height:100vh;display:flex;justify-content:center;align-items:center;
        font-family:'Poppins',sans-serif;color:white;
    }
    .box{background:rgba(255,255,255,.08);padding:35px;border-radius:15px;width:360px;text-align:center;}
    input{width:100%;padding:12px;border-radius:8px;margin:12px 0;border:none;background:rgba(255,255,255,.15);color:white;}
    button{width:100%;padding:10px;border:none;border-radius:8px;background:#4da3ff;font-size:16px;font-weight:600;}
</style>
</head>
<body>

<div class="box">
    <h2>Verify OTP</h2>
    <p>OTP sent to <b><%=email%></b></p>

    <form action="ResetPasswordServlet" method="post">
        <input type="text" name="otp" maxlength="6" placeholder="Enter OTP" required>
        <button type="submit">Verify OTP</button>
    </form>
</div>

<script>
    let s = "<%=status%>";
    if(s==="sent") Swal.fire("OTP sent","Check your email","success");
    if(s==="wrong") Swal.fire("Wrong OTP","Try again","error");
</script>

</body>
</html>
