/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import dao.ProductDAO;
import dao.ProductOrderDTO;
import jakarta.websocket.OnClose;
import jakarta.websocket.OnError;
import jakarta.websocket.OnMessage;
import jakarta.websocket.OnOpen;
import jakarta.websocket.Session;
import jakarta.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;
import model.Product;
import model.ProductVariant;

/**
 *
 * @author LiusDev
 */
@ServerEndpoint("/product-quantity")
public class ProductEndpoint {

    static Set<Session> users = Collections.synchronizedSet(new HashSet<>());

    @OnOpen
    public void handleOpen(Session session) {
        users.add(session);
    }

    @OnMessage
    public void handleMessage(String message, Session userSession) throws IOException {
//        String userEmail = (String) userSession.getUserProperties().get("userEmail");
        String productVariantsJSON = message;
        
        Type variantType = new TypeToken<ArrayList<ProductOrderDTO>>(){}.getType();
        ArrayList<ProductOrderDTO> productVariants = new Gson().fromJson(productVariantsJSON, variantType);
        
        ArrayList<Product> updateProducts = new ArrayList<>();
        
        for(ProductOrderDTO p : productVariants) {
            Product updateProduct = new ProductDAO().getProductById(p.getProductId());
            for(ProductVariant v : updateProduct.getVariants()) {
                if(v.getId() == p.getProductVariantId()) {
                    v.setQuantity(p.getMaxQuantity() - p.getCartQuantity());
                    v.setSoldQuantity(p.getSoldQuantity() + p.getCartQuantity());
                }
            }
            updateProducts.add(updateProduct);
        }
        
        String updateProductsJSON = new Gson().toJson(updateProducts);
        
        for (Session session : users) {
            session.getBasicRemote().sendText(updateProductsJSON);
        }
    }

    @OnClose
    public void handleClose(Session session) {
        users.remove(session);
    }

    @OnError
    public void handleError(Throwable t) {
        t.printStackTrace();
    }
    
}
