package com.mycompany.expensetracker.servlets;

import com.mycompany.expensetracker.config.DBConnection;
import com.mycompany.expensetracker.util.EmailUtil;
import java.io.IOException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
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

            String msg =
                "<h2>Password Reset Request</h2>" +
                "<p>We received a request to reset your ExpenseTracker account password.</p>" +
                "<p><b>Your OTP Code:</b></p>" +
                "<h1 style='color:#007bff;'>" + otp + "</h1>" +
                "<p>Enter this OTP in the verification page to reset your password.</p>" +
                "<p style='color:red;'>Do not share this code with anyone.</p>" +
                "<br>" +
                "<p>Regards,<br><b>ExpenseTracker Team</b></p>";

            EmailUtil.sendHTML(email,"Password Reset OTP",msg);

            HttpSession s = req.getSession();
            s.setAttribute("resetEmail", email);

            resp.sendRedirect("verify-reset.jsp?status=sent");

        }catch(Exception e){resp.getWriter().println("Error:"+e);}
    }
}
