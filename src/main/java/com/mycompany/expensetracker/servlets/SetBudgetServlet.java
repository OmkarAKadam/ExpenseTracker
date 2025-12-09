package com.mycompany.expensetracker.servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import com.mycompany.expensetracker.config.DBConnection;

public class SetBudgetServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if(session == null || session.getAttribute("userId") == null){
            resp.sendRedirect("login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        double budget = Double.parseDouble(req.getParameter("budget"));

        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement pst = con.prepareStatement(
                    "UPDATE users SET budget=? WHERE id=?"
            );
            pst.setDouble(1, budget);
            pst.setInt(2, userId);

            pst.executeUpdate();
            resp.sendRedirect("DashboardDataServlet?budgetSet=true");

        } catch (Exception e) {
            resp.getWriter().println("Error: " + e.getMessage());
        }
    }
}
