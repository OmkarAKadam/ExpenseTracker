package com.mycompany.expensetracker.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.mycompany.expensetracker.config.DBConnection;

public class FilterExpenseServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if(session == null || session.getAttribute("userId") == null){
            resp.sendRedirect("login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String category = req.getParameter("category");
        String from = req.getParameter("fromDate");
        String to = req.getParameter("toDate");

        int page = 1;
        int limit = 10;

        if(req.getParameter("page") != null){
            page = Integer.parseInt(req.getParameter("page"));
        }

        int start = (page - 1) * limit;

        try(Connection con = DBConnection.getConnection()){

            String base = " FROM expenses WHERE user_id=?";
            if(category != null && !category.isEmpty()) base += " AND category='"+category+"'";
            if(from != null && !from.isEmpty()) base += " AND date>='"+from+"'";
            if(to != null && !to.isEmpty()) base += " AND date<='"+to+"'";

            String countQuery = "SELECT COUNT(*)" + base;
            PreparedStatement countPst = con.prepareStatement(countQuery);
            countPst.setInt(1, userId);
            ResultSet countRs = countPst.executeQuery();
            countRs.next();
            int totalRecords = countRs.getInt(1);
            int totalPages = (int)Math.ceil(totalRecords / (double) limit);

            String dataQuery = "SELECT *" + base + " ORDER BY date DESC LIMIT ?,?";
            PreparedStatement dataPst = con.prepareStatement(dataQuery);
            dataPst.setInt(1, userId);
            dataPst.setInt(2, start);
            dataPst.setInt(3, limit);

            ResultSet rs = dataPst.executeQuery();

            List<String[]> expenses = new ArrayList<>();

            while(rs.next()){
                expenses.add(new String[]{
                        rs.getString("title"),
                        rs.getString("category"),
                        rs.getString("amount"),
                        rs.getString("date")
                });
            }

            req.setAttribute("expenses", expenses);
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("category", category);
            req.setAttribute("fromDate", from);
            req.setAttribute("toDate", to);

            req.getRequestDispatcher("view-expenses.jsp").forward(req, resp);

        }catch(Exception e){
            resp.getWriter().println("Error: " + e.getMessage());
        }
    }
}
