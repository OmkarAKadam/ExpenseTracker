<%@page contentType="text/html; charset=UTF-8" import="java.sql.*"%>
<%
    if(session.getAttribute("adminId") == null){
        response.sendRedirect("admin-login.jsp");
        return;
    }

    ResultSet rs = (ResultSet) request.getAttribute("users");
%>
<!DOCTYPE html>
<html>
<head>
<title>Admin - Users List</title>

<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>
    *{margin:0;padding:0;box-sizing:border-box;font-family:'Poppins',sans-serif;}

    body{
        background:#181212;
        min-height:100vh;
        color:white;
        padding:50px 0;
    }

    .container{
        width:92%;
        max-width:950px;
        margin:auto;
        animation:fade .4s ease;
    }
    @keyframes fade{from{opacity:.4;transform:translateY(15px);}to{opacity:1;}}

    h2{
        font-size:28px;
        margin-bottom:18px;
        color:#ff4f4f;
        font-weight:600;
        text-align:center;
    }

    /* Search bar */
    .search-box{
        width:100%;
        margin-bottom:16px;
        display:flex;
        justify-content:center;
    }
    .search-box input{
        width:320px;
        padding:10px 14px;
        border-radius:8px;
        background:rgba(255,255,255,.12);
        border:none;
        color:white;
        outline:none;
        font-size:14px;
        transition:.25s;
    }
    .search-box input:focus{
        background:rgba(255,255,255,.18);
        box-shadow:0 0 0 2px #ff4f4f;
    }

    table{
        width:100%;
        border-collapse:collapse;
        background:rgba(255,255,255,.06);
        backdrop-filter:blur(12px);
        overflow:hidden;
        border-radius:14px;
    }

    thead th{
        background:rgba(255,255,255,.14);
        padding:13px;
        font-size:15px;
        font-weight:500;
        text-align:left;
    }

    td{
        padding:12px;
        font-size:14px;
        border-bottom:1px solid rgba(255,255,255,.08);
    }

    tr:hover{background:rgba(255,255,255,.08);}

    .role{
        padding:5px 10px;
        border-radius:6px;
        font-size:13px;
        font-weight:600;
        text-transform:capitalize;
        color:white;
        justify-self: center;
    }
    .admin{background:#ff4f4f;}
    .user{background:#1c86ff;}

    /* Action buttons */
    .btn-action{
        padding:6px 10px;
        border-radius:6px;
        font-size:12px;
        text-decoration:none;
        color:white;
        font-weight:500;
        margin-right:6px;
        transition:.25s;
    }
    .view{background:#1c86ff;}
    .view:hover{background:#1769cf;}
    
    .del{background:#ff4f4f;}
    .del:hover{background:#d62828;}

    .back-btn{
        display:inline-block;
        margin:28px auto 0;
        padding:10px 18px;
        background:#333;
        border-radius:8px;
        color:white;
        font-weight:500;
        text-decoration:none;
        transition:.25s;
    }
    .back-btn:hover{background:#444;}
</style>
</head>

<body>

<div class="container">

    <h2>Registered Users</h2>

    <!-- Search -->
    <div class="search-box">
        <input id="search" type="text" placeholder="Search user by name/email...">
    </div>

    <table id="userTable">
        <thead>
            <tr>
                <th>Name</th>
                <th>Email</th>
                <th style="width:120px;">Role</th>
            </tr>
        </thead>

        <tbody>
        <%
            boolean has=false;
            while(rs!=null && rs.next()){
                has=true;
                String role = rs.getString("role");
        %>
        <tr>
            <td><%= rs.getString("name") %></td>
            <td><%= rs.getString("email") %></td>

            <td>
                <span class="role <%= (role!=null && role.equalsIgnoreCase("ADMIN"))?"admin":"user" %>">
                    <%= (role!=null?role:"User") %>
                </span>
            </td>
        </tr>
        <% } %>

        <% if(!has){ %>
        <tr><td colspan="5" style="text-align:center;opacity:.8;padding:18px;">No users found</td></tr>
        <% } %>
        </tbody>
    </table>

    <div style="text-align:center;">
        <a href="admin-dashboard.jsp" class="back-btn">← Back</a>
    </div>

</div>

<script>
document.getElementById("search").addEventListener("keyup", function(){
    let filter = this.value.toLowerCase();
    let rows = document.querySelectorAll("#userTable tbody tr");

    rows.forEach(r=>{
        r.style.display = r.innerText.toLowerCase().includes(filter) ? "" : "none";
    });
});
</script>

</body>
</html>
