<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<html>
<head>
    <title>Timetable for Classroom/Lab</title>
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

        /* Container for the timetable */
        .container {
            margin: 150px auto;
            padding: 20px;
            width: 70%;
            background-color: #fff;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            border-radius: 15px;
        }

        /* Center the table */
        .timetable {
            width: 100%;
            border-collapse: collapse;
            margin: 0 auto;
        }

        .timetable th, .timetable td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: center;
        }

        .timetable th {
            background-color: #1abc9c;
            color: #fff;
        }

        .timetable tr:nth-child(even) {
            background-color: #f2f2f2;
        }

        .timetable tr:hover {
            background-color: #ddd;
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

    <!-- Timetable Container -->
    <div class="container">
        <h3>Timetable for <%= (request.getParameter("type").equals("classroom") ? "Classroom " : "Lab ") + request.getParameter("id") %></h3>
        <table class="timetable">
            <%
                Connection conn = null;
                Statement stmt = null;
                ResultSet rs = null;
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/user_management", "root", "tiger");

                    String type = request.getParameter("type");
                    String id = request.getParameter("id");
                    String sql = "";

                    if ("classroom".equals(type)) {
                        sql = "SELECT day_of_week, start_time, end_time, lab_subject, lab_number FROM lab_schedule WHERE class_id = " + id + " ORDER BY FIELD(day_of_week, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'), start_time";
                    } else if ("lab".equals(type)) {
                        sql = "SELECT day_of_week, start_time, end_time, lab_subject, class_name FROM lab_schedule WHERE lab_number = '" + id + "' ORDER BY FIELD(day_of_week, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'), start_time";
                    }

                    stmt = conn.createStatement();
                    rs = stmt.executeQuery(sql);

                    // Table headers
                    if ("lab".equals(type)) {
                        out.println("<tr><th>Day</th><th>Start Time</th><th>End Time</th><th>Subject</th><th>Class Name</th></tr>");
                    } else {
                        out.println("<tr><th>Day</th><th>Start Time</th><th>End Time</th><th>Subject</th><th>Lab Number</th></tr>");
                    }

                    // Table rows
                    while (rs.next()) {
                        out.println("<tr>");
                        out.println("<td>" + rs.getString("day_of_week") + "</td>");
                        out.println("<td>" + rs.getTime("start_time") + "</td>");
                        out.println("<td>" + rs.getTime("end_time") + "</td>");
                        out.println("<td>" + rs.getString("lab_subject") + "</td>");

                        if ("classroom".equals(type)) {
                            out.println("<td>" + rs.getString("lab_number") + "</td>");
                        } else if ("lab".equals(type)) {
                            out.println("<td>" + rs.getString("class_name") + "</td>");
                        }

                        out.println("</tr>");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                    if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                    if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                }
            %>
        </table>
    </div>
</body>
</html>
