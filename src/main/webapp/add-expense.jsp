<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if(session.getAttribute("userId") == null){
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
<title>Add Expense - Expense Tracker</title>

<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/themes/dark.css">
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>

<style>
    *{margin:0;padding:0;box-sizing:border-box;font-family:'Poppins',sans-serif;}

    body{
        background:linear-gradient(135deg,#0b0e15,#121826,#1a2234);
        height:100vh;
        display:flex;
        justify-content:center;
        align-items:center;
        color:white;
    }

    .wrapper{
        width:420px;
        background:rgba(255,255,255,.08);
        padding:45px 40px;
        border-radius:18px;
        backdrop-filter:blur(12px);
        border:1.5px solid rgba(255,255,255,.12);
        box-shadow:0 0 50px rgba(0,0,0,.55);
        animation:fade .4s ease;
    }

    @keyframes fade{from{opacity:.5;transform:translateY(12px);}to{opacity:1;}}

    h2{
        font-size:26px;
        text-align:center;
        color:#4da3ff;
        margin-bottom:25px;
        font-weight:600;
    }

    label{
        font-size:14px;
        font-weight:500;
        margin-bottom:6px;
        display:block;
        margin-top:14px;
    }

    select, input{
        width:100%;
        height:46px;
        background:rgba(255,255,255,0.12);
        border:none;
        border-radius:8px;
        padding:0 12px;
        color:white;
        font-size:14px;
        margin-bottom:14px;
        transition:.25s;
    }

    /* DATE PICKER SAME AS FILTER PAGE */
    #datePicker{
        cursor:pointer;
    }

    select:focus, input:focus{
        background:rgba(255,255,255,0.18);
        box-shadow:0 0 0 2px #4da3ff;
        outline:none;
    }

    select option{
        background:#0d0f17;
        color:white;
        padding:10px;
    }

    input::placeholder{color:#cfcfcf;}

    button{
        width:100%;
        margin-top:20px;
        padding:12px;
        background:linear-gradient(90deg,#4da3ff,#1c86ff);
        border:none;
        border-radius:8px;
        color:white;
        font-size:16px;
        font-weight:600;
        cursor:pointer;
        transition:.25s;
    }
    button:hover{transform:translateY(-2px);opacity:.92;}

    .back{
        text-align:center;
        margin-top:16px;
        font-size:13px;
    }
    .back a{
        color:#4da3ff;
        text-decoration:none;
        font-weight:500;
        transition:.2s;
    }
    .back a:hover{color:#82c2ff;}
</style>
</head>

<body>

<div class="wrapper">

    <h2>Add Expense</h2>

    <form action="AddExpenseServlet" method="post">

        <label>Amount (₹)</label>
        <input type="number" step="0.01" name="amount" placeholder="Enter amount" required>

        <label>Category</label>
        <select name="category" required>
            <option>Food</option>
            <option>Travel</option>
            <option>Shopping</option>
            <option>Bills</option>
            <option>Other</option>
        </select>

        <label>Date</label>
        <input type="text" id="datePicker" name="date" placeholder="Pick date" required>

        <label>Description (optional)</label>
        <input type="text" name="description" placeholder="Short note...">

        <button type="submit">Add Expense</button>
    </form>

    <div class="back">
        <a href="DashboardDataServlet">← Back to Dashboard</a>
    </div>

</div>

<script>
flatpickr("#datePicker", {
    dateFormat:"Y-m-d",
    allowInput:true,
    theme:"dark"
});
</script>

</body>
</html>
