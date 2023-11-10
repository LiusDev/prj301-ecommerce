/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import com.google.gson.Gson;
import dao.CartDAO;
import dao.ProductOrderDTO;
import dao.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.InputStream;
import java.util.ArrayList;
import model.User;
import org.mindrot.jbcrypt.BCrypt;

/**
 *
 * @author LiusDev
 */
@MultipartConfig(maxFileSize = 16177215)
public class ManageAccountController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            String keyword = request.getParameter("keyword");
            String role = request.getParameter("role");
            String status = request.getParameter("status");
            
            if(role != null && !role.equals("customer") && !role.equals("staff") && !role.equals("admin")) {
                role = null;
            }
            if(status != null ){
                switch (status) {
                    case "active":
                        status = "0";
                        break;
                    case "banned":
                        status = "1";
                        break;
                    default:
                        status = null;
                }
            }
            
            ArrayList<User> allUser = new UserDAO().getAllUser(null, keyword, role, status);
            
            request.setAttribute("allUser", allUser);
            
            request.getRequestDispatcher("account.jsp").forward(request, response);
            
        }
    } 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            HttpSession session = request.getSession();
            User currUser = (User) session.getAttribute("user");
            String redirect = request.getRequestURI();
            String params = request.getQueryString();
            if(currUser == null) {
                response.sendRedirect("/login?redirect=" + redirect + (params != null ? ("?" + params) : ""));
                return;
            }
            if(!currUser.getRole().equals("admin")) {
                request.getRequestDispatcher("/noPermission.jsp").forward(request, response);
                return;
            }
            String path = request.getPathInfo();
            
            if(path != null && !path.equals("/")){
                switch (path.substring(1)) {
                    case "new":
                        request.getRequestDispatcher("/admin/newAccount.jsp").forward(request, response);
                        break;
                    case "update":
                        String userId = request.getParameter("id");
                        if(userId == null || userId.isEmpty()) {
                            response.sendRedirect("/admin/account");
                            return;
                        };
                        User user = new UserDAO().getUserById(Integer.parseInt(userId));
                        String userJSON = new Gson().toJson(user);
                        
                        request.setAttribute("user", user);
                        request.setAttribute("userJSON", userJSON);
                        
                        ArrayList<ProductOrderDTO> cartProducts = new CartDAO().getCartProductByUserId(Integer.parseInt(userId));
                        request.getSession().setAttribute("cartProducts", cartProducts);
                        request.setAttribute("cartProducts", cartProducts);
                        
                        request.getRequestDispatcher("/admin/updateAccount.jsp").forward(request, response);
                        break;
                    default:
                        request.getRequestDispatcher("/errorPage.jsp").forward(request, response);
                }
            } else {
                processRequest(request, response);
            }
        }
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            HttpSession session = request.getSession();
            User currUser = (User) session.getAttribute("user");
            if(currUser == null) {
                out.print("Please login");
                return;
            };
            if(!currUser.getRole().equals("admin")) {
                out.print("No Permission");
                return;
            }
            String path = request.getPathInfo().substring(1);
            
            String id = null;
            String firstName = null;
            String lastName = null;
            String email = null;
            String rawPassword = null;
            String bio = null;
            Part filePart = null;
            String role = null;
            String status = null;
            int statusId = 0;
            
            InputStream avatar = null;
            
            User oldUser;
            User checkUser;
            
            switch (path) {
                case "new":
                    firstName = request.getParameter("firstName");
                    lastName = request.getParameter("lastName");
                    email = request.getParameter("email");
                    rawPassword = request.getParameter("password");
                    bio = request.getParameter("bio");
                    filePart = request.getPart("avatar");
                    role = request.getParameter("role");
                    status = request.getParameter("status");
                    statusId = status.equals("banned") ? 1 : 0;
                    
                    checkUser = new UserDAO().getUserByEmail(email);
                    if(checkUser != null) {
                        out.print("Email exist");
                        return;
                    }
                    
                    String password = BCrypt.hashpw(rawPassword, BCrypt.gensalt(10));
                    
                    avatar = null;
                    if(filePart.getSize() > 0) {
                        avatar = filePart.getInputStream();
                    } else {
                        avatar = null;
                    }
                    new UserDAO().newUser(firstName, lastName, email, password, bio, avatar, role, statusId);
                    out.print("Ping");
                    break;
                case "reset-password":
                    id = request.getParameter("id");
                    new UserDAO().resetDefaultPassword(Integer.parseInt(id));
                    break;
                case "update":
                    id = request.getParameter("id");
                    firstName = request.getParameter("firstName");
                    lastName = request.getParameter("lastName");
                    email = request.getParameter("email");
                    bio = request.getParameter("bio");
                    filePart = request.getPart("avatar");
                    role = request.getParameter("role");
                    status = request.getParameter("status");
                    statusId = status.equals("banned") ? 1 : 0;
                    
                    oldUser = new UserDAO().getUserById(Integer.parseInt(id));
                    checkUser = new UserDAO().getUserByEmail(email);
                    
                    if(checkUser != null && !oldUser.getEmail().equals(email)) {
                        out.print("Email exist");
                        return;
                    }
                    
                    avatar = null;
                    if(filePart.getSize() > 0) {
                        avatar = filePart.getInputStream();
                    } else {
                        avatar = null;
                    }
                    
                    new UserDAO().updateUserInfo(Integer.parseInt(id), firstName, lastName, email, bio, role, avatar);
                    
                    new UserDAO().updateUserStatus(Integer.parseInt(id), statusId);
                    
                    if(currUser.getId() == Integer.parseInt(id)){
                        currUser.update(currUser.getId(), currUser.getCreatedAt(), firstName, lastName, email, currUser.getPassword(), bio, role);
                        request.getSession().setAttribute("user", currUser);
                    }
                    break;
                case "delete":
                    id = request.getParameter("id");
                    new UserDAO().deleteUser(Integer.parseInt(id));
                    break;
                default:
                    throw new AssertionError();
            }
        }
    }

}
