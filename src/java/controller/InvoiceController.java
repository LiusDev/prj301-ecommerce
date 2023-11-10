/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import com.google.gson.Gson;
import dao.InvoiceDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import model.Invoice;
import model.User;

/**
 *
 * @author LiusDev
 */
public class InvoiceController extends HttpServlet {
   
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
                response.sendRedirect("/login?redirect=" + redirect);
                return;
            }
            String invoiceId = request.getParameter("id");
            if(invoiceId != null) {
                try {
                    int invoiceIdInt = Integer.parseInt(invoiceId);
                    Invoice invoice = new InvoiceDAO().getInvoice(currUser.getId(), invoiceIdInt);
                    String invoiceJson = new Gson().toJson(invoice);
                    request.setAttribute("invoice", invoice);
                    request.setAttribute("invoiceJson", invoiceJson);
                    request.getRequestDispatcher("invoiceDetail.jsp").forward(request, response);
                } catch (Exception e) {
                }
                return;
            }
            ArrayList<Invoice> invoices = new InvoiceDAO().getInvoices(currUser.getId(), null, null, null, null);
            String invoicesJson = new Gson().toJson(invoices);
            request.setAttribute("invoices", invoices);
            request.setAttribute("invoicesJson", invoicesJson);
            request.getRequestDispatcher("invoice.jsp").forward(request, response);
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
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
        HttpSession session = request.getSession();
        User currUser = (User) session.getAttribute("user");
        boolean isLogin = currUser != null;
        String path = request.getPathInfo().substring(1);
        
        switch(path) {
            case "cancel":
                if(!isLogin) {
                    response.getWriter().print("Please login");
                } else {
                    String invoiceId = request.getParameter("invoiceId");
                    response.getWriter().print(invoiceId);
                    new InvoiceDAO().userCancelOrder(currUser.getId(), Integer.parseInt(invoiceId));
                }
                break;
            default:
                processRequest(request, response);
        }
    }
}
