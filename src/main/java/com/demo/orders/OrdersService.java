package com.demo.orders;

import com.demo.billing.BillingClient;
import com.demo.billing.BillingService;
import java.math.BigDecimal;
import java.util.Objects;

/**
 * Coordinates order placement with billing.
 */
public class OrdersService {

    private final BillingClient billingClient;

    public OrdersService() {
        this(new BillingService());
    }

    public OrdersService(BillingClient billingClient) {
        this.billingClient = Objects.requireNonNull(billingClient, "billingClient");
    }

    public String placeOrder(String orderId, BigDecimal amount) {
        System.out.println("OrdersService: placing order " + orderId + " for " + amount);
        String transactionId = billingClient.charge(orderId, amount);
        System.out.println("OrdersService: order " + orderId + " confirmed with transaction " + transactionId);
        return transactionId;
    }
}
