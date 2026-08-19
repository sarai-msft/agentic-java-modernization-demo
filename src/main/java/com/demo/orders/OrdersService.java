package com.demo.orders;

import com.demo.billing.BillingClient;
import com.demo.billing.BillingService;
import java.math.BigDecimal;

/**
 * OrdersService uses BillingClient interface - decoupled via constructor injection.
 */
public class OrdersService {

    private final BillingClient billingClient;

    public OrdersService() {
        this(new BillingService());
    }

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
