<%-- 
    Document   : profile
    Created on : Sep 28, 2023, 2:33:07 AM
    Author     : LiusDev
--%>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    if(session.getAttribute("user") == null) response.sendRedirect("login");
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Order Detail | ${initParam['webName']}</title>

        <%@include file="components/headerLink.html" %>

    </head>
    <body>
        <%@include file="components/header.jsp" %>
        <section class="section-intro mb-3 mt-5">
            <div class="container">
                <div class="row">
                    <aside class="p-3 col-lg-2">
                        <nav class="nav flex-column nav-pills mb-3 mb-lg-0">
                            <a class="nav-link" href="/user"><b>Profile</b></a>
                            <a class="nav-link" href="/invoice"><b>Invoices</b></a>
                        </nav>
                    </aside>
                    <main class="col-lg-10">
                        <div class="row">
                            <div class="card mb-4">
                                <div class="card-body p-lg-4">
                                    <div class="row mb-4">
                                        <div class="col-lg-6">
                                            <a class="btn btn-primary" href="/invoice" onclick="history.back()"> 
                                                <i class="fa fa-arrow-left me-2"></i> Back 
                                            </a>
                                            <c:if test = "${invoice.paymentStatus == false && invoice.status >= 2}">
                                                <button id="qrBtn" class="btn btn-light"">QR-Code</button>
                                            </c:if>
                                            <c:if test = "${invoice.status == 2 || invoice.status == 3}">
                                                <button id="cancelBtn" class="btn btn-light text-danger">Cancel order</button>
                                            </c:if>
                                        </div>
                                        <div class="col-lg-6 d-flex justify-content-end align-items-center">
                                            <span style="padding-right: 12px; border-right: 1px solid rgba(86, 86, 86, 0.12)">Invoice code: <b>INV${invoice.id}</b></span>
                                            <span class="text-danger" style="padding-left: 12px">${invoice.paymentStatusInfo}</span>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="container mb-1">
                                            <div class="card mb-2">
                                                <c:choose>
                                                    <c:when test="${invoice.status == 1}">
                                                        <div class="card-body">
                                                            <h4 class="card-title">Order canceled!</h4>
                                                            <p>${invoice.canceledBy}</p>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="d-flex flex-wrap flex-sm-nowrap justify-content-between py-3 px-2 bg-secondary">
                                                            <div class="w-100 text-center py-1 px-2"><span class="text-medium">Shipped Via:</span> ${invoice.transportUnit.name}</div>
                                                            <div class="w-100 text-center py-1 px-2"><span class="text-medium">Status:</span> ${invoice.statusName}</div>
                                                            <div class="w-100 text-center py-1 px-2"><span class="text-medium">Order Date:</span> ${invoice.createdAt}</div>
                                                        </div>
                                                        <div class="card-body">
                                                            <div class="steps d-flex flex-wrap flex-sm-nowrap justify-content-between padding-top-2x">
                                                                <div class="step ${invoice.status >= 2 ? "completed" : ""}">
                                                                    <div class="step-icon-wrap">
                                                                        <div class="step-icon"><i class="fas fa-receipt"></i></div>
                                                                    </div>
                                                                    <h4 class="step-title">Pending</h4>
                                                                </div>
                                                                <div class="step ${invoice.status >= 3 ? "completed" : ""}">
                                                                    <div class="step-icon-wrap">
                                                                        <div class="step-icon"><i class="fas fa-clipboard-check"></i></div>
                                                                    </div>
                                                                    <h4 class="step-title">Approved</h4>
                                                                </div>
                                                                <div class="step ${invoice.status >= 4 ? "completed" : ""}">
                                                                    <div class="step-icon-wrap">
                                                                        <div class="step-icon"><i class="fas fa-shipping-fast"></i></div>
                                                                    </div>
                                                                    <h4 class="step-title">Shipping</h4>
                                                                </div>
                                                                <div class="step ${invoice.status >= 5 ? "completed" : ""}">
                                                                    <div class="step-icon-wrap">
                                                                        <div class="step-icon"><i class="fas fa-truck-loading"></i></div>
                                                                    </div>
                                                                    <h4 class="step-title">Received</h4>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                    <hr/>
                                    <div class="row">
                                        <h4 class="card-title mb-5">Order infomation</h4>
                                        <div class="col-lg-6" style="border-right: 1px solid rgba(86, 86, 86, 0.12)">
                                            <div class="row">
                                                <dt class="col-xxl-5 col-lg-4 fw-normal text-muted">Name:</dt>
                                                <dd class="col-xxl-7 col-lg-8">
                                                    <span class="">${invoice.firstName} ${invoice.lastName}</span>
                                                </dd>
                                            </div>
                                            <div class="row">
                                                <dt class="col-xxl-5 col-lg-4 fw-normal text-muted">Phone:</dt>
                                                <dd class="col-xxl-7 col-lg-8">
                                                    <span class="">${invoice.phone}</span>
                                                </dd>
                                            </div>
                                            <div class="row">
                                                <dt class="col-xxl-5 col-lg-4 fw-normal text-muted">Email:</dt>
                                                <dd class="col-xxl-7 col-lg-8">
                                                    <span class="">${invoice.email}</span>
                                                </dd>
                                            </div>
                                            <div class="row">
                                                <dt class="col-xxl-5 col-lg-4 fw-normal text-muted">Address:</dt>
                                                <dd class="col-xxl-7 col-lg-8">
                                                    <span class="">${invoice.address}</span>
                                                </dd>
                                            </div>
                                        </div>
                                        <div class="col-lg-6">
                                            <div class="row">
                                                <dt class="col-xxl-5 col-lg-4 fw-normal text-muted">Transport unit:</dt>
                                                <dd class="col-xxl-7 col-lg-8">
                                                    <span class="">${invoice.transportUnit.name}</span>
                                                </dd>
                                            </div>
                                            <div class="row">
                                                <dt class="col-xxl-5 col-lg-4 fw-normal text-muted">Transport type:</dt>
                                                <dd class="col-xxl-7 col-lg-8">
                                                    <span class="">${invoice.transportUnit.type}</span>
                                                </dd>
                                            </div>
                                            <div class="row">
                                                <dt class="col-xxl-5 col-lg-4 fw-normal text-muted">Estimated delivery time:</dt>
                                                <dd class="col-xxl-7 col-lg-8">
                                                    <span class="">${invoice.transportUnit.fastestShipping} - ${invoice.transportUnit.slowestShipping} days</span>
                                                </dd>
                                            </div>
                                            <div class="row">
                                                <dt class="col-xxl-5 col-lg-4 fw-normal text-muted">Order message:</dt>
                                                <dd class="col-xxl-7 col-lg-8">
                                                    <span class="">${invoice.message}</span>
                                                </dd>
                                            </div>
                                        </div>
                                    </div>
                                </div> <!-- card-body .// -->
                            </div> <!-- card .// --> 
                        </div>
                        <div class="row">
                            <div class="col-lg-8 ps-0">
                                <div class="card mb-4">
                                    <div class="card-body p-lg-4">
                                        <h4 class="card-title mb-4">Order detail</h4>
                                        <div id="cartContainer">
                                            <c:forEach var="product" items="${invoice.invoiceDetails}">
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
                                    </div> <!-- card-body .// -->
                                </div> <!-- card.// -->
                            </div> <!-- col.// -->
                            <aside class="col-lg-4 pe-0">
                                <div class="card shadow-lg mb-4">
                                    <div class="card-body">
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
                                </div> <!-- card.// -->
                            </aside> <!-- col.// -->
                        </div> <!-- row.// -->
                    </main>
                </div>
            </div>
        </section>
        <%@include file="components/footerLink.html" %>
        <script>
            const invoice = ${invoiceJson};

            const getInvoiceTotal = () => {
                const subtotal = invoice.invoiceDetails.reduce((sum, product) => {
                    return sum + (product.cartQuantity * product.price);
                }, 0);
                return subtotal + subtotal * 0.1 + invoice.transportUnit.price;
            };

            let qrBtn;
            if (!invoice.paymentStatus) {
                qrBtn = document.querySelector("#qrBtn");
                qrBtn.onclick = () => {
                    Swal.fire({
                        title: 'Please scan the QR above to pay',
                        text: 'Payment will be verified within 24 hours',
                        imageUrl: 'https://api.vietqr.io/image/970422-2788609072003-DyRPh8P.jpg?accountName=DAO%20XUAN%20QUY&amount=' + getInvoiceTotal() + '&addInfo=INV' + invoice.id,
                        confirmButtonText: 'OK'
                    })
                }
            }
            ;
            let cancelBtn;
            if (invoice.status === 2 || invoice.status === 3) {
                cancelBtn = document.querySelector("#cancelBtn");
                cancelBtn.onclick = () => {
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
                                type: "post",
                                url: "/invoice/cancel",
                                data:
                                        {
                                            "invoiceId": invoice.id
                                        },
                                cache: false,
                                success: function (response) {
                                    console.log(response);
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
            }
            ;


        </script>
    </body>
</html>
