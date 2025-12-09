package com.mycompany.expensetracker.servlets;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.sql.*;
import com.mycompany.expensetracker.config.DBConnection;


public class ExportCSVServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if(session == null || session.getAttribute("userId") == null){
            resp.sendRedirect("login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        resp.setContentType("text/csv");
        resp.setHeader("Content-Disposition", "attachment; filename=expenses.csv");

        try(PrintWriter out = resp.getWriter();
            Connection con = DBConnection.getConnection()) {

            out.println("ID,Amount,Category,Date,Description");

            String sql = "SELECT * FROM expenses WHERE user_id=?";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setInt(1, userId);
            ResultSet rs = pst.executeQuery();

            while(rs.next()) {
                out.println(
                    rs.getInt("id") + "," +
                    rs.getDouble("amount") + "," +
                    rs.getString("category") + "," +
                    rs.getString("date") + "," +
                    "\"" + rs.getString("description") + "\""
                );
            }

        } catch(Exception e){
            resp.getWriter().println("Error: "+e.getMessage());
        }
    }
}
