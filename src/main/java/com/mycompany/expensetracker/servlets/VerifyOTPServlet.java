package com.mycompany.expensetracker.servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import com.mycompany.expensetracker.config.DBConnection;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/VerifyOtpServlet")
public class VerifyOtpServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String otp = req.getParameter("otp").trim();
        HttpSession session = req.getSession(false);

        if(session == null || session.getAttribute("email") == null){
            resp.sendRedirect("register.jsp?sessionExpired=1");
            return;
        }

        String email = session.getAttribute("email").toString();

        try(Connection con = DBConnection.getConnection()){

            PreparedStatement pst = con.prepareStatement(
                "SELECT otp FROM users WHERE email=?"
            );
            pst.setString(1, email);
            ResultSet rs = pst.executeQuery();

            if(rs.next() && rs.getString("otp").equals(otp)){
                System.out.println("⚠ OTP Verified — updating user role & status");
                PreparedStatement update = con.prepareStatement(
                    "UPDATE users SET verified=1, otp=NULL, role='USER' WHERE email=?"
                );
                update.setString(1, email);
                update.executeUpdate();

                session.removeAttribute("email");
                resp.sendRedirect("login.jsp?verified=1");

            } else {
                resp.sendRedirect("verify-otp.jsp?invalidOtp=1");
            }

        } catch(Exception e){
            resp.sendRedirect("verify-otp.jsp?error=1");
        }
    }
}
