package com.mycompany.expensetracker.service;

import java.sql.*;

public class AnalyticsService {

    public static double getTotalExpense(Connection con, int userId) throws Exception {
        PreparedStatement pst = con.prepareStatement(
                "SELECT SUM(amount) AS total FROM expenses WHERE user_id=?");
        pst.setInt(1, userId);
        ResultSet rs = pst.executeQuery();
        return rs.next() ? rs.getDouble("total") : 0;
    }

    public static double getMonthlyExpense(Connection con, int userId) throws Exception {
        PreparedStatement pst = con.prepareStatement(
                "SELECT SUM(amount) AS total FROM expenses WHERE user_id=? AND MONTH(date)=MONTH(CURDATE()) AND YEAR(date)=YEAR(CURDATE())");
        pst.setInt(1, userId);
        ResultSet rs = pst.executeQuery();
        return rs.next() ? rs.getDouble("total") : 0;
    }

    public static String getTopCategory(Connection con, int userId) throws Exception {
        PreparedStatement pst = con.prepareStatement(
                "SELECT category, SUM(amount) AS total FROM expenses WHERE user_id=? GROUP BY category ORDER BY total DESC LIMIT 1");
        pst.setInt(1, userId);
        ResultSet rs = pst.executeQuery();
        return rs.next() ? rs.getString("category") : "None";
    }

    public static double getLastMonthExpense(Connection con, int userId) throws Exception {
        PreparedStatement pst = con.prepareStatement(
                "SELECT SUM(amount) AS total FROM expenses WHERE user_id=? AND MONTH(date)=MONTH(CURDATE()-INTERVAL 1 MONTH) AND YEAR(date)=YEAR(CURDATE()-INTERVAL 1 MONTH)");
        pst.setInt(1, userId);
        ResultSet rs = pst.executeQuery();
        return rs.next() ? rs.getDouble("total") : 0;
    }

    public static double getDailyAverage(Connection con, int userId) throws Exception {
        PreparedStatement pst = con.prepareStatement(
                "SELECT SUM(amount)/COUNT(DISTINCT date) AS avg FROM expenses WHERE user_id=?");
        pst.setInt(1, userId);
        ResultSet rs = pst.executeQuery();
        return rs.next() ? rs.getDouble("avg") : 0;
    }
}
