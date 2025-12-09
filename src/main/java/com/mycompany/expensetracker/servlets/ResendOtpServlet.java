package com.mycompany.expensetracker.servlets;

import com.mycompany.expensetracker.config.DBConnection;
import com.mycompany.expensetracker.util.EmailUtil;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/ResendOtpServlet")
public class ResendOtpServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {

        HttpSession session = req.getSession();
        String email = (String) session.getAttribute("email");

        if(email == null){
            resp.sendRedirect("register.jsp");
            return;
        }

        int otp = (int)(Math.random() * 900000) + 100000;

        try(Connection con = DBConnection.getConnection()){
            PreparedStatement pst = con.prepareStatement("UPDATE users SET otp=? WHERE email=?");
            pst.setInt(1, otp);
            pst.setString(2, email);
            pst.executeUpdate();

            EmailUtil.sendMail(email, "New OTP", "Your new OTP is: " + otp);

            resp.sendRedirect("verify-otp.jsp?status=sent");

        }catch(Exception e){
            resp.getWriter().println("Error: " + e.getMessage());
        }
    }
}
