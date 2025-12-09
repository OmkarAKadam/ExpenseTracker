package com.mycompany.expensetracker.tasks;

import com.mycompany.expensetracker.config.DBConnection;
import com.mycompany.expensetracker.util.EmailUtil;
import com.mycompany.expensetracker.util.PDFGenerator;
import java.sql.*;

public class WeeklyReportTask extends java.util.TimerTask {

    @Override
    public void run() {
        System.out.println("📅 Weekly Expense Report Task Started...");

        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement users = con.prepareStatement("SELECT id, email, name FROM users WHERE role='USER'");
            ResultSet userList = users.executeQuery();

            while (userList.next()) {

                int userId = userList.getInt("id");
                String email = userList.getString("email");
                String name = userList.getString("name");

                String filePath = PDFGenerator.generate(userId); 

                EmailUtil.sendEmailWithAttachment(
                        email,
                        "Weekly Expense Report",
                        "Hello " + name + ",\n\nHere is your weekly expense report.\nStay consistent with your spending.\n\nRegards,\nExpense Tracker",
                        filePath
                );

                System.out.println("📤 Sent weekly report to: " + email);
            }

        } catch (Exception e) {
            System.err.println("❌ Weekly Report Failed: " + e.getMessage());
        }
    }
}
