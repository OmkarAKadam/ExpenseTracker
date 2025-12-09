<%@ page import="java.sql.*" contentType="text/html; charset=UTF-8" %>
<%
    if(session.getAttribute("userId") == null){
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
<title>Analytics - Expense Tracker</title>

<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
<script src="https://www.gstatic.com/charts/loader.js"></script>

<style>
    *{margin:0;padding:0;box-sizing:border-box;font-family:'Poppins',sans-serif;}

    body{
        background:linear-gradient(135deg,#0b0e15,#121826,#1a2234);
        min-height:100vh;
        color:white;
        padding-top:45px;
    }

    .container{
        width:90%;
        max-width:1200px;
        margin:auto;
        animation:fade .6s ease;
    }

    @keyframes fade{from{opacity:.5;transform:translateY(15px);}to{opacity:1;}}

    h2{
        text-align:center;
        font-size:30px;
        color:#4da3ff;
        margin-bottom:30px;
        font-weight:600;
        letter-spacing:1px;
    }

    /* Charts Grid */
    .charts{
        margin-top:20px;
        display:grid;
        grid-template-columns:1fr 1fr;
        gap:30px;
    }

    .chart-box{
        background:rgba(255,255,255,.06);
        padding:22px 25px;
        border-radius:18px;
        backdrop-filter:blur(12px);
        border:1px solid rgba(255,255,255,.14);
        box-shadow:0 0 50px rgba(0,0,0,.45);
        transition:.35s;
    }
    .chart-box:hover{
        transform:translateY(-4px);
        box-shadow:0 0 70px rgba(0,0,0,.55);
    }

    .chart-title{
        font-size:18px;
        margin-bottom:10px;
        color:#4da3ff;
        font-weight:500;
        text-align:center;
        text-transform:uppercase;
        letter-spacing:.6px;
    }

    /* Back Button */
    .back-btn{
        display:block;
        margin:40px auto 18px;
        width:max-content;
        padding:10px 25px;
        text-decoration:none;
        background:#4da3ff;
        color:#fff;
        font-weight:600;
        border-radius:8px;
        transition:.25s;
    }
    .back-btn:hover{
        opacity:.9;
        transform:translateY(-2px);
    }

    /* Responsive */
    @media(max-width:900px){
        .charts{grid-template-columns:1fr;}
        h2{font-size:26px;}
    }
</style>
</head>

<body>

<div class="container">

    <h2>Expense Analytics</h2>

    <div class="charts">

        <div class="chart-box">
            <div class="chart-title">Expense by Category</div>
            <div id="piechart" style="height:380px;"></div>
        </div>

        <div class="chart-box">
            <div class="chart-title">Monthly Expense Trend</div>
            <div id="barchart" style="height:380px;"></div>
        </div>

    </div>

    <a href="DashboardDataServlet" class="back-btn">← Back to Dashboard</a>

</div>


<script>
google.charts.load('current',{packages:['corechart']});
google.charts.setOnLoadCallback(drawCharts);

function drawCharts(){

    /* Category Pie */
    var categoryData=[
        ['Category','Amount'],
        <% ResultSet cat=(ResultSet)request.getAttribute("categoryData");
        while(cat!=null && cat.next()){ %>
            ['<%=cat.getString("category")%>', <%=cat.getDouble("total")%>],
        <% } %>
    ];

    var pie=new google.visualization.PieChart(document.getElementById('piechart'));
    pie.draw(google.visualization.arrayToDataTable(categoryData),{
        backgroundColor:'transparent',
        legend:{textStyle:{color:'#fff',fontSize:12}},
        pieHole:0.35,
        chartArea:{width:'90%',height:'80%'},
    });

    /* Monthly Chart */
    var monthData=[
        ['Month','Total'],
        <% ResultSet mon=(ResultSet)request.getAttribute("monthData");
        while(mon!=null && mon.next()){ %>
            ['<%=mon.getString("month_name")%>', <%=mon.getDouble("total")%>],
        <% } %>
    ];

    var bar=new google.visualization.ColumnChart(document.getElementById('barchart'));
    bar.draw(google.visualization.arrayToDataTable(monthData),{
        backgroundColor:'transparent',
        legend:'none',
        chartArea:{width:'85%',height:'75%'},
        titleTextStyle:{color:'#4da3ff'},
        hAxis:{textStyle:{color:'#fff'}},
        vAxis:{textStyle:{color:'#fff'}}
    });
}
</script>

</body>
</html>
