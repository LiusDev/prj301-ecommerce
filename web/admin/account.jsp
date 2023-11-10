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
    if(!currUser.getRole().equals("admin")) {
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
                <h2>Account</h2>
                <a class="main-btn success-btn btn-hover d-flex align-items-center" href="/admin/account/new">
                    <i class="lni lni-plus"></i> <span>New account</span>
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
                                <input type="text" name="keyword" id="keyword" placeholder="Search..." class="form-control" value="${param.keyword}"/>
                                <button class="btn btn-primary d-flex align-items-center justify-content-center">
                                    <i class="lni lni-search-alt"></i>
                                </button>
                            </div>
                          </form>
                      </div>
                      <div class="col-lg-6 d-flex justify-content-end gap-2">
                          <select class="form-select d-inline-block w-auto" title="Role" name="role" id="roleForm">
                            <option value="default">Role</option>
                            <option value="customer">Customer</option>
                            <option value="staff">Staff</option>
                            <option value="admin">Admin</option>
                          </select>
                          <select class="form-select d-inline-block w-auto" title="Status" name="status" id="statusForm">
                            <option value="default">Status</option>
                            <option value="active">Active</option>
                            <option value="banned">Banned</option>
                          </select>
                          <a class="btn btn-danger d-flex align-items-center justify-content-center" href="account">
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
                            <h6>Name</h6>
                          </th>
                          <th class="px-2">
                            <h6>Email</h6>
                          </th>
                          <th class="px-2">
                            <h6>Role</h6>
                          </th>
                          <th class="px-2">
                            <h6>Status</h6>
                          </th>
                          <th class="px-2">
                            <h6>Action</h6>
                          </th>
                        </tr>
                        <!-- end table row-->
                      </thead>
                      <tbody>
                        <c:forEach var="user" items="${allUser}" varStatus="loop">
                            <tr>
                              <td class="px-2">
                                <p>${loop.index + 1}</p>
                              </td>
                              <td class="px-2">
                                <a class="lead" href="/product?slug=${product.slug}">
                                  <div class="lead-image">
                                    <img src="/image/user?id=${user.id}" alt="${user.firstName}" />
                                  </div>
                                  <div class="lead-text">
                                    <p class="h6 mb-1 text-truncate">${user.firstName} ${user.lastName}</p>
                                  </div>
                                </a>
                              </td>
                              <td class="px-2">
                                <p>${user.email}</p>
                              </td>
                              <td class="px-2">
                                <c:choose>
                                    <c:when test="${user.role == \"customer\"}">
                                        <span class="status-btn light-btn">Customer</span>
                                    </c:when>
                                    <c:when test="${user.role == \"staff\"}">
                                        <span class="status-btn primary-btn">Staff</span>
                                    </c:when>
                                    <c:when test="${user.role == \"admin\"}">
                                        <span class="status-btn danger-btn">Admin</span>
                                    </c:when>
                                </c:choose>
                              </td>
                              <td class="px-2">
                                <c:choose>
                                    <c:when test="${user.banned == false}">
                                        <span class="status-btn success-btn">Active</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-btn danger-btn">Banned</span>
                                    </c:otherwise>
                                </c:choose>
                              </td>
                              <td>
                                <div class="action">
                                    <a class="text-success text-lg px-2" title="Edit" href="/admin/account/update?id=${user.id}">
                                        <i class="lni lni-pencil"></i>
                                    </a>
                                    <button class="text-danger text-lg px-2 deleteBtn" title="Delete" data-id="${user.id}">
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
        let role = params.get("role");
        let status = params.get("status");
        
        const submitParams = (keyword, role, status) => {
            let searchParams = {
                keyword,
                role,
                status
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
        
        const roleForm = document.querySelector("#roleForm");
        const roleOption = Array.from(roleForm.querySelectorAll("option"));
        roleForm.onchange = () => {
            submitParams(keyword, roleForm.value, status);
        };
        roleOption.forEach(option => {
            if(option.value === role) {
                option.selected = true;
            }
        });
        
        const statusForm = document.querySelector("#statusForm");
        const statusOption = Array.from(statusForm.querySelectorAll("option"));
        statusForm.onchange = () => {
            submitParams(keyword, role, statusForm.value);
        };
        statusOption.forEach(option => {
            if(option.value === status) {
                option.selected = true;
            }
        });
        
        const deleteBtns = Array.from(document.querySelectorAll(".deleteBtn"));
        
        const currentURL = new URL(document.location);
        const removeProduct = (id) => {
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
                            url:"/admin/account/delete",
                            data: 
                            {  
                                id: id
                            },
                            cache:false,
                            success: function (response) {
                                console.log(response);
                                switch(response) {
                                    case "Please login":
                                        Swal.fire({
                                            title: 'Please login to continue!',
                                            icon: 'error',
                                            confirmButtonText: 'Login',
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
                removeProduct(btn.dataset.id)
            }
        })
    </script>
  </body>
</html>

