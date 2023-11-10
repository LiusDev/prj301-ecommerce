/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dao.ProductPreviewDTO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import dao.*;
import model.*;
/**
 *
 * @author LiusDev
 */
public class SearchController extends HttpServlet {
   
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
            String keyword = request.getParameter("keyword");
            String category = request.getParameter("category");
            String minPrice = request.getParameter("minPrice");
            String maxPrice = request.getParameter("maxPrice");
            String sortBy = request.getParameter("sortBy");
            String page = request.getParameter("page");
            
            int pageSize = 16;
            
            ArrayList<ProductPreviewDTO> productList = new ProductDAO().getFilterResults(keyword, category, minPrice, maxPrice, sortBy, page, Integer.toString(pageSize), false);
            int productCount = new ProductDAO().getFilterResultCount(keyword, category, minPrice, maxPrice);
            int totalPage = (int) Math.ceil((double) productCount/pageSize);
            ArrayList<Category> categories = new CategoryDAO().getAllCategories(6);
            
            if(keyword != null) request.setAttribute("keyword", keyword);
            
            request.setAttribute("products", productList);
            request.setAttribute("productCount", productCount);
            request.setAttribute("totalPage", totalPage);
            request.setAttribute("categories", categories);
            
            request.getRequestDispatcher("search.jsp").forward(request, response);
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
        processRequest(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
