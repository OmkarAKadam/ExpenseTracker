<%@ page import="java.sql.*" contentType="text/html; charset=UTF-8"%>
<%
    if(session.getAttribute("userId") == null){
        response.sendRedirect("login.jsp");
        return;
    }

    ResultSet rs = (ResultSet) request.getAttribute("expense");
    rs.next();
%>

<!DOCTYPE html>
<html>
<head>
<title>Edit Expense - Expense Tracker</title>

<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">

<style>
    *{margin:0;padding:0;box-sizing:border-box;font-family:'Poppins',sans-serif;}

    body{
        background:linear-gradient(135deg,#0b0e15,#121826,#1a2234);
        height:100vh;
        display:flex;
        justify-content:center;
        align-items:center;
        overflow:hidden;
        color:white;
    }

    .wrapper{
        width:450px;
        background:rgba(255,255,255,.07);
        padding:45px 38px;
        border-radius:20px;
        backdrop-filter:blur(14px);
        border:1.6px solid rgba(255,255,255,.12);
        box-shadow:0 0 55px rgba(0,0,0,.65);
        animation:fade .45s ease;
    }

    @keyframes fade{from{opacity:.5;transform:translateY(25px);}to{opacity:1;}}

    h2{
        text-align:center;
        font-size:28px;
        color:#4da3ff;
        font-weight:600;
        margin-bottom:18px;
        letter-spacing:.7px;
    }

    label{
        font-size:14px;
        font-weight:500;
        display:block;
        margin-bottom:6px;
        text-transform:uppercase;
        opacity:.9;
        letter-spacing:.5px;
        margin-top:14px;
    }

    input,select{
        width:100%;
        height:48px;
        background:rgba(255,255,255,.12);
        border:none;
        border-radius:10px;
        padding:0 14px;
        color:white;
        font-size:14px;
        margin-bottom:8px;
        transition:.25s;
    }

    input:focus, select:focus{
        background:rgba(255,255,255,.18);
        outline:none;
        box-shadow:0 0 0 2px #4da3ff;
    }

    select option{background:#0e111a;color:white;}

    .btn-save{
        width:100%;
        margin-top:22px;
        padding:12px;
        background:linear-gradient(90deg,#4da3ff,#1c86ff);
        border:none;
        border-radius:10px;
        color:white;
        font-size:16px;
        font-weight:600;
        cursor:pointer;
        transition:.25s;
    }
    .btn-save:hover{
        opacity:.92;
        transform:translateY(-2px);
    }

    .cancel{
        display:block;
        text-align:center;
        margin-top:15px;
        font-size:14px;
        color:#ff7b7b;
        text-decoration:none;
        font-weight:500;
        transition:.25s;
    }
    .cancel:hover{color:#ffb3b3; transform:translateY(-2px);}
</style>
</head>

<body>

<div class="wrapper">

    <h2>Edit Expense</h2>

    <form action="UpdateExpenseServlet" method="post">

        <input type="hidden" name="id" value="<%= rs.getInt("id") %>">

        <label>Amount (₹)</label>
        <input type="number" step="0.01" name="amount" value="<%= rs.getDouble("amount") %>" required>

        <label>Category</label>
        <select name="category" required>
            <option <%=rs.getString("category").equals("Food")?"selected":""%>>Food</option>
            <option <%=rs.getString("category").equals("Travel")?"selected":""%>>Travel</option>
            <option <%=rs.getString("category").equals("Shopping")?"selected":""%>>Shopping</option>
            <option <%=rs.getString("category").equals("Bills")?"selected":""%>>Bills</option>
            <option <%=rs.getString("category").equals("Other")?"selected":""%>>Other</option>
        </select>

        <label>Date</label>
        <input type="text" id="datePicker" name="date" value="<%= rs.getString("date") %>" required>

        <label>Description</label>
        <input type="text" name="description" value="<%= rs.getString("description") %>">

        <button type="submit" class="btn-save">Save Changes</button>

    </form>

    <a href="ViewExpenseServlet" class="cancel">Cancel</a>

</div>

<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<script>
flatpickr("#datePicker",{
    dateFormat:"Y-m-d",
    defaultDate:"<%= rs.getString("date") %>"
});
</script>

</body>
</html>
