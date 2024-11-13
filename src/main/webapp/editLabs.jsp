<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<html>
<head>
    <title>Edit Labs and Classes</title>
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            margin: 0;
            padding: 0;
            background: linear-gradient(to bottom right, #e0eafc, #cfdef3);
            display: flex;
            flex-direction: column;
        }

        /* Navbar styles */
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

        .container {
            background-color: #f4f7f9;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            width: 70%;
            margin: 20px auto;
            margin-top: 120px;
        }

        h2 {
            text-align: center;
            color: #34495e;
            margin-bottom: 30px;
        }

        .form-group {
            margin-bottom: 30px;
        }

        .form-group label {
            display: block;
            margin-bottom: 10px;
            font-weight: bold;
        }

        .form-group input, .form-group select {
            width: 100%;
            padding: 12px;
            border-radius: 8px;
            border: 1px solid #ccc;
            margin-bottom: 20px;
        }

        .form-group button {
            padding: 12px;
            border: none;
            background-color: #34495e;
            color: white;
            border-radius: 8px;
            cursor: pointer;
            width: 100%;
            font-size: 16px;
        }

        .form-group button:hover {
            background-color: #2c3e50;
        }

        .message {
            margin-top: 10px;
            text-align: center;
            font-weight: bold;
        }

        .success {
            color: #2ecc71;
        }

        .error {
            color: #e74c3c;
        }

        /* Spacing between sections */
        .section-container {
            margin-bottom: 40px;
            border: 1px solid #ccc;
            border-radius: 10px;
            padding: 20px;
        }

    </style>
</head>
<body>
    <%
        String username = (String) session.getAttribute("username");
        String profilePhotoPath = "dp.png"; // Default profile photo path for all users

        if (username == null) {
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
            <img src="<%= profilePhotoPath %>" alt="Profile Photo" style="height: 40px; width: 40px; border-radius: 50%;">
            <span style="margin-left: 10px;"><%= username %></span>
        </div>
    </div>

    <div class="container">
        <h2>Edit Labs and Classes</h2>

        <%
            Statement stmt = null;
            String labMessage = ""; // Message for lab operations
            String classMessage = ""; // Message for class operations

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/user_management", "root", "tiger");
                stmt = con.createStatement();

                // Create new lab
                if (request.getMethod().equalsIgnoreCase("POST") && request.getParameter("createLab") != null) {
                    String newLabNumber = request.getParameter("lab_number").trim();

                    ResultSet rsLabs = stmt.executeQuery("SELECT COUNT(*) FROM lab_timetable WHERE lab_number = '" + newLabNumber + "'");
                    if (rsLabs.next() && rsLabs.getInt(1) > 0) {
                        labMessage = "Lab number already exists.";
                    } else {
                        stmt.executeUpdate("INSERT INTO lab_timetable (lab_number) VALUES ('" + newLabNumber + "')");
                        labMessage = "Lab " + newLabNumber + " created successfully!";
                    }
                }

                // Delete a lab
                if (request.getMethod().equalsIgnoreCase("POST") && request.getParameter("deleteLab") != null) {
                    String labToDelete = request.getParameter("lab_number").trim();

                    int rowsAffected = stmt.executeUpdate("DELETE FROM lab_timetable WHERE lab_number = '" + labToDelete + "'");
                    if (rowsAffected > 0) {
                        labMessage = "Lab " + labToDelete + " deleted successfully!";
                    } else {
                        labMessage = "Failed to delete lab " + labToDelete + ". It may not exist.";
                    }
                }

                // Create new class
                if (request.getMethod().equalsIgnoreCase("POST") && request.getParameter("createClass") != null) {
                    String className = request.getParameter("class_name").trim();
                    String year = request.getParameter("year");

                    ResultSet rsClasses = stmt.executeQuery("SELECT COUNT(*) FROM classes WHERE class_name = '" + className + "'");
                    if (rsClasses.next() && rsClasses.getInt(1) > 0) {
                        classMessage = "Class name already exists.";
                    } else {
                        stmt.executeUpdate("INSERT INTO classes (class_name, year) VALUES ('" + className + "', " + year + ")");
                        classMessage = "Class " + className + " created successfully!";
                    }
                }

                // Delete a class
                if (request.getMethod().equalsIgnoreCase("POST") && request.getParameter("deleteClass") != null) {
                    String classToDelete = request.getParameter("class_name").trim();

                    int rowsAffected = stmt.executeUpdate("DELETE FROM classes WHERE class_name = '" + classToDelete + "'");
                    if (rowsAffected > 0) {
                        classMessage = "Class " + classToDelete + " deleted successfully!";
                    } else {
                        classMessage = "Failed to delete class " + classToDelete + ". It may not exist.";
                    }
                }

            } catch (Exception e) {
                e.printStackTrace();
                labMessage = "An error occurred: " + e.getMessage();
                classMessage = "An error occurred: " + e.getMessage();
            } finally {
                if (stmt != null) try { stmt.close(); } catch (SQLException e) {}
            }
        %>

        <!-- Labs Section -->
        <div class="section-container">
            <h3>Manage Labs</h3>

            <!-- Create Lab Form -->
            <div class="form-group">
                <form method="post">
                    <label for="lab_number">Create New Lab:</label>
                    <input type="text" id="lab_number" name="lab_number" required>
                    <button type="submit" name="createLab">Create Lab</button>
                </form>
                <div class="message <% out.print(labMessage.contains("successfully") ? "success" : "error"); %>">
                    <%= labMessage %>
                </div>
            </div>

            <!-- Delete Lab Form -->
            <div class="form-group">
                <form method="post">
                    <label for="lab_number">Delete Lab (Enter Lab Number):</label>
                    <input type="text" id="lab_number" name="lab_number" required>
                    <button type="submit" name="deleteLab">Delete Lab</button>
                </form>
                <div class="message <% out.print(labMessage.contains("successfully") ? "success" : "error"); %>">
                    <%= labMessage %>
                </div>
            </div>
        </div>

        <!-- Classes Section -->
        <div class="section-container">
            <h3>Manage Classes</h3>

            <!-- Create Class Form -->
            <div class="form-group">
                <form method="post">
                    <label for="class_name">Create New Class:</label>
                    <input type="text" id="class_name" name="class_name" required>
                    <label for="year">Select Year:</label>
                    <select id="year" name="year" required>
                        <option value="1">1st Year</option>
                        <option value="2">2nd Year</option>
                        <option value="3">3rd Year</option>
                        <option value="4">4th Year</option>
                    </select>
                    <button type="submit" name="createClass">Create Class</button>
                </form>
                <div class="message <% out.print(classMessage.contains("successfully") ? "success" : "error"); %>">
                    <%= classMessage %>
                </div>
            </div>

            <!-- Delete Class Form -->
            <div class="form-group">
                <form method="post">
                    <label for="class_name">Delete Class (Enter Class Name):</label>
                    <input type="text" id="class_name" name="class_name" required>
                    <button type="submit" name="deleteClass">Delete Class</button>
                </form>
                <div class="message <% out.print(classMessage.contains("successfully") ? "success" : "error"); %>">
                    <%= classMessage %>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
