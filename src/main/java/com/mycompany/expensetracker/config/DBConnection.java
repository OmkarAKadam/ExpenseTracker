package com.mycompany.expensetracker.config;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static final String URL = "jdbc:mysql://shinkansen.proxy.rlwy.net:36676/railway?useSSL=false&allowPublicKeyRetrieval=true&autoReconnect=true";
    private static final String USER = "root";   
    private static final String PASS = "nHDfjNQOyiodxiEJDkYORklMQslYbUFf";       

    public static Connection getConnection(){
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(URL, USER, PASS);
        } catch (ClassNotFoundException | SQLException e) {
            return null;
        }
    }
}
