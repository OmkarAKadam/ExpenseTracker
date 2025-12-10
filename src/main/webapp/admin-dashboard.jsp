<%@ page contentType="text/html; charset=UTF-8" import="java.sql.*" %>
<%
    if(session.getAttribute("role") == null || !session.getAttribute("role").equals("ADMIN")){
        response.sendRedirect("admin-login.jsp");
        return;
    }

    int totalUsers = request.getAttribute("totalUsers") != null ? (int)request.getAttribute("totalUsers") : 0;
    int totalExpenses = request.getAttribute("totalExpenses") != null ? (int)request.getAttribute("totalExpenses") : 0;
    double totalAmount = request.getAttribute("totalAmount") != null ? (double)request.getAttribute("totalAmount") : 0.0;

%>

<html>
<head>
<title>Admin Dashboard - Expense Tracker</title>

<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>
    *{margin:0;padding:0;box-sizing:border-box;font-family:'Poppins',sans-serif;}

    body{
        background:#181212;
        min-height:100vh;
        color:white;
        padding-bottom:70px;
    }

    nav{
        background:rgba(255,255,255,.08);
        backdrop-filter:blur(12px);
        border-bottom:1px solid rgba(255,255,255,.14);
        padding:16px 30px;
        display:flex;
        justify-content:space-between;
        align-items:center;
    }

    nav .brand{font-size:23px;font-weight:600;color:#ff4f4f;}

    nav a.logout{
        background:#ff4f4f;
        padding:9px 18px;
        border-radius:8px;
        text-decoration:none;
        color:white;font-weight:500;transition:.25s;
    }
    nav a.logout:hover{background:#c93030;}

    .container{
        width:92%;
        max-width:1100px;
        margin:auto;
        margin-top:45px;
        animation:fade .4s ease;
    }
    @keyframes fade{from{opacity:.5;transform:translateY(12px);}to{opacity:1;}}

    h2{font-size:28px;color:#ff4f4f;font-weight:600;margin-bottom:10px;}
    .welcome{opacity:.8;margin-bottom:35px;font-size:15px;}

    /* Stats Section */
    .stats{
        display:flex;
        gap:22px;
        flex-wrap:wrap;
        margin-bottom:35px;
    }
    .stat-box{
        flex:1;
        min-width:240px;
        background:rgba(255,255,255,.08);
        border-radius:16px;
        padding:25px;
        text-align:center;
        border:1px solid rgba(255,255,255,.12);
        transition:.3s;
        backdrop-filter:blur(10px);
    }
    .stat-box:hover{transform:translateY(-6px);}
    .stat-box i{font-size:28px;margin-bottom:12px;color:#ff4f4f;}
    .stat-box h3{font-size:22px;margin-bottom:4px;font-weight:600;}
    .stat-box span{opacity:.8;font-size:14px;}

    /* Action Cards */
    .card-wrapper{
        display:flex;
        gap:26px;
        flex-wrap:wrap;
    }
    .card{
        flex:1;
        min-width:250px;
        background:rgba(255,255,255,.08);
        border-radius:16px;
        padding:28px;
        text-align:center;
        border:1px solid rgba(255,255,255,.12);
        transition:.3s;
    }
    .card:hover{transform:translateY(-6px);}
    .card h4{font-size:19px;margin-bottom:18px;font-weight:500;}

    .btn{
        display:inline-block;
        padding:10px 18px;
        border-radius:8px;
        font-size:15px;
        text-decoration:none;
        font-weight:500;
        transition:.25s;
        color:white;
    }
    .blue-btn{background:#1c86ff;}
    .yellow-btn{background:#ffb341;color:black;font-weight:600;}
    .red-btn{background:#ff4f4f;}
    .btn:hover{opacity:.9;transform:translateY(-3px);}
</style>

</head>
<body>

<nav>
    <span class="brand"><i class="fa-solid fa-shield-halved"></i> Admin Panel</span>
    <a href="LogoutServlet" class="logout">Logout</a>
</nav>

<div class="container">

    <h2>Dashboard Overview</h2>
    <div class="welcome">Logged in as: <b><%= session.getAttribute("adminName") %></b></div>

    <div class="stats">

        <div class="stat-box">
            <i class="fa-solid fa-users"></i>
            <h3><%= totalUsers %></h3>
            <span>Total Registered Users</span>
        </div>

        <div class="stat-box">
            <i class="fa-solid fa-wallet"></i>
            <h3><%= totalExpenses %></h3>
            <span>Total Expense Entries</span>
        </div>

        <div class="stat-box">
            <i class="fa-solid fa-indian-rupee-sign"></i>
            <h3>₹ <%= totalAmount %></h3>
            <span>Total Amount Logged</span>
        </div>

    </div>

    <div class="card-wrapper">

        <div class="card">
            <h4>View All Expenses</h4>
            <a href="AdminViewExpensesServlet" class="blue-btn btn">Open</a>
        </div>

        <div class="card">
            <h4>Manage Users</h4>
            <a href="ManageUsersServlet" class="yellow-btn btn">Users</a>
        </div>

        <div class="card">
            <h4>Generate PDF / Report</h4>
            <a href="GenerateReportServlet" class="red-btn btn">Report</a>
        </div>

    </div>

</div>

</body>
</html>
