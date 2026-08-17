package com.demo.orders;

import com.demo.billing.BillingService;
import java.math.BigDecimal;

/**
 * OrdersService directly calls BillingService - tight coupling.
 */
public class OrdersService {

    private final BillingService billingService = new BillingService();

    public String placeOrder(String orderId, BigDecimal amount) {
        System.out.println("OrdersService: placing order " + orderId + " for " + amount);
        // Direct call to BillingService - tight coupling
        String transactionId = billingService.charge(orderId, amount);
        System.out.println("OrdersService: order " + orderId + " confirmed with transaction " + transactionId);
        return transactionId;
    }
}
