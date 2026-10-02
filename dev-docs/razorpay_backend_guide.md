# Razorpay Integration Guide (Backend Developer)

> **[🏠 Root README](../README.md) • [📚 Docs Hub](./README.md) • [🗺️ Architecture Flow](./project_architecture_and_flow.md) • [🚀 Open Interactive Portal](./index.html)**
> **Note:** These pages are specifically for **Developer Documentations**.


This document outlines the exact APIs, payloads, and workflows required from the backend to complete the Razorpay payment integration for the FP Mandate application.

## 1. Overview

For security and PCI compliance, the Flutter frontend **does not** generate orders or verify signatures. The frontend strictly acts as a presentation layer that accepts an `order_id` from the backend, opens the Razorpay checkout, and returns the result.

Additionally, because the frontend supports macOS/Windows Desktop, the backend must generate a hosted checkout link alongside the standard `order_id`.

---

---

## 2. API 1: Generate Order & Checkout Link

**Endpoint:** `POST /api/v1/mandate/checkout` (or your equivalent customer details update endpoint)

When the user submits the Mandate Checkout form, the backend must interface with the Razorpay Orders API (`POST https://api.razorpay.com/v1/orders`) to generate a unique order.

### Required Backend Response (JSON Contract)

The frontend strictly expects this JSON structure upon a successful `200 OK` response:

```json
{
  "status": "success",
  "data": {
    "order_id": "order_XXXXXX", 
    "checkout_url": "https://your-backend.com/pay/order_XXXXXX" 
  }
}
```

### 🚨 Critical Requirement for Desktop (`checkout_url`)

Razorpay does not have a native desktop SDK. Our Flutter macOS/Windows app uses an embedded popup window to render a web page.

1. `checkout_url` must point to a web page hosted by your backend (or a Razorpay Payment Link) that renders the Razorpay JS checkout for that specific `order_id`.
2. **The Callback Redirect:** Once the payment on that web page succeeds or fails, the webpage **MUST redirect** to a specific URL format.
   - Success Redirect: `https://your-backend.com/payment/success?payment_id=pay_xxxx`
   - Failure Redirect: `https://your-backend.com/payment/failed`

*Why?* The Flutter Desktop app actively listens to the URLs inside the popup. The exact moment it sees `/payment/success`, it intercepts the `payment_id`, closes the popup window, and proceeds to the success screen natively.

---

---

## 3. API 2: Payment Verification

**Endpoint:** `POST /api/v1/payment/verify`

After the frontend completes the payment (via Mobile Native UI or Web), it will send the Razorpay credentials back to the backend to verify the signature. **Never trust the frontend success state alone.**

### Frontend Request Payload

```json
{
  "razorpay_order_id": "order_XXXXXX",
  "razorpay_payment_id": "pay_XXXXXX",
  "razorpay_signature": "signature_hash_XXXXX"
}
```

### Backend Action

You must verify the signature using your Razorpay Secret Key:

```text
generated_signature = hmac_sha256(order_id + "|" + razorpay_payment_id, RAZORPAY_SECRET)

if (generated_signature == razorpay_signature) {
    // Mark order as PAID in database
}
```

---

---

## 4. Webhooks (Highly Recommended)

In cases where the user loses internet connection exactly after paying but before the frontend can send the verification payload, you should configure Razorpay Webhooks in your Razorpay Dashboard.

**Events to subscribe to:**

- `payment.captured`
- `payment.failed`

Update the database order status based on these webhook events as the ultimate source of truth.

---

---

### 🧭 Module Navigation
|                   ⬅️ Previous Module                   |        🏠 Documentation Hub         |                    ➡️ Next Module                    |
| :---

----------------------------------------------------: | :---------------------------------: | :--------------------------------------------------: |
| [⬅️ Credit Score & Risk Assessment](./credit_score.md) | **[📚 Connected Hub](./README.md)** | [Notifications & Alert System ➡️](./notification.md) |
