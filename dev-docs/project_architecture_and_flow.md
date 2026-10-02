# FP Mandate Project Architecture & Flow

> **[🏠 Root README](../README.md) • [📚 Docs Hub](./README.md) • [🎨 Design System](./theme_and_responsive_system.md) • [🚀 Open Interactive Portal](./index.html)**
> **Note:** These pages are specifically for **Developer Documentations**.

This document serves as the master index for the FP Mandate Flutter application's modular architecture, data flow, and feature set.

---

---

## Application Architecture

The project strictly follows a **Feature-First / Modular** architecture. Each major feature is isolated inside `lib/modules/`, containing its own State Management (Cubit/Bloc), Data layer (Models/Repositories), Screens, and Widgets.

```bash
lib/
├── core/            # Global configs, themes, services (API, secure storage), global helpers
└── modules/         # Isolated feature modules
    ├── auth/        # Authentication (OTP, JWT/Refresh logic)
    ├── errors/      # Global error handling and fallback screens
    ├── history/     # Historical data & logs for user transactions
    ├── home/        # Dashboard, stats, and gatekeeper status tracking (KYC)
    ├── kyc/         # KYC submission, document upload, and cross-device handoff (QR)
    ├── mandate_checkout/ # Core business flow: creating and scheduling e-mandates
    ├── notification/# Push notifications & alerts
    ├── onboarding/  # First-time user experience and walk-throughs
    ├── settings/    # User preferences and app configurations
    ├── splash/      # Initialization, token validation, routing logic
    └── wallet/      # Coin economy and mandate deduction gatekeeping
```

## Global Flows & Gatekeepers

FP Mandate utilizes a series of "Gates" (`lib/core/helpers/`) to ensure users meet requirements before accessing core features like creating a mandate.

1. **Authentication Flow** (See [auth.md](./auth.md)):
   - Handled via `Splash` -> `Onboarding` -> `Auth`.
   - Uses a dual-token (JWT + Refresh) approach securely stored via `SecureStorageService`.
2. **KYC Gatekeeper**:
   - Tracked via `HomeCubit` and `KycBloc`.
   - All status parsing, progress percentage calculations, and state flags (`isReview`, `isRejected`, `isInProgress`, `isVerified`) are processed through `KycStatusEvaluation` (`lib/core/helpers/kyc_status.helper.dart`) and exposed directly on `KycData` getters (`profile.kyc?.isReview`, `profile.kyc?.isVerified`).
   - Before a user can create a mandate, `MandateGateHelper` evaluates `kyc.isVerified`.
   - If incomplete, the user is presented with a `ConfirmationDialog` routing them to the `KYC` module.
3. **Wallet / Coin Gatekeeper**:
   - Tracked via `WalletCubit`.
   - Creating a mandate costs "Coins". `CoinGateHelper` ensures the user's balance meets the required threshold before launching the Checkout screen.

## Module Documentation Index

For detailed flows of specific features, refer to the individual module documents or the **[Connected Documentation Hub](./README.md)**:

- **[Auth Module](./auth.md)**: OTP Login, JWT refresh cycles, and session architecture.
- **[Home Module](./home.md)**: Dashboard data fetching, global KYC tracking, and profile state.
- **[KYC Module](./kyc.md)**: Organization/Personal document upload, verification flow, and Desktop-to-Mobile QR Handoff.
- **[Mandate Checkout Module](./mandate_checkout.md)**: Multi-step wizard (Identity, Financing, Schedule), responsive premium layouts, dynamic mathematical interval calculations.
- **[Customer Module](./customer.md)**: Customer listing, search, pagination, mandate filtering, and detail inspector.
- **[Analytics Module](./analytics.md)**: Cash flow velocity, comparative bar charts, and payment breakdown.
- **[Wallet Module](./wallet.md)**: Virtual coin management, balance checking, and mandate deductions.
- **[History Module](./history.md)**: Historical transaction logs, filtering, and export.
- **[Credit Score Module](./credit_score.md)**: SME credit score report, coin deductions, and download flow.
- **[Notification Module](./notification.md)**: Push notification alerts and activity log.
- **[Settings Module](./settings.md)**: Theme, language, profile, and security preferences.
- **[Splash & Onboarding](./splash.md)**: Boot sequence, token validation, and introduction walkthroughs.
- **[Errors & Fallbacks](./errors.md)**: Network disconnection, lost mode, and maintenance screens.
- **[Design System & Responsive Engine](./theme_and_responsive_system.md)**: Modular design tokens, theme presets, 1-line font switching, and cross-platform adaptive scaling.
- **[Razorpay Backend Guide](./razorpay_backend_guide.md)**: Payment gateway integration, coin checkout, and webhooks.
- **[Build & Release Guide](./build_and_release.md)**: Details on CI/CD pipelines, installer configurations, and multiplatform executables.

