package com.mycompany.expensetracker.tasks;

import com.mycompany.expensetracker.config.DBConnection;
import com.mycompany.expensetracker.util.EmailUtil;
import com.mycompany.expensetracker.util.PDFGenerator;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class WeeklyReportTask extends java.util.TimerTask {

    @Override
    public void run() {
        System.out.println("📅 Weekly Expense Report Task Started...");

        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement users = con.prepareStatement(
                    "SELECT id, email, name FROM users WHERE role='USER'"
            );
            ResultSet userList = users.executeQuery();

            while (userList.next()) {

                int userId = userList.getInt("id");
                String email = userList.getString("email");
                String name = userList.getString("name");

                String filePath = PDFGenerator.generate(userId);

                String message =
                        "<h2>Weekly Expense Report</h2>" +
                        "<p>Hello <b>" + name + "</b>,</p>" +
                        "<p>Your weekly expense report is attached below.</p>" +
                        "<ul>" +
                            "<li>Review your spending habits</li>" +
                            "<li>Track category-wise expenses</li>" +
                            "<li>Stay consistent & improve financial discipline</li>" +
                        "</ul>" +
                        "<p>Keep budgeting smart.<br><br>Regards,<br><b>ExpenseTracker Team</b></p>";

                EmailUtil.sendAttachment(
                        email,
                        "Weekly Expense Report",
                        message,
                        filePath
                );

                System.out.println("📤 Sent weekly report to: " + email);
            }

        } catch (Exception e) {
            System.err.println("❌ Weekly Report Failed: " + e.getMessage());
        }
    }
}
