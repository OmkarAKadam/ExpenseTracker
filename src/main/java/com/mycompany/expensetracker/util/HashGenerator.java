package com.mycompany.expensetracker.util;
import org.mindrot.jbcrypt.BCrypt;

public class HashGenerator {
    public static void main(String[] args) {
        String password = "AZKaizenki572*";
        String hash = BCrypt.hashpw(password, BCrypt.gensalt());
        System.out.println("Hashed Password: " + hash);
    }
}
