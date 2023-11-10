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
        <title>Register | ${initParam['webName']}</title>
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
                <div id="registerMessage" class="flex items-center py-3 px-4 bg-black/5 rounded-md border border-black/20 hidden">
                    <i class="fa-solid fa-triangle-exclamation mr-3 text-red-600"></i>
                    <p class="text-sm text-black/70"></p>
                </div>
                <div class="flex flex-col gap-1">
                    <h1 class="font-semibold text-xl leading-6">Register</h1>
                </div>
                <div class="flex flex-col gap-8">
                    <form id="registerForm" class="flex flex-col gap-4">
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
                            </div>
                            <div class="grid grid-cols-2 gap-4">
                                <div class="flex flex-col col-span-1">
                                    <div class="mb-1">
                                        <label
                                            for="firstName"
                                            class="text-sm leading-5 font-medium"
                                        >
                                            First name
                                        </label>
                                    </div>
                                    <input
                                        id="firstName"
                                        type="text"
                                        class="py-2 px-4 border border-black/20 rounded-md"
                                        name="firstName"
                                        required
                                    />
                                </div>
                                <div class="flex flex-col col-span-1">
                                    <div class="mb-1">
                                        <label
                                            for="lastName"
                                            class="text-sm leading-5 font-medium"
                                        >
                                            Last name
                                        </label>
                                    </div>
                                    <input
                                        id="lastName"
                                        type="text"
                                        class="py-2 px-4 border border-black/20 rounded-md"
                                        name="lastName"
                                        required
                                    />
                                </div>
                            </div>
                        </div>
                        <button
                            id="registerBtn"
                            type="button"
                            class="py-2 px-4 text-sm text-center bg-blue-600 hover:bg-blue-700 text-white flex items-center justify-center rounded-md transition-all duration-500 disabled:text-gray-600 disabled:bg-gray-300 disabled:hover:border-gray-300 disabled:cursor-not-allowed"
                        >
                            <span class="text-white font-semibold">
                                Register
                            </span>
                        </button>
                    </form>
                    <div class="text-sm flex items-center justify-center gap-1">
                        <span>Have account?</span>
                        <a
                            href="/login"
                            class="text-blue-600 hover:text-blue-700 transition-all"
                        >
                            Login
                        </a>
                    </div>
                </div>
            </div>
        </div>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script>
            const registerBtn = document.querySelector("#registerBtn");
            const registerMessageBox = document.querySelector("#registerMessage");
            const registerMessage = registerMessageBox.querySelector("p");
            
            const email = document.querySelector("#email");
            const password = document.querySelector("#password");
            const firstName = document.querySelector("#firstName");
            const lastName = document.querySelector("#lastName");
            
            const inputs = [email, password, firstName, lastName];
            
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
                    registerBtn.disabled = true;
                    registerBtn.innerHTML = loadingChild;
                } else {
                    registerBtn.disabled = false;
                    registerBtn.innerHTML = `<span class="text-white font-semibold">Register</span>`
                }
            }
            
            registerBtn.onclick = () => {
                setBtnLoading(true);
                $.ajax({
                    type:"post",
                    url:"/register",
                    data: {
                        email: email.value,
                        password: password.value,
                        firstName: firstName.value,
                        lastName: lastName.value
                    },
                    cache: false,
                    success: function (response) {
                        switch(response) {
                            case "Logged":
                                window.open("/", "_self");
                                break;
                            case "Fill info":
                                setBtnLoading(false);
                                registerMessageBox.classList.remove("hidden");
                                registerMessage.textContent = "Please fill infomation!";
                                break;
                            case "Email exist":
                                setBtnLoading(false);
                                registerMessageBox.classList.remove("hidden");
                                registerMessage.textContent = "Email exist, please try another!";
                                break;
                            default:
                                window.open((new URL(document.location)).searchParams.get("redirect"), "_self");
                        }
                    }
                });
            }
            window.addEventListener('keyup', function(event) {
                if (event.keyCode === 13) {
                    registerBtn.click();
                }
            });
        </script>
    </body>
</html>
