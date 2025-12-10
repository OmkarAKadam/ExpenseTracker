package com.mycompany.expensetracker.servlets;

import com.mycompany.expensetracker.util.EmailUtil;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/testEmail")
public class TestEmailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {

        try {
            // CHANGE THIS EMAIL TO YOUR OWN
            EmailUtil.sendMail(
                    "YOUR_EMAIL_HERE@gmail.com",
                    "SMTP Live Test",
                    "If you received this, email service is working."
            );

            resp.setContentType("text/plain");
            resp.getWriter().println("✔ Email Sent Successfully. Check your inbox.");

        } catch (Exception e) {
            resp.setContentType("text/plain");
            resp.getWriter().println("❌ Failed: " + e.getMessage());
        }
    }
}
