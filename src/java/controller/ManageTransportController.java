/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import com.google.gson.Gson;
import dao.CategoryDAO;
import dao.TransportUnitDAO;
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
import model.TransportUnit;
import model.User;

/**
 *
 * @author LiusDev
 */
public class ManageTransportController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            request.getRequestDispatcher("transport.jsp").forward(request, response);
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
            ArrayList<TransportUnit> transportUnits = new TransportUnitDAO().getTransportUnits(1000);
            request.setAttribute("transportUnits", transportUnits);
            String transportUnitsJSON = new Gson().toJson(transportUnits);
            request.setAttribute("transportUnitsJSON", transportUnitsJSON);
            
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
            
            int id;
            String name;
            String type;
            int price;
            int fastestShipping;
            int slowestShipping;

            String path = request.getPathInfo().substring(1);
            switch (path) {
                case "add":
                    name = request.getParameter("name");
                    type = request.getParameter("type");
                    price = Integer.parseInt(request.getParameter("price"));
                    fastestShipping = Integer.parseInt(request.getParameter("fastestShipping"));
                    slowestShipping = Integer.parseInt(request.getParameter("slowestShipping"));
                    
                    int newId = new TransportUnitDAO().addTransportUnit(name, type, price, fastestShipping, slowestShipping);
                    out.print(newId);
                    break;
                case "edit":
                    id = Integer.parseInt(request.getParameter("id"));
                    name = request.getParameter("name");
                    type = request.getParameter("type");
                    price = Integer.parseInt(request.getParameter("price"));
                    fastestShipping = Integer.parseInt(request.getParameter("fastestShipping"));
                    slowestShipping = Integer.parseInt(request.getParameter("slowestShipping"));
                    
                    new TransportUnitDAO().updateTransportUnit(id, name, type, price, fastestShipping, slowestShipping);
                    break;
                case "delete":
                    id = Integer.parseInt(request.getParameter("id"));
                    new TransportUnitDAO().deleteTransportUnit(id);
                    break;
                default:
            }
        }
    }

}