## Responsiveness & UI/UX Standards

- **Desktop (macOS/Windows)**: Employs split-screen architecture (Illustration floating cards on the left, vertical steppers or forms on the right). Heavy use of glassmorphism (`BackdropFilter`), dark fintech aesthetics (`AppColors.backgroundDark`, `AppColors.primaryGold`), and keyboard accessibility.
- **Mobile/Tablet**: Employs bottom navigation, stacked cascading accordion forms (e.g., in Mandate Checkout), and bottom sheets (e.g., QR Handoff).

## Environment Configuration & Base URLs

FP Mandate utilizes the `envied` package for obfuscating and securely managing environment variables. All URLs and keys are injected at compile time from a `.env` file and accessed via `lib/core/config/env.dart` and `lib/core/routes/apis/api.endpoints.dart`.

**Primary Configuration (`.env`):**
- **Base API URL:** `https://fpmandate.financepe.in` (`BASE_URL_NEW`)
- **Image/Document Domain:** `https://image.financepe.in` (`IMAGE_DOMAIN`)
- **Razorpay Domain:** `https://api.razorpay.com/v1/` (`RAZORPAY_DOMAIN`)
- **Subfolders:** 
  - `API_SUBFOLDER`: `/api/`
  - `IMAGE_SUBFOLDER`: `/dashapp/`
  - `EMANDATE_SUBFOLDER`: `/emandate/`
- **Keys:** Razorpay keys (`RAZOR_KEY`) and toggles (`USE_LOCAL_PIN`) are also configured here.

*Note: Avoid hardcoding `portal.financepe.tech` or `financepe.in` endpoints in feature modules. Always reference `Api.baseUrlNew` and `Api.emandate` to ensure multi-environment parity.*

## Core Services & Global Capabilities

1. **ExportService (`export.service.dart`)**:
   - A highly generic, cross-platform utility handling dynamic PDF generation and CSV encoding.
   - Modules inject `List<ExportColumn<T>>` into the service along with their raw DTOs.
   - Employs `ExportSelectionDialog` for user-driven field selection prior to exporting.
   - Dynamically resolves native file system boundaries (Desktop Documents via `path_provider` & `url_launcher` vs. Mobile Temporary paths via `share_plus`).

2. **UserInfoService (`user_info.service.dart`)**:
   - Acts as a global reactive singleton (`ChangeNotifier`) caching the currently logged-in user's profile (`ProfileResponse`).
   - Syncs its state whenever the `HomeBloc` successfully fetches user data.
   - Allows disparate UI components (like side drawers, checkout dialogs, and top app bars) to reactively display the user's name, phone, or company name without depending on module-specific Blocs.
   - Cleared automatically during the `AuthService.logout()` flow.

3. **UpdateService (`update.service.dart`)**:
   - A factory singleton implementing the Abstract Factory pattern to handle cross-platform application updates.
   - In **Debug Mode**, safely delegates to `MockUpdateService` to allow UI testing of the gamified update banner on any simulator.
   - In **Android Production**, strictly routes to `ProdUpdateService` for genuine Google Play Core (`in_app_update`) integration.
   - In **iOS/Web Production**, gracefully falls back to `NoOpUpdateService` to permanently hide unsupported update banners from end-users.

---

---

### 🧭 Module Navigation

|          ⬅️ Previous Module          |        🏠 Documentation Hub         |                              ➡️ Next Module                              |
| :---

----------------------------------: | :---------------------------------: | :----------------------------------------------------------------------: |
| [⬅️ Connected Hub Home](./README.md) | **[📚 Connected Hub](./README.md)** | [Design System & Responsive Engine ➡️](./theme_and_responsive_system.md) |
