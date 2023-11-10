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
        <title>Order | ${initParam['webName']}</title>

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
                        <div class="card mb-4">
                            <header class="card-header">
                                <ul class="nav nav-tabs card-header-tabs">
                                    <li class="nav-item">
                                        <a class="nav-link active" data-bs-toggle="tab" data-bs-target="#pending" aria-current="true" href="#">Pending</a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" data-bs-toggle="tab" data-bs-target="#approved" href="#">Approved</a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" data-bs-toggle="tab" data-bs-target="#shipping" href="#">Shipping</a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" data-bs-toggle="tab" data-bs-target="#received" href="#">Received</a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" data-bs-toggle="tab" data-bs-target="#canceled" href="#">Canceled</a>
                                    </li>
                                </ul>
                            </header> <!-- card-header .// -->
                            <div class="tab-content card-body">

                                <!-- tab-pane details -->
                                <article class="tab-pane active" id="pending" role="tabpanel">
                                    <c:forEach var="invoice" items="${invoices}">
                                        <c:if test = "${invoice.status == 2}">
                                            <div id="inv-${invoice.id}" class="card p-3 mb-4">
                                                <div class="mb-3 row">
                                                    <div class="col-lg-6">
                                                        <span style="padding-right: 12px; border-right: 1px solid rgba(86, 86, 86, 0.12)">Invoice code: <b>INV${invoice.id}</b></span>
                                                        <span style="padding: 0px 12px; border-right: 1px solid rgba(86, 86, 86, 0.12)" class="status">${invoice.statusName}</span>
                                                        <span class="text-danger" style="padding-left: 12px">${invoice.paymentStatusInfo}</span>
                                                    </div>
                                                    <div class="col-lg-6">
                                                        <div class="text-end">${invoice.createdAt}</div>
                                                    </div>
                                                </div>
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
                                                    <hr>
                                                </c:forEach>
                                                <div class="row">
                                                    <div class="col-lg-9 action">
                                                        <a href="/invoice?id=${invoice.id}" class="btn btn-primary viewOrderBtn">View order</a>
                                                        <c:if test = "${invoice.paymentStatus == false}">
                                                            <button class="btn btn-light qrBtn" data-invoiceId="${invoice.id}">QR-Code</button>
                                                        </c:if>
                                                        <button class="btn btn-light text-danger cancelBtn" data-invoiceId="${invoice.id}">Cancel order</button>
                                                    </div>
                                                    <div class="col-lg-3 text-end">
                                                        <span>Total: </span><span class="h4">${String.format("%,d", invoice.totalPrice)} ₫</span>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                </article>
                                <!-- tab-pane details .// -->

                                <article class="tab-pane" id="approved" role="tabpanel">
                                    <c:forEach var="invoice" items="${invoices}">
                                        <c:if test = "${invoice.status == 3}">
                                            <div id="inv-${invoice.id}" class="card p-3 mb-4">
                                                <div class="mb-3 row">
                                                    <div class="col-lg-9">
                                                        <span style="padding-right: 12px; border-right: 1px solid rgba(86, 86, 86, 0.12)">Invoice code: <b>INV${invoice.id}</b></span>
                                                        <span style="padding: 0px 12px; border-right: 1px solid rgba(86, 86, 86, 0.12)" class="status">${invoice.statusName}</span>
                                                        <span class="text-danger" style="padding-left: 12px">${invoice.paymentStatusInfo}</span>
                                                    </div>
                                                    <div class="col-lg-3">
                                                        <div class="text-end">${invoice.createdAt}</div>
                                                    </div>
                                                </div>
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
                                                    <hr>
                                                </c:forEach>
                                                <div class="row">
                                                    <div class="col-lg-9 action">
                                                        <a href="/invoice?id=${invoice.id}" class="btn btn-primary viewOrderBtn">View order</a>
                                                        <c:if test = "${invoice.paymentStatus == false}">
                                                            <button class="btn btn-light qrBtn" data-invoiceId="${invoice.id}">QR-Code</button>
                                                        </c:if>
                                                        <button class="btn btn-light text-danger cancelBtn" data-invoiceId="${invoice.id}">Cancel order</button>
                                                    </div>
                                                    <div class="col-lg-3 text-end">
                                                        <span>Total: </span><span class="h4" >${String.format("%,d", invoice.totalPrice)} ₫</span>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                </article>
                                <!-- tab-pane reviews .// -->

                                <article class="tab-pane" id="shipping" role="tabpanel">
                                    <c:forEach var="invoice" items="${invoices}">
                                        <c:if test = "${invoice.status == 4}">
                                            <div id="inv-${invoice.id}" class="card p-3 mb-4">
                                                <div class="mb-3 row">
                                                    <div class="col-lg-9">
                                                        <span style="padding-right: 12px; border-right: 1px solid rgba(86, 86, 86, 0.12)">Invoice code: <b>INV${invoice.id}</b></span>
                                                        <span style="padding: 0px 12px; border-right: 1px solid rgba(86, 86, 86, 0.12)" class="status">${invoice.statusName}</span>
                                                        <span class="text-danger" style="padding-left: 12px">${invoice.paymentStatusInfo}</span>
                                                    </div>
                                                    <div class="col-lg-3">
                                                        <div class="text-end">${invoice.createdAt}</div>
                                                    </div>
                                                </div>
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
                                                    <hr>
                                                </c:forEach>
                                                <div class="row">
                                                    <div class="col-lg-9 action">
                                                        <a href="/invoice?id=${invoice.id}" class="btn btn-primary viewOrderBtn">View order</a>
                                                        <c:if test = "${invoice.paymentStatus == false}">
                                                            <button class="btn btn-light qrBtn" data-invoiceId="${invoice.id}">QR-Code</button>
                                                        </c:if>
                                                    </div>
                                                    <div class="col-lg-3 text-end">
                                                        <span>Total: </span><span class="h4">${String.format("%,d", invoice.totalPrice)} ₫</span>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                </article>
                                <!-- tab-pane shipping .// -->

                                <article class="tab-pane" id="received" role="tabpanel">
                                    <c:forEach var="invoice" items="${invoices}">
                                        <c:if test = "${invoice.status == 5}">
                                            <div id="inv-${invoice.id}" class="card p-3 mb-4">
                                                <div class="mb-3 row">
                                                    <div class="col-lg-9">
                                                        <span style="padding-right: 12px; border-right: 1px solid rgba(86, 86, 86, 0.12)">Invoice code: <b>INV${invoice.id}</b></span>
                                                        <span style="padding: 0px 12px; border-right: 1px solid rgba(86, 86, 86, 0.12)" class="status">${invoice.statusName}</span>
                                                        <span class="text-danger" style="padding-left: 12px">${invoice.paymentStatusInfo}</span>
                                                    </div>
                                                    <div class="col-lg-3">
                                                        <div class="text-end">${invoice.createdAt}</div>
                                                    </div>
                                                </div>
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
                                                    <hr>
                                                </c:forEach>
                                                <div class="row">
                                                    <div class="col-lg-9 action">
                                                        <a href="/invoice?id=${invoice.id}" class="btn btn-primary viewOrderBtn">View order</a>
                                                        <c:if test = "${invoice.paymentStatus == false}">
                                                            <button class="btn btn-light qrBtn" data-invoiceId="${invoice.id}">QR-Code</button>
                                                        </c:if>
                                                    </div>
                                                    <div class="col-lg-3 text-end">
                                                        <span>Total: </span><span class="h4">${String.format("%,d", invoice.totalPrice)} ₫</span>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                </article>
                                <!-- tab-pane seller .// -->

                                <article class="tab-pane" id="canceled" role="tabpanel">
                                    <c:forEach var="invoice" items="${invoices}">
                                        <c:if test = "${invoice.status == 1}">
                                            <div id="inv-${invoice.id}" class="card p-3 mb-4">
                                                <div class="mb-3 row">
                                                    <div class="col-lg-9">
                                                        <span style="padding-right: 12px; border-right: 1px solid rgba(86, 86, 86, 0.12)">Invoice code: <b>INV${invoice.id}</b></span>
                                                        <span style="padding: 0px 12px; border-right: 1px solid rgba(86, 86, 86, 0.12)">${invoice.statusName}</span>
                                                        <span class="text-danger" style="padding-left: 12px">${invoice.paymentStatusInfo}</span>
                                                    </div>
                                                    <div class="col-lg-3">
                                                        <div class="text-end">${invoice.createdAt}</div>
                                                    </div>
                                                </div>
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
                                                    <hr>
                                                </c:forEach>
                                                <div class="row">
                                                    <div class="col-lg-9 action">
                                                        <a href="/invoice?id=${invoice.id}" class="btn btn-primary viewOrderBtn">View order</a>
                                                        <p class="d-inline-block text-danger mx-2">${invoice.canceledBy}</p>
                                                    </div>
                                                    <div class="col-lg-3 text-end">
                                                        <span>Total: </span><span class="h4">${String.format("%,d", invoice.totalPrice)} ₫</span>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                </article>
                                <!-- tab-pane seller .// -->

                            </div> <!-- card-body .// -->
                        </div> <!-- card .// -->
                    </main>
                </div> <!-- row.// -->

            </div> <!-- container .//  -->
        </section>
        <%@include file="components/footerLink.html" %>
        <script>
            const invoices = ${invoicesJson};
            console.log(invoices);

            const findInvoice = (id) => {
                return invoices.find((invoice) => {
                    return invoice.id === parseInt(id);
                });
            };
            const getInvoiceTotal = (id) => {
                const invoiceFound = findInvoice(id);
                const subtotal = invoiceFound.invoiceDetails.reduce((sum, product) => {
                    return sum + (product.cartQuantity * product.price);
                }, 0);
                return subtotal + subtotal * 0.1 + invoiceFound.transportUnit.price;
            }

            const canceledTab = document.querySelector("#canceled");
            const changeOrderStateDOM = (id) => {
                const order = document.querySelector("#inv-" + id);
                order.querySelector(".status").innerText = "Canceled";
                const actionBtns = order.querySelector(".action");
                const viewOrderBtn = actionBtns.querySelector(".viewOrderBtn");
                actionBtns.innerHTML = ""
                actionBtns.append(viewOrderBtn);
                actionBtns.innerHTML += '<p class="d-inline-block text-danger mx-2">Canceled by you</p>';
                canceledTab.prepend(order);
            }
            const qrBtns = Array.from(document.querySelectorAll(".qrBtn"));
            qrBtns.forEach((btn) => {
                btn.onclick = () => {
                    Swal.fire({
                        title: 'Please scan the QR above to pay',
                        text: 'Payment will be verified within 24 hours',
                        imageUrl: 'https://api.vietqr.io/image/970422-2788609072003-DyRPh8P.jpg?accountName=DAO%20XUAN%20QUY&amount=' + getInvoiceTotal(btn.dataset.invoiceid) + '&addInfo=INV' + btn.dataset.invoiceid,
                        confirmButtonText: 'OK'
                    })
                }
            })

            const currentURL = new URL(document.location);
            const cancelBtns = Array.from(document.querySelectorAll(".cancelBtn"));
            cancelBtns.forEach((btn) => {
                btn.onclick = () => {
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
                                            "invoiceId": btn.dataset.invoiceid
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
                                                    window.open("/login?redirect=" + currentURL.pathname + currentURL.search, "_self");
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
                                            changeOrderStateDOM(btn.dataset.invoiceid);
                                            Swal.fire({
                                                title: 'Success!',
                                                icon: 'success',
                                                confirmButtonText: 'OK',
                                                allowOutsideClick: false,
                                                allowEscapeKey: false,
                                            })
//                                        .then((result) => {
//                                            if (result.isConfirmed) {
//                                                location.reload();
//                                            }
//                                        })
                                    }
                                }
                            });
                        }
                    })
                }
            })
        </script>
    </body>
</html>
