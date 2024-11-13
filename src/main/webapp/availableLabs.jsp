<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %> <!-- Importing necessary classes -->
<html>
<head>
    <title>Available Labs</title>
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(to bottom right, #e0eafc, #cfdef3);
            margin: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            height: 100vh;
        }

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

        .center-container {
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            width: 100%;
            height: calc(100vh - 80px);
            margin-top: 80px;
        }

        .result-container {
            background-color: #f4f7f9;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            width: 60%;
            max-width: 800px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 10px;
            border: 1px solid #34495e;
            text-align: center;
        }

        th {
            background-color: #34495e;
            color: white;
        }

        td {
            background-color: #ecf0f1;
        }

        h2 {
            text-align: center;
            color: #34495e;
        }

        .message {
            color: red;
            font-weight: bold;
            text-align: center;
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

    <!-- Centering container -->
    <div class="center-container">
        <div class="result-container">
            <h2>Available Labs</h2>

            <%
                String date = request.getParameter("date");
                String day = request.getParameter("day");
                String startTime = request.getParameter("startTime");
                String endTime = request.getParameter("endTime");

                // Display selected date and time details
                out.println("<p><strong>Selected Date:</strong> " + date + "</p>");
                out.println("<p><strong>Day:</strong> " + day + "</p>");
                out.println("<p><strong>Start Time:</strong> " + startTime + "</p>");
                out.println("<p><strong>End Time:</strong> " + endTime + "</p>");

                Connection conn = null;
                PreparedStatement stmt = null;
                ResultSet rsAvailable = null;
                ResultSet rsUnavailable = null;

                try {
                    // Load JDBC driver
                    Class.forName("com.mysql.cj.jdbc.Driver");

                    // Establish connection to the database
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/user_management", "root", "tiger");

                    // SQL query to find all labs
                    String sqlAllLabs = "SELECT DISTINCT lab_number FROM lab_schedule";
                    stmt = conn.prepareStatement(sqlAllLabs);
                    ResultSet rsAllLabs = stmt.executeQuery();

                    // Create a list of all labs
                    List<String> allLabs = new ArrayList<>();
                    while (rsAllLabs.next()) {
                        allLabs.add(rsAllLabs.getString("lab_number"));
                    }

                    // SQL query to find labs that are scheduled during the selected time slot
                    String sqlUnavailable = "SELECT DISTINCT lab_number FROM lab_schedule " +
                                            "WHERE day_of_week = ? " +
                                            "AND ((start_time < ? AND end_time > ?) OR (start_time < ? AND end_time > ?))"; // Check for overlap
                    stmt = conn.prepareStatement(sqlUnavailable);
                    stmt.setString(1, day);
                    stmt.setString(2, endTime);
                    stmt.setString(3, startTime);
                    stmt.setString(4, startTime);
                    stmt.setString(5, endTime);

                    rsUnavailable = stmt.executeQuery();

                    // Create a set of unavailable labs
                    Set<String> unavailableLabs = new HashSet<>();
                    while (rsUnavailable.next()) {
                        unavailableLabs.add(rsUnavailable.getString("lab_number"));
                    }

                    // Prepare the list of available labs
                    List<String> availableLabs = new ArrayList<>();
                    for (String lab : allLabs) {
                        if (!unavailableLabs.contains(lab)) {
                            availableLabs.add(lab);
                        }
                    }

                    // Display available labs
                    if (availableLabs.isEmpty()) {
                        out.println("<p class='message'>No labs available for selected date: " + date + ", day: " + day + ", from " + startTime + " to " + endTime + ".</p>");
                    } else {
                        out.println("<h3>Available Labs:</h3>");
                        out.println("<table><tr><th>Lab Number</th></tr>");
                        for (String labNumber : availableLabs) {
                            out.println("<tr><td>" + labNumber + "</td></tr>");
                        }
                        out.println("</table>");
                    }

                    // Display unavailable labs
                    if (unavailableLabs.isEmpty()) {
                        out.println("<h3>No labs are currently scheduled during this time.</h3>");
                    } else {
                        out.println("<h3>Unavailable Labs:</h3>");
                        out.println("<table><tr><th>Lab Number</th></tr>");
                        for (String labNumber : unavailableLabs) {
                            out.println("<tr><td>" + labNumber + "</td></tr>");
                        }
                        out.println("</table>");
                    }

                } catch (Exception e) {
                    e.printStackTrace(); // Print stack trace for debugging
                    out.println("<p class='message'>An error occurred: " + e.getMessage() + "</p>");
                } finally {
                    if (rsAvailable != null) try { rsAvailable.close(); } catch (SQLException ignore) {}
                    if (rsUnavailable != null) try { rsUnavailable.close(); } catch (SQLException ignore) {}
                    if (stmt != null) try { stmt.close(); } catch (SQLException ignore) {}
                    if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
                }
            %>
        </div>
    </div>
</body>
</html>
