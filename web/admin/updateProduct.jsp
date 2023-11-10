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
  <title>Update Product | ${initParam['webName']}</title>

  <!-- ========== All CSS files linkup ========= -->
  <link rel="stylesheet" href="https://demo.plainadmin.com/assets/css/bootstrap.min.css" />
  <link rel="stylesheet" href="https://demo.plainadmin.com/assets/css/lineicons.css" />
  <link rel="stylesheet" href="https://demo.plainadmin.com/assets/css/materialdesignicons.min.css" />
  <link rel="stylesheet" href="https://demo.plainadmin.com/assets/css/fullcalendar.css" />
  <link rel="stylesheet" href="https://cdn.quilljs.com/1.3.6/quill.snow.css">
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
                        <h2>Update Product</h2>
                        <div class="breadcrumb-wrapper d-flex align-items-center mb-0">
                            <nav aria-label="breadcrumb">
                                <ol class="breadcrumb mb-0">
                                    <li class="breadcrumb-item">
                                        <a href="/admin/product">Product</a>
                                    </li>
                                    <li class="breadcrumb-item active" aria-current="page">
                                        Update product
                                    </li>
                                </ol>
                            </nav>
                        </div>
                    </div>
                </div>
                <form id="basicInfoForm" class="form-elements-wrapper">
                    <div class="row">
                        <div class="col-lg-6">
                            <div class="card-style mb-30">
                                <h6 class="mb-25">Basic information</h6>
                                <div class="row">
                                    <div class="col-lg-6">
                                        <div class="input-style-1">
                                            <label>Product name</label>
                                            <input type="text" name="name" id="name" placeholder="e.g: Chair, iPhone,..." value="${product.name}"/>
                                        </div>
                                    </div>
                                    <div class="col-lg-6">
                                        <div class="select-style-1">
                                            <label>Category</label>
                                            <div class="select-position">
                                                <select id="category">
                                                    <c:forEach var="category" items="${categories}">
                                                        <option value="${category.id}" selected="${product.category.slug == category.slug}">${category.name}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="input-style-1">
                                        <label>Description</label>
                                        <div style="height: 350px; margin-bottom: 30px">
                                            <div id="editor"></div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="input-style-1">
                                        <label>Featured images</label>
                                        <div class="d-flex gap-4 flex-wrap" id="imagesZone">
                                            <div id="featuredImage" class="d-flex gap-4 flex-wrap">
                                            </div>
                                            <div class="d-flex align-items-center justify-content-center position-relative" style="width: 150px; height: 150px; border: 1px dashed #999; border-radius: 3px;">
                                                <img src="http://100dayscss.com/codepen/upload.svg" />
                                                <input type="file" name="images" id="imageUploadInput" style="position: absolute; width: 100%; height: 100%; opacity: 0; cursor: pointer" multiple accept=".jpg, .png"/>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <div class="card-style mb-30">
                              <h6 class="mb-25">Detail information</h6>
                                <div class="row" id="detailInfo">
                                    <!-- ======= Option here ======= -->
                                </div>
                                <button type="button" class="btn btn-outline-primary mb-4" id="addOptionBtn">Add option</button>
                                <div class="row" id="variantInfo">
                                    <!-- ======= Variant table here ======= -->
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="card-style d-flex position-sticky justify-content-end gap-3 shadow-lg" style="z-index: 100; bottom: 1.5rem">
                        <a class="btn btn-outline-secondary" href="/admin/product">Cancel</a>
                        <button type="button" class="btn btn-danger" id="deleteBtn">Delete</button>
                        <button type="button" class="btn btn-success" id="submitBtn">Update</button>
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
        const productJSON = ${productJSON}
        var quill = new Quill('#editor', {
            placeholder: 'Write description here',
            theme: 'snow'
        });
        quill.clipboard.dangerouslyPasteHTML(`${product.description}`);
        
        const productName = document.querySelector("#name"); //PRODUCT NAME
        const productCategory = document.querySelector("#category"); //PRODUCT CATEGORY
        
        const imagesZone = document.querySelector("#imagesZone");
        const featuredImage = document.querySelector("#featuredImage");
        const imageUploadInput = document.querySelector("#imageUploadInput");
        const submitBtn = document.querySelector("#submitBtn");
        let deleteImageBtns;
        
        async function createFile(url){
            let response = await fetch(url);
            let data = await response.blob();
            let metadata = {
              type: 'image/jpeg'
            };
            let file = new File([data], "test.jpg", metadata);
            return file;
        }
        
        const getCurrentImages = () => {
            let previewImageArr = [];
            productJSON.images.forEach(image => {
                createFile("/image/product?id=" + image.id).then(r => {
                    previewImageArr.push(r);
                })
            })
            return previewImageArr;
        }
        
        let previewImageArr = getCurrentImages(); //PRODUCT IMAGES
        
        imageUploadInput.addEventListener('change', () => {
            const files = imageUploadInput.files;
            
            for (let i = 0; i < files.length; i++) {
                    previewImageArr.push(files[i])
                }
            displayPreviewImages();
        });
        
        imagesZone.addEventListener('drop', (e) => {
            e.preventDefault();
            const files = e.dataTransfer.files;
            for (let i = 0; i < files.length; i++) {
                if(!files[i].type.match("image")) continue;
                if(previewImageArr.every(image => image.name !== files[i].name)) {
                    previewImageArr.push(files[i]);
                }
            }
            displayPreviewImages();
        })
        
        const displayPreviewImages = () => {
            let imagesRender = "";
            
            previewImageArr.forEach((image, index) => {
                imagesRender += `
                    <div class="position-relative">
                        <button type="button" class="position-absolute top-0 start-100 translate-middle btn-close bg-secondary deleteImageBtn" data-index="\${index}"></button>
                        <img src="\${URL.createObjectURL(image)}" alt="thumb-image" class="img-thumbnail" style="height: 150px; width: 150px; object-fit: cover">
                    </div>
                `
            });
            featuredImage.innerHTML = imagesRender;
            deleteImageBtns = Array.from(document.querySelectorAll(".deleteImageBtn"));
            deleteImageBtns.forEach(btn => {
                btn.onclick = () => {
                    previewImageArr.splice(parseInt(btn.dataset.index), 1);
                    displayPreviewImages();
                }
            })
        }
        
        setTimeout(() => {
            displayPreviewImages();
        }, 300);
        
        const addOptionBtn = document.querySelector("#addOptionBtn");
        const detailInfo = document.querySelector("#detailInfo");
        const variantInfo = document.querySelector("#variantInfo");
        
        let priceInput;
        let quantityInput;
        
        let removeOptionBtns
        let removeValueBtns
        let addValueBtns
        let optionInputs
        let valueInputs
        let priceInputs
        let quantityInputs
        
        const generateSKUByName = (name) => {
            let sku = name.toLowerCase();

            sku = sku.replace(/á|à|ả|ạ|ã|ă|ắ|ằ|ẳ|ẵ|ặ|â|ấ|ầ|ẩ|ẫ|ậ/gi, "a");
            sku = sku.replace(/é|è|ẻ|ẽ|ẹ|ê|ế|ề|ể|ễ|ệ/gi, "e");
            sku = sku.replace(/i|í|ì|ỉ|ĩ|ị/gi, "i");
            sku = sku.replace(/ó|ò|ỏ|õ|ọ|ô|ố|ồ|ổ|ỗ|ộ|ơ|ớ|ờ|ở|ỡ|ợ/gi, "o");
            sku = sku.replace(/ú|ù|ủ|ũ|ụ|ư|ứ|ừ|ử|ữ|ự/gi, "u");
            sku = sku.replace(/ý|ỳ|ỷ|ỹ|ỵ/gi, "y");
            sku = sku.replace(/đ/gi, "d");

            sku = sku.toUpperCase();

            sku = sku.replace(
                /\`|\~|\!|\@|\#|\||\$|\%|\^|\&|\*|\(|\)|\+|\=|\,|\.|\/|\?|\>|\<|\'|\"|\:|\;|_|\-/gi,
                ""
            );
            sku = sku.replace(/ /gi, "");

            sku = sku.replace(/\-\-\-\-\-/gi, "");
            sku = sku.replace(/\-\-\-\-/gi, "");
            sku = sku.replace(/\-\-\-/gi, "");
            sku = sku.replace(/\-\-/gi, "");
            sku = "@" + sku + "@";
            sku = sku.replace(/\@\-|\-\@|\@/gi, "");
            return sku;
        };
        const getCurrentOptions = () => {
            let options = {};
            productJSON.options.forEach(option => {
                options[`\${option.option}`] = option.values.map(value => value.value);
            });
            return options;
        }
        let options = getCurrentOptions();
        
        let optionObjs = []; //OPTIONS VALUES
        
        let variants = [];
        let variantObjs = []; //VARIANTS
        
        const detailInfoRender = () => {
            let render = "";
            for (const [attr, values] of Object.entries(options)) {
                let valuesRender = values.map((value, index) => {
                    return `<div class="input-style-1">
                                <label>Value \${index+1}</label>
                                <div class="input-group">
                                    <input type="text" placeholder="e.g: Red" class="form-control valueInput" value="\${value}" data-option="\${attr}" data-value="\${value}"/>
                                    <button class="btn text-danger removeValueBtn" data-option="\${attr}" data-value="\${value}">
                                        <i class="lni lni-trash-can"></i>
                                    </button>
                                </div>
                            </div>`;
                }).join("");
                let optionRender =
                    `<div class="card p-lg-4 mb-4">
                        <div class="row justify-content-end">
                            <button type="button" class="btn-close removeOptionBtn" data-option="\${attr}"></button>
                        </div>
                        <div class="row">
                            <div class="col-lg-6">
                                <div class="input-style-1">
                                    <label>Option</label>
                                    <input type="text" placeholder="e.g: Color" class="optionInput" value="\${attr}" data-option="\${attr}"/>
                                </div>
                            </div>
                            <div class="col-lg-6">
                                \${valuesRender}
                                <button class="btn btn-outline-primary addValueBtn" data-option="\${attr}">Add value</button>
                            </div>
                        </div>
                    </div>`;
                render += optionRender;
            }
            return render;
        };
        
        const defaultRender = `
                <div class="col-lg-6">
                    <div class="input-style-1">
                      <label>Price</label>
                      <input type="number" id="priceInput" placeholder="0 ₫" />
                    </div>
                </div>     
                <div class="col-lg-6">
                    <div class="input-style-1">
                      <label>Quantity</label>
                      <input type="number" id="quantityInput" placeholder="0" />
                    </div>
                </div>
        `
    
        const tableRender = () => {
            let tableHead = `
                <th class="px-2">
                    <h6>#</h6>
                </th>
            `
            for (const [attr, values] of Object.entries(options)) {
                tableHead += `
                    <th class="px-2">
                        <h6>\${attr}</h6>
                    </th>
                `
            }
            tableHead += `
                <th class="px-2">
                    <h6>Price</h6>
                </th>
                <th class="px-2">
                    <h6>Quantity</h6>
                </th>
            `
        
            let tableData = variants.map((variant, index) => {
                let col = `
                    <td class="px-2">
                        <p>\${index+1}</p>
                    </td>
                `;
                let sku = [];
                for (const [attr, values] of Object.entries(variant)) {
                    col += `
                        <td class="px-2">
                            <p>\${values}</p>
                        </td>
                    `
                    sku.push(generateSKUByName(attr) + "-" + generateSKUByName(values));
                }
                col += `
                    <td class="px-2">
                        <input type="number" class="form-control priceInput" placeholder="0 ₫" data-sku="\${sku.join("$")}"/>
                    </td>
                    <td class="px-2">
                        <input type="number" class="form-control quantityInput" placeholder="0" data-sku="\${sku.join("$")}"/>
                    </td>
                `
                return `
                    <tr>
                        \${col}
                    </tr>
                `
            }).join("");
            return `
                <table class="table align-middle" id="variantsTable">
                    <thead>
                        <tr>
                            \${tableHead}
                        </tr>
                    </thead>
                    <tbody>
                        \${tableData}
                    </tbody>
                </table>
            `;
        }
        
        setTimeout(() => {
            if(productJSON.variants.length > 1) {
                const variantsTable = document.querySelector("#variantsTable");
                productJSON.variants.forEach((variant, index) => {
                    let row = variantsTable.rows[index + 1];
                    let priceInput = row.querySelector(".priceInput");
                    let quantityInput = row.querySelector(".quantityInput");

                    priceInput.value = variant.price;
                    quantityInput.value = variant.quantity;
                })
            }
        }, 500)
        
        const renameObjKey = (oldObj, oldKey, newKey) => {
            const keys = Object.keys(oldObj);
            const newObj = keys.reduce((acc, val)=>{
                if(val === oldKey){
                    acc[newKey] = oldObj[oldKey];
                }
                else {
                    acc[val] = oldObj[val];
                }
                return acc;
            }, {});

            return newObj;
        };
        
        function isObjEmpty(obj) {
            for (const prop in obj) {
                if (Object.hasOwn(obj, prop)) {
                    return false;
                }
            }
            return true;
        }
        
        function removeElement(array, elem) {
            let index = array.indexOf(elem);
            if (index > -1) {
                array.splice(index, 1);
            }
        }
        
        function updateElement(array, value, newValue) {
            let index = array.indexOf(value);
            if (index > -1) {
                array[index] = newValue;
            }
        }
        
        let getOptionObjs = () => {
            let optionObjs = [];
            for (const [attr, values] of Object.entries(options)) {
                optionObjs.push({
                    option: attr,
                    sku: generateSKUByName(attr),
                    values: values.map(value => {
                        return {
                            value: value,
                            sku: generateSKUByName(value)
                        }
                    })
                })
            }
            return optionObjs;
        }
        
        let getVariants = () => {
            let variants = [];
            for (const [attr, values] of Object.entries(options))
                variants.push(values.map((v) => ({ [attr]: v })));

            variants = variants.reduce((a, b) =>
                a.flatMap((d) => b.map((e) => ({ ...d, ...e })))
            );
            return variants;
        };
        
        let getVariantObjs = () => {
            let variantObjs = [];
            variantObjs = priceInputs.map((priceInput, index) => {
                return {
                    sku: priceInput.dataset.sku,
                    price: parseInt(priceInput.value) || 0,
                    quantity: parseInt(quantityInputs[index].value) || 0
                }
            })
            return variantObjs;
        }
        
        const getDefaultVariantObjs = () => {
            let variantObjs = [];
            variantObjs.push({
                sku: "",
                price: parseInt(priceInput.value) || productJSON.variants[0].price,
                quantity: parseInt(quantityInput.value) || productJSON.variants[0].quantity
            })
            return variantObjs;
        }
        
        const reRender = () => {
            if(isObjEmpty(options)) {
                detailInfo.innerHTML = defaultRender;
                variantInfo.innerHTML = "";
                priceInput = document.querySelector("#priceInput");
                quantityInput = document.querySelector("#quantityInput");
                
                optionObjs = [];
                variants = [];
                variantObjs = getDefaultVariantObjs();
                priceInput.onchange = () => {
                    variantObjs = getDefaultVariantObjs();
                }
                quantityInput.onchange = () => {
                    variantObjs = getDefaultVariantObjs();
                }
                return;
            };
            detailInfo.innerHTML = detailInfoRender();
            removeOptionBtns = Array.from(document.querySelectorAll(".removeOptionBtn"));
            removeValueBtns = Array.from(document.querySelectorAll(".removeValueBtn"));
            addValueBtns = Array.from(document.querySelectorAll(".addValueBtn"));
            
            optionInputs = Array.from(document.querySelectorAll(".optionInput"));
            valueInputs = Array.from(document.querySelectorAll(".valueInput"));
            
            optionInputs.forEach((input) => {
                input.onchange = () => {
                    options = renameObjKey(options, input.dataset.option, input.value);
                    reRender();
                }
            })
            
            valueInputs.forEach((input) => {
                input.onchange = () => {
                    updateElement(options[`\${input.dataset.option}`], input.dataset.value, input.value);
                    reRender();
                }
            })
            
            removeOptionBtns.forEach((btn) => {
                btn.onclick = () => {
                    delete options[`\${btn.dataset.option}`];
                    reRender();
                };
            });
            
            removeValueBtns.forEach((btn) => {
                btn.onclick = () => {
                    removeElement(options[`\${btn.dataset.option}`], btn.dataset.value);
                    if(options[`\${btn.dataset.option}`].length === 0) delete options[`\${btn.dataset.option}`]
                    reRender();
                }
            })
            addValueBtns.forEach((btn) => {
                btn.onclick = () => {
                    options[`\${btn.dataset.option}`].push("");
                    reRender();
                }
            })
            optionObjs = getOptionObjs();
            variants = getVariants();
            variantInfo.innerHTML = tableRender();
            priceInputs = Array.from(document.querySelectorAll(".priceInput"));
            quantityInputs = Array.from(document.querySelectorAll(".quantityInput"));
            
            variantObjs = getVariantObjs();
            priceInputs.forEach(input => {
                input.onchange = () => {
                    variantObjs = getVariantObjs();
                }
            })
            quantityInputs.forEach(input => {
                input.onchange = () => {
                    variantObjs = getVariantObjs();
                }
            })
        }
        
        reRender();
        
        const newOption = () => {
            Object.assign(options, {"": [""]});
            reRender();
        }
        addOptionBtn.onclick = newOption;
        
        const currentURL = new URL(document.location);
        
        const deleteBtn = document.querySelector("#deleteBtn");
        
        const removeProduct = (slug) => {
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
                            url:"/admin/product/delete",
                            data: 
                            {  
                                slug: slug
                            },
                            cache:false,
                            success: function (response) {
                                console.log(response);
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
                                            title: 'Success!',
                                            icon: 'success',
                                            confirmButtonText: 'OK',
                                            allowOutsideClick: false,
                                            allowEscapeKey: false,
                                        })
                                        .then((result) => {
                                            if (result.isConfirmed) {
                                                window.open("/admim/product", "_self");
                                            }
                                        })
                                }
                            }
                        });
                    }
                })
        }
        
        deleteBtn.onclick = () => {
            removeProduct("${product.slug}");
        };
        
        submitBtn.onclick = () => {
            let data = new FormData();
            data.append("id", ${product.id});
            data.append("name", productName.value);
            previewImageArr.forEach((image) => {
                data.append("images", image);
            })
            data.append("category", productCategory.value);
            data.append("description", quill.root.innerHTML);
            data.append("options", JSON.stringify(optionObjs));
            data.append("variants", JSON.stringify(variantObjs));
            
            $.ajax({
                type:"post",
                url:"/admin/product/update",
                processData: false,
                contentType: false,
                enctype : "multipart/form-data",
                data: data,
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
                                    window.open("/login", "_self");
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
                                title: 'Update product successfully',
                                icon: 'success',
                                confirmButtonText: 'OK',
                                allowOutsideClick: false,
                                allowEscapeKey: false,
                            }).then((result) => {
                                if (result.isConfirmed) {
                                    window.open("/admin/product", "_self");
                                }
                            })
                    }
                }
            });
        }
    </script>
</body>
</html>

