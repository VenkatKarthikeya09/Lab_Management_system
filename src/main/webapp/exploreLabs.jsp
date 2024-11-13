<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<html>
<head>
    <title>Explore Labs</title>
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(to bottom right, #e0eafc, #cfdef3);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            padding: 0;
        }

        .form-container {
            background-color: #f4f7f9;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            margin-top: 100px;
        }

        label {
            display: block;
            margin-bottom: 10px;
            font-size: 16px;
            color: #34495e;
        }

        select, input[type="date"], input[type="text"], button {
            width: 100%;
            padding: 10px;
            margin-bottom: 20px;
            border-radius: 5px;
            border: 1px solid #34495e;
            font-size: 16px;
        }

        button {
            background-color: #1abc9c;
            color: white;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        button:hover {
            background-color: #16a085;
        }

        .message {
            color: red;
            font-weight: bold;
            text-align: center;
        }

        /* Error Message for Time Slots */
        .error-message {
            color: red;
            font-size: 14px;
            margin-top: -10px;
            margin-bottom: 20px;
            display: none;
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
            position: fixed;
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

        /* Disable input styles */
        .disabled-input {
            background-color: #e0eafc;
            border: none;
            cursor: not-allowed;
        }
    </style>
    <script>
        function updateDay() {
            const dateInput = document.getElementById('date');
            const dayDisplay = document.getElementById('day');
            const messageDiv = document.getElementById('message');

            const selectedDate = new Date(dateInput.value);
            const options = { weekday: 'long' };
            const selectedDay = selectedDate.toLocaleDateString('en-US', options);

            dayDisplay.value = selectedDay.charAt(0).toUpperCase() + selectedDay.slice(1);

            if (selectedDay === "Sunday") {
                messageDiv.innerText = "No college on Sunday.";
            } else {
                messageDiv.innerText = "";
            }
        }

        function validateTimeSlots() {
            const startTime = document.getElementById("startTime").value;
            const endTime = document.getElementById("endTime").value;
            const errorMessage = document.getElementById("timeErrorMessage");

            if (startTime >= endTime) {
                errorMessage.style.display = 'block';
                errorMessage.innerText = "Start time must be before end time. Please select correct time slots.";
                return false;
            } else {
                errorMessage.style.display = 'none';  // Hide the error message if validation passes
                return true;
            }
        }
    </script>
</head>
<body>
    <%
        String username = (String) session.getAttribute("username");
        String profilePhotoPath = "dp.png"; 

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
            <img src="<%= profilePhotoPath %>" alt="Profile Photo">
            <span><%= username %></span>
        </div>
    </div>

    <div class="form-container">
        <form action="availableLabs.jsp" method="post" onsubmit="return validateTimeSlots()">
            <label for="date">Select Date:</label>
            <input type="date" id="date" name="date" required onchange="updateDay()">

            <label for="day">Day:</label>
            <input type="text" id="day" name="day" class="disabled-input" readonly>

            <div id="message" class="message"></div>

            <label for="startTime">Select Start Time:</label>
            <select id="startTime" name="startTime" required>
                <option value="09:00:00">9:00 AM</option>
                <option value="09:55:00">9:55 AM</option>
                <option value="10:50:00">10:50 AM</option>
                <option value="11:45:00">11:45 AM</option>
                <option value="13:20:00">1:20 PM</option>
                <option value="14:15:00">2:15 PM</option>
                <option value="15:10:00">3:10 PM</option>
            </select>

            <label for="endTime">Select End Time:</label>
            <select id="endTime" name="endTime" required>
                <option value="09:55:00">9:55 AM</option>
                <option value="10:50:00">10:50 AM</option>
                <option value="11:45:00">11:45 AM</option>
                <option value="12:40:00">12:40 PM</option>
                <option value="13:20:00">1:20 PM</option>
                <option value="14:15:00">2:15 PM</option>
                <option value="15:10:00">3:10 PM</option>
                <option value="16:05:00">4:05 PM</option>
            </select>

            <!-- Error message for invalid time selection -->
            <div id="timeErrorMessage" class="error-message"></div>

            <button type="submit">Find Available Labs</button>
        </form>
    </div>
</body>
</html>
