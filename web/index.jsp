<%-- 
    Document   : index
    Created on : Sep 15, 2023, 1:08:46 PM
    Author     : LiusDev
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>${initParam['webName']}</title>

        <%@include file="components/headerLink.html" %>
    </head>
    <body>
        <%@include file="components/header.jsp" %>
        <section class="section-intro mb-3 mt-5">
            <div class="container">
                <main class="card p-3">
                    <div class="row">
                        <aside class="col-lg-3">
                            <nav class="nav flex-column nav-pills mb-3 mb-lg-0">
                                <c:forEach var="category" items="${categories}">
                                    <a class="nav-link text-truncate" href="search?category=${category.slug}"><b>${category.name}</b></a>
                                        </c:forEach>
                            </nav>
                        </aside>
                        <div class="col-lg-9">

                            <div class="row">
                                <div class="col-xxl-9 col-lg-8">

                                    <!-- carousel -->
                                    <div id="carouselMain" class="carousel-main carousel slide" data-bs-ride="carousel">
                                        <div class="carousel-inner">
                                            <article class="carousel-item active">
                                                <div class="carousel-caption">
                                                    <h2 class="mb-3">
                                                        <span class="fw-normal">Latest trending</span> <br> <strong>Electronic items</strong>
                                                    </h2>
                                                    <a href="#" class="btn btn-warning"> View more </a>
                                                </div>
                                                <img style="height: 352px;" src="https://bootstrap-ecommerce-web.netlify.app/images/banners/main-tech.png" class="d-block w-100 img-cover" alt="Banner">
                                            </article>
                                            <article class="carousel-item">
                                                <div class="carousel-caption">
                                                    <h2 class="mb-3">
                                                        <span class="fw-normal">Latest delas</span> <br> <strong>Best Smartphones</strong>
                                                    </h2>
                                                    <a href="#" class="btn btn-warning"> View more </a>
                                                </div>
                                                <img style="height: 352px;" src="https://bootstrap-ecommerce-web.netlify.app/images/banners/main-phone.png" class="d-block w-100 img-cover" alt="Banner">
                                            </article>
                                        </div>  <!-- carousel-inner .// -->

                                        <button class="carousel-control-prev" type="button" data-bs-target="#carouselMain" data-bs-slide="prev">
                                            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                                            <span class="visually-hidden">Previous</span>
                                        </button>

                                        <button class="carousel-control-next" type="button" data-bs-target="#carouselMain" data-bs-slide="next">
                                            <span class="carousel-control-next-icon" aria-hidden="true"></span>
                                            <span class="visually-hidden">Next</span>
                                        </button>

                                    </div>
                                    <!-- carousel .//end -->

                                </div>
                                <div class="col-xxl-3 col-lg-4 d-none d-lg-block">
                                    <!-- main-right -->
                                    <div class="bg-primary-light p-3 rounded mb-3">
                                        <c:choose>
                                            <c:when test="${sessionScope.user == null}">
                                                <p class="d-flex mb-3 text-base">
                                                    <img src="https://bootstrap-ecommerce-web.netlify.app/images/avatars/avatar.jpg" class="img-avatar me-2" width="44" height="44" alt="">
                                                    <span>Hi, user <br> please login!</span>
                                                </p>
                                                <a href="login" class="btn btn-sm btn-primary w-100">Login</a>
                                            </c:when>
                                            <c:otherwise>
                                                <p class="d-flex mb-3 text-base">
                                                    <img src="image/user?id=${sessionScope.user.id}" class="img-avatar me-2" width="44" height="44" style="object-fit: cover" alt="${sessionScope.user.firstName}">
                                                    <span>Hi, ${sessionScope.user.firstName} ${sessionScope.user.lastName} <br> let's shopping!</span>
                                                </p>
                                                <a href="logout" class="btn btn-sm btn-primary w-100">Logout</a>
                                            </c:otherwise>
                                        </c:choose>

                                    </div>

                                    <div class="bg-warning text-white p-3 rounded mb-2">
                                        Get US $10 off with a new supplier account 
                                        <br> <a href="#" class="text-white mt-1 fw-bold d-inline-block">Get now</a>
                                    </div>
                                    <div class="bg-info text-white p-3 rounded mb-2">
                                        Send quotes with supplier preferences 
                                        <br> <a href="#" class="text-white mt-1 fw-bold d-inline-block">Try now</a>
                                    </div>
                                    <!-- main-right -->
                                </div>
                            </div> <!-- row.// -->
                        </div>
                        <!-- col.// -->
                    </div>
                </main>
            </div> <!-- container end.// -->
        </section>
        <!-- ================ SECTION INTRO END.// ================ -->

        <!-- ================ SECTION CARD CATEGORY  ================ -->
        <section class="pb-3">
            <div class="container">
                <div class="card overflow-hidden">
                    <div class="row gx-0">
                        <aside class="col-lg-3 p-4 bg-cover" style="background-image: url(https://bootstrap-ecommerce-web.netlify.app/images/banners/interior.jpg);">
                            <header>
                                <h3 class="mb-3">Home and <br> outdoor items</h3>
                                <a href="search?category=home-and-outdoor-items" class="btn btn-light">Source now</a>
                            </header><!-- sect-heading -->
                        </aside> <!-- col.// -->
                        <div class="col-lg-9">
                            <ul class="row g-0 bordered-cols m-0">
                                <c:forEach var="product" items="${featuredProducts1}">
                                    <li class="col-6 col-lg-3 col-md-4">
                                        <div class="card-product p-3 pe-0">
                                            <a href="product?slug=${product.slug}" class="title text-truncate">${product.name}</a>
                                            <img class="size-72x72 float-end mb-2" src="image/product?id=${product.image.id}">
                                            <p class="text-muted small">${String.format("%,d", product.minPrice)} ₫</p>
                                        </div>
                                    </li>
                                </c:forEach>
                            </ul>
                        </div> <!-- col.// -->
                    </div>
                    <!-- row .// -->
                </div>
            </div> <!-- container .// -->
        </section>
        <!-- ================ SECTION CARD CATEGORY .// ================ -->

        <!-- ================ SECTION CARD CATEGORY-2  ================ -->
        <section class="pb-3">
            <div class="container">
                <div class="card overflow-hidden">
                    <div class="row gx-0">
                        <aside class="col-lg-3 p-4 bg-cover" style="background-image: url(https://bootstrap-ecommerce-web.netlify.app/images/banners/tech.jpg);">
                            <header>
                                <h3 class="mb-3">Consumer <br> electronics and <br> gadgets</h3>
                                <a href="search?category=consumer-electronics-and-gadgets" class="btn btn-light">Source now</a>
                            </header><!-- sect-heading -->
                        </aside> <!-- col.// -->
                        <div class="col-lg-9">
                            <ul class="row g-0 bordered-cols m-0">
                                <c:forEach var="product" items="${featuredProducts2}">
                                    <li class="col-6 col-lg-3 col-md-4">
                                        <div class="card-product p-3 pe-0">
                                            <a href="product?slug=${product.slug}" class="title text-truncate">${product.name}</a>
                                            <img class="size-72x72 float-end mb-2" src="image/product?id=${product.image.id}">
                                            <p class="text-muted small">${String.format("%,d", product.minPrice)} ₫</p>
                                        </div>
                                    </li>
                                </c:forEach>
                            </ul>
                        </div> <!-- col.// -->
                    </div>
                    <!-- row .// -->
                </div>
            </div> <!-- container .// -->
        </section>
        <!-- ================ SECTION CARD CATEGORY-2 .// ================ -->

        <!-- ================ SECTION PRODUCTS ================ -->
        <section class="pb-3">
            <div class="container">

                <header class="section-heading">
                    <h3>New products</h3>
                </header>

                <div class="row row-cols-xl-5 row-cols-lg-4 row-cols-md-3 row-cols-2">
                    <c:forEach var="product" items="${newProducts}">
                        <div class="col">
                            <figure class="card card-product-grid">
                                <a href="product?slug=${product.slug}" class="img-wrap" title="${product.name}"> <img src="image/product?id=${product.image.id}"> </a>
                                <figcaption class="p-3">
                                    <div class="price-wrap">
                                        <span class="price">${String.format("%,d", product.minPrice)} ₫ - ${String.format("%,d", product.maxPrice)} ₫</span>
                                    </div> <!-- price-wrap.// -->
                                    <a href="product?slug=${product.slug}" class="title text-truncate" title="${product.name}"><b>${product.name}</b></a>
                                </figcaption>
                            </figure>
                        </div> <!-- col end.// -->
                    </c:forEach>
                </div> <!-- row end.// -->
            </div> <!-- container end.// -->
        </section>
        <!-- ================ SECTION PRODUCTS END.// ================ -->

        <!-- ================ SECTION SUBSCRIBE ================ -->
        <section class="padding-y-lg bg-gray-light">
            <div class="container">

                <h4 class="text-center">Subscribe on our newsletter</h4>
                <p class="pb-2 text-center">Get daily news on upcoming offers from many suppliers all over the world</p>

                <div style="max-width:380px;" class="mx-auto">

                    <div class="d-flex">
                        <div class="me-1 flex-grow-1">
                            <input class="w-100 form-control" placeholder="Your Email" type="email">
                        </div> <!-- col.// -->
                        <div class="">
                            <button type="submit" class="btn btn-primary"> <i class="fa fa-envelope"></i> Subscribe
                            </button>
                        </div> <!-- col.// -->
                    </div>
                </div>


            </div> 	<!-- container  .// -->
        </section>
        <%@include file="components/footerLink.html" %>
    </body>
</html>
