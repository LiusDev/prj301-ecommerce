<%-- 
    Document   : checkout
    Created on : Sep 29, 2023, 10:49:29 AM
    Author     : LiusDev
--%>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    if(session.getAttribute("user") == null) response.sendRedirect("login");
%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Checkout | ${initParam['webName']}</title>

        <%@include file="components/headerLink.html" %>

    </head>
    <body>
        <%@include file="components/header.jsp" %>

        <section class="padding-y-sm mt-5">
            <div class="container">
                <div class="row">
                    <main class="col-xl-8 col-lg-8">
                        <article class="card">
                            <div class="card-body">
                                <h5 class="card-title"> Guest checkout </h5>
                                <c:choose>
                                    <c:when test="${cartProducts == null || cartProducts.size() == 0}">
                                        <p>Oops, cannot find any product :(</p>
                                    </c:when>
                                    <c:otherwise>
                                        <form id="infoForm">
                                            <div class="row">
                                                <div class="col-6 mb-3">
                                                    <label class="form-label">First name</label>
                                                    <input id="firstName" name="firstName" type="text" class="form-control" placeholder="Type here" value="${sessionScope.user.firstName}" required>
                                                </div>

                                                <div class="col-6">
                                                    <label class="form-label">Last name</label>
                                                    <input id="lastName" name="lastName" type="text" class="form-control" placeholder="Type here" value="${sessionScope.user.lastName}" required>
                                                </div>

                                                <div class="col-6 mb-3">
                                                    <label class="form-label">Phone</label>
                                                    <input id="phone" name="phone" type="text" value="+84" class="form-control" placeholder="" required>
                                                </div>

                                                <div class="col-6 mb-3">
                                                    <label class="form-label">Email</label>
                                                    <input id="email" name="email" type="text" class="form-control" placeholder="example@gmail.com" value="${sessionScope.user.email}">
                                                </div>
                                            </div>

                                            <hr class="my-4">

                                            <h5 class="card-title"> Shipping info </h5> 

                                            <div class="row g-2 mb-3">
                                                <c:forEach var="transportUnit" items="${transportUnits}" varStatus="loop">
                                                    <div class="col-lg-4 mb-3">
                                                        <div class="box-check p-3">
                                                            <label class="form-check" style="cursor: pointer">
                                                                <input class="form-check-input shipping-method" value=${transportUnit.id} data-price=${transportUnit.price} type="radio" name="transportUnit" ${loop.index == 0 ? "checked" : ""}>
                                                                <b class="border-oncheck"></b>
                                                                <span class="form-check-label">
                                                                    ${transportUnit.type}  <br>
                                                                    <small class="text-muted">${transportUnit.fastestShipping}-${transportUnit.slowestShipping} days via ${transportUnit.name}</small>
                                                                </span>
                                                            </label>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </div> <!-- row end.// -->

                                            <div class="row">

                                                <div class="col-sm-4 mb-3">
                                                    <label for="province" class="form-label">Province / City</label>
                                                    <input id="province" name="province" type="text" class="form-control" placeholder="" required>
                                                </div> <!-- col end.// -->

                                                <div class="col-sm-4 col-6 mb-3">
                                                    <label for="district" class="form-label">District</label>
                                                    <input id="district" name="district" type="text" class="form-control" placeholder="" required>
                                                </div> <!-- col end.// -->

                                                <div class="col-sm-4 col-6 mb-3">
                                                    <label for="commune" class="form-label">Commune / Ward / Town</label>
                                                    <input id="commune" name="commune" type="text" class="form-control" placeholder="" required>
                                                </div> <!-- col end.// -->

                                                <div class="col-sm-12 mb-3">
                                                    <label for="address" class="form-label">Address</label>
                                                    <input id="address" name="address" type="text" class="form-control" placeholder="" required>
                                                </div> <!-- col end.// -->
                                            </div> <!-- row.// -->

                                            <div class="mb-4">
                                                <label for="message" class="form-label">Message to seller</label>
                                                <input id="message" name="message" type="text" class="form-control" placeholder="">
                                            </div> <!-- col end.// -->

                                            <div class="float-end">
                                                <a href="/cart" class="btn btn-light">Cancel</a>
                                                <button id="submitBtn" type="button" class="btn btn-success">Submit order</button>
                                            </div>
                                        </form>
                                    </c:otherwise>
                                </c:choose>
                            </div> <!-- card-body end.// -->
                        </article> <!-- card end.// -->
                    </main> <!-- col.// -->

                    <c:choose>
                        <c:when test="${cartProducts == null || cartProducts.size() == 0}"></c:when>
                        <c:otherwise>
                            <aside class="col-xl-4 col-lg-4">
                                <!-- ============== COMPONENT SUMMARY =============== -->
                                <article class="ms-lg-4 mt-4 mt-lg-0">
                                    <h5 class="mb-3">Summary</h5>
                                    <dl class="row">
                                        <dt class="col-7 fw-normal text-muted">Subtotal: </dt>
                                        <dd class="col-5 text-end" id="subtotal"></dd>

                                        <dt class="col-7 fw-normal text-muted">Discount:</dt>
                                        <dd class="col-5 text-end"> 0 ₫</dd>

                                        <dt class="col-7 fw-normal text-muted">Tax:</dt>
                                        <dd class="col-5 text-end" id="tax"></dd>

                                        <dt class="col-7 fw-normal text-muted">Shipping:</dt>
                                        <dd class="col-5 text-end" id="shipping"></dd>
                                    </dl>
                                    <hr>
                                    <dl class="row">
                                        <dt class="col-7 fw-normal  text-muted">Total:</dt>
                                        <dd class="col-5 h5 text-end" id="total"></dd>
                                    </dl>

                                    <hr>
                                    <p class="text-muted mb-4">Items in cart</p>
                                    <c:forEach var="product" items="${cartProducts}">
                                        <figure class="d-flex align-items-center mb-4">
                                            <a href="/product?slug=${product.slug}" class="flex-grow-0 me-3 flex-shrink-0">
                                                <img src="/image/product?id=${product.imageId}" class="size-72x72 img-thumbnail">
                                            </a>
                                            <figcaption class="flex-grow">
                                                <a href="/product?slug=${product.slug}" class="title"> <b class="fw-bold text-dark">${product.cartQuantity}x</b> ${product.name}</a>
                                                <div class="price text-muted">Total: ${String.format("%,d", product.price * product.cartQuantity)} ₫</div> <!-- price .// -->
                                            </figcaption>
                                        </figure>
                                    </c:forEach>
                                </article> 

                            </aside> <!-- col.// -->
                        </c:otherwise>
                    </c:choose>
                </div> <!-- row.// -->
            </div> <!-- container .//  -->
        </section>

        <%@include file="components/footerLink.html" %>

        <script>
            var websocket = new WebSocket("ws://localhost:8080/product-quantity");
            websocket.onopen = function (message) {
                processOpen(message);
            };
            websocket.onmessage = function (message) {
                processMessage(message);
            };
            websocket.onclose = function (message) {
                processClose(message);
            };
            websocket.onerror = function (message) {
                processError(message);
            };

            function processOpen(message) {
                console.log("Server connect... \n");
            }
            function processMessage(message) {
                console.log(message);
            }
            function processClose(message) {
                console.log("Server Disconnect... \n");
            }
            function processError(message) {
                console.log("Error... " + message + " \n");
            }
            const productJson = ${productsJSON};
            const subtotal = document.querySelector("#subtotal");
            const tax = document.querySelector("#tax");
            const shipping = document.querySelector("#shipping");
            const total = document.querySelector("#total");
            const transportUnits = Array.from(document.getElementsByName("transportUnit"));

            const submitBtn = document.querySelector("#submitBtn");

            const calSubTotal = () => productJson.reduce((total, product) => {
                    return total + (product.price * product.cartQuantity);
                }, 0);
            const updateSubTotal = () => {
                subtotal.innerHTML = Intl.NumberFormat("vi-VN", {
                    style: "currency",
                    currency: "VND",
                }).format(calSubTotal());
            }

            const calTax = () => calSubTotal() * 0.1;
            const updateTax = () => {
                tax.innerHTML = "+ " + Intl.NumberFormat("vi-VN", {
                    style: "currency",
                    currency: "VND"
                }).format(calTax());
            };

            const calShippingFee = () => {
                return parseInt(transportUnits.find((unit) => {
                    return unit.checked === true;
                }).dataset.price);
            };
            const updateShippingFee = () => {
                shipping.innerHTML = "+ " + Intl.NumberFormat("vi-VN", {
                    style: "currency",
                    currency: "VND"
                }).format(calShippingFee());
            };

            const calTotal = () => calSubTotal() + calTax() + calShippingFee();
            const updateTotal = () => {
                total.innerHTML = Intl.NumberFormat("vi-VN", {
                    style: "currency",
                    currency: "VND"
                }).format(calTotal());
            };

            const updateInvoice = () => {
                updateSubTotal();
                updateTax();
                updateShippingFee();
                updateTotal();
            }
            updateInvoice();

            transportUnits.forEach((unit) => {
                unit.onchange = () => {
                    updateInvoice();
                }
            })

            submitBtn.addEventListener("click", () => {
                if (typeof websocket != 'undefined' && websocket.readyState == WebSocket.OPEN) {
                    websocket.send(JSON.stringify(productJson));
                }
                let data = new FormData(document.querySelector("#infoForm"));
                $.ajax({
                    type: "post",
                    url: "/checkout/submit",
                    data:
                            {
                                "firstName": data.get("firstName"),
                                "lastName": data.get("lastName"),
                                "phone": data.get("phone"),
                                "email": data.get("email"),
                                "transportUnit": data.get("transportUnit"),
                                "province": data.get("province"),
                                "district": data.get("district"),
                                "commune": data.get("commune"),
                                "address": data.get("address"),
                                "message": data.get("message")
                            },
                    cache: false,
                    success: function (response) {

                        switch (response) {
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
                                }).then((result) => {
                                    if (result.isConfirmed) {
                                        location.reload();
                                    }
                                })
                                break;
                            case "Fill info":
                                Swal.fire({
                                    title: 'Please fill info',
                                    icon: 'error',
                                    confirmButtonText: 'OK',
                                })
                                break;
                            default:
                                Swal.fire({
                                    title: 'Please scan the QR above to pay',
                                    text: 'Payment will be verified within 24 hours',
                                    imageUrl: 'https://api.vietqr.io/image/970422-2788609072003-DyRPh8P.jpg?accountName=DAO%20XUAN%20QUY&amount=' + calTotal() + '&addInfo=INV-' + response,
                                    confirmButtonText: 'Done',
                                    allowOutsideClick: false,
                                    allowEscapeKey: false,
                                }).then((result) => {
                                    if (result.isConfirmed) {
                                        window.open("/invoice", "_self");
                                    }
                                })
                        }
                    }
                });
            });

        </script>
    </body>
</html>
