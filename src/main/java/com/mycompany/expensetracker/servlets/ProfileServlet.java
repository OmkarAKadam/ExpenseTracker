package com.mycompany.expensetracker.servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;
import com.mycompany.expensetracker.config.DBConnection;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/ProfileServlet")
public class ProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if(session == null || session.getAttribute("userId") == null){
            resp.sendRedirect("login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        try(Connection con = DBConnection.getConnection()){

            PreparedStatement ps = con.prepareStatement(
                "SELECT id,name,email,COALESCE(photo,'') AS photo FROM users WHERE id=?"
            );
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if(rs.next()){
                req.setAttribute("id", rs.getInt("id"));
                req.setAttribute("name", rs.getString("name"));
                req.setAttribute("email", rs.getString("email"));
                req.setAttribute("photo", rs.getString("photo"));
            } 
            else {
                session.invalidate();
                resp.sendRedirect("login.jsp?err=sessionExpired");
                return;
            }

            String page = (req.getParameter("edit") != null) ? "edit-profile.jsp" : "profile.jsp";
            req.getRequestDispatcher(page).forward(req, resp);

        }catch(Exception e){
            e.printStackTrace();
            resp.getWriter().println("Error fetching profile");
        }
    }
}
