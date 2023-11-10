<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<header class="section-header position-fixed top-0 start-0 end-0" style="z-index: 100">
    <section class="header-main bg-white border-bottom py-lg-3 py-2">
        <div class="container">
            <div class="row gx-2 align-items-center">
                <div class="col-xl-2 col-lg col-6 col-sm-6  col-md flex-grow-0">
                    <a class="brand-wrap me-3" href="/">
                        <img class="logo" height="40" src="https://bootstrap-ecommerce-web.netlify.app/images/logo.svg">
                    </a> <!-- brand-wrap end.// -->
                </div> <!-- col end.// -->

                <div class="col-xl-7 col-lg-6 col-12 col-sm-12 col-md">
                    <form action="search" class="search my-3 my-lg-0">
                        <div class="input-group">
                            <input type="search" class="form-control" style="width:30%" placeholder="Search" name="keyword" value="${param.keyword}">
                            <button class="btn btn-primary">
                                <i class="fa fa-search"></i>
                            </button>
                        </div> <!-- input-group end.// -->
                    </form> <!-- search-wrap end.// -->
                </div> <!-- col end.// -->

                <div class="col-xl-3 col-lg col-md-12 col-12">

                    <!-- widgets-wrap  -->
                    <div class="float-lg-end">
                        <c:choose>
                            <c:when test="${sessionScope.user == null}">
                                <div class="widget-header mx-2 text-center" style="min-width:44px">
                                    <a href="login" class="d-inline-block align-middle">
                                        <b>Login</b>
                                    </a>
                                </div>

                                <div class="widget-header mx-2 text-center" style="min-width: 44px;">
                                    <a href="register" class="d-inline-block align-middle">
                                        <b>Register</b>
                                    </a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="widget-header mx-2 text-center" style="min-width: 44px;">
                                    <a href="cart" class="d-inline-block align-middle">
                                        <span class="fs-5 d-inline-block"> <i class="fa fa-shopping-cart"></i> </span>
                                        <small style="max-width:80px;" class="d-block text-truncate"> Cart </small>
                                    </a>
                                </div>

                                <div class="widget-header mx-2 text-center" style="min-width:44px">
                                    <a href="/user" class="d-inline-block align-middle">
                                        <span class="fs-5 d-inline-block"> <i class="fa fa-user"></i> </span>
                                        <small style="max-width:80px;" class="d-block text-truncate"> Profile </small>
                                    </a>
                                </div>

                                <div class="widget-header mx-2 text-center" style="min-width: 44px;">
                                    <a href="logout" class="d-inline-block align-middle">
                                        <span class="fs-5 d-inline-block"> <i class="fas fa-sign-out-alt"></i> </span>
                                        <small style="max-width:80px;" class="d-block text-truncate"> Logout </small>
                                    </a>
                                </div>

                            </c:otherwise>
                        </c:choose>
                    </div>
                </div> <!-- col end.// -->
            </div> <!-- row end.// -->
        </div> <!-- container end.// -->
    </section> <!-- header-main end.// -->
</header>
<div style="height: 60px"></div>