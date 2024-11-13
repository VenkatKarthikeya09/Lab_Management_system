//package com.example;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/SignupServlet")
public class SignupServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve form parameters
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");

        // Initialize response
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            // Load MySQL JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish a connection to the database
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/user_management", "root", "tiger");

            // Check if the username already exists
            String checkUserSql = "SELECT * FROM users WHERE username = ?";
            ps = conn.prepareStatement(checkUserSql);
            ps.setString(1, username);
            rs = ps.executeQuery();

            if (rs.next()) {
                // Username already exists
                response.sendRedirect("signup-failed.jsp?error=duplicate");
            } else {
                // SQL query to insert user data
                String sql = "INSERT INTO users (username, email, password) VALUES (?, ?, ?)";
                ps = conn.prepareStatement(sql);
                ps.setString(1, username);
                ps.setString(2, email);
                ps.setString(3, password); // Ideally, you should hash the password before saving

                // Execute the update
                int rowsInserted = ps.executeUpdate();
                if (rowsInserted > 0) {
                    // Redirect to signup success page
                    response.sendRedirect("signup-success.jsp?username=" + username);
                } else {
                    response.sendRedirect("signup-failed.jsp?error=insert");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("signup-failed.jsp?error=exception");
        } finally {
            // Close resources
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
            out.close();
        }
    }
}
