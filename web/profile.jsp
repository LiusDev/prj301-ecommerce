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
        <title>Profile | ${initParam['webName']}</title>

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
                        <div class="card p-3 mb-4">
                            <div class="card-body p-lg-4">
                                <h4 class="card-title mb-5">My profile</h4>
                                <form id="profileForm">
                                    <div class="row mb-5">
                                        <div class="col-lg-8" style="padding-right: 64px; border-right: 1px solid rgba(86, 86, 86, 0.12)">
                                            <div class="row">
                                                <dt class="col-xxl-3 col-lg-4 fw-normal text-muted">First name</dt>
                                                <dd class="col-xxl-9 col-lg-8">
                                                    <input name="firstName" type="text" class="form-control" placeholder="Frist name" value="${sessionScope.user.firstName}" required>
                                                </dd>
                                            </div>
                                            <div class="row">
                                                <dt class="col-xxl-3 col-lg-4 fw-normal text-muted">Last name</dt>
                                                <dd class="col-xxl-9 col-lg-8">
                                                    <input name="lastName" type="text" class="form-control" placeholder="Last name" value="${sessionScope.user.lastName}" required>
                                                </dd>
                                            </div>
                                            <div class="row">
                                                <dt class="col-xxl-3 col-lg-4 fw-normal text-muted">Email</dt>
                                                <dd class="col-xxl-9 col-lg-8">
                                                    <input name="email" type="text" class="form-control" placeholder="example@gmail.com" value="${sessionScope.user.email}" required>
                                                </dd>
                                            </div>
                                            <div class="row">
                                                <dt class="col-xxl-3 col-lg-4 fw-normal text-muted">Bio</dt>
                                                <dd class="col-xxl-9 col-lg-8">
                                                    <input name="bio" type="text" class="form-control" placeholder="Bio" value="${sessionScope.user.bio}" required>
                                                </dd>
                                            </div>
                                        </div>
                                        <div class="col-lg-4 d-flex flex-column align-items-center" style="padding-left: 64px">
                                            <img id="avatar" src="image/user?id=${sessionScope.user.id}" class="img-avatar me-2 mb-3" width="128" height="128" style="object-fit: cover" alt="${sessionScope.user.firstName}">
                                            <input name="avatar" type="file" class="form-control" id="avatarUpload" accept=".jpg, .png" style="width: 240px"/>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-lg-8 row">
                                            <dt class="col-xxl-3 col-lg-4 fw-normal text-muted"></dt>
                                            <dd class="col-xxl-9 col-lg-8">
                                                <button type="button" id="submitBtn" class="btn btn-success">Save</button>
                                            </dd>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                        <div class="card p-3">
                            <div class="card-body p-lg-4">
                                <h4 class="card-title mb-5">Update password</h4>
                                <form id="passwordForm">
                                    <div class="col-lg-8">
                                        <div class="row mb-5">
                                            <div class="row">
                                                <dt class="col-xxl-3 col-lg-4 fw-normal text-muted">Current password</dt>
                                                <dd class="col-xxl-9 col-lg-8">
                                                    <input name="oldPassword" type="password" class="form-control" required>
                                                </dd>
                                            </div>
                                            <div class="row">
                                                <dt class="col-xxl-3 col-lg-4 fw-normal text-muted">New password</dt>
                                                <dd class="col-xxl-9 col-lg-8">
                                                    <input name="newPassword" type="password" class="form-control" required>
                                                </dd>
                                            </div>
                                            <div class="row">
                                                <dt class="col-xxl-3 col-lg-4 fw-normal text-muted">Confirm password</dt>
                                                <dd class="col-xxl-9 col-lg-8">
                                                    <input name="confirmPassword" type="password" class="form-control" required>
                                                </dd>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <dt class="col-xxl-3 col-lg-4 fw-normal text-muted"></dt>
                                            <dd class="col-xxl-9 col-lg-8">
                                                <button type="button" id="submitPasswordBtn" class="btn btn-success">Save</button>
                                            </dd>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </main>
                </div>
            </div>
        </section>

        <%@include file="components/footerLink.html" %>

        <script>
            const avatar = document.querySelector("#avatar");
            const avatarUpload = document.querySelector("#avatarUpload");
            const submitBtn = document.querySelector("#submitBtn");

            avatarUpload.addEventListener('change', function (event) {
                const file = event.target.files[0];

                if (file) {
                    const reader = new FileReader();

                    reader.onload = function (e) {
                        avatar.src = e.target.result;
                    };

                    reader.readAsDataURL(file);
                }
            });

            submitBtn.onclick = () => {
                const profileForm = document.querySelector("#profileForm");
                let data = new FormData(profileForm);
                $.ajax({
                    type: "post",
                    url: "/user/update",
                    processData: false,
                    contentType: false,
                    enctype: "multipart/form-data",
                    data: data,
                    cache: false,
                    success: function (response)
                    {

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
                                })
                                break;
                            case "Fill info":
                                Swal.fire({
                                    title: 'Please fill info',
                                    icon: 'error',
                                    confirmButtonText: 'OK',
                                })
                                break;
                            case "Email exist":
                                Swal.fire({
                                    title: 'Email exist, please try another!',
                                    icon: 'error',
                                    confirmButtonText: 'OK',
                                })
                                break;
                            default:
                                Swal.fire({
                                    title: 'Update infomation successfully',
                                    icon: 'success',
                                    confirmButtonText: 'OK',
                                    allowOutsideClick: false,
                                    allowEscapeKey: false,
                                }).then((result) => {
                                    if (result.isConfirmed) {
                                        location.reload();
                                    }
                                })

                        }
                    }
                });
            }

            const submitPasswordBtn = document.querySelector("#submitPasswordBtn");
            submitPasswordBtn.onclick = () => {
                const passwordForm = document.querySelector("#passwordForm");
                var data = new FormData(passwordForm);
                $.ajax({
                    type: "post",
                    processData: false,
                    contentType: false,
                    url: "/user/update-password",
                    enctype: "multipart/form-data",
                    data: data,
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
                                });
                                break;
                            case "Fill info":
                                Swal.fire({
                                    title: 'Please fill info',
                                    icon: 'error',
                                    confirmButtonText: 'OK',
                                })
                                break;
                            case "Wrong password":
                                Swal.fire({
                                    title: 'Wrong password!',
                                    icon: 'error',
                                    confirmButtonText: 'OK'
                                });
                                break;
                            case "Password do not match":
                                Swal.fire({
                                    title: 'Password do not match!',
                                    icon: 'warning',
                                    confirmButtonText: 'OK'
                                });
                                break;
                            default:
                                Swal.fire({
                                    title: 'Update infomation successfully',
                                    icon: 'success',
                                    confirmButtonText: 'OK',
                                    allowOutsideClick: false,
                                    allowEscapeKey: false,
                                }).then((result) => {
                                    if (result.isConfirmed) {
                                        location.reload();
                                    }
                                })

                        }
                    }
                });
            }
        </script>
    </body>
</html>
