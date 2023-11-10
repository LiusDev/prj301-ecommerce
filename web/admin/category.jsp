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
  <title>Category | ${initParam['webName']}</title>

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
    <main class="main-wrapper">
      <!-- ========== header start ========== -->
        <%@include file="/components/adminHeader.jsp" %>
      <!-- ========== header end ========== -->

        <section class="table-components">
            <div class="container-fluid">
                <div class="title-wrapper pt-30">
                    <div class="d-flex align-items-center justify-content-between mb-4">
                        <h2>Category</h2>
                    </div>
                </div>
                <div class="row">
                    <div class="categories-wrapper col-lg-6">
                        <div class="card-style mb-30">
                            <div class="table-wrapper table-responsive mb-2">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th class="px-2">
                                                <h6>#</h6>
                                            </th>
                                            <th class="px-2">
                                                <h6>Name</h6>
                                            </th>
                                            <th class="px-2">
                                              <h6>Action</h6>
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody id="categoryList"></tbody>
                                </table>
                            </div>
                            <button type="button" class="btn btn-outline-primary mb-0" id="newCategoryBtn">New category</button>
                        </div>
                    </div>
                    <div class="statistical-wrapper col-lg-6">
                        <div class="card-style mb-30">
                            <div class="title d-flex flex-wrap align-items-center justify-content-between">
                                <div class="left">
                                  <h6 class="text-medium mb-30">Number of products by each category</h6>
                                </div>
                            </div>
                            <div class="chart">
                                <canvas id="Chart2" style="width: 100%; margin-left: -45px;"></canvas>
                            </div>
                        </div>
                    </div>
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
        const generateSlugByName = (name) => {
            let slug = name.toLowerCase();

            slug = slug.replace(/á|à|ả|ạ|ã|ă|ắ|ằ|ẳ|ẵ|ặ|â|ấ|ầ|ẩ|ẫ|ậ/gi, "a");
            slug = slug.replace(/é|è|ẻ|ẽ|ẹ|ê|ế|ề|ể|ễ|ệ/gi, "e");
            slug = slug.replace(/i|í|ì|ỉ|ĩ|ị/gi, "i");
            slug = slug.replace(/ó|ò|ỏ|õ|ọ|ô|ố|ồ|ổ|ỗ|ộ|ơ|ớ|ờ|ở|ỡ|ợ/gi, "o");
            slug = slug.replace(/ú|ù|ủ|ũ|ụ|ư|ứ|ừ|ử|ữ|ự/gi, "u");
            slug = slug.replace(/ý|ỳ|ỷ|ỹ|ỵ/gi, "y");
            slug = slug.replace(/đ/gi, "d");

            slug = slug.replace(
                /\`|\~|\!|\@|\#|\||\$|\%|\^|\&|\*|\(|\)|\+|\=|\,|\.|\/|\?|\>|\<|\'|\"|\:|\;|_/gi,
                ""
            );

            slug = slug.replace(/ /gi, "-");

            slug = slug.replace(/\-\-\-\-\-/gi, "-");
            slug = slug.replace(/\-\-\-\-/gi, "-");
            slug = slug.replace(/\-\-\-/gi, "-");
            slug = slug.replace(/\-\-/gi, "-");

            slug = "@" + slug + "@";
            slug = slug.replace(/\@\-|\-\@|\@/gi, "");

            return slug;
        };
        
        const categoriesJSON = ${categoriesJSON}
        const countsJSON = ${countsJSON}
        
        const categoryTable = document.querySelector(".table");
        const categoryList = document.querySelector("#categoryList");
        
        let editBtns;
        let deleteBtns;
        let confirmBtn;
        let cancelBtns;
        
        const newCategoryBtn = document.querySelector("#newCategoryBtn");
        
        const editBtnsAction = () => {
            editBtns = Array.from(document.querySelectorAll(".editBtn"));
            editBtns.forEach((btn) => {
                btn.onclick = () => {
                    renderTable();
                    let index = parseInt(btn.dataset.index);
                    let name = categoryTable.rows[index+1].cells[1].innerText;
                    categoryTable.rows[index+1].cells[1].innerHTML = `<input type="text" value="\${name}" class="form-control form-control-sm"/>`
                    categoryTable.rows[index+1].cells[2].innerHTML = `
                        <div class="action">
                            <button type="button" title="Confirm" id="confirmBtn" class="text-success text-lg px-2" data-index="\${index}">
                                <i class="lni lni-checkmark"></i>
                            </button>
                            <button type="button" title="Cancel" id="cancelBtn" class="text-danger text-lg px-2" data-index="\${index}">
                                <i class="lni lni-close"></i>
                            </button>
                        </div>
                    `
                    confirmBtnAction();
                    cancelBtnAction();
                }
            })
        }
        
        const deleteBtnsAction = () => {
            deleteBtns = Array.from(document.querySelectorAll(".deleteBtn"));
            deleteBtns.forEach((btn) => {
                btn.onclick = () => {
                    renderTable();
                    let index = parseInt(btn.dataset.index);
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
                                url:"/admin/category/delete",
                                data: 
                                {  
                                    "id": categoriesJSON[index].id
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
                                        case "Rest product":
                                            Swal.fire({
                                                title: 'Failed!',
                                                text: 'There are products in the category, please change them before deleting.',
                                                icon: 'warning',
                                                confirmButtonText: 'OK',
                                            })
                                            break;
                                        default:
                                            categoriesJSON.splice(index, 1);
                                            renderTable();
                                            Swal.fire({
                                                title: 'Success!',
                                                icon: 'success',
                                                confirmButtonText: 'OK',
                                                allowOutsideClick: false,
                                                allowEscapeKey: false,
                                            })
                                    }
                                }
                            });
                        }
                    })
                }
            })
        }
        
        const confirmBtnAction = () => {
            confirmBtn = document.querySelector("#confirmBtn");
            confirmBtn.onclick = () => {
                let index = parseInt(confirmBtn.dataset.index);
                let row = categoryTable.rows[index+1];
                let newName = row.cells[1].querySelector("input").value;
                let newSlug = generateSlugByName(newName);
                categoriesJSON[index].name = newName;
                categoriesJSON[index].slug = newSlug;
                renderTable();
                $.ajax({
                    type:"post",
                    url:"/admin/category/edit",
                    data: 
                    {
                        id: categoriesJSON[index].id,
                        name: newName,
                        slug: newSlug
                    },
                    cache:false,
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
                        }
                    }
                });
            };
        }
        
        const cancelBtnAction = () => {
            cancelBtn = document.querySelector("#cancelBtn");
            cancelBtn.onclick = renderTable;
        }
        
        const renderTable = () => {
            categoryList.innerHTML = "";
            categoriesJSON.forEach((category, index) => {
                categoryList.innerHTML += `
                    <tr>
                        <td class="px-2">
                            <p>\${index + 1}</p>
                        </td>
                        <td class="px-2">
                            <p>\${category.name}</p>
                        </td>
                        <td class="px-2">
                            <div class="action">
                                <button type="button" title="Edit" class="text-success text-lg px-2 editBtn" data-index="\${index}">
                                    <i class="lni lni-pencil"></i>
                                </button>
                                <button type="button" title="Delete" class="text-danger text-lg px-2 deleteBtn" data-index="\${index}">
                                  <i class="lni lni-trash-can"></i>
                                </button>
                            </div>
                        </td>
                    </tr>
                `
            })
            
            editBtnsAction();
            deleteBtnsAction();
        }
        renderTable();
        
        let confirmNewCatBtn;
        let cancelNewCatBtn;
        newCategoryBtn.onclick = () => {
            renderTable();
            newCategoryBtn.disabled = true;
            categoryList.innerHTML += `
                <tr>
                    <td class="px-2">
                        <p>\${categoriesJSON.length + 1}</p>
                    </td>
                    <td class="px-2">
                        <input type="text" id="newCategory" class="form-control form-control-sm"/>
                    </td>
                    <td class="px-2">
                        <div class="action">
                            <button type="button" title="Confirm" id="confirmBtn" class="text-success text-lg px-2">
                                <i class="lni lni-checkmark"></i>
                            </button>
                            <button type="button" title="Cancel" id="cancelBtn" class="text-danger text-lg px-2">
                                <i class="lni lni-close"></i>
                            </button>
                        </div>
                    </td>
                </tr>
            `;
            confirmNewCatBtn = document.querySelector("#confirmBtn");
            cancelNewCatBtn = document.querySelector("#cancelBtn");
            
            confirmNewCatBtn.onclick = () => {
                const newCategory = document.querySelector("#newCategory");
                if(newCategory.value.length === 0) {
                    Swal.fire({
                        title: 'Category name empty!',
                        icon: 'warning',
                        confirmButtonText: 'OK'
                    })
                    return;
                }
                $.ajax({
                    type:"post",
                    url:"/admin/category/add",
                    data: 
                    {
                        name: newCategory.value,
                        slug: generateSlugByName(newCategory.value)
                    },
                    cache:false,
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
                                categoriesJSON.push({
                                    id: parseInt(response),
                                    name: newCategory.value,
                                    slug: generateSlugByName(newCategory.value)
                                })
                                renderTable();
                        }
                    }
                });
                newCategoryBtn.disabled = false;
            }
            
            cancelNewCatBtn.onclick = () => {
                newCategoryBtn.disabled = false;
                renderTable();
            }
            
        };
        const ctx2 = document.getElementById("Chart2").getContext("2d");
        const chart2 = new Chart(ctx2, {
            type: "bar",
            data: {
                labels: countsJSON.map(cat => cat.name),
                datasets: [
                    {
                        label: "",
                        backgroundColor: "#365CF5",
                        borderRadius: 30,
                        barThickness: 6,
                        maxBarThickness: 8,
                        data: countsJSON.map(cat => cat.count),
                    },
                ],
            },
            options: {
                indexAxis: 'y',
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
    </script>
</body>
</html>

