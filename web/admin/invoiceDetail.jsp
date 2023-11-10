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
  <title>Invoice Detail | ${initParam['webName']}</title>

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
                        <h2>Invoice Detail</h2>
                        <div class="breadcrumb-wrapper d-flex align-items-center mb-0">
                            <nav aria-label="breadcrumb">
                                <ol class="breadcrumb mb-0">
                                    <li class="breadcrumb-item">
                                        <a href="/admin/invoice">Invoice</a>
                                    </li>
                                    <li class="breadcrumb-item active" aria-current="page">
                                        Detail
                                    </li>
                                </ol>
                            </nav>
                        </div>
                    </div>
                </div>
                <form id="basicInfoForm" class="form-elements-wrapper">
                    <div class="row">
                        <div class="col-lg-7">
                            <div class="card-style mb-30">
                                <div class="title d-flex justify-content-between align-items-center mb-25">
                                    <div class="left">
                                        <h6>Order information</h6>
                                    </div>
                                    <div class="right">
                                        <p>${invoice.createdAt} | <b>INV${invoice.id}</b></p>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-6">
                                        <div class="select-style-1">
                                            <label>Payment status</label>
                                            <div class="select-position">
                                                <select id="paymentStatus">
                                                    <option value="unpaid" ${invoice.paymentStatus == false ? "selected" : ""}>Unpaid</option>
                                                    <option value="paid" ${invoice.paymentStatus == true ? "selected" : ""}>Paid</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-lg-6">
                                        <div class="select-style-1">
                                            <label>Order status</label>
                                            <div class="select-position">
                                                <select id="orderStatus" ${invoice.status == 1 && invoice.userCanceled == true ? "disabled style=\"background: rgba(239, 239, 239, 0.5\")" : ""}>
                                                    <option value="pending" ${invoice.status == 2 ? "selected" : ""}>Pending</option>
                                                    <option value="approved" ${invoice.status == 3 ? "selected" : ""}>Approved</option>
                                                    <option value="shipping" ${invoice.status == 4 ? "selected" : ""}>Shipping</option>
                                                    <option value="received" ${invoice.status == 5 ? "selected" : ""}>Received</option>
                                                    <option value="canceled" ${invoice.status == 1 && invoice.userCanceled == false ? "selected" : ""}>Canceled</option>
                                                    <c:if test="${invoice.status == 1 && invoice.userCanceled == true}">
                                                        <option value="canceledUser" ${invoice.status == 1 && invoice.userCanceled == true ? "selected" : ""}>Canceled: By user</option>
                                                    </c:if>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-6">
                                        <div class="input-style-1">
                                            <label>Name</label>
                                            <input type="text" value="${invoice.firstName} ${invoice.lastName}" disabled/>
                                        </div>
                                    </div>
                                    <div class="col-lg-6">
                                        <div class="input-style-1">
                                            <label>Phone</label>
                                            <input type="text" value="${invoice.phone}" disabled/>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="input-style-1">
                                        <label>Email</label>
                                        <input type="text" value="${invoice.email}" disabled/>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="input-style-1">
                                        <label>Address</label>
                                        <input type="text" value="${invoice.address}" disabled/>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="input-style-1">
                                        <label>Message</label>
                                        <input type="text" value="${invoice.message}" disabled/>
                                    </div>
                                </div>
                            </div>
                            <div class="card-style mb-30">
                                <h6 class="mb-25">Transport</h6>
                                <div class="row">
                                    <div class="col-lg-6">
                                        <div class="input-style-1">
                                            <label>Transport Unit</label>
                                            <input type="text" value="${invoice.transportUnit.name}" disabled/>
                                        </div>
                                    </div>
                                    <div class="col-lg-6">
                                        <div class="input-style-1">
                                            <label>Transport Type</label>
                                            <input type="text" value="${invoice.transportUnit.type}" disabled/>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-6">
                                        <div class="input-style-1">
                                            <label>Shipping fee</label>
                                            <input type="text" value="${String.format("%,d",invoice.transportUnit.price)} ₫" disabled/>
                                        </div>
                                    </div>
                                    <div class="col-lg-6">
                                        <div class="input-style-1">
                                            <label>Shipping time</label>
                                            <input type="text" value="${invoice.transportUnit.fastestShipping} - ${invoice.transportUnit.slowestShipping} days" disabled/>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-5">
                            <div class="card-style mb-30">
                                <h6 class="mb-25">Order detail</h6>
                                <div class="row">
                                    <c:forEach var="product" items="${invoice.invoiceDetails}" varStatus="loop">
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
                                <div class="row">
                                    <dl class="row">
                                            <dt class="col-5 fw-normal text-muted">Subtotal:</dt>
                                            <dd class="col-7 text-end" id="subtotal">${String.format("%,d", invoice.subTotal)} ₫</dd>

                                            <dt class="col-5 fw-normal text-muted">Discount:</dt>
                                            <dd class="col-7 text-end" id="discount">0 ₫</dd>

                                            <dt class="col-5 fw-normal text-muted">Tax:</dt>
                                            <dd class="col-7 text-end" id="tax">+ ${String.format("%,.0f", invoice.subTotal * 0.1)} ₫</dd>

                                            <dt class="col-5 fw-normal text-muted">Shipping:</dt>
                                            <dd class="col-7 text-end" id="shipping">+ ${String.format("%,d", invoice.transportUnit.price)} ₫</dd>
                                    </dl>
                                    <hr>
                                    <dl class="row">
                                            <dt class="col-5 h5 text-muted">Total:</dt>
                                            <dd class="col-7 h5 text-end" id="total"> ${String.format("%,d", invoice.totalPrice)} ₫ </dd>
                                    </dl>
                                </div> <!-- card-body.// -->
                            </div>
                        </div>
                    </div>
                    <div class="card-style d-flex position-sticky justify-content-end gap-3 shadow-lg py-3" style="z-index: 100; bottom: 1.5rem">
                        <a class="btn btn-outline-secondary" href="/admin/invoice">Cancel</a>
                        <button type="button" class="btn btn-success" id="submitBtn">Save</button>
                    </div>
                </form>
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
        const invoiceJSON = ${invoiceJSON}
        const paymentStatus = document.querySelector("#paymentStatus");
        const orderStatus = document.querySelector("#orderStatus");
        const submitBtn = document.querySelector("#submitBtn");
        let params = new URL(document.location).searchParams;
        let id = params.get("id");
        submitBtn.onclick = () => {
            $.ajax({
                type:"post",
                url:"/admin/invoice/update",
                data: {
                    id: id,
                    paymentStatus: paymentStatus.value,
                    status: orderStatus.value
                },
                cache: false,
                success: function (response) {

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
                                title: 'Update invoice successfully',
                                icon: 'success',
                                confirmButtonText: 'OK',
                                allowOutsideClick: false,
                                allowEscapeKey: false,
                            }).then((result) => {
                                if (result.isConfirmed) {
                                    window.open("/admin/invoice", "_self");
                                }
                            })
                    }
                }
            });
        }
    </script>
</body>
</html>

