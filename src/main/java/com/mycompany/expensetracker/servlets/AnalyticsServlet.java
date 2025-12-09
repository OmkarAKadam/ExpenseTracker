package com.mycompany.expensetracker.servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import com.mycompany.expensetracker.config.DBConnection;

public class AnalyticsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if(session == null || session.getAttribute("userId") == null){
            resp.sendRedirect("login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        try(Connection con = DBConnection.getConnection()){

            String catQuery = "SELECT category, SUM(amount) AS total FROM expenses WHERE user_id=? GROUP BY category";
            PreparedStatement pst1 = con.prepareStatement(catQuery);
            pst1.setInt(1, userId);
            req.setAttribute("categoryData", pst1.executeQuery());

            String monthQuery =
            "SELECT DATE_FORMAT(date,'%b %Y') AS month_name, SUM(amount) AS total " +
            "FROM expenses WHERE user_id=? " +
            "GROUP BY DATE_FORMAT(date,'%b %Y') " +
            "ORDER BY MIN(date)";

            PreparedStatement pst2 = con.prepareStatement(monthQuery);
            pst2.setInt(1, userId);
            req.setAttribute("monthData", pst2.executeQuery());

            req.getRequestDispatcher("analytics.jsp").forward(req, resp);

        }catch(Exception e){
            resp.getWriter().println("Error: "+e.getMessage());
        }
    }
}
