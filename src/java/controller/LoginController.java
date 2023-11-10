/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dao.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.mindrot.jbcrypt.BCrypt;
import model.User;

/**
 *
 * @author LiusDev
 */
public class LoginController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        HttpSession session = request.getSession();
        if(session.getAttribute("user") != null) {
            response.sendRedirect("/");
        } else {
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try (PrintWriter out = response.getWriter()) {
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            HttpSession session = request.getSession();
            if(session.getAttribute("user") != null) {
                response.getWriter().print("Logged");
            } else {
                String email = request.getParameter("email");
                String password = request.getParameter("password");
                String redirect = request.getParameter("redirect");
                User user = new UserDAO().getUserByEmail(email);

                if(user == null) {
                    request.getSession().setAttribute("user", null);
                    response.getWriter().print("Invalid email");
                    return;
                }

                if(!BCrypt.checkpw(password, user.getPassword())) {
                    request.getSession().setAttribute("user", null);
                    response.getWriter().print("Invalid password");
                    return;
                }
                
                if(user.isBanned()) {
                    request.getSession().setAttribute("user", null);
                    response.getWriter().print("Banned");
                    return;
                }

                request.getSession().setAttribute("user", user);
                if(!redirect.isEmpty()) {
                    response.getWriter().print(redirect);
                    return;
                }
                switch (user.getRole()) {
                    case "customer":
                        response.getWriter().print("/");
                        break;
                    case "admin":
                    case "staff":
                        response.getWriter().print("/admin");
                        break;
                    default:
                        response.getWriter().print("/");
                }
            }
        }
    }

}
