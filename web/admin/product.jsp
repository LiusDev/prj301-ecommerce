<%-- 
    Document   : adminProduct
    Created on : Oct 10, 2023, 10:28:11 AM
    Author     : LiusDev
--%>

<%@page import="model.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    User currUser = (User) session.getAttribute("user");
    if(currUser == null) {
        response.sendRedirect("/login");
        return;
    }
    if(!currUser.getRole().equals("admin") && !currUser.getRole().equals("staff")) {
        request.getRequestDispatcher("/noPermission.jsp").forward(request, response);
        return;
    }
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="shortcut icon" href="assets/images/favicon.svg" type="image/x-icon" />
    <title>Product | ${initParam['webName']}</title>

    <!-- ========== All CSS files linkup ========= -->
    <link rel="stylesheet" href="https://demo.plainadmin.com/assets/css/bootstrap.min.css" />
    <link rel="stylesheet" href="https://demo.plainadmin.com/assets/css/lineicons.css" />
    <link rel="stylesheet" href="https://demo.plainadmin.com/assets/css/materialdesignicons.min.css" />
    <link rel="stylesheet" href="https://demo.plainadmin.com/assets/css/fullcalendar.css" />
    <link rel="stylesheet" href="https://demo.plainadmin.com/assets/css/main.css" />
  </head>
  <body>
    <!-- ======== Preloader =========== -->
    <div id="preloader">
      <div class="spinner"></div>
    </div>
    <!-- ======== Preloader =========== -->

    <%@include file="/components/adminSidebar.jsp" %>

    <!-- ======== main-wrapper start =========== -->
    <main class="main-wrapper">
      <!-- ========== header start ========== -->
    <%@include file="/components/adminHeader.jsp" %>
      <!-- ========== header end ========== -->

      <!-- ========== table components start ========== -->
      <section class="table-components">
        <div class="container-fluid">
          <!-- ========== title-wrapper start ========== -->
          <div class="title-wrapper pt-30">
            <div class="d-flex align-items-center justify-content-between mb-4">
                <h2>Product</h2>
                <a class="main-btn success-btn btn-hover d-flex align-items-center" href="product/add">
                    <i class="lni lni-plus"></i> <span>Add product</span>
                </a>
            </div>
            <!-- end row -->
          </div>
          <!-- ========== title-wrapper end ========== -->
          
          <div class="filters-wrapper">
              <div class="card-style mb-30">
                  <div class="row">
                      <div class="col-lg-6">
                          <form action="product" class="search my-3 my-lg-0">
                            <div class="input-group">
                                <input type="text" name="keyword" id="keyword" placeholder="Product name" class="form-control" value="${param.keyword}"/>
                                <button class="btn btn-primary d-flex align-items-center justify-content-center">
                                    <i class="lni lni-search-alt"></i>
                                </button>
                            </div>
                          </form>
                      </div>
                      <div class="col-lg-6 d-flex justify-content-end gap-2">
                          <select class="form-select d-inline-block w-auto" title="Category" name="category" id="categoryForm">
                              <option value="default">Category</option>
                              <c:forEach var="category" items="${categories}" varStatus="loop">
                                <option value="${category.slug}">${category.name}</option>
                              </c:forEach>
                          </select>
                          <select class="form-select d-inline-block w-auto" title="Sort By" name="sortBy" id="sortByForm">
                            <option value="default">Sort By</option>
                            <option value="createdAt">Latest</option>
                            <option value="sales">Sales</option>
                            <option value="priceAsc">Price: Ascending</option>
                            <option value="priceDesc">Price: Descending</option>
                          </select>
                          <a class="btn btn-danger d-flex align-items-center justify-content-center" href="product">
                              <i class="lni lni-eraser"></i>
                          </a>
                      </div>
                  </div>
              </div>
          </div>
          
          
          <!-- ========== tables-wrapper start ========== -->
          <div class="tables-wrapper">
            <div class="row">
              <div class="col-lg-12">
                <div class="card-style mb-30">
                  <div class="table-wrapper table-responsive">
                    <table class="table">
                      <thead>
                        <tr>
                          <th class="px-2">
                            <h6>#</h6>
                          </th>
                          <th class="px-2">
                            <h6>Product</h6>
                          </th>
                          <th class="px-2">
                            <h6>Quantity</h6>
                          </th>
                          <th class="px-2">
                            <h6>Sold quantity</h6>
                          </th>
                          <th class="px-2">
                            <h6>Action</h6>
                          </th>
                        </tr>
                        <!-- end table row-->
                      </thead>
                      <tbody>
                        <c:forEach var="product" items="${products}" varStatus="loop">
                            <tr>
                              <td class="px-2">
                                <p>${loop.index + 1}</p>
                              </td>
                              <td class="px-2">
                                <a class="lead" href="/product?slug=${product.slug}">
                                  <div class="lead-image">
                                    <img src="/image/product?id=${product.image.id}" alt="${product.image.alt}" />
                                  </div>
                                  <div class="lead-text">
                                    <p class="h6 mb-1 text-truncate" style="max-width: 600px">${product.name}</p>
                                    <p>${String.format("%,d", product.minPrice)} ₫ - ${String.format("%,d", product.maxPrice)} ₫</p>
                                  </div>
                                </a>
                              </td>
                              <td class="px-2">
                                <p>${product.totalQuantity}</p>
                              </td>
                              <td class="px-2">
                                <p>${product.totalSoldQuantity}</p>
                              </td>
                              <td>
                                <div class="action">
                                    <a class="text-primary text-lg px-2" href="/product?slug=${product.slug}" target="_blank">
                                        <i class="lni lni-eye"></i>
                                    </a>
                                    <a class="text-success text-lg px-2" href="/admin/product/update?id=${product.id}">
                                        <i class="lni lni-pencil"></i>
                                    </a>
                                    <button class="text-danger text-lg px-2 deleteBtn" data-slug="${product.slug}">
                                      <i class="lni lni-trash-can"></i>
                                    </button>
                                </div>
                              </td>
                            </tr>
                            <!-- end table row -->
                        </c:forEach>
                      </tbody>
                    </table>
                    <!-- end table -->
                  </div>
                </div>
                <!-- end card -->
              </div>
              <!-- end col -->
            </div>
            <!-- end row -->
          </div>
          <!-- ========== tables-wrapper end ========== -->
        </div>
        <!-- end container -->
      </section>
      <!-- ========== table components end ========== -->
    </main>
    <!-- ======== main-wrapper end =========== -->

    <!-- ========= All Javascript files linkup ======== -->
    <script src="https://demo.plainadmin.com/assets/js/bootstrap.bundle.min.js"></script>
    <script src="https://demo.plainadmin.com/assets/js/Chart.min.js"></script>
    <script src="https://demo.plainadmin.com/assets/js/dynamic-pie-chart.js"></script>
    <script src="https://demo.plainadmin.com/assets/js/moment.min.js"></script>
    <script src="https://demo.plainadmin.com/assets/js/fullcalendar.js"></script>
    <script src="https://demo.plainadmin.com/assets/js/jvectormap.min.js"></script>
    <script src="https://demo.plainadmin.com/assets/js/world-merc.js"></script>
    <script src="https://demo.plainadmin.com/assets/js/polyfill.js"></script>
    <script src="https://demo.plainadmin.com/assets/js/main.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        let params = new URL(document.location).searchParams;
        let keyword = params.get("keyword");
        let category = params.get("category");
        let minPrice = params.get("minPrice");
        let maxPrice = params.get("maxPrice");
        let sortBy = params.get("sortBy");
        let page = params.get("page");
        
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
            };

            const {origin, pathname} = window.location;
            window.open(pathname + "?" + searchString, "_self");
        };
        
        const categoryForm = document.querySelector("#categoryForm");
        const categoryOption = Array.from(categoryForm.querySelectorAll("option"));
        categoryForm.onchange = () => {
            submitParams(keyword, categoryForm.value, minPrice, maxPrice, sortBy);
        };
        categoryOption.forEach(option => {
            if(option.value === category) {
                option.selected = true;
            }
        });
        
        const sortByForm = document.querySelector("#sortByForm");
        const sortByOption = Array.from(sortByForm.querySelectorAll("option"));
        sortByForm.onchange = () => {
            submitParams(keyword, category, minPrice, maxPrice, sortByForm.value);
        };
        sortByOption.forEach(option => {
            if(option.value === sortBy) {
                option.selected = true;
            }
        });
        
        const deleteBtns = Array.from(document.querySelectorAll(".deleteBtn"));
        
        const currentURL = new URL(document.location);
        const removeProduct = (slug) => {
            Swal.fire({
                    title: 'Are you sure?',
                    text: "You won't be able to revert this!",
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#d33',
                    confirmButtonText: "I'm sure!"
                }).then((result) => {
                    if (result.isConfirmed) {
                        $.ajax({
                            type:"post",
                            url:"/admin/product/delete",
                            data: 
                            {  
                                slug: slug
                            },
                            cache:false,
                            success: function (response) {
                                console.log(response);
                                switch(response) {
                                    case "Please login":
                                        Swal.fire({
                                            title: 'Please login to continue!',
                                            icon: 'error',
                                            showCancelButton: true,
                                            confirmButtonText: 'Login',
                                            cancelButtonText: 'OK',
                                            allowOutsideClick: false,
                                            allowEscapeKey: false,
                                        }).then((result) => {
                                            if (result.isConfirmed) {
                                                window.open("/login?redirect=" + currentURL.pathname + currentURL.search, "_self");
                                            }
                                        })
                                        break;
                                    case "No Permission":
                                        Swal.fire({
                                            title: 'You dont have permission to do this!',
                                            icon: 'error',
                                            confirmButtonText: 'OK',
                                            allowOutsideClick: false,
                                            allowEscapeKey: false,
                                        }).then((result) => {
                                            if (result.isConfirmed) {
                                                location.reload();
                                            }
                                        })
                                        break;
                                    default:
                                        Swal.fire({
                                            title: 'Success!',
                                            icon: 'success',
                                            confirmButtonText: 'OK',
                                            allowOutsideClick: false,
                                            allowEscapeKey: false,
                                        })
                                        .then((result) => {
                                            if (result.isConfirmed) {
                                                location.reload();
                                            }
                                        })
                                }
                            }
                        });
                    }
                })
        }
        
        deleteBtns.forEach(btn => {
            btn.onclick = () => {
                removeProduct(btn.dataset.slug)
            }
        })
    </script>
  </body>
</html>

