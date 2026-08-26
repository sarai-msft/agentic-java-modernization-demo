package com.demo.billing;

import java.math.BigDecimal;

/**
 * Direct billing service - tightly coupled to OrdersService.
 */
public class BillingService implements BillingClient {

    @Override
    public String charge(String orderId, BigDecimal amount) {
        // Simulate billing logic
        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("Amount must be positive");
        }
        String transactionId = "TXN-" + orderId + "-" + System.currentTimeMillis();
        System.out.println("BillingService: charged " + amount + " for order " + orderId + " -> " + transactionId);
        return transactionId;
    }
}
