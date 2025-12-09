package com.mycompany.expensetracker.servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import com.mycompany.expensetracker.config.DBConnection;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/VerifyOtpServlet")
public class VerifyOTPServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String otp = req.getParameter("otp").trim();
        HttpSession session = req.getSession();
        String email = (String) session.getAttribute("email");

        if(email == null){
            resp.getWriter().println("Session expired. Register again.");
            return;
        }

        try(Connection con = DBConnection.getConnection()){

            PreparedStatement pst = con.prepareStatement(
                "SELECT otp FROM users WHERE email=? AND verified=0"
            );
            pst.setString(1, email);
            ResultSet rs = pst.executeQuery();

            if(rs.next() && rs.getInt("otp") == Integer.parseInt(otp)){

                PreparedStatement update = con.prepareStatement(
                    "UPDATE users SET verified=1, otp=NULL WHERE email=?"
                );
                update.setString(1, email);
                update.executeUpdate();

                session.removeAttribute("email");
                resp.sendRedirect("login.jsp");

            } else {
                resp.getWriter().println("Invalid OTP!");
            }

        } catch(Exception e){
            resp.getWriter().println("Verification Failed");
        }
    }
}
