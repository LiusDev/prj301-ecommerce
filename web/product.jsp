<%-- 
    Document   : product
    Created on : Sep 19, 2023, 2:18:15 PM
    Author     : LiusDev
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page errorPage="errorPage.jsp" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>${product.name} | ${initParam['webName']}</title>
        <%@include file="components/headerLink.html" %>
    </head>
    <body>
        <%@include file="components/header.jsp" %>
        <c:choose>
            <c:when test="${product == null}">
                <p>Oops, cannot find any product :(</p>
            </c:when>
            <c:otherwise>
                <section class="mt-5">
                    <div class="container">
                        <article class="card p-3 mb-4">
                            <div class="row">
                                <aside class="col-lg-4">
                                    <figure class="gallery-wrap">
                                        <a href="#" class="img-main-wrap mb-3">
                                            <img id="thumbImage" src="image/product?id=${product.images[0].id}" alt="thumb-image" class="img-thumbnail w-100 img-contain" style="max-height: 360px">
                                        </a>

                                        <div class="thumbs-wrap text-center overflow-auto text-nowrap" id="images">
                                            <c:forEach var="image" items="${product.images}">
                                                <img class="item-thumb img-thumbnail size-60x60 previewImg" height="60" src="image/product?id=${image.id}">
                                            </c:forEach>
                                        </div> <!-- thumbs-wrap.// -->
                                    </figure> <!-- gallery-wrap .end// -->
                                </aside>
                                <main class="col-lg-7">

                                    <article>
                                        <h4 class="mb-2">${product.name}</h4>

                                        <div class="rating-wrap mb-3">
                                            <ul class="rating-stars">
                                                <li style="width:80%" class="stars-active"> <img src="./detailPage_files/stars-active.svg" alt=""> </li>
                                                <li> <img height="520" src="./detailPage_files/starts-disable.svg" alt=""> </li>
                                            </ul>
                                            <b class="label-rating text-warning"> 4.5</b>
                                            <i class="dot"></i>
                                            <span class="label-rating text-muted"> <i class="fa fa-comment"></i> 34 reviews </span>
                                            <i class="dot"></i>
                                            <span class="label-rating text-muted"> <i class="fa fa-shopping-basket"></i> <span id="totalSoldQuantity"></span> sold </span>
                                        </div> <!-- rating-wrap.// -->

                                        <div class="d-flex mb-3 p-3 bg-warning-light col-lg-9">
                                            <var class="text-danger h3" id="price"></var>
                                        </div>

                                        <dl class="row" id="productOptions">
                                            <c:forEach var="option" items="${product.options}">
                                                <dt class="col-xxl-3 col-lg-4 fw-normal text-muted">${option.option}</dt>
                                                <dd class="col-xxl-9 col-lg-8">
                                                    <select class="form-select d-inline-block w-auto productOption" title="${option.sku}" data-sku="${option.sku}">
                                                        <c:forEach var="value" items="${option.values}">
                                                            <option value="${value.sku}">${value.value}</option>
                                                        </c:forEach>
                                                    </select>
                                                </dd>
                                            </c:forEach>
                                        </dl>

                                        <dl class="row">
                                            <dt class="col-xxl-3 col-lg-4 fw-normal text-muted">Quantity</dt>
                                            <dd class="col-xxl-9 col-lg-8">
                                                <div class="input-group mb-2">
                                                    <button class="btn btn-outline-secondary" id="quantityDown" type="button" style="width: 40px">-</button>
                                                    <input id="quantity" type="number" class="form-control" style="max-width: 80px; text-align: center" value="1"/>
                                                    <button class="btn btn-outline-secondary" id="quantityUp" type="button" style="width: 40px">+</button>
                                                </div>
                                                <p class="text-danger"><span id="quantityLeft">45</span> products left in stock</p>
                                                <span class="text-danger mx-2" id="quantityAlert"></span>
                                            </dd>
                                        </dl>

                                        <dl class="row">
                                            <dt class="col-xxl-3 col-lg-4 fw-normal text-muted"></dt>
                                            <dd class="col-xxl-9 col-lg-8">
                                                <button type="button" id="addCartBtn" class="btn btn-primary">Add to cart</button>
                                            </dd>
                                        </dl>

                                    </article> <!-- product-info-aside .// -->
                                </main> <!-- col.// -->
                            </div> <!-- row.// -->
                        </article>
                    </div> <!-- container .//  -->
                </section>
                <!-- ================ SECTION-ITEM-INFO END .// ============== -->



                <!-- ================ SECTION-DETAIL-BOTTOM ============== -->
                <section>
                    <div class="container">
                        <div class="row">
                            <main>
                                <div class="card mb-4">
                                    <header class="card-header">
                                        <ul class="nav nav-tabs card-header-tabs">
                                            <li class="nav-item">
                                                <a class="nav-link active" data-bs-toggle="tab" data-bs-target="#details" aria-current="true" href="#">Description</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-link" data-bs-toggle="tab" data-bs-target="#reviews" href="#">Reviews</a>
                                            </li>
                                        </ul>
                                    </header> <!-- card-header .// -->
                                    <div class="tab-content card-body">

                                        <!-- tab-pane details -->
                                        <article class="tab-pane active" id="details" role="tabpanel">
                                            ${product.description}
                                        </article>
                                        <!-- tab-pane details .// -->

                                        <article class="tab-pane" id="reviews" role="tabpanel">
                                            <h6>Reviews </h6>
                                            Culpa reprehenderit, nam doloribus possimus sapiente quo cumque maxime rerum. Sit repellat nisi consequuntur assumenda, ipsam ab aut hic sint laboriosam tempore!
                                        </article>
                                        <!-- tab-pane reviews .// -->
                                    </div> <!-- card-body .// -->
                                </div> <!-- card .// -->
                            </main>
                        </div> <!-- row.// -->

                    </div> <!-- container .//  -->
                </section>
                <!-- ================ SECTION-DETAIL-BOTTOM END .// ============== -->


                <!-- ================ SECTION-RELATED ============== -->
                <section>
                    <div class="container">
                        <article class="card p-3 mb-4">
                            <h5 class="card-title"> Related products </h5>

                            <div class="row">
                                <c:forEach var="product" items="${relatedProducts}">
                                    <div class="col-xxl-2 col-xl-3 col-sm-4 col-6">
                                        <figure class="card-product-grid product-sm">
                                            <a href="product?slug=${product.slug}" class="img-wrap border rounded"> <img src="image/product?id=${product.image.id}" alt="${product.image.alt}"> </a>
                                            <figcaption class="mt-2">
                                                <a href="https://bootstrap-ecommerce-web.netlify.app/p-market-detail#" class="title text-truncate"> ${product.name} </a>
                                                <p class="mt-1 text-muted">${String.format("%,d", product.minPrice)} ₫ - ${String.format("%,d", product.maxPrice)} ₫</p> <!-- price.// -->
                                            </figcaption>
                                        </figure> <!-- item // -->
                                    </div> <!-- col // -->
                                </c:forEach>
                            </div> <!-- row // -->
                        </article>
                    </div> <!-- container .//  -->
                </section>
            </c:otherwise>
        </c:choose>
        <%@include file="components/footerLink.html" %>
        <script>
            let updateProducts;
            let product = ${productsJson}

            const totalSoldQuantity = product.variants.reduce((sum, variant) => {
                return sum + variant.soldQuantity;
            }, 0)

            document.querySelector("#totalSoldQuantity").innerHTML = totalSoldQuantity;

            const thumbImage = document.querySelector("#thumbImage");

            const previewImages = Array.from(document.querySelectorAll(".previewImg"));
            previewImages.forEach((image) => {
                image.addEventListener("click", () => {
                    thumbImage.src = image.src;
                });
            })


            let SKU = product.options.map((option) => {
                return option.sku + "-" + option.values[0].sku;
            });

            const handleSKU = (index, sku) => {
                SKU[index] = sku;
            }

            const getCurrVariant = () => product.variants.find((variant) => {
                    return variant.sku === SKU.join("$");
                })

            const price = document.querySelector("#price");
            const setPrice = (content) => {
                if (typeof (content) === 'string') {
                    price.innerHTML = content
                } else {
                    price.innerHTML = Intl.NumberFormat("vi-VN", {
                        style: "currency",
                        currency: "VND",
                    }).format(content)
                }
            }
            setPrice(getCurrVariant().price);

            const quantityLeft = document.querySelector("#quantityLeft");
            const setQuantityLeft = (content) => {
                quantityLeft.innerHTML = content;
            }
            setQuantityLeft(getCurrVariant().quantity);

            const getTotalQuantity = (product) => {
                return product.variants.reduce((sum, v) => {
                    return sum + v.quantity;
                }, 0);
            }

            const options = Array.from(document.querySelectorAll(".productOption"));
            options.forEach((option, index) => {
                option.addEventListener("change", () => {
                    let sku = option.dataset.sku + "-" + option.value;
                    handleSKU(index, sku);
                    let currVariant = getCurrVariant();
                    if (currVariant.quantity <= 0) {
                        setPrice("Out of stock!");
                        setQuantityLeft(getCurrVariant().quantity);
                        addCartBtn.disabled = true;
                    } else {
                        setPrice(getCurrVariant().price);
                        setQuantityLeft(getCurrVariant().quantity);
                        addCartBtn.disabled = false;
                    }
                })
            })

            const quantityInput = document.querySelector("#quantity");
            const quantityAlert = document.querySelector("#quantityAlert");
            const quantityDownBtn = document.querySelector("#quantityDown");
            const quantityUpBtn = document.querySelector("#quantityUp");
            const addCartBtn = document.querySelector("#addCartBtn");

            const controlQuantity = (num) => {
                if (parseInt(quantityInput.value) + num > getCurrVariant().quantity) {
                    quantityInput.value = getCurrVariant().quantity;
                    return;
                }
                if (parseInt(quantityInput.value) + num <= 1) {
                    quantityInput.value = 1;
                    return;
                }
                quantityInput.value = parseInt(quantityInput.value) + num;
            };

            quantityDownBtn.onclick = () => {
                controlQuantity(-1)
            };
            quantityUpBtn.onclick = () => {
                controlQuantity(1)
            };

            quantityInput.addEventListener("change", () => {
                if (quantityInput.value > getCurrVariant().quantity) {
                    quantityAlert.innerHTML = "Out of stock!";
                    addCartBtn.disabled = true;
                    quantityUpBtn.disabled = true;
                    quantityInput.value = getCurrVariant().quantity;
                } else {
                    quantityAlert.innerHTML = "";
                    addCartBtn.disabled = false;
                    quantityUpBtn.disabled = false;
                }
                if (quantityInput.value <= 1) {
                    quantityInput.value = 1;
                    quantityDownBtn.disabled = true;
                } else {
                    quantityDownBtn.disabled = false;
                }
            });

            const currentURL = new URL(document.location);

            addCartBtn.addEventListener("click", () => {
                $.ajax({
                    type: "post",
                    url: "/cart/add",
                    data:
                            {
                                "productVariantId": getCurrVariant().id,
                                "quantity": quantityInput.value
                            },
                    cache: false,
                    success: function (response)
                    {
                        console.log(response)
                        if (response === "Please login") {
                            Swal.fire({
                                title: 'Please login to continue!',
                                icon: 'error',
                                showCancelButton: true,
                                confirmButtonText: 'Login',
                                cancelButtonText: 'Cancel'
                            }).then((result) => {
                                if (result.isConfirmed) {
                                    window.open("/login?redirect=" + currentURL.pathname + currentURL.search, "_self");
                                }
                            })
                        } else {
                            Swal.fire({
                                title: 'Add to cart successfully',
                                icon: 'success',
                                showCancelButton: true,
                                confirmButtonText: 'Go to cart',
                                cancelButtonText: 'OK'
                            }).then((result) => {
                                if (result.isConfirmed) {
                                    window.open("/cart", "_self");
                                }
                            })
                        }
                    }
                });
            });

            var websocket = new WebSocket("ws://localhost:8080/product-quantity");
            websocket.onopen = function (message) {
                processOpen(message);
            };
            websocket.onclose = function (message) {
                processClose(message);
            };
            websocket.onerror = function (message) {
                processError(message);
            };
            websocket.onmessage = function (message) {
                processMessage(message);
            };

            function processMessage(updateProductsJSON) {
                let updateProducts = JSON.parse(updateProductsJSON.data);
                let foundProduct = updateProducts.find((p) => product.id === p.id);
                if (foundProduct) {
                    let buyQuantity = getTotalQuantity(product) - getTotalQuantity(foundProduct);
                    product = foundProduct;
                    setQuantityLeft(getCurrVariant().quantity);
                    Toastify({
                        text: `An user just buy \${buyQuantity} products`,
                        duration: 3000,
                        newWindow: true,
                        close: true,
                        gravity: "bottom", // `top` or `bottom`
                        position: "right", // `left`, `center` or `right`
                        stopOnFocus: true, // Prevents dismissing of toast on hover
                        style: {
                            color: "#565656",
                            background: "#f7f7f7",
                        },
                        onClick: function () {} // Callback after click
                    }).showToast();
                }
            }
            function processOpen(message) {
                console.log("Server connect... \n");
            }
            function processClose(message) {
                console.log("Server Disconnect... \n");
            }
            function processError(message) {
                console.log("Error... " + message + " \n");
            }
        </script>
    </body>
</html>
