/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import com.google.gson.Gson;
import dao.InvoiceDAO;
import dao.ProductDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import model.Invoice;
import model.Product;
import model.User;

/**
 *
 * @author LiusDev
 */
public class ManageInvoiceController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            
            String keyword = request.getParameter("keyword");
            String paymentStatus = request.getParameter("paymentStatus");
            String status = request.getParameter("status");
            
            String paymentStatusId = null;
            if (paymentStatus != null) {
                switch (paymentStatus) {
                    case "unpaid":
                        paymentStatusId = "0";
                        break;
                    case "paid":
                        paymentStatusId = "1";
                        break;
                }
            }
            
            String statusId = null;
            String userCanceledId = null;
            if(status != null) {
                switch (status) {
                    case "canceledUser":
                        statusId = "1";
                        userCanceledId = "1";
                        break;
                    case "canceledAdmin":
                        statusId = "1";
                        userCanceledId = "0";
                        break;
                    case "pending":
                        statusId = "2";
                        break;
                    case "approved":
                        statusId = "3";
                        break;
                    case "shipping":
                        statusId = "4";
                        break;
                    case "received":
                        statusId = "5";
                        break;
                    default:
                        statusId = null;
                        userCanceledId = null;
                }
            }
            
            ArrayList<Invoice> invoices = new InvoiceDAO().getInvoices(null, keyword, paymentStatusId, statusId, userCanceledId);
            
            request.setAttribute("invoices", invoices);
            
            request.getRequestDispatcher("invoice.jsp").forward(request, response);
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
            if(!currUser.getRole().equals("admin") && !currUser.getRole().equals("staff")) {
                request.getRequestDispatcher("/noPermission.jsp").forward(request, response);
                return;
            }
            String path = request.getPathInfo();
            
            if(path != null && !path.equals("/")){
                switch (path.substring(1)) {
                    case "detail":
                        String invoiceId = request.getParameter("id");
                        if(invoiceId == null || invoiceId.isEmpty()) {
                            response.sendRedirect("/admin/invoice");
                            return;
                        };
                        Invoice invoice = new InvoiceDAO().getInvoice(null, Integer.parseInt(invoiceId));
                        String invoiceJSON = new Gson().toJson(invoice);
                        
                        request.setAttribute("invoice", invoice);
                        request.setAttribute("invoiceJSON", invoiceJSON);
                        request.getRequestDispatcher("/admin/invoiceDetail.jsp").forward(request, response);
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
            if(!currUser.getRole().equals("admin") && !currUser.getRole().equals("staff")) {
                out.print("No Permission");
                return;
            }
            String path = request.getPathInfo().substring(1);
            
            String id = null;
            String paymentStatus = null;
            String status = null;
            switch (path) {
                case "update":
                    id = request.getParameter("id");
                    paymentStatus = request.getParameter("paymentStatus");
                    status = request.getParameter("status");
                    
                    if(id == null || paymentStatus == null || status == null) {
                        out.print("Failed");
                        return;
                    }
                    
                    int paymentStatusId = 0;
                    switch (paymentStatus) {
                        case "unpaid":
                            paymentStatusId = 0;
                            break;
                        case "paid":
                            paymentStatusId = 1;
                            break;
                    }
                    new InvoiceDAO().updatePaymentStatus(Integer.parseInt(id), paymentStatusId);
                    
                    int statusId = 2;
                    switch (status) {
                        case "canceled":
                            statusId = 1;
                            break;
                        case "pending":
                            statusId = 2;
                            break;
                        case "approved":
                            statusId = 3;
                            break;
                        case "shipping":
                            statusId = 4;
                            break;
                        case "received":
                            statusId = 5;
                            break;
                    }
                    new InvoiceDAO().updateStatus(Integer.parseInt(id), statusId);
                    break;
                default:
                    throw new AssertionError();
            }
        }
    }
}
