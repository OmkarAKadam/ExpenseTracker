package com.mycompany.expensetracker.servlets;

import java.io.IOException;
import jakarta.servlet.http.*;
import java.sql.*;

import com.mycompany.expensetracker.config.DBConnection;

public class DeleteExpenseServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if(session == null){
            resp.sendRedirect("login.jsp");
            return;
        }

        Integer adminId = (Integer) session.getAttribute("adminId");
        Integer userId  = (Integer) session.getAttribute("userId");
        int expenseId   = Integer.parseInt(req.getParameter("id"));

        try(Connection con = DBConnection.getConnection()){

            PreparedStatement pst;

            if(adminId != null) {
                pst = con.prepareStatement("DELETE FROM expenses WHERE id=?");
                pst.setInt(1, expenseId);
                pst.executeUpdate();
                resp.sendRedirect("AdminViewExpensesServlet");
                return;
            }

            if(userId != null) {
                pst = con.prepareStatement("DELETE FROM expenses WHERE id=? AND user_id=?");
                pst.setInt(1, expenseId);
                pst.setInt(2, userId);
                pst.executeUpdate();
                resp.sendRedirect("ViewExpenseServlet");
            }

        }catch(Exception e){
            resp.getWriter().println("Error: " + e.getMessage());
        }
    }
}
