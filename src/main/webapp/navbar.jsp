<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<html>
<head>
    <title>Navigation</title>
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            margin: 0;
            padding: 0;
            background: linear-gradient(to bottom right, #e0eafc, #cfdef3);
        }

        /* Modern Navbar */
        .navbar {
            background-color: #2c3e50;
            border-radius: 15px;
            padding: 20px;
            width: 70%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            position: absolute;
            top: 20px;
            left: 50%;
            transform: translateX(-50%);
        }

        .navbar .links {
            display: flex;
            gap: 30px;
        }

        .navbar a {
            text-decoration: none;
            color: #ecf0f1;
            font-size: 16px;
            padding: 10px 20px;
            border-radius: 20px;
            transition: background-color 0.3s ease;
        }

        .navbar a:hover {
            background-color: #1abc9c;
            color: #fff;
        }

        /* Profile Section */
        .profile {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .profile img {
            border-radius: 50%;
            width: 45px;
            height: 45px;
        }

        .profile span {
            color: #ecf0f1;
            font-size: 18px;
        }
    </style>
</head>
<body>
    <%
        // Get logged-in user's username from session
        String username = (String) session.getAttribute("username");
        String profilePhotoPath = "dp.png"; // Default profile photo path for all users

        if (username == null) {
            // If session expired or not found, redirect to login page
            response.sendRedirect("login-signup.html");
        }
    %>

    <!-- Navigation Bar -->
    <div class="navbar">
        <div class="links">
            <a href="home.jsp">Home</a>
            <a href="profile.jsp">Profile</a>
            <a href="settings.jsp">Settings</a>
            <a href="LogoutServlet">Logout</a>
        </div>

        <!-- User Profile -->
        <div class="profile">
            <img src="<%= profilePhotoPath %>" alt="Profile Photo">
            <span><%= username %></span>
        </div>
    </div>
</body>
</html>
