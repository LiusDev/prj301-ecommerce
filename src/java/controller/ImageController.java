/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dao.ProductDAO;
import dao.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.ProductImage;

/**
 *
 * @author LiusDev
 */
public class ImageController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String path = request.getPathInfo().substring(1);
        String imageId = request.getParameter("id");
        switch(path) {
            case "product":
                ProductImage productImage = new ProductDAO().getProductImage(Integer.parseInt(imageId));
                response.getOutputStream().write(productImage.getImage());
                break;
            case "user":
                byte[] userImage = new UserDAO().getUserAvatar(Integer.parseInt(imageId));
                response.getOutputStream().write(userImage);
                break;
            default:
                break;
        }
    }

}
