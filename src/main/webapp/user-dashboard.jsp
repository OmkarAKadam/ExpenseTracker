<%@ page contentType="text/html; charset=UTF-8" %>
<%
    if(session.getAttribute("userId") == null){
        response.sendRedirect("login.jsp");
        return;
    }
    
    String photo = (String) session.getAttribute("userPhoto");
    if(photo == null || photo.trim().isEmpty()) photo = "default.png";
%>

<!DOCTYPE html>
<html>
<head>
<title>Expense Tracker - Dashboard</title>

<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">

<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: "Poppins", sans-serif;
}

body {
    background: linear-gradient(135deg, #0b0e15, #121826, #1a2234);
    min-height: 100vh;
    color: white;
}

nav {
    display: flex;
    justify-content: space-between;
    background: rgba(26, 34, 51, 0.85);
    backdrop-filter: blur(6px);
    align-items: center;
    padding: 0px 28px;
    box-shadow: 0 4px 12px rgba(0,0,0,.4);
    position: sticky;
    top: 0;
    z-index: 100;
    transition: background 0.3s ease, box-shadow 0.3s ease;
}

.brand {
    font-size: 22px;
    font-weight: 600;
    color: #4da3ff;
    letter-spacing: 1px;
}

.nav-links {
    display: flex;
    gap: 18px;
    align-items: center;
}

nav a {
    text-decoration: none;
    color: #fff;
    font-weight: 500;
    padding: 8px 14px;
    border-radius: 8px;
    transition: background 0.3s ease, transform 0.2s ease;
}

nav a:hover {
    background: rgba(255,255,255,0.1);
    transform: translateY(-2px);
}

.profile {
    border-radius: 50%;
    width: 42px;
    height: 42px;
    display: flex;
    align-items: center;
    justify-content: center;
    background: #4da3ff;
    font-size: 18px;
    font-weight: 600;
    color: #fff;
    box-shadow: 0 0 8px rgba(77,163,255,.6);
    transition: background 0.3s ease, box-shadow 0.3s ease;
}
.profile:hover {
    background: #357ae8;
    box-shadow: 0 0 12px rgba(77,163,255,.9);
}

.logout {
    background: #ff4f4f;
    padding: 8px 16px;
    border-radius: 6px;
    color: white;
    font-weight: 500;
    text-decoration: none;
    transition: .25s;
}
.logout:hover {
    background: #c92e2e;
}

.container {
    width: 90%;
    max-width: 1150px;
    margin: 50px auto;
    animation: fade .4s ease;
}
@keyframes fade {
    from {opacity: .4; transform: translateY(12px);}
    to {opacity: 1;}
}

h2 {
    font-size: 28px;
    font-weight: 600;
    margin-bottom: 35px;
}

.card-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 22px;
}

.card {
    background: rgba(255, 255, 255, .07);
    padding: 26px;
    border-radius: 18px;
    backdrop-filter: blur(10px);
    text-align: center;
    border: 1px solid rgba(255, 255, 255, .10);
    transition: .3s;
    min-height: 140px;
    box-shadow: 0 6px 16px rgba(0,0,0,.25);
}
.card:hover {
    transform: translateY(-6px);
    box-shadow: 0 8px 20px rgba(0,0,0,.35);
}
.card h4 {
    font-size: 15px;
    opacity: .8;
    margin-bottom: 6px;
}
.card h2 {
    font-size: 26px;
    margin-top: 4px;
    font-weight: 600;
    color: #4da3ff;
}

.budget-title {
    font-size: 18px;
    font-weight: 600;
    margin-bottom: 10px;
    color: #4da3ff;
}
.budget-values {
    font-size: 17px;
    margin-bottom: 10px;
}
.budget-bar {
    width: 100%;
    height: 12px;
    background: #2c3242;
    border-radius: 10px;
    overflow: hidden;
    margin-bottom: 12px;
}
.budget-fill {
    height: 100%;
    background: #4da3ff;
    transition: .4s;
}

.alert {
    color: #ff4f4f;
    font-weight: 600;
    margin-bottom: 10px;
}
.safe {
    color: #31e67c;
    font-weight: 600;
    margin-bottom: 10px;
}

