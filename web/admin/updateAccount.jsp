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
  <title>Update Account | ${initParam['webName']}</title>

  <!-- ========== All CSS files linkup ========= -->
  <link rel="stylesheet" href="https://demo.plainadmin.com/assets/css/bootstrap.min.css" />
  <link rel="stylesheet" href="https://demo.plainadmin.com/assets/css/lineicons.css" />
  <link rel="stylesheet" href="https://demo.plainadmin.com/assets/css/materialdesignicons.min.css" />
  <link rel="stylesheet" href="https://demo.plainadmin.com/assets/css/fullcalendar.css" />
  <link rel="stylesheet" href="https://cdn.quilljs.com/1.3.6/quill.snow.css">
  <link href="https://bootstrap-ecommerce-web.netlify.app/css/ui.css?v=2.0" rel="stylesheet" type="text/css">
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
    <main class="main-wrapper pb-4">
      <!-- ========== header start ========== -->
    <%@include file="/components/adminHeader.jsp" %>
      <!-- ========== header end ========== -->

        <section class="table-components">
            <div class="container-fluid">
                <div class="title-wrapper pt-30">
                    <div class="d-flex align-items-center justify-content-between mb-4">
                        <h2>Update Account</h2>
                        <div class="breadcrumb-wrapper d-flex align-items-center mb-0">
                            <nav aria-label="breadcrumb">
                                <ol class="breadcrumb mb-0">
                                    <li class="breadcrumb-item">
                                        <a href="/admin/account">Account</a>
                                    </li>
                                    <li class="breadcrumb-item active" aria-current="page">
                                        Update account
                                    </li>
                                </ol>
                            </nav>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg-7">
                        <div class="card-style mb-30">
                            <h6 class="mb-25">Information</h6>
                            <form id="infoForm" class="form-elements-wrapper">
                                <div class="row">
                                    <div class="col-lg-6">
                                        <div class="input-style-1">
                                            <label>First name</label>
                                            <input type="text" name="firstName" id="firstName" value="${user.firstName}"/>
                                        </div>
                                        <div class="input-style-1">
                                            <label>Last name</label>
                                            <input type="text" name="lastName" id="lastName" value="${user.lastName}"/>
                                        </div>
                                    </div>
                                    <div class="col-lg-6 d-flex flex-column align-items-center">
                                        <img id="avatar" src="/image/user?id=${user.id}" class="me-2 mb-3 rounded-circle" width="164" height="164" style="object-fit: cover" alt="${user.firstName}">
                                        <input name="avatar" type="file" class="form-control" id="avatarUpload" accept=".jpg, .png" style="width: 240px"/>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="input-style-1">
                                        <label>Email</label>
                                        <input type="text" name="email" id="email" value="${user.email}"/>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="input-style-1">
                                        <label>Bio</label>
                                        <input type="text" name="bio" id="bio" value="${user.bio}"/>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-4">
                                        <div class="select-style-1">
                                            <label>Role</label>
                                            <div class="select-position">
                                                <select id="role" name="role">
                                                    <option value="customer" ${user.role == "customer" ? "selected" : ""}>Customer</option>
                                                    <option value="staff" ${user.role == "staff" ? "selected" : ""}>Staff</option>
                                                    <option value="admin" ${user.role == "admin" ? "selected" : ""}>Admin</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-lg-4">
                                        <div class="select-style-1">
                                            <label>Status</label>
                                            <div class="select-position">
                                                <select id="status" name="status">
                                                    <option value="active" ${user.banned == false ? "selected" : ""}>Active</option>
                                                    <option value="banned" ${user.banned == true ? "selected" : ""}>Banned</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-lg-4">
                                        <div class="input-style-1">
                                            <label>Password</label>
                                            <button type="button" class="main-btn danger-btn btn-hover" id="resetPasswordBtn">Reset password</button>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                    <div class="col-lg-5">
                        <div class="card-style mb-30">
                            <h6 class="mb-25">Cart</h6>
                            <div class="row">
                                <c:forEach var="product" items="${cartProducts}" varStatus="loop">
                                    <article class="row mb-4">
                                        <div class="col-lg-9">
                                            <figure class="d-flex align-items-start">
                                                <a href="/product?slug=${product.slug}" class="me-3 flex-shrink-0">
                                                    <img src="/image/product?id=${product.imageId}" class="size-100x100 img-thumbnail">
                                                </a>
                                                <figcaption class="info">
                                                    <a class="title" href="/product?slug=${product.slug}"><b>${product.name}</b></a>
                                                    <p class="text-muted"> 
                                                        ${product.variant}
                                                    </p>
                                                    <p> 
                                                        x${product.cartQuantity}
                                                    </p>
                                                </figcaption>
                                            </figure>
                                        </div> 
                                        <div class="col-lg-3 d-flex align-items-center justify-content-end">
                                            <var class="h5 productPrice">${String.format("%,d", product.price * product.cartQuantity)} ₫</var> 
                                        </div>
                                    </article>
                                    <hr/>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="card-style d-flex position-sticky justify-content-end gap-3 shadow-lg" style="z-index: 100; bottom: 1.5rem">
                    <a class="btn btn-outline-secondary" href="/admin/account">Cancel</a>
                    <button type="button" class="btn btn-danger" id="deleteBtn">Delete</button>
                    <button type="button" class="btn btn-success" id="submitBtn">Update</button>
                </div>
            </div>
        </section>
    </main>

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
    <script src="https://cdn.quilljs.com/1.3.6/quill.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        const avatar = document.querySelector("#avatar");
        const avatarUpload = document.querySelector("#avatarUpload");
        const submitBtn = document.querySelector("#submitBtn");
        
        avatarUpload.addEventListener('change', function(event) {
            const file = event.target.files[0];

            if (file) {
                const reader = new FileReader();

                reader.onload = function(e) {
                  avatar.src = e.target.result;
                };

                reader.readAsDataURL(file);
            }
        });

        submitBtn.onclick = () => {
            const infoForm = document.querySelector("#infoForm");
            let data = new FormData(infoForm);
            data.append("id", "${user.id}");
            $.ajax({
                type:"post",
                url:"/admin/account/update",
                processData: false,
                contentType: false,
                enctype : "multipart/form-data",
                data: data,
                cache:false,
                success: function (response) 
                {
                    
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
                                        window.open("/login", "_self");
                                    }
                                })
                                break;
                            case "Failed":
                                Swal.fire({
                                    title: 'Failed!',
                                    icon: 'error',
                                    confirmButtonText: 'OK',
                                    allowOutsideClick: false,
                                    allowEscapeKey: false,
                                })
                                break;
                            case "Fill info":
                                Swal.fire({
                                    title: 'Please fill info',
                                    icon: 'error',
                                    confirmButtonText: 'OK',
                                })
                                break;
                            case "Email exist":
                                Swal.fire({
                                    title: 'Email exist, please try another!',
                                    icon: 'error',
                                    confirmButtonText: 'OK',
                                })
                                break;
                            default:
                                Swal.fire({
                                    title: 'Update infomation successfully',
                                    icon: 'success',
                                    confirmButtonText: 'OK',
                                    allowOutsideClick: false,
                                    allowEscapeKey: false,
                                }).then((result) => {
                                    if (result.isConfirmed) {
                                        window.open("/admin/account", "_self");
                                    }
                                })  
                                
                    }
                }
            });
        }
        
        const resetPasswordBtn = document.querySelector("#resetPasswordBtn");
        resetPasswordBtn.onclick = () => {
            $.ajax({
                type:"post",
                url:"/admin/account/reset-password",
                data: {
                    id: "${user.id}"
                },
                cache:false,
                success: function (response) 
                {
                    
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
                                        window.open("/login", "_self");
                                    }
                                })
                                break;
                            case "Failed":
                                Swal.fire({
                                    title: 'Failed!',
                                    icon: 'error',
                                    confirmButtonText: 'OK',
                                    allowOutsideClick: false,
                                    allowEscapeKey: false,
                                })
                                break;
                            default:
                                Swal.fire({
                                    title: 'Reset password successfully',
                                    text: 'Default password: 123456',
                                    icon: 'success',
                                    confirmButtonText: 'OK',
                                    allowOutsideClick: false,
                                    allowEscapeKey: false,
                                }).then((result) => {
                                    if (result.isConfirmed) {
                                        window.open("/admin/account", "_self");
                                    }
                                })  
                                
                    }
                }
            });
        }
    </script>
</body>
</html>

