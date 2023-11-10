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
    <title>Invoice | ${initParam['webName']}</title>

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
                <h2>Invoice</h2>
            </div>
            <!-- end row -->
          </div>
          <!-- ========== title-wrapper end ========== -->
          
          <div class="filters-wrapper">
              <div class="card-style mb-30">
                  <div class="row">
                      <div class="col-lg-6">
                          <form action="invoice" class="search my-3 my-lg-0">
                            <div class="input-group">
                                <input type="text" name="keyword" id="keyword" placeholder="Search" class="form-control" value="${param.keyword}"/>
                                <button class="btn btn-primary d-flex align-items-center justify-content-center">
                                    <i class="lni lni-search-alt"></i>
                                </button>
                            </div>
                          </form>
                      </div>
                      <div class="col-lg-6 d-flex justify-content-end gap-2">
                          <select class="form-select d-inline-block w-auto" title="Payment status" name="paymentStatus" id="paymentStatusForm">
                            <option value="default">Payment status</option>
                            <option value="unpaid">Unpaid</option>
                            <option value="paid">Paid</option>
                          </select>
                          <select class="form-select d-inline-block w-auto" title="Order status" name="orderStatus" id="orderStatusForm">
                            <option value="default">Order status</option>
                            <option value="pending">Pending</option>
                            <option value="approved">Approved</option>
                            <option value="shipping">Shipping</option>
                            <option value="received">Received</option>
                            <option value="canceledUser">Canceled: By user</option>
                            <option value="canceledAdmin">Canceled: By admin</option>
                          </select>
                          <a class="btn btn-danger d-flex align-items-center justify-content-center" href="invoice">
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
                            <h6>Receiver's information</h6>
                          </th>
                          <th class="px-2">
                            <h6>Address</h6>
                          </th>
                          <th class="px-2">
                            <h6>Transport unit</h6>
                          </th>
                          <th class="px-2">
                            <h6>Total price</h6>
                          </th>
                          <th class="px-2">
                            <h6>Payment status</h6>
                          </th>
                          <th class="px-2">
                            <h6>Order status</h6>
                          </th>
                          <th class="px-2">
                            <h6>Action</h6>
                          </th>
                        </tr>
                        <!-- end table row-->
                      </thead>
                      <tbody>
                        <c:forEach var="invoice" items="${invoices}" varStatus="loop">
                            <tr>
                              <td class="px-2">
                                <p>${loop.index + 1}</p>
                              </td>
                              <td class="px-2">
                                <a class="lead" href="/admin/invoice/detail?id=${invoice.id}">
                                  <div class="lead-text">
                                    <p class="h6 mb-1 text-truncate">${invoice.firstName} ${invoice.lastName}</p>
                                    <p>${invoice.phone} | ${invoice.email}</p>
                                  </div>
                                </a>
                              </td>
                              <td class="px-2">
                                <p>${invoice.address}</p>
                              </td>
                              <td class="px-2">
                                <p>${invoice.transportUnit.name}</p>
                              </td>
                              <td class="px-2">
                                <p>${String.format("%,d", invoice.totalPrice)} ₫</p>
                              </td>
                              <td>
                                <c:choose>
                                    <c:when test="${invoice.paymentStatus == false}">
                                        <span class="status-btn light-btn">Unpaid</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-btn success-btn">Paid</span>
                                    </c:otherwise>
                                </c:choose>
                              </td>
                              <td>
                                <c:choose>
                                    <c:when test="${invoice.status == 1 && invoice.userCanceled == true}">
                                        <span class="status-btn danger-btn">Canceled by user</span>
                                    </c:when>
                                    <c:when test="${invoice.status == 1 && invoice.userCanceled == false}">
                                        <span class="status-btn danger-btn">Canceled by admin</span>
                                    </c:when>
                                    <c:when test="${invoice.status == 2}">
                                        <span class="status-btn light-btn">Pending</span>
                                    </c:when>
                                    <c:when test="${invoice.status == 3}">
                                        <span class="status-btn primary-btn">Approved</span>
                                    </c:when>
                                    <c:when test="${invoice.status == 4}">
                                        <span class="status-btn info-btn">Shipping</span>
                                    </c:when>
                                    <c:when test="${invoice.status == 5}">
                                        <span class="status-btn success-btn">Received</span>
                                    </c:when>
                                </c:choose>
                              </td>
                              <td>
                                <div class="action">
                                    <a class="text-success text-lg px-2" href="/admin/invoice/detail?id=${invoice.id}">
                                        <i class="lni lni-pencil"></i>
                                    </a>
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
        let paymentStatus = params.get("paymentStatus");
        let status = params.get("status");
        
        const submitParams = (keyword, paymentStatus, status) => {
            let searchParams = {
                keyword,
                paymentStatus,
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
        
        const paymentStatusForm = document.querySelector("#paymentStatusForm");
        const paymentStatusOption = Array.from(paymentStatusForm.querySelectorAll("option"));
        paymentStatusForm.onchange = () => {
            submitParams(keyword, paymentStatusForm.value, status);
        };
        paymentStatusOption.forEach(option => {
            if(option.value === paymentStatus) {
                option.selected = true;
            }
        });
        
        const orderStatusForm = document.querySelector("#orderStatusForm");
        const orderStatusOption = Array.from(orderStatusForm.querySelectorAll("option"));
        orderStatusForm.onchange = () => {
            submitParams(keyword, paymentStatus, orderStatusForm.value);
        };
        orderStatusOption.forEach(option => {
            if(option.value === status) {
                option.selected = true;
            }
        });
    </script>
  </body>
</html>

