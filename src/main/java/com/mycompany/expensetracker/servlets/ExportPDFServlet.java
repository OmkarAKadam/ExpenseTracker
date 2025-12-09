package com.mycompany.expensetracker.servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import com.mycompany.expensetracker.config.DBConnection;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;

public class ExportPDFServlet extends HttpServlet {
    private PdfPCell createCell(String text) {
        PdfPCell cell = new PdfPCell(new Phrase(text == null ? "" : text));
        cell.setPadding(6);
        cell.setBorderColor(BaseColor.LIGHT_GRAY);
        return cell;
    }
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        resp.setContentType("application/pdf");
        resp.setHeader("Content-Disposition", "attachment; filename=Expense_Report.pdf");

        try {
            Document document = new Document(PageSize.A4, 40, 40, 40, 40);
            PdfWriter.getInstance(document, resp.getOutputStream());
            document.open();

            Font titleFont = new Font(Font.FontFamily.HELVETICA, 22, Font.BOLD, new BaseColor(50, 80, 200));
            Font smallFont = new Font(Font.FontFamily.HELVETICA, 11, Font.NORMAL, BaseColor.GRAY);
            Font tableHeader = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD, BaseColor.WHITE);

            Paragraph title = new Paragraph("EXPENSE REPORT", titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            title.setSpacingAfter(10f);
            document.add(title);

            document.add(new Paragraph("User: " + session.getAttribute("userName"), smallFont));
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
                cell.setBorderColor(BaseColor.GRAY);
                table.addCell(cell);
            }

            Connection con = DBConnection.getConnection();
            PreparedStatement pst = con.prepareStatement("SELECT * FROM expenses WHERE user_id=?");
            pst.setInt(1, userId);
            ResultSet rs = pst.executeQuery();

            double total = 0;
            while (rs.next()) {
                table.addCell(createCell(String.valueOf(rs.getInt("id"))));
                table.addCell(createCell("₹ " + rs.getDouble("amount")));
                table.addCell(createCell(rs.getString("category")));
                table.addCell(createCell(rs.getString("date")));
                table.addCell(createCell(rs.getString("description")));
                total += rs.getDouble("amount");
            }

            document.add(table);

            Paragraph summary = new Paragraph("Total Expense: ₹ " + total,
                    new Font(Font.FontFamily.HELVETICA, 14, Font.BOLD));
            summary.setSpacingBefore(5f);
            summary.setSpacingAfter(30f);
            document.add(summary);

            Paragraph footer = new Paragraph("Generated via Expense Tracker • Page 1",
                    new Font(Font.FontFamily.HELVETICA, 9, Font.ITALIC, BaseColor.GRAY));
            footer.setAlignment(Element.ALIGN_CENTER);
            footer.setSpacingBefore(50f);
            document.add(footer);

            document.close();

        } catch (DocumentException | IOException | SQLException e) {
            resp.getWriter().println("Error: " + e.getMessage());
        }
    }
}
