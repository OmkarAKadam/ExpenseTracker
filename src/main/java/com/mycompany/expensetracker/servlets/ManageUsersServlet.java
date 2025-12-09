package com.mycompany.expensetracker.servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import com.mycompany.expensetracker.config.DBConnection;

public class ManageUsersServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        if(s == null || s.getAttribute("adminId") == null){
            resp.sendRedirect("admin-login.jsp");
            return;
        }

        try(Connection con = DBConnection.getConnection()){
            PreparedStatement pst = con.prepareStatement("SELECT id,name,email,role FROM users");
            ResultSet rs = pst.executeQuery();

            req.setAttribute("users", rs);
            req.getRequestDispatcher("admin-users.jsp").forward(req, resp);

        }catch(Exception e){
            resp.getWriter().println("Error: "+e.getMessage());
        }
    }
}
