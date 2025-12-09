package com.mycompany.expensetracker.util;

import com.mycompany.expensetracker.config.DBConnection;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;

import java.io.FileOutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class PDFGenerator {

    public static String generate(int userId) throws Exception {

        String filePath = System.getProperty("user.home") + "/Weekly_Report_" + userId + ".pdf";

        Document document = new Document(PageSize.A4, 40, 40, 40, 40);
        PdfWriter.getInstance(document, new FileOutputStream(filePath));
        document.open();

        Font titleFont = new Font(Font.FontFamily.HELVETICA, 22, Font.BOLD, new BaseColor(50, 80, 200));
        Font smallFont = new Font(Font.FontFamily.HELVETICA, 11, Font.NORMAL, BaseColor.GRAY);
        Font tableHeader = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD, BaseColor.WHITE);

        Paragraph title = new Paragraph("WEEKLY EXPENSE REPORT", titleFont);
        title.setAlignment(Element.ALIGN_CENTER);
        title.setSpacingAfter(10f);
        document.add(title);

        document.add(new Paragraph("User ID: " + userId, smallFont));
        document.add(new Paragraph("Generated On: " + new java.util.Date(), smallFont));
        document.add(new Paragraph("\n"));

        PdfPTable table = new PdfPTable(5);
        table.setWidthPercentage(100);
        table.setSpacingBefore(15f);
        table.setSpacingAfter(15f);
        table.setWidths(new float[]{1.2f, 1.8f, 2f, 2f, 3.2f});

        String[] headers = {"ID", "Amount", "Category", "Date", "Description"};
        for (String h : headers) {
            PdfPCell cell = new PdfPCell(new Phrase(h, tableHeader));
            cell.setBackgroundColor(new BaseColor(60, 100, 230));
            cell.setPadding(7);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            table.addCell(cell);
        }

        Connection con = DBConnection.getConnection();
        PreparedStatement pst = con.prepareStatement("SELECT * FROM expenses WHERE user_id=?");
        pst.setInt(1, userId);
        ResultSet rs = pst.executeQuery();

        double total = 0;
        while (rs.next()) {
            table.addCell(String.valueOf(rs.getInt("id")));
            table.addCell("₹ " + rs.getDouble("amount"));
            table.addCell(rs.getString("category"));
            table.addCell(rs.getString("date"));
            table.addCell(rs.getString("description"));
            total += rs.getDouble("amount");
        }

        document.add(table);

        Paragraph summary = new Paragraph("Total Expense: ₹ " + total,
                new Font(Font.FontFamily.HELVETICA, 14, Font.BOLD));
        summary.setSpacingBefore(5f);
        document.add(summary);

        document.close();

        return filePath;
    }
}
