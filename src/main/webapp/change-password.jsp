<%@ page contentType="text/html; charset=UTF-8" %>
<%
    if(session.getAttribute("userId") == null){
        response.sendRedirect("login.jsp");
        return;
    }
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html>
<head>
<title>Change Password</title>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<style>
*{margin:0;padding:0;box-sizing:border-box;font-family:'Poppins',sans-serif;}
body{
    background:linear-gradient(135deg,#0b0e15,#121826,#1a2234);
    height:100vh;display:flex;justify-content:center;align-items:center;color:white;
}

.card{
    width:390px;background:rgba(255,255,255,.08);
    padding:40px 35px;border-radius:18px;backdrop-filter:blur(12px);
    border:1.5px solid rgba(255,255,255,.12);box-shadow:0 0 50px rgba(0,0,0,.55);
}

h2{text-align:center;color:#4da3ff;margin-bottom:25px;}

input{
    width:100%;padding:12px;margin-top:12px;border:none;border-radius:8px;
    background:rgba(255,255,255,.12);color:white;font-size:14px;
}
input:focus{background:rgba(255,255,255,.18);outline:none;box-shadow:0 0 0 2px #4da3ff;}

button{
    width:100%;padding:12px;margin-top:18px;border:none;border-radius:8px;
    background:#1c86ff;color:white;font-size:16px;font-weight:600;cursor:pointer;
}
button:hover{background:#4da3ff;}

.back{text-align:center;margin-top:14px;}
.back a{color:#4da3ff;text-decoration:none;}
.back a:hover{color:#82c2ff;}
</style>
</head>

<body>

<div class="card">
    <h2>Change Password</h2>

    <form method="post" action="ChangePasswordServlet">
        <input type="password" name="current" placeholder="Current Password" required>
        <input type="password" name="newpass" placeholder="New Password" required>
        <input type="password" name="confirm" placeholder="Confirm Password" required>

        <button type="submit">Update Password</button>
    </form>

    <div class="back"><a href="ProfileServlet">← Back to Profile</a></div>
</div>

<script>
const msg = "<%= msg==null?"":msg %>";

if(msg==="wrong")
Swal.fire("Incorrect Password","Try again.","error");

if(msg==="mismatch")
Swal.fire("Passwords don't match","Check new password.","warning");

if(msg==="success")
Swal.fire("Password Updated","Login again for security.","success");
</script>

</body>
</html>
