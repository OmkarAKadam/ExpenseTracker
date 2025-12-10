package com.mycompany.expensetracker.util;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.io.File;
import java.util.Properties;

public class EmailUtil {

    private static final String FROM_EMAIL = System.getenv("EMAIL_USER"); 
    private static final String APP_PASSWORD = System.getenv("EMAIL_PASS");

    private static Session getSession() {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp-relay.brevo.com");
        props.put("mail.smtp.port", "587");

        return Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(
                    System.getenv("EMAIL_USER"),
                    System.getenv("EMAIL_PASS")
                );
            }
        });
    }


    public static void sendMail(String to, String subject, String otp) throws Exception {
        Message message = new MimeMessage(getSession());
        message.setFrom(new InternetAddress(FROM_EMAIL));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
        message.setSubject(subject);

        String body =
                "Hello,\n\n" +
                "Welcome to ExpenseTracker!\n\n" +
                "Your verification code is:\n" +
                "🔐 OTP: " + otp + "\n\n" +
                "Valid for one-time use.\n" +
                "Do not share it with anyone.\n\n" +
                "Regards,\nExpenseTracker Team";

        message.setText(body);

        Transport.send(message);
        System.out.println("📧 OTP email sent to: " + to);
    }

    public static void sendHTML(String to, String subject, String htmlContent) throws Exception {
        Message message = new MimeMessage(getSession());
        message.setFrom(new InternetAddress(FROM_EMAIL));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
        message.setSubject(subject);

        message.setContent(htmlContent, "text/html; charset=utf-8");
        Transport.send(message);

        System.out.println("📩 HTML Email Sent → " + to);
    }

    public static void sendEmailWithAttachment(String to, String subject, String htmlContent, String filePath)
            throws Exception {

        Message message = new MimeMessage(getSession());
        message.setFrom(new InternetAddress(FROM_EMAIL));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
        message.setSubject(subject);

        MimeBodyPart textPart = new MimeBodyPart();
        textPart.setContent(htmlContent, "text/html; charset=utf-8");

        MimeBodyPart attachment = new MimeBodyPart();
        attachment.attachFile(new File(filePath));

        Multipart multipart = new MimeMultipart();
        multipart.addBodyPart(textPart);
        multipart.addBodyPart(attachment);

        message.setContent(multipart);

        Transport.send(message);
        System.out.println("📄 HTML Email + Attachment Sent → " + to);
    }
}
