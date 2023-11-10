<%-- 
    Document   : noPermission
    Created on : Sep 30, 2023, 11:13:15 PM
    Author     : LiusDev
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Opps!</title>

        <%@include file="components/headerLink.html" %>
    </head>
    <body class="bg-gray-100">
        <%@include file="components/header.jsp" %>

        <section class="section-intro mb-3 mt-5">
            <div class="container">
                <main class="card p-3">
                    <div class="d-flex flex-column align-items-center">
                        <h1 class="h3 text-center mb-3">You do not have permission to view this page!</h1>
                        <a class="btn btn-primary" href="/" onclick="history.back()"> 
                            <i class="fa fa-arrow-left me-2"></i> Back to shop 
                        </a>
                    </div>
                </main>
            </div>
        </section>
    </body>
</html>
