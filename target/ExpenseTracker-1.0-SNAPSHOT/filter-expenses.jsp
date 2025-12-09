<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>Filter Expenses - Expense Tracker</title>

<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/themes/dark.css"> 
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>

<style>
    *{margin:0;padding:0;box-sizing:border-box;font-family:'Poppins',sans-serif;}

    body{
        background:linear-gradient(135deg,#0b0e15,#121826,#1a2234);
        height:100vh;display:flex;justify-content:center;align-items:center;color:white;
    }

    .wrapper{
        width:430px;background:rgba(255,255,255,.08);padding:48px 42px;border-radius:20px;
        backdrop-filter:blur(14px);border:1.5px solid rgba(255,255,255,.12);
        box-shadow:0 0 60px rgba(0,0,0,.55);animation:fade .45s ease;
    }
    @keyframes fade{from{opacity:.4;transform:translateY(12px);}to{opacity:1;}}

    h2{text-align:center;font-size:28px;color:#4da3ff;margin-bottom:25px;font-weight:600;}

    label{font-size:14px;font-weight:500;margin-bottom:6px;margin-top:14px;display:block;}

    select,input{
        width:100%;height:46px;background:rgba(255,255,255,.12);border:none;border-radius:9px;
        padding:0 12px;color:white;font-size:14px;margin-bottom:14px;transition:.25s;
    }
    input:focus,select:focus{
        background:rgba(255,255,255,.18);outline:none;box-shadow:0 0 0 2px #4da3ff;
    }

    select option{background:#1a2234;color:white;}

    /* QUICK FILTER CHIPS */
    .quick-filters{
        display:flex;gap:8px;margin-bottom:10px;margin-top:5px;flex-wrap:wrap;
    }
    .chip{
        padding:6px 14px;border-radius:30px;background:rgba(255,255,255,.12);
        cursor:pointer;font-size:13px;transition:.25s;border:1px solid rgba(255,255,255,.12);
    }
    .chip:hover{background:#4da3ff;color:#08121e;}

    button{
        width:100%;padding:12px;margin-top:18px;border:none;
        background:linear-gradient(90deg,#4da3ff,#1c86ff);
        border-radius:9px;font-size:16px;font-weight:600;color:white;
        cursor:pointer;transition:.25s;letter-spacing:.4px;
    }
    button:hover{opacity:.92;transform:translateY(-2px);box-shadow:0 4px 12px rgba(77,163,255,.4);}

    .back{text-align:center;margin-top:18px;font-size:13px;}
    .back a{color:#4da3ff;text-decoration:none;font-weight:500;transition:.25s;}
    .back a:hover{color:#82c2ff;text-shadow:0 0 6px rgba(130,194,255,.6);}
</style>
</head>

<body>

<div class="wrapper">

    <h2>Filter Expenses</h2>

    <form action="FilterExpenseServlet" method="get">

        <label>Category</label>
        <select name="category">
            <option value="">All</option>
            <option>Food</option>
            <option>Travel</option>
            <option>Shopping</option>
            <option>Bills</option>
            <option>Other</option>
        </select>

        <label>Date Range</label>
        <input type="text" id="rangeDate" name="range" placeholder="Select range">

        <div class="quick-filters">
            <span class="chip" onclick="setRange(7)">Last 7 Days</span>
            <span class="chip" onclick="setRange(30)">Last 30 Days</span>
            <span class="chip" onclick="today()">Today</span>
            <span class="chip" onclick="thisMonth()">This Month</span>
        </div>

        <button type="submit">Apply Filter</button>
    </form>

    <div class="back"><a href="DashboardDataServlet">← Back to Dashboard</a></div>
</div>


<script>
flatpickr("#rangeDate",{mode:"range",dateFormat:"Y-m-d",theme:"dark",allowInput:true});

/* QUICK FILTER FUNCTIONS */
function setRange(days){
    let end=new Date(),start=new Date();
    start.setDate(start.getDate()-days);
    rangeDate._flatpickr.setDate([start,end]);
}
function today(){
    let d=new Date();
    rangeDate._flatpickr.setDate([d,d]);
}
function thisMonth(){
    let now=new Date(),start=new Date(now.getFullYear(),now.getMonth(),1);
    rangeDate._flatpickr.setDate([start,now]);
}
</script>

</body>
</html>
