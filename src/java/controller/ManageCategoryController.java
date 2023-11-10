/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import com.google.gson.Gson;
import dao.CategoryDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import model.Category;
import model.User;

/**
 *
 * @author LiusDev
 */
public class ManageCategoryController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            request.getRequestDispatcher("category.jsp").forward(request, response);
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
            if(currUser == null) {
                response.sendRedirect("/login?redirect=" + redirect);
                return;
            }
            if(!currUser.getRole().equals("admin") && !currUser.getRole().equals("staff")) {
                request.getRequestDispatcher("/noPermission.jsp").forward(request, response);
                return;
            }
            ArrayList<Category> categoryList = new CategoryDAO().getAllCategories(1000);
            request.setAttribute("categories", categoryList);
            String categoriesJSON = new Gson().toJson(categoryList);
            request.setAttribute("categoriesJSON", categoriesJSON);
            
            HashMap<Category, Integer> counts = new CategoryDAO().getProductCountByCategories(1000);
            
            request.setAttribute("counts", counts);
            String countsJSON = "[";
            for(Map.Entry<Category, Integer> entry : counts.entrySet()) {
                countsJSON +=   "{\n" +
                                "    \"id\": " + entry.getKey().getId() + ",\n" +
                                "    \"name\":\"" + entry.getKey().getName() + "\",\n" +
                                "    \"count\":" + entry.getValue() + "\n" +
                                "},\n";
            }
            countsJSON +=   "]";
            request.setAttribute("countsJSON", countsJSON);
            
            processRequest(request, response);
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
            int id;
            String name;
            String slug;
            switch (path) {
                case "add":
                    name = request.getParameter("name");
                    slug = request.getParameter("slug");
                    
                    int newId = new CategoryDAO().addCategory(name, slug);
                    out.print(newId);
                    break;
                case "edit":
                    id = Integer.parseInt(request.getParameter("id"));
                    name = request.getParameter("name");
                    slug = request.getParameter("slug");
                    
                    new CategoryDAO().updateCategory(id, name, slug);
                    break;
                case "delete":
                    id = Integer.parseInt(request.getParameter("id"));
                    HashMap<Category, Integer> counts = new CategoryDAO().getProductCountByCategories(1000);
                    for(Map.Entry<Category, Integer> entry : counts.entrySet()) {
                        if(entry.getKey().getId() == id && entry.getValue() > 0) {
                            out.print("Rest product");
                            return;
                        }
                    }
                    new CategoryDAO().deleteCategory(id);
                    break;
                default:
            }
        }
    }
}
