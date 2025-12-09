package com.mycompany.expensetracker.servlets;

import com.mycompany.expensetracker.config.DBConnection;
import java.io.IOException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.*;

@WebServlet("/ResetPasswordServlet")
public class ResetPasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)throws IOException{
        String otp=req.getParameter("otp");
        HttpSession s=req.getSession();
        String email=(String)s.getAttribute("resetEmail");

        try(Connection con=DBConnection.getConnection()){
            PreparedStatement pst=con.prepareStatement("SELECT otp FROM users WHERE email=?");
            pst.setString(1,email);
            ResultSet rs=pst.executeQuery();

            if(rs.next() && rs.getInt("otp")==Integer.parseInt(otp)){
                s.setAttribute("allowReset",true);
                resp.sendRedirect("new-password.jsp");
            } else resp.sendRedirect("verify-reset.jsp?status=wrong");

        }catch(Exception e){resp.getWriter().println("Error:"+e);}
    }
}
