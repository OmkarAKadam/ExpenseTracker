package com.mycompany.expensetracker.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;
import com.mycompany.expensetracker.config.DBConnection;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;

public class GenerateReportServlet extends HttpServlet {

    private PdfPCell cell(String txt) {
        PdfPCell c = new PdfPCell(new Phrase(txt == null ? "" : txt));
        c.setPadding(6);
        c.setBorderColor(BaseColor.GRAY);
        return c;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        resp.setContentType("application/pdf");
        resp.setHeader("Content-Disposition", "attachment; filename=Admin_Expense_Report.pdf");

        Document doc = new Document(PageSize.A4, 40, 40, 40, 40);

        try {
            PdfWriter.getInstance(doc, resp.getOutputStream());
            doc.open();

            Font titleFont = new Font(Font.FontFamily.HELVETICA, 22, Font.BOLD, new BaseColor(50, 80, 200));
            Font smallFont = new Font(Font.FontFamily.HELVETICA, 11, Font.NORMAL, BaseColor.GRAY);
            Font tableHeader = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD, BaseColor.WHITE);

            Paragraph title = new Paragraph("ADMIN EXPENSE REPORT", titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            title.setSpacingAfter(12f);
            doc.add(title);

            doc.add(new Paragraph("Generated On: " + new java.util.Date(), smallFont));
            doc.add(new Paragraph("Report Type: All Users Overview", smallFont));
            doc.add(new Paragraph("\n"));

            PdfPTable table = new PdfPTable(6);
            table.setWidthPercentage(100);
            table.setSpacingBefore(15f);
            table.setSpacingAfter(15f);
            table.setWidths(new float[]{1f, 1.3f, 1.5f, 1.5f, 1.5f, 3f});

            String[] cols = {"ID", "User ID", "Amount (₹)", "Category", "Date", "Description"};

            for(String col : cols){
                PdfPCell h = new PdfPCell(new Phrase(col, tableHeader));
                h.setBackgroundColor(new BaseColor(60, 100, 230));
                h.setHorizontalAlignment(Element.ALIGN_CENTER);
                h.setPadding(7);
                h.setBorderColor(BaseColor.GRAY);
                table.addCell(h);
            }

            Connection con = DBConnection.getConnection();
            PreparedStatement pst = con.prepareStatement(
                "SELECT id, user_id, amount, category, date, description FROM expenses ORDER BY id DESC"
            );
            ResultSet rs = pst.executeQuery();

            double total = 0;
            boolean hasData = false;

            while(rs.next()){
                hasData = true;
                table.addCell(cell(String.valueOf(rs.getInt("id"))));
                table.addCell(cell(String.valueOf(rs.getInt("user_id"))));
                table.addCell(cell("₹ " + rs.getDouble("amount")));
                table.addCell(cell(rs.getString("category")));
                table.addCell(cell(String.valueOf(rs.getDate("date"))));
                table.addCell(cell(rs.getString("description")));
                total += rs.getDouble("amount");
            }

            if(!hasData){
                PdfPCell noData = new PdfPCell(new Phrase("No Data Available"));
                noData.setPadding(10);
                noData.setHorizontalAlignment(Element.ALIGN_CENTER);
                noData.setColspan(6);
                table.addCell(noData);
            }

            doc.add(table);

            Paragraph summary = new Paragraph("Total Expenses (All Users): ₹ " + total,
                    new Font(Font.FontFamily.HELVETICA, 14, Font.BOLD));
            summary.setSpacingBefore(10f);
            summary.setSpacingAfter(30f);
            doc.add(summary);

            Paragraph footer = new Paragraph("Generated via Expense Tracker Admin Panel",
                    new Font(Font.FontFamily.HELVETICA, 9, Font.ITALIC, BaseColor.GRAY));
            footer.setAlignment(Element.ALIGN_CENTER);
            doc.add(footer);

            doc.close();

        } catch (Exception e) {
            resp.getWriter().println("Error: " + e.getMessage());
        }
    }
}
