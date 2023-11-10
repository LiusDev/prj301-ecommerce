/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import com.google.gson.Gson;
import dao.CartDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import dao.ProductOrderDTO;
import model.User;

public class CartController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            HttpSession session = request.getSession();
            User currUser = (User) session.getAttribute("user");
            if(currUser == null) {
                String redirect = request.getRequestURI();
                response.sendRedirect("login?redirect=" + redirect);
            } else {
                response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
                ArrayList<ProductOrderDTO> cartProducts = new CartDAO().getCartProductByUserId(currUser.getId());
                request.getSession().setAttribute("cartProducts", cartProducts);
                String productsJSON = new Gson().toJson(cartProducts);
                request.setAttribute("productsJSON", productsJSON);
                request.setAttribute("cartProducts", cartProducts);
                request.getRequestDispatcher("cart.jsp").forward(request, response);
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
        HttpSession session = request.getSession();
        User currUser = (User) session.getAttribute("user");
        boolean isLogin = currUser != null;
        String path = request.getPathInfo().substring(1);
        
        switch(path) {
            case "add":
                if(!isLogin) {
                    response.getWriter().print("Please login");
                } else {
                    String productVariantId = request.getParameter("productVariantId");
                    String quantity = request.getParameter("quantity");
                    new CartDAO().addToCart(currUser.getId(), Integer.parseInt(productVariantId), Integer.parseInt(quantity));
                }
                break;
            case "update-quantity":
                if(!isLogin) {
                    response.sendRedirect("login");
                } else {
                    String productVariantId = request.getParameter("productVariantId");
                    String quantity = request.getParameter("quantity");
                    new CartDAO().updateCartQuantity(currUser.getId(), Integer.parseInt(productVariantId), Integer.parseInt(quantity));
                }
                break;
            case "delete":
                if(!isLogin) {
                    response.sendRedirect("login");
                } else {
                    String productVariantId = request.getParameter("productVariantId");
                    new CartDAO().deleteCartItem(currUser.getId(), Integer.parseInt(productVariantId));
                }
                break;
            default:
                processRequest(request, response);
        }
    }

}
