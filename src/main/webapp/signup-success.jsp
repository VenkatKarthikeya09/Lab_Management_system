<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Signup Success</title>
</head>
<body>
    <h1>Your account has been successfully registered!</h1>
    <p>Welcome, <%= request.getParameter("username") %></p>
    <p><a href="login-signup.html">Go to Login</a></p>
</body>
</html>
