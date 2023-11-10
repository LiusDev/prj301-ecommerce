/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import com.google.gson.Gson;
import dao.CategoryDAO;
import dao.ProductDAO;
import dao.ProductPreviewDTO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.lang.reflect.Type;
import com.google.gson.reflect.TypeToken;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.Part;
import model.Category;
import model.Product;
import model.ProductImage;
import model.ProductOption;
import model.ProductVariant;
import model.User;
import util.InputStreamHelper;

/**
 *
 * @author LiusDev
 */
@MultipartConfig(maxFileSize = 16177215)
public class ManageProductController extends HttpServlet {
   
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
            /* TODO output your page here. You may use following sample code. */
            
            String keyword = request.getParameter("keyword");
            String category = request.getParameter("category");
            String minPrice = request.getParameter("minPrice");
            String maxPrice = request.getParameter("maxPrice");
            String sortBy = request.getParameter("sortBy");
            String page = request.getParameter("page");
            
            if(category != null && category.equals("default")) category = null;
            int pageSize = 20;
            
            ArrayList<ProductPreviewDTO> productList = new ProductDAO().getFilterResults(keyword, category, minPrice, maxPrice, sortBy, page, Integer.toString(pageSize), true);
            int productCount = new ProductDAO().getFilterResultCount(keyword, category, minPrice, maxPrice);
            int totalPage = (int) Math.ceil((double) productCount/pageSize);
            
//            if(keyword != null) request.setAttribute("keyword", keyword);
            
            request.setAttribute("products", productList);
            request.setAttribute("productCount", productCount);
            request.setAttribute("totalPage", totalPage);
            request.setAttribute("categories", request.getAttribute("categories"));
            
            request.getRequestDispatcher("product.jsp").forward(request, response);
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
            
            ArrayList<Category> categories = new CategoryDAO().getAllCategories(1000);
            request.setAttribute("categories", categories);
            if(path != null && !path.equals("/")){
                switch (path.substring(1)) {
                    case "add":
                        request.getRequestDispatcher("/admin/addProduct.jsp").forward(request, response);
                        break;
                    case "update":
                        String productId = request.getParameter("id");
                        if(productId == null || productId.isEmpty()) {
                            response.sendRedirect("/admin/product");
                            return;
                        };
                        Product product = new ProductDAO().getProductById(Integer.parseInt(productId));
                        String productJSON = new Gson().toJson(product);
                        
                        request.setAttribute("product", product);
                        request.setAttribute("productJSON", productJSON);
                        request.getRequestDispatcher("/admin/updateProduct.jsp").forward(request, response);
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
            String productId;
            String name;
            String slug;
            String description;
            String categoryId;
            ArrayList<ProductImage> images;
            Type optionsType = new TypeToken<ArrayList<ProductOption>>(){}.getType();
            ArrayList<ProductOption> options;
            Type variantsType = new TypeToken<ArrayList<ProductVariant>>(){}.getType();
            ArrayList<ProductVariant> variants;
            Product product;
            switch (path) {
                case "add":
                    name = request.getParameter("name");
                    slug = request.getParameter("slug");
                    description = request.getParameter("description");
                    categoryId = request.getParameter("category");
                    
                    images = new ArrayList<>();
                    for(Part part : request.getParts()) {
                        if(part.getName().equals("images")) {
                            ProductImage image = new ProductImage();
                            image.setImage(new InputStreamHelper().readAllBytes(part.getInputStream()));
                            image.setAlt(slug);
                            images.add(image);
                        };
                    }
                    
                    
                    options = new Gson().fromJson(request.getParameter("options"), optionsType);
                    
                    variants = new Gson().fromJson(request.getParameter("variants"), variantsType);
                    
                    if(name.isEmpty() || slug.isEmpty() || categoryId.isEmpty() || images.size() == 0 || variants.size() == 0) {
                        out.print("Fill info");
                        return;
                    }
                    
                    product = new Product();
                    product.setName(name);
                    product.setSlug(slug);
                    product.setDescription(description);
                    product.setCategory(new CategoryDAO().getCategoryById(Integer.parseInt(categoryId)));
                    product.setImages(images);
                    product.setOptions(options);
                    product.setVariants(variants);
                    
                    new ProductDAO().addProduct(product);
                    break;
                case "delete":
                    String removeSlug = request.getParameter("slug");
                    new ProductDAO().removeProduct(removeSlug);
                    break;
                case "update":
                    productId = request.getParameter("id");
                    Product oldProduct = new ProductDAO().getProductById(Integer.parseInt(productId));
                    
                    name = request.getParameter("name");
                    slug = request.getParameter("slug");
                    description = request.getParameter("description");
                    categoryId = request.getParameter("category");
                    
                    images = new ArrayList<>();
                    for(Part part : request.getParts()) {
                        if(part.getName().equals("images")) {
                            ProductImage image = new ProductImage();
                            image.setImage(new InputStreamHelper().readAllBytes(part.getInputStream()));
                            image.setAlt(slug);
                            images.add(image);
                        };
                    }

                    options = new Gson().fromJson(request.getParameter("options"), optionsType);

                    variants = new Gson().fromJson(request.getParameter("variants"), variantsType);
                    
                    if(name.isEmpty() || categoryId.isEmpty() || images.size() == 0 || variants.size() == 0) {
                        out.print("Fill info");
                        return;
                    }
                    
                    product = new Product();
                    product.setName(name);
                    product.setDescription(description);
                    product.setCategory(new CategoryDAO().getCategoryById(Integer.parseInt(categoryId)));
                    product.setImages(images);
                    product.setOptions(options);
                    product.setVariants(variants);
                    
                    new ProductDAO().updateProduct(Integer.parseInt(productId), oldProduct, product);
                    break;
                default:
                    throw new AssertionError();
            }
        }
    }

}
