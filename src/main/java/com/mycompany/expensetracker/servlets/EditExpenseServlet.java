package com.mycompany.expensetracker.servlets;

import com.mycompany.expensetracker.config.DBConnection;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class EditExpenseServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if(session == null || session.getAttribute("userId") == null){
            resp.sendRedirect("login.jsp");
            return;
        }

        int id = Integer.parseInt(req.getParameter("id"));
        int userId = (int) session.getAttribute("userId");

        try(Connection con = DBConnection.getConnection()) {
            PreparedStatement pst = con.prepareStatement(
                "SELECT * FROM expenses WHERE id=? AND user_id=?"
            );
            pst.setInt(1,id);
            pst.setInt(2,userId);
            ResultSet rs = pst.executeQuery();

            req.setAttribute("expense", rs);
            req.getRequestDispatcher("edit-expense.jsp").forward(req, resp);
        }
        catch(Exception e){ resp.getWriter().println(e); }
    }
}
