package com.mycompany.expensetracker.servlets;

import com.mycompany.expensetracker.config.DBConnection;
import com.mycompany.expensetracker.util.EmailUtil;
import java.io.IOException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.*;

@WebServlet("/SendResetOtpServlet")
public class SendResetOtpServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String email = req.getParameter("email");

        try(Connection con = DBConnection.getConnection()){

            PreparedStatement check = con.prepareStatement("SELECT * FROM users WHERE email=?");
            check.setString(1, email);
            ResultSet rs = check.executeQuery();

            if(!rs.next()){
                resp.sendRedirect("forgot-password.jsp?status=noemail");
                return;
            }

            int otp = (int)(Math.random()*900000)+100000;

            PreparedStatement pst = con.prepareStatement("UPDATE users SET otp=? WHERE email=?");
            pst.setInt(1, otp);
            pst.setString(2, email);
            pst.executeUpdate();

            EmailUtil.sendMail(email,"Password Reset OTP","Your OTP is: "+otp);

            HttpSession s = req.getSession();
            s.setAttribute("resetEmail", email);

            resp.sendRedirect("verify-reset.jsp?status=sent");

        }catch(Exception e){resp.getWriter().println("Error:"+e);}
    }
}
