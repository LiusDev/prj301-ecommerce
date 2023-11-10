/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

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
import model.User;
import org.mindrot.jbcrypt.BCrypt;

/**
 *
 * @author LiusDev
 */

@MultipartConfig(maxFileSize = 16177215)
public class UserController extends HttpServlet {
   
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            HttpSession session = request.getSession();
            if(session.getAttribute("user") == null) {
                String redirect = request.getRequestURI();
                response.sendRedirect("/login?redirect=" + redirect);
            } else {
                request.getRequestDispatcher("profile.jsp").forward(request, response);
            }
        }
    } 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            HttpSession session = request.getSession();
            User currUser = (User) session.getAttribute("user");
            boolean isLogin = currUser != null;
            String path = request.getPathInfo().substring(1);
            switch(path) {
                case "update":
                    if(!isLogin) {
                        response.getWriter().print("Please login");
                    } else {
                        String firstName = request.getParameter("firstName");
                        String lastName = request.getParameter("lastName");
                        String email = request.getParameter("email");
                        String bio = request.getParameter("bio");
                        Part filePart = request.getPart("avatar");
                        
                        User checkUser = new UserDAO().getUserByEmail(email);
                    
                        if(checkUser != null && !currUser.getEmail().equals(email)) {
                            out.print("Email exist");
                            return;
                        }
                        
                        InputStream avatar = null;
                        if(filePart.getSize() > 0) {
                            avatar = filePart.getInputStream();
                        } else {
                            avatar = null;
                        }
                        
                        String role = currUser.getRole();
                        new UserDAO().updateUserInfo(currUser.getId(), firstName, lastName, email, bio, role, avatar);
                        currUser.update(currUser.getId(), currUser.getCreatedAt(), firstName, lastName, email, currUser.getPassword(), bio, currUser.getRole());
                        request.getSession().setAttribute("user", currUser);
                    }
                    break;
                case "update-password":
                    if(!isLogin) {
                        response.getWriter().print("Please login");
                    } else {
                        String oldPassword = request.getParameter("oldPassword");
                        String newPassword = request.getParameter("newPassword");
                        String confirmPassword = request.getParameter("confirmPassword");
                        if(oldPassword.isEmpty() || newPassword.isEmpty() || confirmPassword.isEmpty()) {
                            response.getWriter().print("Fill info");
                            return;
                        }
                        if(!BCrypt.checkpw(oldPassword, currUser.getPassword())) {
                            response.getWriter().print("Wrong password");
                            return;
                        }
                        if(!newPassword.equals(confirmPassword)) {
                            response.getWriter().print("Password do not match");
                            return;
                        }
                        new UserDAO().updatePassword(currUser.getId(), BCrypt.hashpw(newPassword, BCrypt.gensalt(10)));
                        currUser.setPassword(BCrypt.hashpw(newPassword, BCrypt.gensalt(10)));
                        request.getSession().setAttribute("user", currUser);
                    }
                    break;
                default:
                    processRequest(request, response);
            }
        }
    }

}
