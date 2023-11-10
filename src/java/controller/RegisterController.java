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
import model.User;
import org.mindrot.jbcrypt.BCrypt;

/**
 *
 * @author LiusDev
 */
public class RegisterController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        HttpSession session = request.getSession();
        if(session.getAttribute("user") != null) {
            response.sendRedirect("/");
        } else {
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try (PrintWriter out = response.getWriter()) {
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            HttpSession session = request.getSession();
            if(session.getAttribute("user") != null) {
                out.print("Logged");
                return;
            }
            String email = request.getParameter("email");
            String rawPassword = request.getParameter("password");
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            
            if(email.isEmpty() || rawPassword.isEmpty() || firstName.isEmpty() || lastName.isEmpty()) {
                out.print("Fill info");
                return;
            }
            User checkUser = new UserDAO().getUserByEmail(email);
            if(checkUser != null) {
                out.print("Email exist");
                return;
            }
            
            String password = BCrypt.hashpw(rawPassword, BCrypt.gensalt(10));

            int newUserId = new UserDAO().register(email, password, firstName, lastName);

            User user = new User();
            user.update(newUserId, "", firstName, lastName, email, password, "", "customer");

            request.getSession().setAttribute("user", user);
        }
    }

}
