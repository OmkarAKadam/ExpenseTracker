package com.mycompany.expensetracker.servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import com.mycompany.expensetracker.config.DBConnection;

public class AddExpenseServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if(session == null || session.getAttribute("userId") == null){
            resp.sendRedirect("login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        double amount = Double.parseDouble(req.getParameter("amount"));
        String category = req.getParameter("category");
        String date = req.getParameter("date");
        String desc = req.getParameter("description");

        try(Connection con = DBConnection.getConnection()){
            String sql = "INSERT INTO expenses(user_id,amount,category,date,description) VALUES(?,?,?,?,?)";
            PreparedStatement pst = con.prepareStatement(sql);

            pst.setInt(1, userId);
            pst.setDouble(2, amount);
            pst.setString(3, category);
            pst.setString(4, date);
            pst.setString(5, desc);

            pst.executeUpdate();
            resp.sendRedirect("DashboardDataServlet");

        }catch(Exception e){
            resp.getWriter().println("Error: " + e.getMessage());
        }
    }
}
