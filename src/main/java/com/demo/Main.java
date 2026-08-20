package com.demo;

import com.demo.billing.BillingService;
import com.demo.orders.OrdersService;
import java.math.BigDecimal;

public class Main {
    public static void main(String[] args) {
        System.out.println("=== Orders Billing Monolith ===");
        System.out.println();

        OrdersService orders = new OrdersService(new BillingService());
        orders.placeOrder("ORD-1001", new BigDecimal("249.99"));
        orders.placeOrder("ORD-1002", new BigDecimal("89.50"));

        System.out.println();
        System.out.println("All orders processed.");
    }
}
