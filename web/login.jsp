<%-- 
    Document   : login
    Created on : Sep 27, 2023, 11:14:38 PM
    Author     : LiusDev
--%>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    if(session.getAttribute("user") != null) response.sendRedirect("/");
%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login | ${initParam['webName']}</title>
        <script src="https://cdn.tailwindcss.com"></script>
        
        <!-- Font awesome 5 -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/js/all.min.js"></script>
    </head>
    <body class="bg-gray-100">
        <div class="min-h-screen flex items-center justify-center">
            <div class="bg-white w-96 max-w-[calc(100vw - 5rem)] px-8 py-10 rounded-2xl drop-shadow-xl flex flex-col gap-8">
                <a href="/">
                    <img src="https://bootstrap-ecommerce-web.netlify.app/images/logo.svg" alt="Logo" class="w-28" />
                </a>
                <div id="loginMessage" class="flex items-center py-3 px-4 bg-black/5 rounded-md border border-black/20 hidden">
                    <i class="fa-solid fa-triangle-exclamation mr-3 text-red-600"></i>
                    <p class="text-sm text-black/70"></p>
                </div>
                <div class="flex flex-col gap-1">
                    <h1 class="font-semibold text-xl leading-6">Login</h1>
                </div>
                <div class="flex flex-col gap-8">
                    <form id="loginForm" class="flex flex-col gap-4">
                        <div class="flex flex-col gap-2">
                            <div class="flex flex-col">
                                <div class="mb-1">
                                    <label
                                        for="email"
                                        class="text-sm leading-5 font-medium"
                                    >
                                        Email
                                    </label>
                                </div>
                                <input
                                    id="email"
                                    type="text"
                                    class="py-2 px-4 border border-black/20 rounded-md"
                                    name="email"
                                    required
                                />
                            </div>
                            <div class="flex flex-col">
                                <div class="mb-1">
                                    <label
                                        for="password"
                                        class="text-sm leading-5 font-medium"
                                    >
                                        Password
                                    </label>
                                </div>
                                <input
                                    id="password"
                                    type="password"
                                    class="py-2 px-4 border border-black/20 rounded-md mb-2"
                                    name="password"
                                    required
                                />
                                <div>
                                    <a
                                        href="/forgot-password"
                                        class="flex justify-end text-blue-600 hover:text-blue-700 transition-all text-sm"
                                    >
                                        Forgot password?
                                    </a>
                                </div>
                            </div>
                        </div>
                        <button
                            id="loginBtn"
                            type="button"
                            class="py-2 px-4 text-sm text-center bg-blue-600 hover:bg-blue-700 text-white flex items-center justify-center rounded-md transition-all duration-500 disabled:text-gray-600 disabled:bg-gray-300 disabled:hover:border-gray-300 disabled:cursor-not-allowed"
                        >
                            <span class="text-white font-semibold">
                                Login
                            </span>
                        </button>
                    </form>
                    <div class="text-sm flex items-center justify-center gap-1">
                        <span>Don't have account?</span>
                        <a
                            href="/register"
                            class="text-blue-600 hover:text-blue-700 transition-all"
                        >
                            Register now
                        </a>
                    </div>
                </div>
            </div>
        </div>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script>
            const loginBtn = document.querySelector("#loginBtn");
            const loginMessageBox = document.querySelector("#loginMessage");
            const loginMessage = loginMessageBox.querySelector("p");
            
            const email = document.querySelector("#email");
            const password = document.querySelector("#password");
            
            const inputs = [email, password];
            
            inputs.forEach((input) => {
                input.onchange = () => {
                    loginMessageBox.classList.add("hidden");
                }
            })
            
            const loadingChild =
                `<svg
                    class="animate-spin -ml-1 mr-3 h-5 w-5 text-white"
                    xmlns="http://www.w3.org/2000/svg"
                    fill="none"
                    viewBox="0 0 24 24"
                >
                    <circle
                        class="opacity-25"
                        cx="12"
                        cy="12"
                        r="10"
                        stroke="currentColor"
                        strokeWidth="4"
                    ></circle>
                    <path
                        class="opacity-75"
                        fill="currentColor"
                        d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
                    ></path>
                </svg>`;
            const setBtnLoading = (isLoading) => {
                if(isLoading) {
                    loginBtn.disabled = true;
                    loginBtn.innerHTML = loadingChild;
                } else {
                    loginBtn.disabled = false;
                    loginBtn.innerHTML = `<span class="text-white font-semibold">Login</span>`
                }
            }
            
            loginBtn.onclick = () => {
                setBtnLoading(true);
                $.ajax({
                    type:"post",
                    url:"/login",
                    data: {
                        email: email.value,
                        password: password.value,
                        redirect: (new URL(document.location)).searchParams.get("redirect")
                    },
                    cache: false,
                    success: function (response) {
                        switch(response) {
                            case "Logged":
                                window.open("/", "_self");
                                break;
                            case "Invalid email":
                                setBtnLoading(false);
                                loginMessageBox.classList.remove("hidden");
                                loginMessage.textContent = "Invalid email, please try again!";
                                break;
                            case "Invalid password":
                                setBtnLoading(false);
                                loginMessageBox.classList.remove("hidden");
                                loginMessage.textContent = "Incorrect password, please try again!";
                                break;
                            case "Banned":
                                setBtnLoading(false);
                                loginMessageBox.classList.remove("hidden");
                                loginMessage.textContent = "You have been banned by the administrator!";
                                break;
                            default:
                                window.open(response, "_self");
                        }
                    }
                });
            }
            window.addEventListener('keyup', function(event) {
                if (event.keyCode === 13) {
                    loginBtn.click();
                }
            });
        </script>
    </body>
</html>
