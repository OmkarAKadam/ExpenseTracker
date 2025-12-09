package com.mycompany.expensetracker.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;
import com.mycompany.expensetracker.config.DBConnection;

@WebServlet("/UpdateProfileServlet")
@MultipartConfig(
        maxFileSize = 1024 * 1024 * 2,      // 2MB
        maxRequestSize = 1024 * 1024 * 5    // 5MB
)
public class UpdateProfileServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if(session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String name = req.getParameter("name");
        String email = req.getParameter("email");

        if(name == null || name.trim().isEmpty() || email == null || email.trim().isEmpty()) {
            resp.sendRedirect("profile.jsp?error=Invalid input");
            return;
        }

        Part filePart = req.getPart("photo");
        String fileName = null;

        if(filePart != null && filePart.getSize() > 0) {
            String ext = filePart.getSubmittedFileName().substring(filePart.getSubmittedFileName().lastIndexOf(".")).toLowerCase();

            if(!ext.equals(".jpg") && !ext.equals(".jpeg") && !ext.equals(".png")) {
                resp.sendRedirect("profile.jsp?error=Invalid file type");
                return;
            }

            fileName = System.currentTimeMillis() + ext;

            String uploadPath = req.getServletContext().getRealPath("/uploads/");
            File dir = new File(uploadPath);
            if(!dir.exists()) dir.mkdirs();

            filePart.write(uploadPath + File.separator + fileName);
        }

        try(Connection con = DBConnection.getConnection()) {

            String sql = (fileName != null)
                    ? "UPDATE users SET name=?, email=?, photo=? WHERE id=?"
                    : "UPDATE users SET name=?, email=? WHERE id=?";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, name);
            ps.setString(2, email);

            if(fileName != null) {
                ps.setString(3, fileName);
                ps.setInt(4, userId);
            } else {
                ps.setInt(3, userId);
            }

            ps.executeUpdate();

            session.setAttribute("userName", name);
            session.setAttribute("userEmail", email);
            if(fileName != null) session.setAttribute("userPhoto", fileName);

            resp.sendRedirect("ProfileServlet?updated=1");

        } catch(Exception e) {
            resp.sendRedirect("profile.jsp?error=Update failed");
        }
    }
}