.budget-form {
    display: flex;
    justify-content: center;
    gap: 12px;
    margin-top: 8px;
}
.budget-form input {
    padding: 9px;
    border-radius: 6px;
    border: none;
    width: 140px;
}
.budget-form button {
    padding: 9px 12px;
    background: #4da3ff;
    border: none;
    color: white;
    font-weight: 600;
    border-radius: 6px;
    cursor: pointer;
    transition: background 0.3s ease;
}
.budget-form button:hover {
    background: #1c86ff;
}

.btn-area {
    margin-top: 35px;
    display: grid;
    grid-template-columns: repeat(4,1fr);
    gap: 15px;
}

.btn-area a {
    padding: 14px;
    text-align: center;
    border-radius: 8px;
    font-weight: 600;
    text-decoration: none;
    transition:.25s;
    font-size:15px;
}

.add {
    background: #1c86ff;
    color: white;
}

.view {
    background: #444;
    color: white;
}

.filter {
    background: #ffb341;
    color: white;
}

.analytics {
    background: #7a55ff;
    color: white;
}

.btn-area a:hover {
    opacity: .9;
    transform: translateY(-2px);
}


@media(max-width: 768px) {
    .card-grid {
        grid-template-columns: repeat(1, 1fr);
    }
    .budget-card {
        grid-column: auto;
    }
}
</style>
</head>

<body>

<nav>
    <span class="brand">Expense Tracker</span>
    <div class="nav-links">
        <a href="ProfileServlet">
            <img src="<%=request.getContextPath()%>/uploads/<%= request.getAttribute("photo") %>"
            style="width:42px;height:42px;border-radius:50%;object-fit:cover;border:2px solid #4da3ff"/>
        </a>
        <a href="LogoutServlet" class="logout">Logout</a>
    </div>
</nav>

<div class="container">

<h2>Welcome, <%= session.getAttribute("userName") %> 👋</h2>

<div class="card-grid"> 
    <div class="card">
        <h4>Total Expense</h4>
        <h2>₹ <%=request.getAttribute("totalExpense")%></h2>
    </div>

    <div class="card">
        <h4>This Month</h4>
        <h2>₹ <%= request.getAttribute("monthExpense") %></h2>
    </div>

    <div class="card">
        <h4>Top Category</h4>
        <h2 style="color:#ffb341;">
            <%= request.getAttribute("topCategory") %>
        </h2>
    </div>

    <div class="card">
        <h4>Daily Avg Spend</h4>
        <h2 style="color:#1ccc88;">
            ₹ <%= request.getAttribute("avgDaily") %>
        </h2>
    </div>

    <div class="card">
        <h4>Last Month</h4>
        <h2 style="color:#c77dff;">
            ₹ <%= request.getAttribute("lastMonth") %>
        </h2>
    </div>

    <div class="card budget-card">
        <div class="budget-title">Monthly Budget</div>

        <div class="budget-values">
            <b>₹ <%= request.getAttribute("monthExpense") %></b> /
            ₹ <%= request.getAttribute("budget") %>
        </div>

        <div class="budget-bar">
            <div class="budget-fill"
                 style="width:<%= Math.min(100,
                     ((double)request.getAttribute("monthExpense") /
                     (double)request.getAttribute("budget")) * 100 ) %>%">
            </div>
        </div>

        <% if ((boolean)request.getAttribute("overLimit")) { %>
            <p class="alert">⚠ You exceeded monthly budget!</p>
        <% } else { %>
            <p class="safe">Within Budget ✓</p>
        <% } %>

        <form action="SetBudgetServlet" method="post" class="budget-form">
            <input type="number" name="budget" placeholder="Set New Budget ₹" required>
            <button>Update</button>
        </form>
    </div>
    </div>
</div>

<div class="container"> 
    <div class="btn-area">
        <a href="add-expense.jsp" class="add">➕ Add Expense</a>
        <a href="ViewExpenseServlet" class="view">📄 View Expenses</a>
        <a href="filter-expenses.jsp" class="filter">🔍 Filter</a>
        <a href="AnalyticsServlet" class="analytics">📊 Analytics</a>
    </div>
</div>


</body>
</html>
