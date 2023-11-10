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
    <title>Transport | ${initParam['webName']}</title>

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
                <h2>Transport</h2>
                <button class="main-btn success-btn btn-hover d-flex align-items-center" id="newTransportBtn">
                    <i class="lni lni-plus"></i> <span>New transport unit</span>
                </button>
            </div>
            <!-- end row -->
          </div>
          <!-- ========== title-wrapper end ========== -->
          
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
                            <h6>Name</h6>
                          </th>
                          <th class="px-2">
                            <h6>Type</h6>
                          </th>
                          <th class="px-2">
                            <h6>Price</h6>
                          </th>
                          <th class="px-2">
                            <h6>Fastest shipping (days)</h6>
                          </th>
                          <th class="px-2">
                            <h6>Slowest shipping (days)</h6>
                          </th>
                          <th class="px-2">
                            <h6>Action</h6>
                          </th>
                        </tr>
                        <!-- end table row-->
                      </thead>
                      <tbody id="transportList"></tbody>
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
        const transportUnitsJSON = ${transportUnitsJSON};
        
        const transportTable = document.querySelector(".table");
        const transportList = document.querySelector("#transportList");
        
        let editBtns;
        let deleteBtns;
        let confirmBtn;
        let cancelBtns;
        
        const newTransportBtn = document.querySelector("#newTransportBtn");
        
        const editBtnsAction = () => {
            editBtns = Array.from(document.querySelectorAll(".editBtn"));
            editBtns.forEach((btn) => {
                btn.onclick = () => {
                    renderTable();
                    let index = parseInt(btn.dataset.index);
                    transportTable.rows[index+1].cells[1].innerHTML = `<input type="text" value="\${transportUnitsJSON[index].name}" class="form-control form-control-sm"/>`
                    transportTable.rows[index+1].cells[2].innerHTML = `
                        <select class="form-select d-inline-block w-auto" title="Transport Type" name="transportType" id="typeForm">
                            <option value="Normal delivery" \${transportUnitsJSON[index].type === 'Normal delivery' ? "selected" : ""}>Normal delivery</option>
                            <option value="Express delivery" \${transportUnitsJSON[index].type === 'Express delivery' ? "selected" : ""}>Express delivery</option>
                        </select>
                    `
                    transportTable.rows[index+1].cells[3].innerHTML = `<input type="number" value="\${transportUnitsJSON[index].price}" class="form-control form-control-sm"/>`
                    transportTable.rows[index+1].cells[4].innerHTML = `<input type="number" value="\${transportUnitsJSON[index].fastestShipping}" class="form-control form-control-sm"/>`
                    transportTable.rows[index+1].cells[5].innerHTML = `<input type="number" value="\${transportUnitsJSON[index].slowestShipping}" class="form-control form-control-sm"/>`
                    transportTable.rows[index+1].cells[6].innerHTML = `
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
                                url:"/admin/transport/delete",
                                data: 
                                {  
                                    "id": transportUnitsJSON[index].id
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
                                        default:
                                            transportUnitsJSON.splice(index, 1);
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
                let row = transportTable.rows[index+1];
                let newName = row.cells[1].querySelector("input").value;
                let newType = row.cells[2].querySelector("select").value;
                let newPrice = row.cells[3].querySelector("input").value;
                let newFastestShipping = row.cells[4].querySelector("input").value;
                let newSlowestShipping = row.cells[5].querySelector("input").value;
                
                transportUnitsJSON[index].name = newName;
                transportUnitsJSON[index].type = newType;
                transportUnitsJSON[index].price = parseInt(newPrice);
                transportUnitsJSON[index].fastestShipping = parseInt(newFastestShipping);
                transportUnitsJSON[index].slowestShipping = parseInt(newSlowestShipping);
                
                renderTable();
                $.ajax({
                    type:"post",
                    url:"/admin/transport/edit",
                    data: 
                    {
                        id: transportUnitsJSON[index].id,
                        name: newName,
                        type: newType,
                        price: newPrice,
                        fastestShipping: newFastestShipping,
                        slowestShipping: newSlowestShipping
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
            transportList.innerHTML = "";
            transportUnitsJSON.forEach((transportUnit, index) => {
                transportList.innerHTML += `
                    <tr>
                        <td class="px-2">
                            <p>\${index + 1}</p>
                        </td>
                        <td class="px-2">
                            <p>\${transportUnit.name}</p>
                        </td>
                        <td class="px-2">
                            <span class="status-btn \${transportUnit.type === "Normal delivery" ? "success-btn" : "danger-btn"}">\${transportUnit.type}</span>
                        </td>
                        <td class="px-2">
                            <p>\${Intl.NumberFormat("vi-VN", {
                                    style: "currency",
                                    currency: "VND"
                                }).format(transportUnit.price)}</p>
                        </td>
                        <td class="px-2">
                            <p>\${transportUnit.fastestShipping}</p>
                        </td>
                        <td class="px-2">
                            <p>\${transportUnit.slowestShipping}</p>
                        </td>
                        <td>
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
        
        let confirmNewTransBtn;
        let cancelNewTransBtn;
        newTransportBtn.onclick = () => {
            renderTable();
            newTransportBtn.disabled = true;
            transportList.innerHTML += `
                <tr>
                    <td class="px-2">
                        <p>\${transportUnitsJSON.length + 1}</p>
                    </td>
                    <td class="px-2">
                        <input type="text" id="newName" class="form-control form-control-sm"/>
                    </td>
                    <td class="px-2">
                        <select class="form-select d-inline-block w-auto" title="Transport Type" name="transportType" id="newType">
                            <option value="Normal delivery">Normal delivery</option>
                            <option value="Express delivery">Express delivery</option>
                        </select>
                    </td>
                    <td class="px-2">
                        <input type="number" id="newPrice" class="form-control form-control-sm"/>
                    </td>
                    <td class="px-2">
                        <input type="number" id="newFastestShipping" class="form-control form-control-sm"/>
                    </td>
                    <td class="px-2">
                        <input type="number" id="newSlowestShipping" class="form-control form-control-sm"/>
                    </td>
                    <td>
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
            `
            confirmNewCatBtn = document.querySelector("#confirmBtn");
            cancelNewCatBtn = document.querySelector("#cancelBtn");
            
            confirmNewCatBtn.onclick = () => {
                const newName = document.querySelector("#newName");
                const newType = document.querySelector("#newType");
                const newPrice = document.querySelector("#newPrice");
                const newFastestShipping = document.querySelector("#newFastestShipping");
                const newSlowestShipping = document.querySelector("#newSlowestShipping");

                if(newName.value.length === 0 || newType.value.length === 0 || newPrice.value.length === 0 || newFastestShipping.value.length === 0 || newSlowestShipping.value.length === 0) {
                    Swal.fire({
                        title: 'Fill info!',
                        icon: 'warning',
                        confirmButtonText: 'OK'
                    })
                    return;
                }
                $.ajax({
                    type:"post",
                    url:"/admin/transport/add",
                    data: 
                    {
                        name: newName.value,
                        type: newType.value,
                        price: newPrice.value,
                        fastestShipping: newFastestShipping.value,
                        slowestShipping: newSlowestShipping.value
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
                                transportUnitsJSON.push({
                                    id: parseInt(response),
                                    name: newName.value,
                                    type: newType.value,
                                    price: newPrice.value,
                                    fastestShipping: newFastestShipping.value,
                                    slowestShipping: newSlowestShipping.value
                                })
                                renderTable();
                        }
                    }
                });
                cancelNewCatBtn.disabled = false;
            }
            
            cancelNewCatBtn.onclick = () => {
                newTransportBtn.disabled = false;
                renderTable();
            }
        }
    </script>
  </body>
</html>

