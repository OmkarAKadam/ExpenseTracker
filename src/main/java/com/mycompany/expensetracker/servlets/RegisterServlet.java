package com.mycompany.expensetracker.servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import org.mindrot.jbcrypt.BCrypt;
import com.mycompany.expensetracker.config.DBConnection;
import com.mycompany.expensetracker.util.EmailUtil;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String name = req.getParameter("name").trim();
        String email = req.getParameter("email").trim();
        String password = req.getParameter("password").trim();

        if(name.isEmpty() || email.isEmpty() || password.isEmpty()){
            resp.getWriter().println("Invalid input");
            return;
        }

        try(Connection con = DBConnection.getConnection()) {

            PreparedStatement check = con.prepareStatement("SELECT email FROM users WHERE email=?");
            check.setString(1, email);
            ResultSet rs = check.executeQuery();

            if(rs.next()){
                resp.sendRedirect("register.jsp?status=exists");
                return;
            }

            String hashed = BCrypt.hashpw(password, BCrypt.gensalt());
            int otp = (int)(Math.random()*900000) + 100000;

            PreparedStatement pst = con.prepareStatement(
                "INSERT INTO users(name,email,password,otp,verified) VALUES(?,?,?,?,0)"
            );
            pst.setString(1, name);
            pst.setString(2, email);
            pst.setString(3, hashed);
            pst.setInt(4, otp);
            pst.executeUpdate();

            EmailUtil.sendMail(
                email,
                "ExpenseTracker Email Verification",
                "Hi "+name+",\nYour OTP is: "+otp+"\nDo not share it."
            );

            HttpSession session = req.getSession();
            session.setAttribute("email", email);

            resp.sendRedirect("verify-otp.jsp");

        } catch (Exception e){
            resp.sendRedirect("register.jsp?status=error");
        }
    }
}
