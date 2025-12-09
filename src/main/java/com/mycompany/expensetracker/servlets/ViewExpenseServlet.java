package com.mycompany.expensetracker.servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.mycompany.expensetracker.config.DBConnection;

public class ViewExpenseServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if(session == null || session.getAttribute("userId") == null){
            resp.sendRedirect("login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        int page = 1;
        int recordsPerPage = 10;

        if(req.getParameter("page") != null){
            page = Integer.parseInt(req.getParameter("page"));
        }

        int start = (page - 1) * recordsPerPage;

        try(Connection con = DBConnection.getConnection()){

            String query = "SELECT * FROM expenses WHERE user_id=? ORDER BY date DESC LIMIT ?,?";
            PreparedStatement pst = con.prepareStatement(query);
            pst.setInt(1, userId);
            pst.setInt(2, start);
            pst.setInt(3, recordsPerPage);

            ResultSet rs = pst.executeQuery();

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

            PreparedStatement countPst = con.prepareStatement("SELECT COUNT(*) FROM expenses WHERE user_id=?");
            countPst.setInt(1, userId);

            ResultSet countRs = countPst.executeQuery();
            countRs.next();

            int totalRecords = countRs.getInt(1);
            int totalPages = (int)Math.ceil(totalRecords / (double)recordsPerPage);

            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);
            req.getRequestDispatcher("view-expenses.jsp").forward(req, resp);

        }catch(Exception e){
            resp.getWriter().println("Error: " + e.getMessage());
        }
    }
}
