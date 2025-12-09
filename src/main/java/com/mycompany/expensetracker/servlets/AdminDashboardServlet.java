package com.mycompany.expensetracker.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;
import com.mycompany.expensetracker.config.DBConnection;

public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try(Connection con = DBConnection.getConnection()){

            PreparedStatement ps1 = con.prepareStatement("SELECT COUNT(*) FROM users");
            ResultSet rs1 = ps1.executeQuery();
            rs1.next();
            req.setAttribute("totalUsers", rs1.getInt(1));

            PreparedStatement ps2 = con.prepareStatement("SELECT COUNT(*) FROM expenses");
            ResultSet rs2 = ps2.executeQuery();
            rs2.next();
            req.setAttribute("totalExpenses", rs2.getInt(1));

            PreparedStatement ps3 = con.prepareStatement("SELECT SUM(amount) FROM expenses");
            ResultSet rs3 = ps3.executeQuery();
            rs3.next();
            req.setAttribute("totalAmount", rs3.getDouble(1));

            req.getRequestDispatcher("admin-dashboard.jsp").forward(req, resp);

        }catch(Exception e){
        }
    }
}
