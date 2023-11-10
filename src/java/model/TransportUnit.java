/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author LiusDev
 */
public class TransportUnit {
    private int id;
    private String createdAt;
    private String name;
    private String type;
    private int price;
    private int fastestShipping;
    private int slowestShipping;

    public TransportUnit(int id, String createdAt, String name, String type, int price, int fastestShipping, int slowestShipping) {
        this.id = id;
        this.createdAt = createdAt;
        this.name = name;
        this.type = type;
        this.price = price;
        this.fastestShipping = fastestShipping;
        this.slowestShipping = slowestShipping;
    }

    public TransportUnit() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }

    public int getFastestShipping() {
        return fastestShipping;
    }

    public void setFastestShipping(int fastestShipping) {
        this.fastestShipping = fastestShipping;
    }

    public int getSlowestShipping() {
        return slowestShipping;
    }

    public void setSlowestShipping(int slowestShipping) {
        this.slowestShipping = slowestShipping;
    }
    
    
}
