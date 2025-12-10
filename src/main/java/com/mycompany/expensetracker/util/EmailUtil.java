package com.mycompany.expensetracker.util;

import okhttp3.*;
import org.json.JSONArray;
import org.json.JSONObject;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Base64;

public class EmailUtil {

    private static final String API_KEY = System.getenv("BREVO_API_KEY");
    private static final String SENDER = System.getenv("BREVO_SENDER");

    private static final OkHttpClient client = new OkHttpClient();

    public static void sendOtp(String to, String name, int otp) throws Exception {
        OkHttpClient client = new OkHttpClient();

        JSONObject data = new JSONObject();
        data.put("sender", new JSONObject().put("email", SENDER).put("name", "ExpenseTracker"));
        data.put("to", new JSONArray().put(new JSONObject().put("email", to)));
        data.put("subject", "Your ExpenseTracker OTP");
        data.put("htmlContent",
                "<div style='font-family:Arial;padding:15px'>"
                + "<h2>Verification Code</h2>"
                + "<p>Hello <b>"+name+"</b>,</p>"
                + "<p>Your OTP is:</p>"
                + "<h1 style='color:#28a745'>"+otp+"</h1>"
                + "<p>Valid for 10 minutes.</p>"
                + "<p><b>Don't share with anyone</b></p>"
                + "</div>"
        );

        Request request = new Request.Builder()
                .url("https://api.brevo.com/v3/smtp/email")
                .addHeader("api-key", API_KEY)
                .addHeader("Content-Type", "application/json")
                .post(RequestBody.create(data.toString(), MediaType.parse("application/json")))
                .build();

        Response response = client.newCall(request).execute();
        System.out.println("📩 OTP Email => "+response.code()+" | "+response.message());
    }


    public static void sendMail(String to, String subject, String message) throws Exception {
        okhttp3.OkHttpClient client = new okhttp3.OkHttpClient();

        org.json.JSONObject data = new org.json.JSONObject();
        data.put("sender", new org.json.JSONObject().put("email", SENDER).put("name", "ExpenseTracker"));
        data.put("to", new org.json.JSONArray().put(new org.json.JSONObject().put("email", to)));
        data.put("subject", subject);
        data.put("htmlContent", "<p>" + message + "</p>");

        okhttp3.Request request = new okhttp3.Request.Builder()
                .url("https://api.brevo.com/v3/smtp/email")
                .addHeader("api-key", API_KEY)
                .addHeader("Content-Type", "application/json")
                .post(okhttp3.RequestBody.create(data.toString(), okhttp3.MediaType.parse("application/json")))
                .build();

        okhttp3.Response response = client.newCall(request).execute();
        System.out.println("📩 Email Sent Response => " + response.code() + " | " + response.message());
    }
    
    public static void sendOtpReset(String to, int otp) throws Exception {

        OkHttpClient client = new OkHttpClient();

        JSONObject data = new JSONObject();
        data.put("sender", new JSONObject().put("email", SENDER).put("name", "ExpenseTracker"));
        data.put("to", new JSONArray().put(new JSONObject().put("email", to)));
        data.put("subject", "Password Reset OTP");
        data.put("htmlContent",
                "<h2>Password Reset Request</h2>"
                + "<p>We received a request to reset your account password.</p>"
                + "<h1 style='color:#007bff'>" + otp + "</h1>"
                + "<p>Enter this OTP to continue.<br><b>Valid for one time use.</b></p>"
                + "<p style='color:red'>Do NOT share this code.</p>"
                + "<br><b>- ExpenseTracker Team</b>"
        );

        Request request = new Request.Builder()
                .url("https://api.brevo.com/v3/smtp/email")
                .addHeader("api-key", API_KEY)
                .addHeader("Content-Type", "application/json")
                .post(RequestBody.create(data.toString(), MediaType.parse("application/json")))
                .build();

        Response response = client.newCall(request).execute();
        System.out.println("📩 Password Reset Email => " + response.code()+" | "+response.message());
    }

    public static void sendAttachment(String to, String subject, String htmlContent, String filePath) throws Exception {
        byte[] fileBytes = Files.readAllBytes(Paths.get(filePath));
        String base64File = Base64.getEncoder().encodeToString(fileBytes);

        JSONObject attachment = new JSONObject()
                .put("content", base64File)
                .put("name", Paths.get(filePath).getFileName().toString())
                .put("type", "application/pdf");

        JSONObject body = new JSONObject()
                .put("sender", new JSONObject().put("email", SENDER).put("name", "Expense Tracker"))
                .put("to", new JSONArray().put(new JSONObject().put("email", to)))
                .put("subject", subject)
                .put("htmlContent", htmlContent)
                .put("attachment", new JSONArray().put(attachment));

        Request request = new Request.Builder()
                .url("https://api.brevo.com/v3/smtp/email")
                .addHeader("api-key", API_KEY)
                .addHeader("Content-Type", "application/json")
                .post(RequestBody.create(body.toString(), MediaType.parse("application/json")))
                .build();

        Response response = client.newCall(request).execute();
        System.out.println("📄 EMAIL WITH ATTACHMENT → " + response.code() + " " + response.message());
    }
}
