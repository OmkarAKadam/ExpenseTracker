package com.mycompany.expensetracker.servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import com.mycompany.expensetracker.config.DBConnection;
import org.mindrot.jbcrypt.BCrypt;

public class AdminLoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        try(Connection con = DBConnection.getConnection()){

            String sql = "SELECT * FROM users WHERE email=? AND role='ADMIN'";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setString(1, email);

            ResultSet rs = pst.executeQuery();

            if(rs.next()){

                String hash = rs.getString("password");

                if(BCrypt.checkpw(password, hash)){

                    HttpSession session = req.getSession();
                    session.setAttribute("adminId", rs.getInt("id"));
                    session.setAttribute("adminName", rs.getString("name"));

                    resp.sendRedirect("AdminDashboardServlet");
                } else {
                    resp.getWriter().println("Wrong admin password!");
                }

            } else {
                resp.getWriter().println("Admin not found!");
            }

        } catch(Exception e){
            resp.getWriter().println("Error: "+e.getMessage());
        }

    }

}
