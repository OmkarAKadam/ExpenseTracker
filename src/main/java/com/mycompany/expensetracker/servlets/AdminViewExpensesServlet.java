package com.mycompany.expensetracker.servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import com.mycompany.expensetracker.config.DBConnection;

public class AdminViewExpensesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        HttpSession session = req.getSession(false);
        if(session == null || session.getAttribute("adminId") == null){
            resp.sendRedirect("admin-login.jsp");
            return;
        }

        try(Connection con = DBConnection.getConnection()){

            String sql = "SELECT e.*, u.name AS user_name FROM expenses e JOIN users u ON e.user_id = u.id";
            PreparedStatement pst = con.prepareStatement(sql);
            ResultSet rs = pst.executeQuery();

            req.setAttribute("expenses", rs);
            req.getRequestDispatcher("admin-all-expenses.jsp").forward(req, resp);

        }catch(Exception e){
            resp.getWriter().println("Error: " + e.getMessage());
        }
    }
}
