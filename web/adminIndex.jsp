<%-- 
    Document   : admin
    Created on : Sep 28, 2023, 3:03:32 AM
    Author     : LiusDev
--%>

<%@page import="model.User" %>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    User currUser = (User) session.getAttribute("user");
    if(currUser == null) {
        response.sendRedirect("/login");
        return;
    }
    if(!currUser.getRole().equals("admin") && !currUser.getRole().equals("staff")) {
        request.getRequestDispatcher("noPermission.jsp").forward(request, response);
        return;
    }
%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="shortcut icon" href="assets/images/favicon.svg" type="image/x-icon" />
    <title>Admin Dashboard | ${initParam['webName']}</title>

    <!-- ========== All CSS files linkup ========= -->
    <link rel="stylesheet" href="https://demo.plainadmin.com/assets/css/bootstrap.min.css" />
    <link rel="stylesheet" href="https://demo.plainadmin.com/assets/css/lineicons.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="https://demo.plainadmin.com/assets/css/materialdesignicons.min.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="https://demo.plainadmin.com/assets/css/fullcalendar.css" />
    <link rel="stylesheet" href="https://demo.plainadmin.com/assets/css/main.css" />
  </head>
  <body>
    <!-- ======== Preloader =========== -->
    <div id="preloader">
      <div class="spinner"></div>
    </div>
    <!-- ======== Preloader =========== -->

    <!-- ======== sidebar-nav start =========== -->
    <%@include file="/components/adminSidebar.jsp" %>
    <!-- ======== sidebar-nav end =========== -->

    <!-- ======== main-wrapper start =========== -->
    <main class="main-wrapper">
      <!-- ========== header start ========== -->
      <%@include file="/components/adminHeader.jsp" %>
      <!-- ========== header end ========== -->

      <!-- ========== section start ========== -->
      <section class="section">
        <div class="container-fluid">
          <!-- ========== title-wrapper start ========== -->
          <div class="title-wrapper pt-30">
            <div class="row align-items-center">
              <div class="title">
                <h2>eCommerce Dashboard</h2>
              </div>
            </div>
            <!-- end row -->
          </div>
          <!-- ========== title-wrapper end ========== -->
          <div class="row">
            <div class="col-xl-3 col-lg-4 col-sm-6">
              <div class="icon-card mb-30">
                <div class="icon purple">
                  <i class="lni lni-cart-full"></i>
                </div>
                <div class="content">
                  <h6 class="mb-10">New Orders</h6>
                  <h3 class="text-bold mb-10">34567</h3>
                  <p class="text-sm text-success">
                    <i class="lni lni-arrow-up"></i> +2.00%
                    <span class="text-gray">(30 days)</span>
                  </p>
                </div>
              </div>
              <!-- End Icon Cart -->
            </div>
            <!-- End Col -->
            <div class="col-xl-3 col-lg-4 col-sm-6">
              <div class="icon-card mb-30">
                <div class="icon success">
                  <i class="lni lni-dollar"></i>
                </div>
                <div class="content">
                  <h6 class="mb-10">Total Income</h6>
                  <h3 class="text-bold mb-10">$74,567</h3>
                  <p class="text-sm text-success">
                    <i class="lni lni-arrow-up"></i> +5.45%
                    <span class="text-gray">Increased</span>
                  </p>
                </div>
              </div>
              <!-- End Icon Cart -->
            </div>
            <!-- End Col -->
            <div class="col-xl-3 col-lg-4 col-sm-6">
              <div class="icon-card mb-30">
                <div class="icon primary">
                  <i class="lni lni-credit-cards"></i>
                </div>
                <div class="content">
                  <h6 class="mb-10">Total Expense</h6>
                  <h3 class="text-bold mb-10">$24,567</h3>
                  <p class="text-sm text-danger">
                    <i class="lni lni-arrow-down"></i> -2.00%
                    <span class="text-gray">Expense</span>
                  </p>
                </div>
              </div>
              <!-- End Icon Cart -->
            </div>
            <!-- End Col -->
            <div class="col-xl-3 col-lg-4 col-sm-6">
              <div class="icon-card mb-30">
                <div class="icon orange">
                  <i class="lni lni-user"></i>
                </div>
                <div class="content">
                  <h6 class="mb-10">New User</h6>
                  <h3 class="text-bold mb-10">34567</h3>
                  <p class="text-sm text-danger">
                    <i class="lni lni-arrow-down"></i> -25.00%
                    <span class="text-gray"> Earning</span>
                  </p>
                </div>
              </div>
              <!-- End Icon Cart -->
            </div>
            <!-- End Col -->
          </div>
          <!-- End Row -->
          <div class="row">
            <div class="col-lg-7">
              <div class="card-style mb-30">
                <div class="title d-flex flex-wrap justify-content-between">
                  <div class="left">
                    <h6 class="text-medium mb-10">Yearly Stats</h6>
                    <h3 class="text-bold">$245,479</h3>
                  </div>
                  <div class="right">
                    <div class="select-style-1">
                      <div class="select-position select-sm">
                        <select class="light-bg">
                          <option value="">Yearly</option>
                          <option value="">Monthly</option>
                          <option value="">Weekly</option>
                        </select>
                      </div>
                    </div>
                    <!-- end select -->
                  </div>
                </div>
                <!-- End Title -->
                <div class="chart">
                  <canvas id="Chart1" style="width: 100%; height: 400px; margin-left: -35px;"></canvas>
                </div>
                <!-- End Chart -->
              </div>
            </div>
            <!-- End Col -->
            <div class="col-lg-5">
              <div class="card-style mb-30">
                <div class="title d-flex flex-wrap align-items-center justify-content-between">
                  <div class="left">
                    <h6 class="text-medium mb-30">Sales/Revenue</h6>
                  </div>
                  <div class="right">
                    <div class="select-style-1">
                      <div class="select-position select-sm">
                        <select class="light-bg">
                          <option value="">Yearly</option>
                          <option value="">Monthly</option>
                          <option value="">Weekly</option>
                        </select>
                      </div>
                    </div>
                    <!-- end select -->
                  </div>
                </div>
                <!-- End Title -->
                <div class="chart">
                  <canvas id="Chart2" style="width: 100%; height: 400px; margin-left: -45px;"></canvas>
                </div>
                <!-- End Chart -->
              </div>
            </div>
            <!-- End Col -->
          </div>
          <!-- End Row -->
          <div class="row">
            <div class="col-lg-5">
              <div class="card-style mb-30">
                <div class="title d-flex justify-content-between align-items-center">
                  <div class="left">
                    <h6 class="text-medium mb-30">Sells by State</h6>
                  </div>
                </div>
                <!-- End Title -->
                <div id="map" style="width: 100%; height: 400px; overflow: hidden;"></div>
                <p>Last updated: 7 days ago</p>
              </div>
            </div>
            <!-- End Col -->
            <div class="col-lg-7">
              <div class="card-style mb-30">
                <div class="title d-flex flex-wrap justify-content-between align-items-center">
                  <div class="left">
                    <h6 class="text-medium mb-30">Top Selling Products</h6>
                  </div>
                  <div class="right">
                    <div class="select-style-1">
                      <div class="select-position select-sm">
                        <select class="light-bg">
                          <option value="">Yearly</option>
                          <option value="">Monthly</option>
                          <option value="">Weekly</option>
                        </select>
                      </div>
                    </div>
                    <!-- end select -->
                  </div>
                </div>
                <!-- End Title -->
                <div class="table-responsive">
                  <table class="table top-selling-table">
                    <thead>
                      <tr>
                        <th></th>
                        <th>
                          <h6 class="text-sm text-medium">Products</h6>
                        </th>
                        <th class="min-width">
                          <h6 class="text-sm text-medium">Category</h6>
                        </th>
                        <th class="min-width">
                          <h6 class="text-sm text-medium">Price</h6>
                        </th>
                        <th class="min-width">
                          <h6 class="text-sm text-medium">Sold</h6>
                        </th>
                        <th class="min-width">
                          <h6 class="text-sm text-medium">Profit</h6>
                        </th>
                        <th></th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr>
                        <td>
                          <div class="check-input-primary">
                            <input class="form-check-input" type="checkbox" id="checkbox-1" />
                          </div>
                        </td>
                        <td>
                          <div class="product">
                            <div class="image">
                              <img src="assets/images/products/product-mini-1.jpg" alt="" />
                            </div>
                            <p class="text-sm">Arm Chair</p>
                          </div>
                        </td>
                        <td>
                          <p class="text-sm">Interior</p>
                        </td>
                        <td>
                          <p class="text-sm">$345</p>
                        </td>
                        <td>
                          <p class="text-sm">43</p>
                        </td>
                        <td>
                          <p class="text-sm">$45</p>
                        </td>
                        <td>
                          <div class="action justify-content-end">
                            <button class="more-btn ml-10 dropdown-toggle" id="moreAction1" data-bs-toggle="dropdown"
                              aria-expanded="false">
                              <i class="lni lni-more-alt"></i>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="moreAction1">
                              <li class="dropdown-item">
                                <a href="#0" class="text-gray">Remove</a>
                              </li>
                              <li class="dropdown-item">
                                <a href="#0" class="text-gray">Edit</a>
                              </li>
                            </ul>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td>
                          <div class="check-input-primary">
                            <input class="form-check-input" type="checkbox" id="checkbox-1" />
                          </div>
                        </td>
                        <td>
                          <div class="product">
                            <div class="image">
                              <img src="assets/images/products/product-mini-2.jpg" alt="" />
                            </div>
                            <p class="text-sm">SOfa</p>
                          </div>
                        </td>
                        <td>
                          <p class="text-sm">Interior</p>
                        </td>
                        <td>
                          <p class="text-sm">$145</p>
                        </td>
                        <td>
                          <p class="text-sm">13</p>
                        </td>
                        <td>
                          <p class="text-sm">$15</p>
                        </td>
                        <td>
                          <div class="action justify-content-end">
                            <button class="more-btn ml-10 dropdown-toggle" id="moreAction1" data-bs-toggle="dropdown"
                              aria-expanded="false">
                              <i class="lni lni-more-alt"></i>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="moreAction1">
                              <li class="dropdown-item">
                                <a href="#0" class="text-gray">Remove</a>
                              </li>
                              <li class="dropdown-item">
                                <a href="#0" class="text-gray">Edit</a>
                              </li>
                            </ul>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td>
                          <div class="check-input-primary">
                            <input class="form-check-input" type="checkbox" id="checkbox-1" />
                          </div>
                        </td>
                        <td>
                          <div class="product">
                            <div class="image">
                              <img src="assets/images/products/product-mini-3.jpg" alt="" />
                            </div>
                            <p class="text-sm">Dining Table</p>
                          </div>
                        </td>
                        <td>
                          <p class="text-sm">Interior</p>
                        </td>
                        <td>
                          <p class="text-sm">$95</p>
                        </td>
                        <td>
                          <p class="text-sm">32</p>
                        </td>
                        <td>
                          <p class="text-sm">$215</p>
                        </td>
                        <td>
                          <div class="action justify-content-end">
                            <button class="more-btn ml-10 dropdown-toggle" id="moreAction1" data-bs-toggle="dropdown"
                              aria-expanded="false">
                              <i class="lni lni-more-alt"></i>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="moreAction1">
                              <li class="dropdown-item">
                                <a href="#0" class="text-gray">Remove</a>
                              </li>
                              <li class="dropdown-item">
                                <a href="#0" class="text-gray">Edit</a>
                              </li>
                            </ul>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td>
                          <div class="check-input-primary">
                            <input class="form-check-input" type="checkbox" id="checkbox-1" />
                          </div>
                        </td>
                        <td>
                          <div class="product">
                            <div class="image">
                              <img src="assets/images/products/product-mini-4.jpg" alt="" />
                            </div>
                            <p class="text-sm">Office Chair</p>
                          </div>
                        </td>
                        <td>
                          <p class="text-sm">Interior</p>
                        </td>
                        <td>
                          <p class="text-sm">$105</p>
                        </td>
                        <td>
                          <p class="text-sm">23</p>
                        </td>
                        <td>
                          <p class="text-sm">$345</p>
                        </td>
                        <td>
                          <div class="action justify-content-end">
                            <button class="more-btn ml-10 dropdown-toggle" id="moreAction1" data-bs-toggle="dropdown"
                              aria-expanded="false">
                              <i class="lni lni-more-alt"></i>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="moreAction1">
                              <li class="dropdown-item">
                                <a href="#0" class="text-gray">Remove</a>
                              </li>
                              <li class="dropdown-item">
                                <a href="#0" class="text-gray">Edit</a>
                              </li>
                            </ul>
                          </div>
                        </td>
                      </tr>
                    </tbody>
                  </table>
                  <!-- End Table -->
                </div>
              </div>
            </div>
            <!-- End Col -->
          </div>
          <!-- End Row -->
          <div class="row">
            <div class="col-lg-7">
              <div class="card-style mb-30">
                <div class="title d-flex flex-wrap align-items-center justify-content-between">
                  <div class="left">
                    <h6 class="text-medium mb-2">Sales Forecast</h6>
                  </div>
                  <div class="right">
                    <div class="select-style-1 mb-2">
                      <div class="select-position select-sm">
                        <select class="light-bg">
                          <option value="">Last Month</option>
                          <option value="">Last 3 Months</option>
                          <option value="">Last Year</option>
                        </select>
                      </div>
                    </div>
                    <!-- end select -->
                  </div>
                </div>
                <!-- End Title -->
                <div class="chart">
                  <div id="legend3">
                    <ul class="legend3 d-flex flex-wrap align-items-center mb-30">
                      <li>
                        <div class="d-flex">
                          <span class="bg-color primary-bg"> </span>
                          <div class="text">
                            <p class="text-sm text-success">
                              <span class="text-dark">Revenue</span> +25.55%
                              <i class="lni lni-arrow-up"></i>
                            </p>
                          </div>
                        </div>
                      </li>
                      <li>
                        <div class="d-flex">
                          <span class="bg-color purple-bg"></span>
                          <div class="text">
                            <p class="text-sm text-success">
                              <span class="text-dark">Net Profit</span> +45.55%
                              <i class="lni lni-arrow-up"></i>
                            </p>
                          </div>
                        </div>
                      </li>
                      <li>
                        <div class="d-flex">
                          <span class="bg-color orange-bg"></span>
                          <div class="text">
                            <p class="text-sm text-danger">
                              <span class="text-dark">Order</span> -4.2%
                              <i class="lni lni-arrow-down"></i>
                            </p>
                          </div>
                        </div>
                      </li>
                    </ul>
                  </div>
                  <canvas id="Chart3" style="width: 100%; height: 450px; margin-left: -35px;"></canvas>
                </div>
              </div>
            </div>
            <!-- End Col -->
            <div class="col-lg-5">
              <div class="card-style mb-30">
                <div class="title d-flex flex-wrap align-items-center justify-content-between">
                  <div class="left">
                    <h6 class="text-medium mb-2">Traffic</h6>
                  </div>
                  <div class="right">
                    <div class="select-style-1 mb-2">
                      <div class="select-position select-sm">
                        <select class="bg-ligh">
                          <option value="">Last 6 Months</option>
                          <option value="">Last 3 Months</option>
                          <option value="">Last Year</option>
                        </select>
                      </div>
                    </div>
                    <!-- end select -->
                  </div>
                </div>
                <!-- End Title -->
                <div class="chart">
                  <div id="legend4">
                    <ul class="legend3 d-flex flex-wrap gap-3 gap-sm-0 align-items-center mb-30">
                      <li>
                        <div class="d-flex">
                          <span class="bg-color primary-bg"> </span>
                          <div class="text">
                            <p class="text-sm text-success">
                              <span class="text-dark">Store Visits</span>
                              +25.55%
                              <i class="lni lni-arrow-up"></i>
                            </p>
                            <h2>3456</h2>
                          </div>
                        </div>
                      </li>
                      <li>
                        <div class="d-flex">
                          <span class="bg-color danger-bg"></span>
                          <div class="text">
                            <p class="text-sm text-danger">
                              <span class="text-dark">Visitors</span> -2.05%
                              <i class="lni lni-arrow-down"></i>
                            </p>
                            <h2>3456</h2>
                          </div>
                        </div>
                      </li>
                    </ul>
                  </div>
                  <canvas id="Chart4" style="width: 100%; height: 420px; margin-left: -35px;"></canvas>
                </div>
                <!-- End Chart -->
              </div>
            </div>
            <!-- End Col -->
          </div>
          <!-- End Row -->
          <div class="row">
            <div class="col-lg-5">
              <div class="card-style calendar-card mb-30">
                <div id="calendar-mini"></div>
              </div>
            </div>
            <!-- End Col -->
            <div class="col-lg-7">
              <div class="card-style mb-30">
                <div class="title d-flex flex-wrap align-items-center justify-content-between">
                  <div class="left">
                    <h6 class="text-medium mb-30">Sales History</h6>
                  </div>
                  <div class="right">
                    <div class="select-style-1">
                      <div class="select-position select-sm">
                        <select class="light-bg">
                          <option value="">Today</option>
                          <option value="">Yesterday</option>
                        </select>
                      </div>
                    </div>
                    <!-- end select -->
                  </div>
                </div>
                <!-- End Title -->
                <div class="table-responsive">
                  <table class="table top-selling-table">
                    <thead>
                      <tr>
                        <th>
                          <h6 class="text-sm text-medium">Products</h6>
                        </th>
                        <th class="min-width">
                          <h6 class="text-sm text-medium">
                            Category <i class="lni lni-arrows-vertical"></i>
                          </h6>
                        </th>
                        <th class="min-width">
                          <h6 class="text-sm text-medium">
                            Revenue <i class="lni lni-arrows-vertical"></i>
                          </h6>
                        </th>
                        <th class="min-width">
                          <h6 class="text-sm text-medium">
                            Status <i class="lni lni-arrows-vertical"></i>
                          </h6>
                        </th>
                        <th>
                          <h6 class="text-sm text-medium text-end">
                            Actions <i class="lni lni-arrows-vertical"></i>
                          </h6>
                        </th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr>
                        <td>
                          <div class="product">
                            <div class="image">
                              <img src="assets/images/products/product-mini-1.jpg" alt="" />
                            </div>
                            <p class="text-sm">Bedroom</p>
                          </div>
                        </td>
                        <td>
                          <p class="text-sm">Interior</p>
                        </td>
                        <td>
                          <p class="text-sm">$345</p>
                        </td>
                        <td>
                          <span class="status-btn close-btn">Pending</span>
                        </td>
                        <td>
                          <div class="action justify-content-end">
                            <button class="edit">
                              <i class="lni lni-pencil"></i>
                            </button>
                            <button class="more-btn ml-10 dropdown-toggle" id="moreAction1" data-bs-toggle="dropdown"
                              aria-expanded="false">
                              <i class="lni lni-more-alt"></i>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="moreAction1">
                              <li class="dropdown-item">
                                <a href="#0" class="text-gray">Remove</a>
                              </li>
                              <li class="dropdown-item">
                                <a href="#0" class="text-gray">Edit</a>
                              </li>
                            </ul>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td>
                          <div class="product">
                            <div class="image">
                              <img src="assets/images/products/product-mini-2.jpg" alt="" />
                            </div>
                            <p class="text-sm">Arm Chair</p>
                          </div>
                        </td>
                        <td>
                          <p class="text-sm">Interior</p>
                        </td>
                        <td>
                          <p class="text-sm">$345</p>
                        </td>
                        <td>
                          <span class="status-btn warning-btn">Refund</span>
                        </td>
                        <td>
                          <div class="action justify-content-end">
                            <button class="edit">
                              <i class="lni lni-pencil"></i>
                            </button>
                            <button class="more-btn ml-10 dropdown-toggle" id="moreAction1" data-bs-toggle="dropdown"
                              aria-expanded="false">
                              <i class="lni lni-more-alt"></i>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="moreAction1">
                              <li class="dropdown-item">
                                <a href="#0" class="text-gray">Remove</a>
                              </li>
                              <li class="dropdown-item">
                                <a href="#0" class="text-gray">Edit</a>
                              </li>
                            </ul>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td>
                          <div class="product">
                            <div class="image">
                              <img src="assets/images/products/product-mini-3.jpg" alt="" />
                            </div>
                            <p class="text-sm">Sofa</p>
                          </div>
                        </td>
                        <td>
                          <p class="text-sm">Interior</p>
                        </td>
                        <td>
                          <p class="text-sm">$345</p>
                        </td>
                        <td>
                          <span class="status-btn success-btn">Completed</span>
                        </td>
                        <td>
                          <div class="action justify-content-end">
                            <button class="edit">
                              <i class="lni lni-pencil"></i>
                            </button>
                            <button class="more-btn ml-10 dropdown-toggle" id="moreAction1" data-bs-toggle="dropdown"
                              aria-expanded="false">
                              <i class="lni lni-more-alt"></i>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="moreAction1">
                              <li class="dropdown-item">
                                <a href="#0" class="text-gray">Remove</a>
                              </li>
                              <li class="dropdown-item">
                                <a href="#0" class="text-gray">Edit</a>
                              </li>
                            </ul>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td>
                          <div class="product">
                            <div class="image">
                              <img src="assets/images/products/product-mini-4.jpg" alt="" />
                            </div>
                            <p class="text-sm">Kitchen</p>
                          </div>
                        </td>
                        <td>
                          <p class="text-sm">Interior</p>
                        </td>
                        <td>
                          <p class="text-sm">$345</p>
                        </td>
                        <td>
                          <span class="status-btn close-btn">Canceled</span>
                        </td>
                        <td>
                          <div class="action justify-content-end">
                            <button class="edit">
                              <i class="lni lni-pencil"></i>
                            </button>
                            <button class="more-btn ml-10 dropdown-toggle" id="moreAction1" data-bs-toggle="dropdown"
                              aria-expanded="false">
                              <i class="lni lni-more-alt"></i>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="moreAction1">
                              <li class="dropdown-item">
                                <a href="#0" class="text-gray">Remove</a>
                              </li>
                              <li class="dropdown-item">
                                <a href="#0" class="text-gray">Edit</a>
                              </li>
                            </ul>
                          </div>
                        </td>
                      </tr>
                    </tbody>
                  </table>
                  <!-- End Table -->
                </div>
              </div>
            </div>
            <!-- End Col -->
          </div>
          <!-- End Row -->
        </div>
        <!-- end container -->
      </section>
      <!-- ========== section end ========== -->
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

    <script>
      // ======== jvectormap activation
      var markers = [
        { name: "Egypt", coords: [26.8206, 30.8025] },
        { name: "Russia", coords: [61.524, 105.3188] },
        { name: "Canada", coords: [56.1304, -106.3468] },
        { name: "Greenland", coords: [71.7069, -42.6043] },
        { name: "Brazil", coords: [-14.235, -51.9253] },
      ];

      var jvm = new jsVectorMap({
        map: "world_merc",
        selector: "#map",
        zoomButtons: true,

        regionStyle: {
          initial: {
            fill: "#d1d5db",
          },
        },

        labels: {
          markers: {
            render: (marker) => marker.name,
          },
        },

        markersSelectable: true,
        selectedMarkers: markers.map((marker, index) => {
          var name = marker.name;

          if (name === "Russia" || name === "Brazil") {
            return index;
          }
        }),
        markers: markers,
        markerStyle: {
          initial: { fill: "#4A6CF7" },
          selected: { fill: "#ff5050" },
        },
        markerLabelStyle: {
          initial: {
            fontWeight: 400,
            fontSize: 14,
          },
        },
      });
      // ====== calendar activation
      document.addEventListener("DOMContentLoaded", function () {
        var calendarMiniEl = document.getElementById("calendar-mini");
        var calendarMini = new FullCalendar.Calendar(calendarMiniEl, {
          initialView: "dayGridMonth",
          headerToolbar: {
            end: "today prev,next",
          },
        });
        calendarMini.render();
      });

      // =========== chart one start
      const ctx1 = document.getElementById("Chart1").getContext("2d");
      const chart1 = new Chart(ctx1, {
        type: "line",
        data: {
          labels: [
            "Jan",
            "Fab",
            "Mar",
            "Apr",
            "May",
            "Jun",
            "Jul",
            "Aug",
            "Sep",
            "Oct",
            "Nov",
            "Dec",
          ],
          datasets: [
            {
              label: "",
              backgroundColor: "transparent",
              borderColor: "#365CF5",
              data: [
                600, 800, 750, 880, 940, 880, 900, 770, 920, 890, 976, 1100,
              ],
              pointBackgroundColor: "transparent",
              pointHoverBackgroundColor: "#365CF5",
              pointBorderColor: "transparent",
              pointHoverBorderColor: "#fff",
              pointHoverBorderWidth: 5,
              borderWidth: 5,
              pointRadius: 8,
              pointHoverRadius: 8,
              cubicInterpolationMode: "monotone", // Add this line for curved line
            },
          ],
        },
        options: {
          plugins: {
            tooltip: {
              callbacks: {
                labelColor: function (context) {
                  return {
                    backgroundColor: "#ffffff",
                    color: "#171717"
                  };
                },
              },
              intersect: false,
              backgroundColor: "#f9f9f9",
              title: {
                fontFamily: "Plus Jakarta Sans",
                color: "#8F92A1",
                fontSize: 12,
              },
              body: {
                fontFamily: "Plus Jakarta Sans",
                color: "#171717",
                fontStyle: "bold",
                fontSize: 16,
              },
              multiKeyBackground: "transparent",
              displayColors: false,
              padding: {
                x: 30,
                y: 10,
              },
              bodyAlign: "center",
              titleAlign: "center",
              titleColor: "#8F92A1",
              bodyColor: "#171717",
              bodyFont: {
                family: "Plus Jakarta Sans",
                size: "16",
                weight: "bold",
              },
            },
            legend: {
              display: false,
            },
          },
          responsive: true,
          maintainAspectRatio: false,
          title: {
            display: false,
          },
          scales: {
            y: {
              grid: {
                display: false,
                drawTicks: false,
                drawBorder: false,
              },
              ticks: {
                padding: 35,
                max: 1200,
                min: 500,
              },
            },
            x: {
              grid: {
                drawBorder: false,
                color: "rgba(143, 146, 161, .1)",
                zeroLineColor: "rgba(143, 146, 161, .1)",
              },
              ticks: {
                padding: 20,
              },
            },
          },
        },
      });
      // =========== chart one end

      // =========== chart two start
      const ctx2 = document.getElementById("Chart2").getContext("2d");
      const chart2 = new Chart(ctx2, {
        type: "bar",
        data: {
          labels: [
            "Jan",
            "Fab",
            "Mar",
            "Apr",
            "May",
            "Jun",
            "Jul",
            "Aug",
            "Sep",
            "Oct",
            "Nov",
            "Dec",
          ],
          datasets: [
            {
              label: "",
              backgroundColor: "#365CF5",
              borderRadius: 30,
              barThickness: 6,
              maxBarThickness: 8,
              data: [
                600, 700, 1000, 700, 650, 800, 690, 740, 720, 1120, 876, 900,
              ],
            },
          ],
        },
        options: {
          plugins: {
            tooltip: {
              callbacks: {
                titleColor: function (context) {
                  return "#8F92A1";
                },
                label: function (context) {
                  let label = context.dataset.label || "";

                  if (label) {
                    label += ": ";
                  }
                  label += context.parsed.y;
                  return label;
                },
              },
              backgroundColor: "#F3F6F8",
              titleAlign: "center",
              bodyAlign: "center",
              titleFont: {
                size: 12,
                weight: "bold",
                color: "#8F92A1",
              },
              bodyFont: {
                size: 16,
                weight: "bold",
                color: "#171717",
              },
              displayColors: false,
              padding: {
                x: 30,
                y: 10,
              },
          },
          },
          legend: {
            display: false,
            },
          legend: {
            display: false,
          },
          layout: {
            padding: {
              top: 15,
              right: 15,
              bottom: 15,
              left: 15,
            },
          },
          responsive: true,
          maintainAspectRatio: false,
          scales: {
            y: {
              grid: {
                display: false,
                drawTicks: false,
                drawBorder: false,
              },
              ticks: {
                padding: 35,
                max: 1200,
                min: 0,
              },
            },
            x: {
              grid: {
                display: false,
                drawBorder: false,
                color: "rgba(143, 146, 161, .1)",
                drawTicks: false,
                zeroLineColor: "rgba(143, 146, 161, .1)",
              },
              ticks: {
                padding: 20,
              },
            },
          },
          plugins: {
            legend: {
              display: false,
            },
            title: {
              display: false,
            },
          },
        },
      });
      // =========== chart two end

      // =========== chart three start
      const ctx3 = document.getElementById("Chart3").getContext("2d");
      const chart3 = new Chart(ctx3, {
        type: "line",
        data: {
          labels: [
            "Jan",
            "Feb",
            "Mar",
            "Apr",
            "May",
            "Jun",
            "Jul",
            "Aug",
            "Sep",
            "Oct",
            "Nov",
            "Dec",
          ],
          datasets: [
            {
              label: "Revenue",
              backgroundColor: "transparent",
              borderColor: "#365CF5",
              data: [80, 120, 110, 100, 130, 150, 115, 145, 140, 130, 160, 210],
              pointBackgroundColor: "transparent",
              pointHoverBackgroundColor: "#365CF5",
              pointBorderColor: "transparent",
              pointHoverBorderColor: "#365CF5",
              pointHoverBorderWidth: 3,
              pointBorderWidth: 5,
              pointRadius: 5,
              pointHoverRadius: 8,
              fill: false,
              tension: 0.4,
            },
            {
              label: "Profit",
              backgroundColor: "transparent",
              borderColor: "#9b51e0",
              data: [
                120, 160, 150, 140, 165, 210, 135, 155, 170, 140, 130, 200,
              ],
              pointBackgroundColor: "transparent",
              pointHoverBackgroundColor: "#9b51e0",
              pointBorderColor: "transparent",
              pointHoverBorderColor: "#9b51e0",
              pointHoverBorderWidth: 3,
              pointBorderWidth: 5,
              pointRadius: 5,
              pointHoverRadius: 8,
              fill: false,
              tension: 0.4,
            },
            {
              label: "Order",
              backgroundColor: "transparent",
              borderColor: "#f2994a",
              data: [180, 110, 140, 135, 100, 90, 145, 115, 100, 110, 115, 150],
              pointBackgroundColor: "transparent",
              pointHoverBackgroundColor: "#f2994a",
              pointBorderColor: "transparent",
              pointHoverBorderColor: "#f2994a",
              pointHoverBorderWidth: 3,
              pointBorderWidth: 5,
              pointRadius: 5,
              pointHoverRadius: 8,
              fill: false,
              tension: 0.4,
            },
          ],
        },
        options: {
          plugins: {
            tooltip: {
              intersect: false,
              backgroundColor: "#fbfbfb",
              titleColor: "#8F92A1",
              bodyColor: "#272727",
              titleFont: {
                size: 16,
                family: "Plus Jakarta Sans",
                weight: "400",
              },
              bodyFont: {
                family: "Plus Jakarta Sans",
                size: 16,
              },
              multiKeyBackground: "transparent",
              displayColors: false,
              padding: {
                x: 30,
                y: 15,
              },
              borderColor: "rgba(143, 146, 161, .1)",
              borderWidth: 1,
              enabled: true,
            },
            title: {
              display: false,
            },
            legend: {
              display: false,
            },
          },
          layout: {
            padding: {
              top: 0,
            },
          },
          responsive: true,
          // maintainAspectRatio: false,
          legend: {
            display: false,
          },
          scales: {
            y: {
              grid: {
                display: false,
                drawTicks: false,
                drawBorder: false,
              },
              ticks: {
                padding: 35,
              },
              max: 350,
              min: 50,
            },
            x: {
              grid: {
                drawBorder: false,
                color: "rgba(143, 146, 161, .1)",
                drawTicks: false,
                zeroLineColor: "rgba(143, 146, 161, .1)",
              },
              ticks: {
                padding: 20,
              },
            },
          },
        },
      });
      // =========== chart three end

      // ================== chart four start
      const ctx4 = document.getElementById("Chart4").getContext("2d");
      const chart4 = new Chart(ctx4, {
        type: "bar",
        data: {
          labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun"],
          datasets: [
            {
              label: "",
              backgroundColor: "#365CF5",
              borderColor: "transparent",
              borderRadius: 20,
              borderWidth: 5,
              barThickness: 20,
              maxBarThickness: 20,
              data: [600, 700, 1000, 700, 650, 800],
            },
            {
              label: "",
              backgroundColor: "#d50100",
              borderColor: "transparent",
              borderRadius: 20,
              borderWidth: 5,
              barThickness: 20,
              maxBarThickness: 20,
              data: [690, 740, 720, 1120, 876, 900],
            },
          ],
        },
        options: {
          plugins: {
            tooltip: {
              backgroundColor: "#F3F6F8",
              titleColor: "#8F92A1",
              titleFontSize: 12,
              bodyColor: "#171717",
              bodyFont: {
                weight: "bold",
                size: 16,
              },
              multiKeyBackground: "transparent",
              displayColors: false,
              padding: {
                x: 30,
                y: 10,
              },
              bodyAlign: "center",
              titleAlign: "center",
              enabled: true,
            },
            legend: {
              display: false,
            },
          },
          layout: {
            padding: {
              top: 0,
            },
          },
          responsive: true,
          // maintainAspectRatio: false,
          title: {
            display: false,
          },
          scales: {
            y: {
              grid: {
                display: false,
                drawTicks: false,
                drawBorder: false,
              },
              ticks: {
                padding: 35,
                max: 1200,
                min: 0,
              },
            },
            x: {
              grid: {
                display: false,
                drawBorder: false,
                color: "rgba(143, 146, 161, .1)",
                zeroLineColor: "rgba(143, 146, 161, .1)",
              },
              ticks: {
                padding: 20,
              },
            },
          },
        },
      });
        // =========== chart four end
    </script>
  </body>
</html>
