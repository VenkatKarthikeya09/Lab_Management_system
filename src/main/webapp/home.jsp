<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<html>
<head>
    <title>Home</title>
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            margin: 0;
            padding: 0;
            background: linear-gradient(to bottom right, #e0eafc, #cfdef3);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            overflow: hidden;
        }

        .main-container {
            background-color: #f4f7f9;
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            width: 70%;
            display: flex;
            justify-content: center;
            align-items: center;
            flex-direction: column;
            margin-top: 105px; /* Increased from 50px to 70px to create more space */
        }

        /* Flexbox for Centering Containers */
        .container {
            display: flex;
            gap: 40px; /* Spacing between the boxes */
            justify-content: center;
            align-items: center;
            flex-wrap: wrap; /* Wrap boxes in case of overflow */
            margin-bottom: 30px; /* Add space below each container */
        }

        /* Box Styling */
        .box {
            width: 300px;
            height: 200px;
            background-color: #34495e; /* Darker shade matching the navbar */
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            display: flex;
            justify-content: center;
            align-items: center;
            text-align: center;
            padding: 20px;
            cursor: pointer;
            transition: transform 0.3s ease, background-color 0.3s ease;
            text-decoration: none; /* Remove underline */
            background: linear-gradient(to right, #34495e, #2c3e50); /* Dark gradient */
        }

        /* Different Colors for Boxes */
        .box:nth-child(1) {
            background: linear-gradient(to right, #2c3e50, #1abc9c); /* Matching green-blue gradient */
        }

        .box:nth-child(2) {
            background: linear-gradient(to right, #34495e, #16a085); /* Darker green-blue gradient */
        }

        .box:nth-child(3) {
            background: linear-gradient(to right, #2c3e50, #2980b9); /* Blue gradient for Edit Labs */
        }

        .box:nth-child(4) {
            background: linear-gradient(to right, #34495e, #8e44ad); /* Purple gradient for Edit Time Tables */
        }

        /* Hover Effects */
        .box:hover {
            transform: scale(1.1);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15); /* Slightly larger shadow on hover */
        }

        /* Box Title Styling */
        .box h2 {
            font-size: 24px;
            color: #ecf0f1; /* Light text color to match the dark box */
        }

        /* Remove link underline */
        a {
            text-decoration: none; /* Remove underline from links */
        }

        /* Mobile Responsive Design */
        @media (max-width: 768px) {
            .container {
                flex-direction: column;
                gap: 20px;
            }
        }
    </style>
</head>
<body>
    <%
        String username = (String) session.getAttribute("username");
        String profilePhotoPath = "bg.png";

        if (username == null) {
            response.sendRedirect("login-signup.html");
        }
    %>

    <!-- Include Navbar -->
    <jsp:include page="navbar.jsp"></jsp:include>

    <!-- Main Content Section with a matching color container -->
    <div class="main-container">
        <div class="container">
            <!-- 1st Container: Explore Labs -->
            <a href="exploreLabs.jsp">
                <div class="box">
                    <h2>Explore Labs</h2>
                </div>
            </a>
            <!-- 2nd Container: Explore Time Tables -->
            <a href="exploreTimetables.jsp">
                <div class="box">
                    <h2>Explore Time Tables</h2> <!-- Updated name -->
                </div>
            </a>
        </div>
        <div class="container">
            <!-- 3rd Container: Edit Labs -->
            <a href="editLabs.jsp">
                <div class="box">
                    <h2>Edit Labs & Classes</h2>
                </div>
            </a>
            <!-- 4th Container: Edit Time Tables -->
            <a href="editTimetables.jsp">
                <div class="box">
                    <h2>Edit Time Tables</h2>
                </div>
            </a>   
        </div>
    </div>
</body>
</html>
