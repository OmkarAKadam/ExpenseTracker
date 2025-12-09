package com.mycompany.expensetracker.util;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.io.File;
import java.util.Properties;

public class EmailUtil {
    private static final String FROM_EMAIL = "kaizenki572@gmail.com";
    private static final String APP_PASSWORD = "lqjkkqstghabhkcd";

    private static Session getSession() {

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        return Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, APP_PASSWORD);
            }
        });
    }

    public static void sendMail(String to, String subject, String msgText) throws Exception {
        Message message = new MimeMessage(getSession());
        message.setFrom(new InternetAddress(FROM_EMAIL));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
        message.setSubject(subject);
        message.setText(msgText);

        Transport.send(message);
    }

    public static void sendEmailWithAttachment(String to, String subject, String messageText, String filePath)
            throws Exception {

        Message message = new MimeMessage(getSession());
        message.setFrom(new InternetAddress(FROM_EMAIL));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
        message.setSubject(subject);

        MimeBodyPart textPart = new MimeBodyPart();
        textPart.setText(messageText);

        MimeBodyPart attachment = new MimeBodyPart();
        attachment.attachFile(new File(filePath));

        Multipart multipart = new MimeMultipart();
        multipart.addBodyPart(textPart);
        multipart.addBodyPart(attachment);

        message.setContent(multipart);

        Transport.send(message);
    }
}
