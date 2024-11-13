<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<html>
<head>
    <title>Welcome</title>
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            margin: 0;
            padding: 0;
            background: linear-gradient(to bottom right, #e0eafc, #cfdef3);
        }

        /* Common Styles */
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

        .welcome-container {
            margin-top: 150px;
            text-align: center;
        }

        .welcome-box {
            background-color: white;
            padding: 50px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            display: inline-block;
            width: 80%;
            max-width: 800px;
            margin: 0 auto;
        }

        .welcome-box h1 {
            font-size: 48px;
            color: #34495e;
            margin-bottom: 20px;
        }

        .welcome-box p {
            font-size: 20px;
            color: #7f8c8d;
            margin-top: 0;
        }

        .continue-button {
            margin-top: 30px;
            display: inline-block;
            padding: 15px 30px;
            font-size: 18px;
            color: white;
            background-color: #1abc9c;
            border: none;
            border-radius: 30px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .continue-button:hover {
            background-color: #16a085;
            transform: scale(1.05);
        }
    </style>
</head>
<body>
    <%
        String username = (String) session.getAttribute("username");
        String profilePhotoPath = "default.jpg"; 
        
        if (username != null) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/user_management", "root", "tiger");
                PreparedStatement ps = conn.prepareStatement("SELECT profile_photo FROM users WHERE username = ?");
                ps.setString(1, username);
                ResultSet rs = ps.executeQuery();
                
                if (rs.next()) {
                    profilePhotoPath = rs.getString("profile_photo");
                    if (profilePhotoPath == null || profilePhotoPath.isEmpty()) {
                        profilePhotoPath = "default.jpg";
                    }
                }
                rs.close();
                ps.close();
                conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            response.sendRedirect("login-signup.html");
        }
    %>

    <!-- Include Navbar -->
    <jsp:include page="navbar.jsp"></jsp:include>

    <!-- Welcome Section -->
    <div class="welcome-container">
        <div class="welcome-box">
            <h1>Welcome, <%= username %>!</h1>
            <p>We are glad to have you on board. Explore the options below to get started.</p>

            <!-- Continue Button -->
            <a href="home.jsp">
                <button class="continue-button">Continue ▶</button>
            </a>
        </div>
    </div>
</body>
</html>
