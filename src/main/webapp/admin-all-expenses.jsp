<%@page contentType="text/html; charset=UTF-8" import="java.sql.*"%>
<%
    if(session.getAttribute("adminId") == null){
        response.sendRedirect("admin-login.jsp");
        return;
    }

    ResultSet rs = (ResultSet) request.getAttribute("expenses");
%>
<!DOCTYPE html>
<html>
<head>
<title>Admin - All Expenses</title>

<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">

<style>
    *{margin:0;padding:0;box-sizing:border-box;font-family:'Poppins',sans-serif;}

    body{
        background:#181212;
        min-height:100vh;
        color:white;
        padding-top:50px;
    }

    .container{
        width:92%;
        max-width:1200px;
        margin:auto;
        animation:fade .4s ease;
    }
    @keyframes fade{from{opacity:.3;transform:translateY(20px);}to{opacity:1;}}

    h2{
        font-size:30px;
        font-weight:600;
        text-align:center;
        color:#ff4f4f;
        margin-bottom:25px;
    }

    /* Controls row */
    .controls{
        display:flex;
        gap:10px;
        justify-content:center;
        flex-wrap:wrap;
        margin-bottom:18px;
    }

    .controls input, .controls select{
        padding:10px;
        border-radius:8px;
        background:rgba(255,255,255,.1);
        border:none;
        color:white;
        width:240px;
        outline:none;
        transition:.3s;
    }
    .controls input:focus, .controls select:focus{
        background:rgba(255,255,255,.18);
        box-shadow:0 0 0 2px #ff4f4f;
    }

    table{
        width:100%;
        border-collapse:collapse;
        background:rgba(255,255,255,.06);
        backdrop-filter:blur(10px);
        border-radius:12px;
        overflow:hidden;
    }

    thead th{
        background:rgba(255,255,255,.15);
        padding:14px;
        font-size:14.5px;
        font-weight:600;
        cursor:pointer;
        user-select:none;
        position:sticky;
        top:0;
    }
    thead th:hover{
        background:rgba(255,255,255,.22);
    }

    td{
        padding:12px;
        border-bottom:1px solid rgba(255,255,255,.07);
        font-size:14px;
    }
    tr:hover{
        background:rgba(255,255,255,.08);
    }

    .delete-btn{
        background:#ff4f4f;
        padding:6px 12px;
        border-radius:6px;
        color:white;
        text-decoration:none;
        font-size:13px;
        font-weight:600;
        transition:.25s;
    }
    .delete-btn:hover{background:#d62828;}
    .delete-btn:active{transform:scale(.95);}

    /* Pagination */
    .pagination{
        margin-top:20px;
        display:flex;
        justify-content:center;
        gap:10px;
    }
    .pagination button{
        background:#333;
        color:white;
        padding:7px 14px;
        border:none;
        border-radius:6px;
        cursor:pointer;
        transition:.25s;
    }
    .pagination button:hover{background:#444;}
    .pagination button.active{background:#ff4f4f;}

    .no-data{text-align:center;padding:20px;opacity:.7;}

    .back-btn{
        display:block;
        margin:25px auto;
        width:120px;
        text-align:center;
        background:#333;
        padding:10px 20px;
        border-radius:8px;
        color:white;
        text-decoration:none;
        font-weight:500;
    }
    .back-btn:hover{background:#444;}
</style>
</head>

<body>

<div class="container">

    <h2>All Expenses</h2>

    <div class="controls">
        <input type="text" id="search" placeholder="Search anything...">
        <select id="filterCategory">
            <option value="">Filter by Category</option>
            <option>Food</option>
            <option>Travel</option>
            <option>Shopping</option>
            <option>Bills</option>
            <option>Other</option>
        </select>
    </div>

    <table id="expenseTable">
        <thead>
        <tr>
            <th data-sort="name">User Name</th>
            <th data-sort="amount">Amount (₹)</th>
            <th data-sort="category">Category</th>
            <th data-sort="date">Date</th>
            <th>Description</th>
            <th style="width:90px">Action</th>
        </tr>
        </thead>

        <tbody id="tableBody">
        <%
            boolean has=false;
            while(rs!=null && rs.next()){
                has=true;
        %>
        <tr>
            <td><%=rs.getString("user_name")%></td>
            <td><%=rs.getDouble("amount")%></td>
            <td><%=rs.getString("category")%></td>
            <td><%=rs.getString("date")%></td>
            <td><%=rs.getString("description")%></td>
            <td><a class="delete-btn" href="javascript:;" onclick="del(<%=rs.getInt("id")%>)">Delete</a></td>
        </tr>
        <% } %>

        <% if(!has){ %>
        <tr><td colspan="7" class="no-data">No expenses found</td></tr>
        <% } %>
        </tbody>
    </table>

    <div class="pagination" id="pagination"></div>

    <a href="AdminDashboardServlet" class="back-btn">← Back</a>

</div>

<script>
function del(id){
    if(confirm("Delete this entry?")){
        window.location="DeleteExpenseServlet?id="+id;
    }
}

const search=document.getElementById("search");
const category=document.getElementById("filterCategory");
const rows=[...document.querySelectorAll("#tableBody tr")];

function filterTable(){
    let s=search.value.toLowerCase();
    let c=category.value.toLowerCase();

    rows.forEach(r=>{
        let text=r.innerText.toLowerCase();
        let cat=r.children[3].innerText.toLowerCase();

        r.style.display = (text.includes(s) && (c=="" || cat==c))? "" : "none";
    });
}
search.onkeyup=filterTable;
category.onchange=filterTable;

/* Sorting */
document.querySelectorAll("th[data-sort]").forEach(th=>{
    th.onclick=()=>{
        let col=[...th.parentNode.children].indexOf(th);
        let rowsArray=[...document.querySelectorAll("#tableBody tr")];

        let asc=th.classList.toggle("asc");
        rowsArray.sort((a,b)=>{
            let x=a.children[col].innerText.toLowerCase();
            let y=b.children[col].innerText.toLowerCase();
            return asc ? x.localeCompare(y):y.localeCompare(x);
        });
        rowsArray.forEach(r=>document.getElementById("tableBody").appendChild(r));
    }
});

const rowsPerPage=10;
function paginate(){
    const tr=document.querySelectorAll("#tableBody tr");
    const pages=Math.ceil(tr.length/rowsPerPage);
    
    let pg=document.getElementById("pagination");
    pg.innerHTML="";
    for(let i=1;i<=pages;i++){
        let btn=document.createElement("button");
        btn.innerText=i;

        btn.onclick=()=>{
            showPage(i,tr);
            document.querySelectorAll(".pagination button").forEach(b=>b.classList.remove("active"));
            btn.classList.add("active");
        }
        pg.append(btn);
    }
    if(pages>0) pg.children[0].click();
}
function showPage(p,tr){
    tr.forEach((r,i)=>{
        r.style.display=(i>=((p-1)*rowsPerPage) && i<(p*rowsPerPage))?"":"none";
    });
}
paginate();
</script>

</body>
</html>
