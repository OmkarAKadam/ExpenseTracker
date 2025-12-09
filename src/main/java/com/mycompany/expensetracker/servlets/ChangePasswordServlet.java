package com.mycompany.expensetracker.servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.sql.*;
import org.mindrot.jbcrypt.BCrypt;
import com.mycompany.expensetracker.config.DBConnection;

@WebServlet("/ChangePasswordServlet")
public class ChangePasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if(session == null || session.getAttribute("userId") == null){
            resp.sendRedirect("login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        String current = req.getParameter("current");
        String newpass = req.getParameter("newpass");
        String confirm = req.getParameter("confirm");

        if(!newpass.equals(confirm)){
            resp.sendRedirect("change-password.jsp?msg=mismatch");
            return;
        }

        try(Connection con = DBConnection.getConnection()){

            PreparedStatement ps = con.prepareStatement("SELECT password FROM users WHERE id=?");
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if(rs.next()){

                String hashedDB = rs.getString("password");

                if(!BCrypt.checkpw(current, hashedDB)){
                    resp.sendRedirect("change-password.jsp?msg=wrong");
                    return;
                }

                String hashedNew = BCrypt.hashpw(newpass, BCrypt.gensalt());

                PreparedStatement update = con.prepareStatement("UPDATE users SET password=? WHERE id=?");
                update.setString(1, hashedNew);
                update.setInt(2, userId);
                update.executeUpdate();

                session.invalidate();
                resp.sendRedirect("login.jsp?msg=password_changed");
                return;
            }

        } catch(Exception e){
            e.printStackTrace();
            resp.sendRedirect("change-password.jsp?msg=error");
        }
    }
}
