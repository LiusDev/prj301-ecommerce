<%-- 
    Document   : cart
    Created on : Sep 28, 2023, 12:47:15 AM
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
        <title>Cart | ${initParam['webName']}</title>
        <%@include file="components/headerLink.html" %>

    </head>
    <body>
        <%@include file="components/header.jsp" %>
        <section class="py-4 mt-5">
            <div class="container">

                <!-- =================== COMPONENT CART+SUMMARY ====================== -->
                <div class="row">
                    <main class="col-lg-9">
                        <div class="card mb-4">
                            <div class="card-body p-lg-4">
                                <h4 class="card-title mb-4">Shopping cart</h4>
                                <c:choose>
                                    <c:when test="${cartProducts == null || cartProducts.size() == 0}">
                                        <p>Oops, cannot find any product :(</p>
                                    </c:when>
                                    <c:otherwise>
                                        <div id="cartContainer">
                                            <c:forEach var="product" items="${cartProducts}">
                                                <c:choose>
                                                    <c:when test="${product.storage == true}">
                                                        <div id="${product.productVariantId}">
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
                                                                            <button type="button" class="btn btn-light text-danger btn-sm remove-btn" data-remove="${product.productVariantId}">Remove</button> 
                                                                        </figcaption>
                                                                    </figure>
                                                                </div> 
                                                                <div class="col-lg-3">
                                                                    <div class="text-end mb-2">
                                                                        <var class="h6 productPrice d-none"></var> 
                                                                    </div> <!-- price-wrap .// -->
                                                                    <div class="input-group input-group-sm justify-content-end">
                                                                        <p class="text-danger">Product does not exist</p>
                                                                        <button class="quantityDown d-none" type="button" style="width: 36px">-</button>
                                                                        <input type="number" class="form-control quantityInput d-none" style="max-width: 60px; text-align: center" value="${product.cartQuantity}"/>
                                                                        <button class="quantityUp d-none" type="button" style="width: 36px">+</button>
                                                                    </div>
                                                                </div>
                                                            </article> <!-- row.// -->
                                                            <hr>
                                                        </div>
                                                    </c:when>
                                                    <c:when test="${product.variantStorage == true}">
                                                        <div id="${product.productVariantId}">
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
                                                                            <button type="button" class="btn btn-light text-danger btn-sm remove-btn" data-remove="${product.productVariantId}">Remove</button> 
                                                                        </figcaption>
                                                                    </figure>
                                                                </div> 
                                                                <div class="col-lg-3">
                                                                    <div class="text-end mb-2">
                                                                        <var class="h6 productPrice d-none"></var> 
                                                                    </div> <!-- price-wrap .// -->
                                                                    <div class="input-group input-group-sm justify-content-end">
                                                                        <p class="text-danger">Product variant not exist</p>
                                                                        <button class="quantityDown d-none" type="button" style="width: 36px">-</button>
                                                                        <input type="number" class="form-control quantityInput d-none" style="max-width: 60px; text-align: center" value="${product.cartQuantity}"/>
                                                                        <button class="quantityUp d-none" type="button" style="width: 36px">+</button>
                                                                    </div>
                                                                </div>
                                                            </article> <!-- row.// -->
                                                            <hr>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div id="${product.productVariantId}">
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
                                                                            <button type="button" class="btn btn-light text-danger btn-sm remove-btn" data-remove="${product.productVariantId}">Remove</button> 
                                                                            <!--<a href="https://bootstrap-ecommerce-web.netlify.app/p-market-cart#" class="btn btn-light btn-sm">Save for later</a>-->
                                                                        </figcaption>
                                                                    </figure>
                                                                </div> 
                                                                <div class="col-lg-3">
                                                                    <div class="text-end mb-2">
                                                                        <var class="h6 productPrice"></var> 
                                                                    </div> <!-- price-wrap .// -->
                                                                    <div class="input-group input-group-sm justify-content-end">
                                                                        <button class="btn btn-outline-secondary quantityDown" type="button" style="width: 36px">-</button>
                                                                        <input type="number" class="form-control quantityInput" style="max-width: 60px; text-align: center" value="${product.cartQuantity}"/>
                                                                        <button class="btn btn-outline-secondary quantityUp" type="button" style="width: 36px">+</button>
                                                                    </div>
                                                                </div>
                                                            </article> <!-- row.// -->
                                                            <hr>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:forEach>
                                        </div>
                                    </c:otherwise>
                                </c:choose>


                                <a class="btn btn-light" href="/" onclick="history.back()"> 
                                    <i class="fa fa-arrow-left me-2"></i> Back to shop 
                                </a>

                            </div> <!-- card-body .// -->
                        </div> <!-- card.// -->

                    </main> <!-- col.// -->
                    <aside class="col-lg-3">
                        <c:choose>
                            <c:when test="${cartProducts == null || cartProducts.size() == 0}"></c:when>
                            <c:otherwise>
                                <div class="card shadow-lg mb-4">
                                    <div class="card-body">
                                        <dl class="row">
                                            <dt class="col-5 fw-normal text-muted">Subtotal: </dt>
                                            <dd class="col-7 text-end" id="subtotal"></dd>

                                            <dt class="col-5 fw-normal text-muted">Discount:</dt>
                                            <dd class="col-7 text-end" id="discount">0 ₫</dd>

                                            <dt class="col-5 fw-normal text-muted">Tax:</dt>
                                            <dd class="col-7 text-end" id="tax">+ $14.00 </dd>

                                            <dt class="col-5 fw-normal text-muted">Shipping:</dt>
                                            <dd class="col-7 text-end" id="shipping">+ $9.50 </dd>
                                        </dl>
                                        <hr>
                                        <dl class="row">
                                            <dt class="col-5 h5 text-muted">Total:</dt>
                                            <dd class="col-7 h5 text-end" id="total"> $357.90 </dd>
                                        </dl>

                                        <div class="my-3">
                                            <a class="btn btn-lg p-3 btn-success w-100" href="/checkout"> Make Purchase </a>
                                        </div>
                                        <p class="text-center mt-3">
                                            <img src="https://bootstrap-ecommerce-web.netlify.app/images/misc/payments.png" height="24">
                                        </p>

                                    </div> <!-- card-body.// -->
                                </div> <!-- card.// -->
                            </c:otherwise>
                        </c:choose>

                    </aside> <!-- col.// -->

                </div> <!-- row.// -->
                <!-- =================== COMPONENT 1 CART+SUMMARY .//END  ====================== -->



                <article class="rounded p-5 bg-gray-light">

                    <!-- ---- features ----	 -->
                    <div class="row">
                        <div class="col-md-4">
                            <!-- item-feature -->
                            <figure class="d-flex align-items-center">
                                <span class="icon me-3 rounded-circle size-48x48 bg-gray">
                                    <i class="fa fa-lock fa-lg"></i>
                                </span> 
                                <figcaption>
                                    Secure Payment
                                    <p class="mb-0 text-muted">Have you ever finally just </p>
                                </figcaption>
                            </figure> 
                            <!-- item-feature .// -->
                        </div> <!-- col.// -->
                        <div class="col-md-4">
                            <!-- item-feature -->
                            <figure class="d-flex align-items-center">
                                <span class="icon me-3 rounded-circle size-48x48 bg-gray">
                                    <i class="fa fa-phone fa-lg"></i>
                                </span> 
                                <figcaption>
                                    Customer Support
                                    <p class="mb-0 text-muted">Have you ever finally just </p>
                                </figcaption>
                            </figure> 
                            <!-- item-feature .// -->
                        </div> <!-- col.// -->
                        <div class="col-md-4">
                            <!-- item-feature -->
                            <figure class="d-flex align-items-center">
                                <span class="icon me-3 rounded-circle size-48x48 bg-gray">
                                    <i class="fa fa-truck fa-lg"></i>
                                </span> 
                                <figcaption>
                                    Free Delivery
                                    <p class="mb-0 text-muted"> Have you ever finally just </p>
                                </figcaption>
                            </figure> 
                            <!-- item-feature .// -->
                        </div> <!-- col.// -->
                </article>

            </div> <!-- container .//  -->
        </section>
        <%@include file="components/footerLink.html" %>

        <script>
            const productJson = ${productsJSON};
            const validProduct = productJson.filter(product => product.storage === false && product.variantStorage === false);

            const productsPrice = Array.from(document.querySelectorAll(".productPrice"));
            const quantityDownBtns = Array.from(document.querySelectorAll(".quantityDown"));
            const quantityUpBtns = Array.from(document.querySelectorAll(".quantityUp"));
            const quantityInputs = Array.from(document.querySelectorAll(".quantityInput"));
            const removeBtns = Array.from(document.querySelectorAll(".remove-btn"));

            const controlQuantity = (num, index) => {
                if (productJson[index].cartQuantity + num > productJson[index].maxQuantity) {
                    productJson[index].cartQuantity = productJson[index].maxQuantity;
                    quantityInputs[index].value = productJson[index].cartQuantity;
                    postChangeQuantity(productJson[index].productVariantId, productJson[index].cartQuantity);
                    updateInvoice();
                    return;
                }
                if (productJson[index].cartQuantity + num <= 1) {
                    productJson[index].cartQuantity = 1;
                    quantityInputs[index].value = productJson[index].cartQuantity;
                    postChangeQuantity(productJson[index].productVariantId, 1);
                    updateInvoice();
                    return;
                }
                productJson[index].cartQuantity += num;
                quantityInputs[index].value = productJson[index].cartQuantity;
                updateInvoice();
                postChangeQuantity(productJson[index].productVariantId, productJson[index].cartQuantity);
            };

            const updatePrice = () => {
                productsPrice.forEach((product, index) => {
                    product.innerHTML = Intl.NumberFormat("vi-VN", {
                        style: "currency",
                        currency: "VND",
                    }).format(productJson[index].cartQuantity * productJson[index].price);
                })
            }


            const subtotal = document.querySelector("#subtotal");
            const tax = document.querySelector("#tax");
            const shipping = document.querySelector("#shipping");
            const total = document.querySelector("#total");

            const calSubTotal = () => productJson.reduce((total, product) => {
                    if (product.storage === false && product.variantStorage === false) {
                        return total + (product.price * product.cartQuantity);
                    } else {
                        return total;
                    }
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

            const calShippingFee = () => 20000;
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
                updatePrice();
                updateSubTotal();
                updateTax();
                updateShippingFee();
                updateTotal();
            }
            updateInvoice();

            const postChangeQuantity = (productVariantId, quantity) => {
                $.ajax({
                    type: "post",
                    url: "/cart/update-quantity",
                    data:
                            {
                                "productVariantId": productVariantId,
                                "quantity": quantity
                            },
                    cache: false,
                    success: function (response)
                    {

                    }
                });
            }

            quantityUpBtns.forEach((quantityUpBtn, index) => {
                quantityUpBtn.onclick = () => {
                    controlQuantity(1, index);
                };
            });
            quantityDownBtns.forEach((quantityDownBtn, index) => {
                quantityDownBtn.onclick = () => {
                    controlQuantity(-1, index);
                };
            });
            quantityInputs.forEach((quantityInput, index) => {
                quantityInput.addEventListener("change", () => {
                    if (productJson[index].cartQuantity > productJson[index].maxQuantity) {
                        quantityInput.value = productJson[index].maxQuantity;
                    }
                    if (productJson[index].cartQuantity <= 1) {
                        quantityInput.value = 1;
                    }
                })
            })

            const cartContainer = document.querySelector("#cartContainer");
            const checkEmpty = () => {
                if (cartContainer.firstElementChild === null) {
                    cartContainer.innerHTML = "<p>Oops, cannot find any product :(</p>";
                }
            }
            const removeDomItem = (productVariantId) => {
                document.getElementById(productVariantId).remove();
                checkEmpty();
            };

            removeBtns.forEach((removeBtn) => {
                removeBtn.addEventListener("click", () => {
                    $.ajax({
                        type: "post",
                        url: "/cart/delete",
                        data:
                                {
                                    "productVariantId": removeBtn.dataset.remove,
                                },
                        cache: false,
                        success: function (response)
                        {
                            removeDomItem(removeBtn.dataset.remove);
                            Swal.fire({
                                title: 'Remove from cart successfully',
                                icon: 'success',
                                confirmButtonText: 'OK',
                            })
                        }
                    });
                })
            });
        </script>
    </body>
</html>
