<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<html>
<head>
    <title>Edit Timetables</title>
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

        .container {
            margin-top: 120px; /* Space between navbar and container */
            width: 70%;
            margin-left: auto;
            margin-right: auto;
            background-color: #fff;
            padding: 30px; /* Increased padding for better spacing */
            border-radius: 15px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        h1, h2 {
            margin-top: 20px;
            margin-bottom: 10px;
        }

        form {
            background-color: #f9f9f9; /* Light background for forms */
            padding: 20px; /* Space inside form */
            border-radius: 10px;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px; /* Space between forms */
        }

        label {
            display: block; /* Labels on new lines */
            margin-bottom: 5px; /* Space below labels */
            font-weight: bold; /* Bold labels for emphasis */
        }

        input, select, button {
            width: 100%; /* Full-width inputs and buttons */
            padding: 10px; /* Padding for inputs and buttons */
            margin-bottom: 15px; /* Space between inputs */
            border-radius: 5px;
            border: 1px solid #ccc;
        }

        button {
            background-color: #2c3e50;
            color: #fff;
            cursor: pointer;
            border: none;
            transition: background-color 0.3s ease;
        }

        button:hover {
            background-color: #1abc9c;
        }

        .message {
            margin-top: 20px;
            font-size: 18px;
        }

        .success {
            color: green;
        }

        .error {
            color: red;
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

    <%
        Statement stmt = null;
        String timetableMessage = ""; // Message for timetable operations

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/user_management", "root", "tiger");
            stmt = con.createStatement();

            // Assign class to lab
            if (request.getMethod().equalsIgnoreCase("POST") && request.getParameter("assignClass") != null) {
                String labNumber = request.getParameter("lab_number").trim();
                String className = request.getParameter("class_name").trim();
                String dayOfWeek = request.getParameter("day_of_week");
                String startTime = request.getParameter("start_time");
                String endTime = request.getParameter("end_time");
                String labSubject = request.getParameter("lab_subject");

                boolean isAvailable = true; // To check if the lab is available

                // Check if the lab is free during the requested time
                String checkQuery = "SELECT COUNT(*) FROM lab_timetable WHERE lab_number = ? AND day_of_week = ? " +
                                    "AND ((? >= start_time AND ? <= end_time) OR (? >= start_time AND ? <= end_time))";
                PreparedStatement checkStmt = con.prepareStatement(checkQuery);
                checkStmt.setString(1, labNumber);
                checkStmt.setString(2, dayOfWeek);
                checkStmt.setString(3, startTime);
                checkStmt.setString(4, endTime);
                checkStmt.setString(5, startTime);
                checkStmt.setString(6, endTime);

                ResultSet checkRs = checkStmt.executeQuery();
                if (checkRs.next() && checkRs.getInt(1) > 0) {
                    isAvailable = false; // Lab is not available
                }

                // If the lab is available, proceed with the assignment
                if (isAvailable) {
                    // Get the class_id based on class_name
                    String classIdQuery = "SELECT class_id FROM classes WHERE class_name = ?";
                    PreparedStatement classIdStmt = con.prepareStatement(classIdQuery);
                    classIdStmt.setString(1, className);
                    ResultSet classIdRs = classIdStmt.executeQuery();

                    int classId = -1;
                    if (classIdRs.next()) {
                        classId = classIdRs.getInt("class_id");
                    }

                    if (classId != -1) {
                        // Insert into lab_timetable
                        String insertTimetableQuery = "INSERT INTO lab_timetable (class_id, lab_number, day_of_week, start_time, end_time, lab_subject) " +
                                                       "VALUES (?, ?, ?, ?, ?, ?)";
                        PreparedStatement insertTimetableStmt = con.prepareStatement(insertTimetableQuery);
                        insertTimetableStmt.setInt(1, classId);
                        insertTimetableStmt.setString(2, labNumber);
                        insertTimetableStmt.setString(3, dayOfWeek);
                        insertTimetableStmt.setString(4, startTime);
                        insertTimetableStmt.setString(5, endTime);
                        insertTimetableStmt.setString(6, labSubject);
                        insertTimetableStmt.executeUpdate();

                        // Update or insert into lab_schedule
                        String insertScheduleQuery = "INSERT INTO lab_schedule (lab_number, day_of_week, start_time, end_time, lab_subject, class_id, class_name) " +
                                                      "VALUES (?, ?, ?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE " +
                                                      "start_time = ?, end_time = ?, lab_subject = ?, class_id = ?, class_name = ?";
                        PreparedStatement insertScheduleStmt = con.prepareStatement(insertScheduleQuery);
                        insertScheduleStmt.setString(1, labNumber);
                        insertScheduleStmt.setString(2, dayOfWeek);
                        insertScheduleStmt.setString(3, startTime);
                        insertScheduleStmt.setString(4, endTime);
                        insertScheduleStmt.setString(5, labSubject);
                        insertScheduleStmt.setInt(6, classId);
                        insertScheduleStmt.setString(7, className);
                        // Update part
                        insertScheduleStmt.setString(8, startTime);
                        insertScheduleStmt.setString(9, endTime);
                        insertScheduleStmt.setString(10, labSubject);
                        insertScheduleStmt.setInt(11, classId);
                        insertScheduleStmt.setString(12, className);

                        insertScheduleStmt.executeUpdate();

                        timetableMessage = "Class " + className + " assigned to Lab " + labNumber + " successfully!";
                        insertScheduleStmt.close();
                        insertTimetableStmt.close();
                    } else {
                        timetableMessage = "Class not found!";
                    }
                } else {
                    timetableMessage = "The lab is already booked for the selected time.";
                }

                checkStmt.close();
            }

            // Delete timetable
            if (request.getMethod().equalsIgnoreCase("POST") && request.getParameter("deleteTimetable") != null) {
                String deleteLabNumber = request.getParameter("delete_lab_number_timetable").trim();
                String deleteDayOfWeek = request.getParameter("delete_day_of_week");
                String deleteStartTime = request.getParameter("delete_start_time");
                String deleteEndTime = request.getParameter("delete_end_time");

                // Delete from lab_timetable
                String deleteTimetableQuery = "DELETE FROM lab_timetable WHERE lab_number = ? AND day_of_week = ? AND start_time = ? AND end_time = ?";
                PreparedStatement deleteTimetableStmt = con.prepareStatement(deleteTimetableQuery);
                deleteTimetableStmt.setString(1, deleteLabNumber);
                deleteTimetableStmt.setString(2, deleteDayOfWeek);
                deleteTimetableStmt.setString(3, deleteStartTime);
                deleteTimetableStmt.setString(4, deleteEndTime);
                int timetableRowsAffected = deleteTimetableStmt.executeUpdate();

                // Delete from lab_schedule
                String deleteScheduleQuery = "DELETE FROM lab_schedule WHERE lab_number = ? AND day_of_week = ? AND start_time = ? AND end_time = ?";
                PreparedStatement deleteScheduleStmt = con.prepareStatement(deleteScheduleQuery);
                deleteScheduleStmt.setString(1, deleteLabNumber);
                deleteScheduleStmt.setString(2, deleteDayOfWeek);
                deleteScheduleStmt.setString(3, deleteStartTime);
                deleteScheduleStmt.setString(4, deleteEndTime);
                int scheduleRowsAffected = deleteScheduleStmt.executeUpdate();

                if (timetableRowsAffected > 0 || scheduleRowsAffected > 0) {
                    timetableMessage = "Timetable deleted successfully!";
                } else {
                    timetableMessage = "No timetable found for the given details.";
                }

                deleteTimetableStmt.close();
                deleteScheduleStmt.close();
            }

            con.close();
        } catch (Exception e) {
            e.printStackTrace();
            timetableMessage = "Error occurred: " + e.getMessage();
        }
    %>

    <div class="container">
        <h1>Edit Timetables</h1>

        <h2>Assign Class to Lab</h2>
        <form method="POST">
            <label for="lab_number">Lab Number:</label>
            <input type="text" id="lab_number" name="lab_number" required>
            <label for="class_name">Class Name:</label>
            <input type="text" id="class_name" name="class_name" required>
            <label for="day_of_week">Day of the Week:</label>
            <select id="day_of_week" name="day_of_week" required>
                <option value="Monday">Monday</option>
                <option value="Tuesday">Tuesday</option>
                <option value="Wednesday">Wednesday</option>
                <option value="Thursday">Thursday</option>
                <option value="Friday">Friday</option>
                <option value="Saturday">Saturday</option>
            </select>
            <label for="start_time">Start Time:</label>
            <input type="time" id="start_time" name="start_time" required>
            <label for="end_time">End Time:</label>
            <input type="time" id="end_time" name="end_time" required>
            <label for="lab_subject">Lab Subject:</label>
            <input type="text" id="lab_subject" name="lab_subject" required>
            <button type="submit" name="assignClass">Assign Class</button>
        </form>

        <h2>Delete Timetable</h2>
        <form method="POST">
            <label for="delete_lab_number_timetable">Lab Number:</label>
            <input type="text" id="delete_lab_number_timetable" name="delete_lab_number_timetable" required>
            <label for="delete_day_of_week">Day of the Week:</label>
            <select id="delete_day_of_week" name="delete_day_of_week" required>
                <option value="Monday">Monday</option>
                <option value="Tuesday">Tuesday</option>
                <option value="Wednesday">Wednesday</option>
                <option value="Thursday">Thursday</option>
                <option value="Friday">Friday</option>
            </select>
            <label for="delete_start_time">Start Time:</label>
            <input type="time" id="delete_start_time" name="delete_start_time" required>
            <label for="delete_end_time">End Time:</label>
            <input type="time" id="delete_end_time" name="delete_end_time" required>
            <button type="submit" name="deleteTimetable">Delete Timetable</button>
        </form>
        <div class="message <% out.print(timetableMessage.contains("successfully") ? "success" : "error"); %>">
            <%= timetableMessage %>
        </div>
    </div>
</body>
</html>
