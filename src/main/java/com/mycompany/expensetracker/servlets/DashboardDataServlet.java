package com.mycompany.expensetracker.servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import com.mycompany.expensetracker.config.DBConnection;
import com.mycompany.expensetracker.service.AnalyticsService;

public class DashboardDataServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if(session == null || session.getAttribute("userId") == null){
            resp.sendRedirect("login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        try(Connection con = DBConnection.getConnection()){

            req.setAttribute("totalExpense", AnalyticsService.getTotalExpense(con, userId));
            req.setAttribute("monthExpense", AnalyticsService.getMonthlyExpense(con, userId));
            req.setAttribute("topCategory", AnalyticsService.getTopCategory(con, userId));
            req.setAttribute("avgDaily", AnalyticsService.getDailyAverage(con, userId));
            req.setAttribute("lastMonth", AnalyticsService.getLastMonthExpense(con, userId));

            PreparedStatement pst = con.prepareStatement("SELECT budget FROM users WHERE id=?");
            pst.setInt(1, userId);
            ResultSet rsBudget = pst.executeQuery();

            double budget = 0;
            if(rsBudget.next()) budget = rsBudget.getDouble("budget");
            req.setAttribute("budget", budget);

            boolean overLimit = (double) req.getAttribute("monthExpense") > budget && budget > 0;
            req.setAttribute("overLimit", overLimit);

            PreparedStatement ps = con.prepareStatement("SELECT photo FROM users WHERE id=?");
            ps.setInt(1, userId);
            ResultSet rsPhoto = ps.executeQuery();

            String photo = "default.png";
            if(rsPhoto.next() && rsPhoto.getString("photo") != null) {
                photo = rsPhoto.getString("photo");
            }
            req.setAttribute("photo", photo);

            req.getRequestDispatcher("user-dashboard.jsp").forward(req, resp);

        } catch (Exception e){
            resp.getWriter().println("Error: " + e.getMessage());
        }
    }
}
