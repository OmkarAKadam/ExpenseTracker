package com.mycompany.expensetracker.servlets;

import com.mycompany.expensetracker.config.DBConnection;
import com.mycompany.expensetracker.util.EmailUtil;
import jakarta.servlet.http.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.*;
import java.sql.*;


@WebServlet("/EmailCSVTestServlet")
public class EmailCSVTestServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if(session == null || session.getAttribute("userId") == null){
            resp.sendRedirect("login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String email = (String) session.getAttribute("email"); 

        String filePath = System.getProperty("user.home") + "/Downloads/expense_"+userId+".csv";

        try(Connection con = DBConnection.getConnection()){

            FileWriter csvWriter = new FileWriter(filePath);
            csvWriter.append("ID,Amount,Category,Date,Description\n");

            PreparedStatement pst = con.prepareStatement("SELECT * FROM expenses WHERE user_id=?");
            pst.setInt(1, userId);
            ResultSet rs = pst.executeQuery();

            boolean dataFound = false;
            while(rs.next()){
                dataFound = true;
                csvWriter.append(rs.getInt("id")+",");
                csvWriter.append(rs.getDouble("amount")+",");
                csvWriter.append(rs.getString("category")+",");
                csvWriter.append(rs.getString("date")+",");
                csvWriter.append(rs.getString("description")+"\n");
            }

            csvWriter.flush();
            csvWriter.close();

            if(!dataFound){
                resp.getWriter().println("No expenses found. Add some first.");
                return;
            }

            EmailUtil.sendEmailWithAttachment(
                email,
                "Expense Tracker CSV Test Mail",
                "Here is your CSV expense report (test).",
                filePath
            );

            resp.getWriter().println("<h2>CSV Sent Successfully to "+email+" ✔</h2>");

        } catch (Exception e){
            resp.getWriter().println("Error: "+e.getMessage());
        }
    }
}
