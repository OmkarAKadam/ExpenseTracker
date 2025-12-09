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
<title>Your Profile</title>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">

<style>
body{
    background:linear-gradient(135deg,#0b0e15,#121826,#1a2233);
    color:#fff;
    display:flex;
    justify-content:center;
    align-items:center;
    height:100vh;
    margin:0;
    font-family:'Poppins',sans-serif;
}

.card{
    background:rgba(255,255,255,.08);
    padding:40px;
    border-radius:15px;
    width:380px;
    text-align:center;
    box-shadow:0 8px 20px rgba(0,0,0,.4);
    animation:fadeIn 0.6s ease-in-out;
}

@keyframes fadeIn{
    from{opacity:0; transform:translateY(20px);}
    to{opacity:1; transform:translateY(0);}
}

img{
    width:110px;
    height:110px;
    border-radius:50%;
    object-fit:cover;
    margin-bottom:12px;
    border:3px solid #4da3ff;
    transition:box-shadow 0.3s ease;
}
img:hover{
    box-shadow:0 0 15px #4da3ff;
}

h2{
    margin:10px 0 5px;
    font-weight:600;
}
p{
    margin:5px 0;
    font-size:14px;
    opacity:0.85;
}

.actions a{
    display:block;
    width:100%;
    margin:8px 0;
    padding:10px;
    border-radius:8px;
    text-decoration:none;
    font-weight:600;
    color:white;
    cursor:pointer;
    background:#4da3ff;
    transition:background 0.3s ease, transform 0.2s ease, box-shadow 0.3s ease;
}
.actions a:hover{
    background:#357ae8;
    transform:translateY(-2px); /* subtle lift instead of scale */
    box-shadow:0 4px 12px rgba(0,0,0,.3);
}
.logout{background:#ff4f4f;}
.logout:hover{background:#e63939;}

@media(max-width:500px){
    .card{
        width:90%;
        padding:20px;
    }
    img{
        width:90px;
        height:90px;
    }
}
</style>
</head>

<body>

<div class="card">

    <img src="uploads/<%= photo %>"/>

    <h2><%= request.getAttribute("name") %></h2>
    <p>📧 <%= request.getAttribute("email") %></p>

    <div class="actions" style="margin-top: 20px;">
        <a href="ProfileServlet?edit=1">✏️ Edit Profile</a>
        <a href="change-password.jsp">🔑 Change Password</a>
        <a href="DashboardDataServlet">📊 Back to Dashboard</a>
        <a href="LogoutServlet" class="logout">🚪 Logout</a>
    </div>

</div>
</body>
</html>

