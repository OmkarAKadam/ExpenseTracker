package com.mycompany.expensetracker.servlets;

import com.mycompany.expensetracker.config.DBConnection;
import java.io.IOException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.*;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/UpdatePasswordServlet")
public class UpdatePasswordServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req,HttpServletResponse resp)throws IOException{
        String pass=req.getParameter("pass");
        HttpSession s=req.getSession();
        String email=(String)s.getAttribute("resetEmail");

        try(Connection con=DBConnection.getConnection()){
            String hash=BCrypt.hashpw(pass, BCrypt.gensalt());
            PreparedStatement pst=con.prepareStatement("UPDATE users SET password=?,otp=NULL WHERE email=?");
            pst.setString(1,hash);
            pst.setString(2,email);
            pst.executeUpdate();

            s.removeAttribute("resetEmail");
            s.removeAttribute("allowReset");
            resp.sendRedirect("login.jsp?status=reset-done");

        }catch(Exception e){resp.getWriter().println("Error:"+e);}
    }
}
