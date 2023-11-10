<%-- 
    Document   : search
    Created on : Sep 15, 2023, 3:09:23 PM
    Author     : LiusDev
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Search for ${param.keyword} | ${initParam['webName']}</title>
        <%@include file="components/headerLink.html" %>
    </head>
    <body>
        <%@include file="components/header.jsp" %>
        <section class="mt-5">
            <div class="container">
                <div class="row">
                    <div class="col-xl-2 col-lg-3"></div>
                    <aside class="col-xl-2 col-lg-3 position-fixed" style="max-width: 12%">

                        <button class="btn btn-outline-secondary mb-3 w-100  d-lg-none" data-bs-toggle="collapse" data-bs-target="#aside_filter">Show filter</button>

                        <!-- ===== Card for sidebar filter ===== -->
                        <div id="aside_filter" class="collapse d-lg-block mb-5">

                            <!-- filterby item -->
                            <article>
                                <a href="/" class="fw-bold text-dark py-3 d-block border-top" data-bs-toggle="collapse" data-bs-target="#collapse_aside1">
                                    <i class="icon-control fa fa-chevron-down"></i>
                                    Category
                                </a>
                                <div class="collapse show" id="collapse_aside1">
                                    <div class="pb-3">
                                        <ul class="list-menu mb-0 nav nav-pills d-block" id="categories">
                                            <c:forEach var="category" items="${categories}">
                                                <li><a class="nav-link" data-slug="${category.slug}" style="cursor: pointer">${category.name}</a></li>
                                                </c:forEach>
                                        </ul>
                                    </div>
                                </div> <!-- collapse .// -->
                            </article>
                            <!-- filterby item .// -->

                            <!-- filterby item -->
                            <article>
                                <a href="/" class="fw-bold text-dark py-3 d-block border-top" data-bs-toggle="collapse" data-bs-target="#collapse_aside2">
                                    <i class="icon-control fa fa-chevron-down"></i>
                                    Price range
                                </a>
                                <div class="collapse show" id="collapse_aside2">
                                    <div class="pb-3">
                                        <form id="priceForm">
                                            <div class="row mb-2 g-2">
                                                <div class="col-6">
                                                    <label for="min" class="form-label">Min</label>
                                                    <input type="number" class="form-control" id="minPrice" name="minPrice" placeholder="₫0" value="${param.minPrice}">
                                                </div> <!-- col end.// -->

                                                <div class="col-6">
                                                    <label for="max" class="form-label">Max</label>
                                                    <input type="number" class="form-control" id="maxPrice" name="maxPrice" placeholder="₫99999" value="${param.maxPrice}">
                                                </div> <!-- col end.// -->
                                            </div> <!-- row end.// -->
                                            <button class="btn btn-light text-primary w-100">Apply</button>
                                        </form>
                                    </div>
                                </div> <!-- collapse .// -->
                            </article>
                            <article class="py-3 d-block border-top">
                                <a class="btn btn-primary w-100" href="/search?keyword=${param.keyword}"><b>Reset</b></a>
                            </article>
                        </div> <!-- card.// -->

                        <!-- ===== Card for sidebar filter .// ===== -->

                    </aside> <!-- col .// -->
                    <main class="col-xl-10 col-lg-9">

                        <header class="card mb-3">
                            <div class="p-3 d-md-flex align-items-center">
                                <!-- left   -->
                                <span class="d-block py-2">Found <b>${productCount}</b> items</span>
                                <!-- left  .//  -->
                                <!-- right -->
                                <div class="ms-auto d-md-flex align-items-center gap-3">
                                    <select class="form-select d-inline-block w-auto" title="sortBy" name="sortBy" id="sortByForm">
                                        <option value="default">Default</option>
                                        <option value="createdAt">Latest</option>
                                        <option value="sales">Sales</option>
                                        <option value="priceAsc">Price: Ascending</option>
                                        <option value="priceDesc">Price: Descending</option>
                                    </select>
                                </div>  <!-- right .//-->
                            </div>
                        </header>  <!-- card .//-->

                        <!-- ========= content items ========= -->

                        <c:choose>
                            <c:when test="${products == null || products.size() == 0}">
                                <p>Oops, cannot find any product :(</p>
                            </c:when>
                            <c:otherwise>
                                <div class="row">
                                    <c:forEach var="product" items="${products}">
                                        <div class="col-xxl-3 col-xl-4 col-sm-6 col-12">
                                            <figure class="card card-product-grid">
                                                <a href="product?slug=${product.slug}" class="img-wrap"> <img src="image/product?id=${product.image.id}" alt="${product.image.alt}">  </a>
                                                <figcaption class="p-3 border-top">
                                                    <!--                          <a href="https://bootstrap-ecommerce-web.netlify.app/p-market-list-grid#" class="float-end btn btn-light btn-icon"> <i class="fa fa-heart"></i> </a>-->
                                                    <div class="price-wrap mb-1">
                                                        <strong class="price text-lg">${product.minPrice} ₫</strong>
                                                        <span> - </span>
                                                        <strong class="price text-lg">₫${product.maxPrice} ₫</strong>
                                                    </div> <!-- price-wrap.// -->
                                                    <!--                          <div class="rating-wrap mb-1">
                                                                                <ul class="rating-stars">
                                                                                  <li class="stars-active" style="width: 40%;">
                                                                                    <img src="./searchPage_files/stars-active.svg" alt="">
                                                                                  </li>
                                                                                  <li> <img src="./searchPage_files/starts-disable.svg" alt=""> </li>
                                                                                </ul>
                                                                                <span class="label-rating text-warning">3.5</span>
                                                                              </div>  rating-wrap .// -->
                                                    <a href="product?slug=${product.slug}" class="title text-truncate"> ${product.name} </a>
                                                </figcaption>
                                            </figure> <!-- card // -->
                                        </div> <!-- col .// -->
                                    </c:forEach>
                                </div> <!-- row.// -->
                                <footer class="d-flex my-4">
                                    <nav>
                                        <ul class="pagination" id="pages">
                                            <!--                                <li class="page-item">
                                                                                <a class="page-link" style="cursor: pointer" data-page="prev">Prev</a>
                                                                            </li>-->
                                            <c:forEach var = "i" begin = "1" end ="${totalPage}">
                                                <li class="page-item"><a class="page-link" style="cursor: pointer" data-page="${i}">${i}</a></li>
                                                </c:forEach>
                                            <!--                                <li class="page-item">
                                                                                <a class="page-link" style="cursor: pointer" data-page="next">Next</a>
                                                                            </li>-->
                                        </ul>
                                    </nav>
                                </footer>
                            </c:otherwise>
                        </c:choose>
                    </main> <!-- col .// -->
                </div> <!-- row .// -->
            </div> <!-- container .//  -->
        </section>
        <%@include file="components/footerLink.html" %>

        <script>
            let params = new URL(document.location).searchParams;
            let keyword = params.get("keyword");
            let category = params.get("category");
            let minPrice = params.get("minPrice");
            let maxPrice = params.get("maxPrice");
            let sortBy = params.get("sortBy");
            let page = params.get("page");

            const categories = document.querySelector("#categories");
            const categoryChilds = Array.from(categories.querySelectorAll("a"));
            categoryChilds.forEach(child => {
                child.addEventListener("click", (e) => {
                    e.preventDefault();
                    submitParams(keyword, child.dataset.slug);
                });
            });

            const priceForm = document.querySelector("#priceForm");
            const minPriceInput = priceForm.querySelector("#minPrice");
            const maxPriceInput = priceForm.querySelector("#maxPrice");

            priceForm.addEventListener("submit", (e) => {
                e.preventDefault();
                submitParams(keyword, category, minPriceInput.value, maxPriceInput.value);
            });

            const sortByForm = document.querySelector("#sortByForm");
            const sortByOption = Array.from(sortByForm.querySelectorAll("option"));
            sortByForm.onchange = () => {
                submitParams(keyword, category, minPrice, maxPrice, sortByForm.value);
            };
            sortByOption.forEach(option => {
                if (option.value === sortBy) {
                    option.selected = true;
                }
            });

            const pages = document.querySelector("#pages");

            if (pages !== null) {
                const allPage = Array.from(pages.querySelectorAll("li"));
                allPage.forEach(pageChild => {
                    const pageAnchor = pageChild.querySelector("a");
                    pageAnchor.addEventListener("click", (e) => {
                        e.preventDefault();
                        submitParams(keyword, category, minPrice, maxPrice, sortBy, pageAnchor.dataset.page);
                    })
                });

                if (page != null) {
                    allPage.forEach(pageChild => {
                        const pageAnchor = pageChild.querySelector("a");
                        if (pageAnchor.dataset.page === page)
                            pageChild.classList.add("active");
                    });
                } else {
                    allPage[0].classList.add("active");
                }
            }

            const submitParams = (keyword, category, minPrice, maxPrice, sortBy, page) => {
                let searchParams = {
                    keyword,
                    category,
                    minPrice,
                    maxPrice,
                    sortBy,
                    page
                };

                Object.keys(searchParams).forEach(key => {
                    if (searchParams[key] == null) {
                        delete searchParams[key];
                    }
                });

                let searchString = "";
                for (const [key, value] of Object.entries(searchParams)) {
                    searchString += key + "=" + value + "&";
                }
                ;

                const {origin, pathname} = window.location;
                window.open(pathname + "?" + searchString, "_self");
            };
        </script>
    </body>
</html>
