package com.demo.billing;

import java.math.BigDecimal;

public interface BillingClient {

    String charge(String orderId, BigDecimal amount);
}