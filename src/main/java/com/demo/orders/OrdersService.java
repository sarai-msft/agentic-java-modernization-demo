package com.demo.orders;

import com.demo.billing.BillingClient;
import java.math.BigDecimal;

/**
 * OrdersService depends on BillingClient interface - decoupled.
 */
public class OrdersService {

    private final BillingClient billingClient;

    public OrdersService(BillingClient billingClient) {
        this.billingClient = billingClient;
    }

    public String placeOrder(String orderId, BigDecimal amount) {
        System.out.println("OrdersService: placing order " + orderId + " for " + amount);
        String transactionId = billingClient.charge(orderId, amount);
        System.out.println("OrdersService: order " + orderId + " confirmed with transaction " + transactionId);
        return transactionId;
    }
}
