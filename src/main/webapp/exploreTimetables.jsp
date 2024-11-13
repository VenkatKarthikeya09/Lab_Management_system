<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.HashSet, java.util.Set, java.util.List, java.util.ArrayList, java.util.Collections" %>
<html>
<head>
    <title>Explore Time Tables</title>
    <style>
        /* Same CSS as before */
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
            margin-top: 50px;
        }

        .section {
            width: 100%;
            margin-bottom: 20px;
        }

        .section h3 {
            text-align: left;
            color: #34495e;
        }

        .item-list {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
        }

        .item {
            padding: 10px 20px;
            background-color: #34495e;
            color: white;
            border-radius: 10px;
            cursor: pointer;
            transition: transform 0.3s ease, background-color 0.3s ease;
        }

        .item:hover {
            transform: scale(1.1);
            background-color: #2c3e50;
        }

        .heading {
            font-size: 24px;
            margin-bottom: 10px;
            text-align: center;
            color: #34495e;
        }
    </style>
    <script>
        function redirectTimetable(type, id) {
            window.location.href = 'viewTimetable.jsp?type=' + type + '&id=' + id;
        }
    </script>
</head>
<body>
    <%
        String username = (String) session.getAttribute("username");
        if (username == null) {
            response.sendRedirect("login-signup.html");
        }
    %>

    <!-- Include Navbar -->
    <jsp:include page="navbar.jsp"></jsp:include>

    <!-- Main Content Section -->
    <div class="main-container">
        <h2 class="heading">Classrooms & Labs Timetables</h2>
        
        <!-- Classrooms Section -->
        <div class="section">
            <h3>Classrooms:</h3>
            <div class="item-list">
                <%
                    Set<String> classSet = new HashSet<>(); // To prevent duplicates

                    // Database connection and fetching classroom timetable data
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/user_management", "root", "tiger");
                        
                        // Fetch Classes with Timetables, sorted by class_name
                        String classQuery = "SELECT DISTINCT c.class_id, c.class_name " +
                                            "FROM classes c " +
                                            "JOIN lab_timetable lt ON c.class_id = lt.class_id " +
                                            "ORDER BY c.class_name"; // Sorting by class_name

                        Statement stmt = con.createStatement();
                        ResultSet classRs = stmt.executeQuery(classQuery);
                        
                        while (classRs.next()) {
                            String classId = classRs.getString("class_id");
                            String className = classRs.getString("class_name");
                            if (classId != null && !classId.trim().isEmpty()) {
                                classSet.add(classId + "-" + className); // Use both class_id and class_name for display
                            }
                        }
                        
                        stmt.close();
                        con.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }

                    // Convert Set to List and sort it
                    List<String> classList = new ArrayList<>(classSet);
                    Collections.sort(classList); // Sort the list

                    // Display classes
                    if (classList.isEmpty()) {
                        out.println("<div class='item'>No classrooms available.</div>");
                    } else {
                        for (String classDetails : classList) {
                            String[] details = classDetails.split("-");
                            String classId = details[0];
                            String className = details[1];
                %>
                    <div class="item" onclick="redirectTimetable('classroom', '<%= classId %>')">Class <%= className %></div>
                <% 
                        } 
                    }
                %>
            </div>
        </div>
        
        <!-- Labs Section -->
        <div class="section">
            <h3>Labs:</h3>
            <div class="item-list">
                <%
                    Set<String> labSet = new HashSet<>(); // To prevent duplicates

                    // Database connection and fetching lab timetable data
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/user_management", "root", "tiger");
                        Statement stmt = con.createStatement();
                        ResultSet rs = stmt.executeQuery("SELECT DISTINCT lab_number FROM lab_timetable ORDER BY lab_number"); // Sorting by lab_number
                        
                        while (rs.next()) {
                            String labNumber = rs.getString("lab_number");
                            if (labNumber != null && !labNumber.trim().isEmpty()) {
                                labSet.add(labNumber);
                            }
                        }
                        
                        stmt.close();
                        con.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }

                    // Convert Set to List and sort it
                    List<String> labList = new ArrayList<>(labSet);
                    Collections.sort(labList); // Sort the list

                    // Display labs
                    if (labList.isEmpty()) {
                        out.println("<div class='item'>No labs available.</div>");
                    } else {
                        for (String labNumber : labList) {
                %>
                    <div class="item" onclick="redirectTimetable('lab', '<%= labNumber %>')">Lab <%= labNumber %></div>
                <% 
                        } 
                    }
                %>
            </div>
        </div>
    </div>
</body> 
</html>
