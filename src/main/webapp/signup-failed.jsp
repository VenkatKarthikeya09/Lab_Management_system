<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Signup Failed</title>
</head>
<body>
    <h1>Signup Failed</h1>
    <%
        String error = request.getParameter("error");
        if ("duplicate".equals(error)) {
            out.println("<p>The username is already taken. Please choose a different username.</p>");
        } else if ("insert".equals(error)) {
            out.println("<p>There was an error registering your account. Please try again.</p>");
        } else if ("exception".equals(error)) {
            out.println("<p>An unexpected error occurred. Please try again later.</p>");
        }
    %>
    <p><a href="login-signup.html">Back to Signup</a></p>
</body>
</html>
