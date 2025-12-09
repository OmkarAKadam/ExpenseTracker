<%@ page import="java.sql.*" contentType="text/html; charset=UTF-8" %>
<%
    if(session.getAttribute("userId") == null){
        response.sendRedirect("login.jsp");
        return;
    }

    ResultSet rs = (ResultSet) request.getAttribute("expenses");
%>
<html>
    <head>
    <title>My Expenses - Expense Tracker</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        *{margin:0;padding:0;box-sizing:border-box;font-family:'Poppins',sans-serif;}

        body{
            background:linear-gradient(135deg,#0b0e15,#121826,#1a2234);
            min-height:100vh;
            color:white;
            padding-top:40px;
        }

        .container{
            width:90%;
            max-width:1100px;
            margin:auto;
            animation:fade .4s ease;
        }
        @keyframes fade{from{opacity:.3;transform:translateY(15px);}to{opacity:1;}}

        .header-bar{
            display:flex;justify-content:space-between;align-items:center;
            margin-bottom:25px;
        }

        h2{
            font-size:28px;
            font-weight:600;
            color:#4da3ff;
        }

        .action-btns a{
            margin-left:8px;
            padding:9px 16px;
            font-size:14px;
            font-weight:500;
            border-radius:8px;
            text-decoration:none;
            transition:.25s;
        }
        .btn-add{background:#28a745;color:white;}
        .btn-add:hover{background:#218838}
        .btn-filter{background:#ffb341;color:black;}
        .btn-filter:hover{opacity:.85;}
        .btn-csv{background:#0099ff;color:white;}
        .btn-csv:hover{background:#007ed6;}
        .btn-pdf{background:#ff4757;color:white;}
        .btn-pdf:hover{background:#d6343f;}
        .btn-back{background:#4da3ff;color:white;}
        .btn-back:hover{background:#1c86ff;}

        .expense-table {
        width:100%;
        border-collapse:collapse;
        margin-top:10px;
        background:rgba(255,255,255,.05);
        border-radius:12px;
        overflow:hidden;
    }

    .expense-table th {
        background:rgba(255,255,255,.13);
        padding:14px;
        font-size:15px;
        font-weight:600;
        text-align:left;
    }

    .expense-table td {
        padding:12px;
        font-size:14px;
        border-bottom:1px solid rgba(255,255,255,.07);
    }

    .expense-table tr:hover {
        background:rgba(255,255,255,.08);
    }

    .action-col {
        white-space:nowrap;
        text-align:center;
    }

    .btn-edit {
        background:#f1c40f;
        color:#000;
        padding:6px 12px;
        border-radius:6px;
        font-size:13px;
        text-decoration:none;
        margin-right:6px;
        transition:.2s;
    }
    .btn-edit:hover { opacity:.9; }

    .btn-delete {
        background:#e74c3c;
        color:#fff;
        padding:6px 12px;
        border-radius:6px;
        font-size:13px;
        text-decoration:none;
        transition:.2s;
    }
    .btn-delete:hover { opacity:.85; }

        .pill{
            padding:5px 10px;border-radius:30px;font-size:13px;color:white;
        }
        .Food{background:#ff7675;}
        .Travel{background:#1abc9c;}
        .Bills{background:#0984e3;}
        .Shopping{background:#e17055;}
        .Other{background:#6c5ce7;}
    </style>
    </head>

    <body>

        <div class="container">

            <div class="header-bar">
                <h2>My Expenses</h2>

                <div class="action-btns">
                    <a href="add-expense.jsp" class="btn-add">+ Add Expense</a>
                    <a href="filter-expenses.jsp" class="btn-filter">Filter</a>
                    <a href="ExportCSVServlet" class="btn-csv">CSV</a>
                    <a href="ExportPDFServlet" class="btn-pdf">PDF</a>
                    <a href="DashboardDataServlet" class="btn-back">Back</a>
                </div>
            </div>

            <table class="expense-table">
                <thead>
                    <tr>
                        <th>Amount (₹)</th>
                        <th>Category</th>
                        <th>Date</th>
                        <th>Description</th>
                        <th style="text-align:center;">Actions</th>
                    </tr>
                </thead>

                <tbody>
                <%
                    boolean hasData = false;
                    while(rs != null && rs.next()){
                        hasData = true;
                %>
                    <tr>
                        <td>₹ <%= rs.getDouble("amount") %></td>
                        <td><%= rs.getString("category") %></td>
                        <td><%= rs.getString("date") %></td>
                        <td><%= rs.getString("description") %></td>

                        <td class="action-col">
                            <a href="EditExpenseServlet?id=<%= rs.getInt("id") %>" class="btn-edit">Edit</a>
                            <a href="DeleteExpenseServlet?id=<%= rs.getInt("id") %>" 
                               class="btn-delete"
                               onclick="return confirm('Delete this expense?')">Delete</a>
                        </td>
                    </tr>
                <% } %>

                <% if(!hasData){ %>
                    <tr><td colspan="6" class="no-data">No expenses found</td></tr>
                <% } %>
                </tbody>
            </table>
            <div style="margin-top:25px; text-align:center;">
                <%
                    Integer currentPage = (Integer) request.getAttribute("currentPage");
                    Integer totalPages = (Integer) request.getAttribute("totalPages");

                    if (currentPage == null) currentPage = 1;
                    if (totalPages == null) totalPages = 1;

                    for(int i = 1; i <= totalPages; i++){
                        if(i == currentPage){
                %>
                            <span style="padding:8px 12px;background:#4da3ff;margin:4px;border-radius:6px;font-weight:600;">
                                <%= i %>
                            </span>
                <%
                        } else {
                %>
                            <a href="ViewExpenseServlet?page=<%= i %>" 
                               style="padding:8px 12px;background:#3a3a3a;margin:4px;border-radius:6px;text-decoration:none;color:white;">
                                <%= i %>
                            </a>
                <%
                        }
                    }
                %>
            </div>
        </div>
    </body>
</html>
