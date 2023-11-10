/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import com.google.gson.Gson;
import dao.CartDAO;
import dao.InvoiceDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import dao.ProductOrderDTO;
import dao.TransportUnitDAO;
import model.TransportUnit;
import model.User;

/**
 *
 * @author LiusDev
 */
public class CheckoutController extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
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
                ArrayList<ProductOrderDTO> validCartProduct = new ArrayList<>();
                for(ProductOrderDTO p : cartProducts) {
                    if(!p.isStorage() && !p.isVariantStorage()) {
                        validCartProduct.add(p);
                    }
                }
                ArrayList<TransportUnit> transportUnits = new TransportUnitDAO().getTransportUnits(10);
                String productsJSON = new Gson().toJson(validCartProduct);
                request.setAttribute("transportUnits", transportUnits);
                request.setAttribute("productsJSON", productsJSON);
                request.setAttribute("cartProducts", validCartProduct);
                request.getRequestDispatcher("checkout.jsp").forward(request, response);
            }
        }
    } 
    
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
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
                case "submit":
                    if(!isLogin) {
                        response.getWriter().print("Please login");
                    } else {
                        ArrayList<ProductOrderDTO> cartProducts = new CartDAO().getCartProductByUserId(currUser.getId());
                        ArrayList<ProductOrderDTO> validCartProduct = new ArrayList<>();
                        for(ProductOrderDTO p : cartProducts) {
                            if(!p.isStorage() && !p.isVariantStorage()) {
                                validCartProduct.add(p);
                            }
                        }
                        if(validCartProduct.isEmpty()) {
                            response.getWriter().print("Failed");
                            return;
                        }
                        String firstName = request.getParameter("firstName");
                        String lastName = request.getParameter("lastName");
                        String phone = request.getParameter("phone");
                        String email = request.getParameter("email");
                        int transportUnit;
                        try {
                            transportUnit = Integer.parseInt(request.getParameter("transportUnit"));
                        } catch (Exception e) {
                            transportUnit = 1;
                        }
                        String province = request.getParameter("province");
                        String district = request.getParameter("district");
                        String commune = request.getParameter("commune");
                        String address = request.getParameter("address");
                        String message = request.getParameter("message");
                        if(firstName.isEmpty() || lastName.isEmpty() || phone.isEmpty() || province.isEmpty() || district.isEmpty() || commune.isEmpty() || address.isEmpty()) {
                            response.getWriter().print("Fill info");
                            return;
                        }
                        String fullAdress = address + ", " + commune + ", " + district + ", " + province;
                        
                        long invoiceId = new InvoiceDAO().addInvoice(currUser.getId(), firstName, lastName, phone, email, fullAdress, transportUnit, message, validCartProduct);
                        
                    }
                    break;
                default:
                    processRequest(request, response);
            }
        }
    }

}
