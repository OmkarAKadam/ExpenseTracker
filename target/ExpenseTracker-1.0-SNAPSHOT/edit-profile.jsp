<%@ page contentType="text/html; charset=UTF-8" %>
<%
    if(session.getAttribute("userId") == null){
        response.sendRedirect("login.jsp");
        return;
    }

    String photo = (String) request.getAttribute("photo");
    if(photo == null || photo.trim().isEmpty()) photo = "default.png";
%>

<!DOCTYPE html>
<html>
<head>
<title>Edit Profile</title>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">

<style>
body{
    background:linear-gradient(135deg,#0b0e15,#121826,#1a2234);
    height:100vh;
    display:flex;justify-content:center;align-items:center;color:white;
}
.card{
    width:420px;padding:35px;border-radius:18px;
    background:rgba(255,255,255,.08);backdrop-filter:blur(12px);
    border:1.4px solid rgba(255,255,255,.15);
    box-shadow:0 0 50px rgba(0,0,0,.55);
}
h2{text-align:center;margin-bottom:18px;color:#4da3ff;font-size:26px;font-weight:600;}
img{width:110px;height:110px;border-radius:50%;object-fit:cover;display:block;margin:auto;border:3px solid #4da3ff;}
input{
    width:100%;padding:12px;margin-top:14px;border:none;border-radius:9px;
    background:rgba(255,255,255,.12);color:white;font-size:14px;transition:.25s;
}
input:focus{background:rgba(255,255,255,.18);outline:none;box-shadow:0 0 0 2px #4da3ff;}
button{
    width:100%;margin-top:18px;padding:12px;border:none;border-radius:8px;
    background:#4da3ff;font-size:16px;font-weight:600;color:white;cursor:pointer;
}
button:hover{background:#1c86ff;}
a{display:block;text-align:center;margin-top:14px;color:#ff7272;text-decoration:none;}
a:hover{color:#ffa3a3;}

</style>
</head>

<body>

<div class="card">

    <img src="uploads/<%=photo%>" />

    <h2>Edit Profile</h2>

    <form action="UpdateProfileServlet" method="post" enctype="multipart/form-data">

        <input type="text" name="name" value="<%=request.getAttribute("name")%>" required>
        <input type="email" name="email" value="<%=request.getAttribute("email")%>">

        <label style="margin-top:10px;display:block;font-size:14px;">Change Profile Photo</label>
        <input type="file" name="photo" accept="image/*">

        <button type="submit">Save Changes</button>
    </form>

    <a href="ProfileServlet">Cancel</a>
</div>

</body>
</html>

