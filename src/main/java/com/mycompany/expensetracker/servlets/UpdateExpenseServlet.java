package com.mycompany.expensetracker.servlets;

import com.mycompany.expensetracker.config.DBConnection;
import java.io.IOException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.PreparedStatement;

public class UpdateExpenseServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if(session==null || session.getAttribute("userId")==null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        int userId = (int)session.getAttribute("userId");
        int id = Integer.parseInt(req.getParameter("id"));
        double amount = Double.parseDouble(req.getParameter("amount"));
        String category = req.getParameter("category");
        String date = req.getParameter("date");
        String desc = req.getParameter("description");

        try(Connection con = DBConnection.getConnection()){
            PreparedStatement pst = con.prepareStatement(
                "UPDATE expenses SET amount=?, category=?, date=?, description=? WHERE id=? AND user_id=?"
            );
            pst.setDouble(1, amount);
            pst.setString(2, category);
            pst.setString(3, date);
            pst.setString(4, desc);
            pst.setInt(5,id);
            pst.setInt(6,userId);

            pst.executeUpdate();
            resp.sendRedirect("ViewExpenseServlet");
        }
        catch(Exception e){ resp.getWriter().println(e); }
    }
}
