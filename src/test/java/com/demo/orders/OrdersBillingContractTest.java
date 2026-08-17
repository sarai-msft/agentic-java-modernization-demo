package com.demo.orders;

import com.demo.billing.BillingService;
import org.junit.Test;
import java.math.BigDecimal;
import static org.junit.Assert.*;

public class OrdersBillingContractTest {

    @Test
    public void testPlaceOrderChargesBilling() {
        OrdersService orders = new OrdersService();
        String txn = orders.placeOrder("ORD-001", new BigDecimal("99.99"));
        assertNotNull("Transaction ID should not be null", txn);
        assertTrue("Transaction ID should start with TXN-", txn.startsWith("TXN-"));
    }

    @Test
    public void testBillingServiceDirectly() {
        BillingService billing = new BillingService();
        String txn = billing.charge("ORD-002", new BigDecimal("50.00"));
        assertNotNull(txn);
        assertTrue(txn.contains("ORD-002"));
    }

    @Test(expected = IllegalArgumentException.class)
    public void testBillingRejectsZeroAmount() {
        BillingService billing = new BillingService();
        billing.charge("ORD-003", BigDecimal.ZERO);
    }

    @Test(expected = IllegalArgumentException.class)
    public void testBillingRejectsNullAmount() {
        BillingService billing = new BillingService();
        billing.charge("ORD-004", null);
    }
}
