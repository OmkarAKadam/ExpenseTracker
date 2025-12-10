package com.mycompany.expensetracker.servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import org.mindrot.jbcrypt.BCrypt;
import com.mycompany.expensetracker.config.DBConnection;

public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        try(Connection con = DBConnection.getConnection()){

            PreparedStatement pst = con.prepareStatement("SELECT * FROM users WHERE email=?");
            pst.setString(1, email);

            ResultSet rs = pst.executeQuery();

            if(rs.next()) {

                String dbHashedPassword = rs.getString("password");
                int verified = rs.getInt("verified");

                if(verified == 1 && BCrypt.checkpw(password, dbHashedPassword)) {

                    HttpSession session = req.getSession();
                    session.setAttribute("userId", rs.getInt("id"));
                    session.setAttribute("userName", rs.getString("name"));
                    session.setAttribute("email", rs.getString("email"));
                    session.setAttribute("role", "USER");
                    session.setAttribute("userPhoto", rs.getString("photo"));

                    resp.sendRedirect("DashboardDataServlet");

                } else {
                    resp.sendRedirect("login.jsp?status=invalid");
                }

            } else {
                resp.sendRedirect("login.jsp?status=invalid");
            }

        } catch(Exception e){
            resp.sendRedirect("login.jsp?status=invalid");
        }
    }

}
