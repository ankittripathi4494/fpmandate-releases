# Flutter Design System & Responsive Layout Engine: Complete User Manual

> **[🏠 Root README](../README.md) • [📚 Docs Hub](./README.md) • [🗺️ Architecture Flow](./project_architecture_and_flow.md) • [🚀 Open Interactive Portal](./index.html)**
> **Note:** These pages are specifically for **Developer Documentations**.

>
> **A self-contained, enterprise-grade, easily migratable Flutter design and responsive layout system.**
> Designed to be copied directly into **any new Flutter project** with zero broken imports or architecture rewrites.

---

---

## 📑 Table of Contents

- [Flutter Design System \& Responsive Layout Engine: Complete User Manual](#flutter-design-system--responsive-layout-engine-complete-user-manual)
  - [📑 Table of Contents](#-table-of-contents)
  - [1. Architecture Overview](#1-architecture-overview)
    - [Directory Structure](#directory-structure)
    - [Why This Design is Superior](#why-this-design-is-superior)
  - [2. Quick-Start Migration (Drop into ANY New Project)](#2-quick-start-migration-drop-into-any-new-project)
    - [Step 1: Add Dependencies](#step-1-add-dependencies)
    - [Step 2: Copy Folders](#step-2-copy-folders)
    - [Step 3: Wrap `MaterialApp` with `ScreenUtilInit` \& `AppTheme`](#step-3-wrap-materialapp-with-screenutilinit--apptheme)
  - [3. Responsive Mobile \& Desktop Separation](#3-responsive-mobile--desktop-separation)
    - [Breakpoints \& `ResponsiveLayout`](#breakpoints--responsivelayout)
    - [Adaptive Units: `rw`, `rh`, `rsp`, `rr`, `verticalSpaceResponsive`, `horizontalSpaceResponsive`](#adaptive-units-rw-rh-rsp-rr-verticalspaceresponsive-horizontalspaceresponsive)
    - [Inline Responsive Logic: `context.responsive<T>()`](#inline-responsive-logic-contextresponsivet)
  - [4. Design System Tokens](#4-design-system-tokens)
    - [Semantic Colors \& Dynamic Palette Switching (`context.colors`)](#semantic-colors--dynamic-palette-switching-contextcolors)
      - [Available Semantic Color Tokens](#available-semantic-color-tokens)
    - [Typography \& One-Line Font Switching](#typography--one-line-font-switching)
      - [How to Switch the Font Family in 1 Line](#how-to-switch-the-font-family-in-1-line)
      - [Using Typography in Widgets](#using-typography-in-widgets)
    - [Spacing \& Adaptive Gap Widgets (`AppSpacing`)](#spacing--adaptive-gap-widgets-appspacing)
      - [Fixed (Compile-Time `const`)](#fixed-compile-time-const)
      - [Adaptive (Scales on Mobile, Raw on Desktop)](#adaptive-scales-on-mobile-raw-on-desktop)
    - [Padding \& Insets (`AppInsets` \& `context.*Padding`)](#padding--insets-appinsets--contextpadding)
      - [Convenience Context Getters](#convenience-context-getters)
      - [Direct Insets](#direct-insets)
    - [Shapes \& Corner Radii (`AppRadius` \& `AppShapes`)](#shapes--corner-radii-appradius--appshapes)
      - [Standard Radius Values](#standard-radius-values)
      - [Adaptive BorderRadius](#adaptive-borderradius)
      - [Adaptive Shapes](#adaptive-shapes)
    - [Shadows \& Elevation (`AppShadows`)](#shadows--elevation-appshadows)
  - [5. Theme Switching \& Brand Presets](#5-theme-switching--brand-presets)
    - [Available Brand Presets](#available-brand-presets)
    - [Customizing a Preset \& Global Corner Radius](#customizing-a-preset--global-corner-radius)
  - [6. Real-World Copy-Paste Component Recipes](#6-real-world-copy-paste-component-recipes)
    - [Recipe 1: Complete Responsive Card](#recipe-1-complete-responsive-card)
    - [Recipe 2: Responsive Modal Bottom Sheet](#recipe-2-responsive-modal-bottom-sheet)
    - [Recipe 3: Responsive Grid / Dashboard](#recipe-3-responsive-grid--dashboard)
  - [7. FAQ \& Best Practices](#7-faq--best-practices)
    - [Q: Why did elements look giant on desktop before, and how does this fix it?](#q-why-did-elements-look-giant-on-desktop-before-and-how-does-this-fix-it)
    - [Q: Can I copy this into a project without `google_fonts`?](#q-can-i-copy-this-into-a-project-without-google_fonts)
    - [Q: Can I copy this into a project with a completely different name?](#q-can-i-copy-this-into-a-project-with-a-completely-different-name)
    - [🧭 Module Navigation](#-module-navigation)

---

---

## 1. Architecture Overview

This architecture permanently separates your project's styling and layout logic into two self-contained, decoupled directories:

### Directory Structure

```bash
lib/core/
├── responsive/                                  # Responsive Layout Engine
│   ├── responsive_helper.dart                   # Breakpoints (<650, 650-1100, >=1100), device detection
│   ├── responsive_layout.dart                   # ResponsiveLayout widget & adaptive num extensions (rw, rh, rsp, rr)
│   └── responsive.dart                          # Barrel export for responsive module
│
└── theme/                                       # Design System & Theming Engine
    ├── app_colors.dart                          # Raw color palette & material shades
    ├── app_typography.dart                      # Configurable typography scale & font resolver
    ├── app_text_styles.dart                     # Backward-compatible text styles (headline1..caption)
    ├── app_spacing.dart                         # Spacing scalars, insets, and gap widgets
    ├── app_radii.dart                           # Corner radii, border radius, and shape borders
    ├── app_shadows.dart                         # Elevation shadows for light/dark modes
    ├── theme_extensions.dart                    # AppThemeColors ThemeExtension
    ├── app_theme_config.dart                    # Config engine & theme presets (Gold, Blue, Emerald, Indigo)
    ├── app_theme.dart                           # Material 3 ThemeData builder
    ├── theme_context_ext.dart                   # Ergonomic BuildContext extensions (context.colors, context.isDark)
    └── theme.dart                               # Master barrel export
```

### Why This Design is Superior

- **Zero App Coupling**: Neither folder imports `package:your_app_name/...`. Internal imports are 100% relative (`import 'app_colors.dart';`), so you can drop them into any project with any package name.
- **Zero OS Dependencies**: Breakpoint and platform detection uses pure Flutter `foundation` (`kIsWeb`, `defaultTargetPlatform`). No `universal_io` or `dart:io` crashes on Web!
- **Mobile Scaled, Desktop Crisp**: Solves the classic Flutter web/desktop flaw where mobile-scaling packages make desktop UIs giant.

---

---

## 2. Quick-Start Migration (Drop into ANY New Project)

### Step 1: Add Dependencies

In the new project's `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_screenutil: ^5.9.3 # For mobile responsive scaling
  google_fonts: ^8.2.0       # For configurable fonts (optional)
```

### Step 2: Copy Folders

Copy the two folders directly:

- Copy `lib/core/responsive/` -> `your_project/lib/core/responsive/`
- Copy `lib/core/theme/` -> `your_project/lib/core/theme/`

### Step 3: Wrap `MaterialApp` with `ScreenUtilInit` & `AppTheme`

In your `main.dart` or root app widget:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/theme/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // Standard mobile base
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        title: 'My App',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
      ),
    );
  }
}
```

---

---

## 3. Responsive Mobile & Desktop Separation

### Breakpoints & `ResponsiveLayout`

The system defines 3 standard viewport tiers:

- **Mobile**: `< 650` px
- **Tablet**: `650` px to `< 1100` px
- **Desktop**: `>= 1100` px

Use `ResponsiveLayout` when mobile and desktop need entirely different UI structures:

```dart
import 'package:your_project/core/theme/theme.dart';

class CustomerScreen extends StatelessWidget {
  const CustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: (context) => const MobileCustomerList(),
      tablet: (context) => const TabletCustomerGrid(), // Optional, falls back to desktop
      desktop: (context) => const DesktopCustomerTable(),
    );
  }
}
```

### Adaptive Units: `rw`, `rh`, `rsp`, `rr`, `verticalSpaceResponsive`, `horizontalSpaceResponsive`

On numbers (`num`), use the responsive getters:

| Extension                        | Mobile Behavior (`ScreenUtil`)  | Desktop / Web Behavior         | Best Used For                      |
| ---

-------------------------------- | ------------------------------- | ------------------------------ | ---------------------------------- |
| **`.rw`**                        | `width * (deviceWidth / 375)`   | Raw value (`toDouble()`)       | Widths, horizontal padding/margin  |
| **`.rh`**                        | `height * (deviceHeight / 812)` | Raw value (`toDouble()`)       | Heights, vertical padding/margin   |
| **`.rsp`**                       | Scaled font point (`sp`)        | Raw value (`toDouble()`)       | Font sizes                         |
| **`.rr`**                        | Scaled radius (`r`)             | Raw value (`toDouble()`)       | Border radius, uniform padding     |
| **`.verticalSpaceResponsive`**   | `SizedBox(height: rh)`          | `SizedBox(height: toDouble())` | Vertical spacing between widgets   |
| **`.horizontalSpaceResponsive`** | `SizedBox(width: rw)`           | `SizedBox(width: toDouble())`  | Horizontal spacing between widgets |

### Inline Responsive Logic: `context.responsive<T>()`

Instead of writing verbose `LayoutBuilder` blocks for simple value changes:

```dart
// Adaptive Grid Columns
final columns = context.responsive<int>(
  mobile: 1,
  tablet: 2,
  desktop: 4,
);

// Adaptive Icon Size
final iconSize = context.responsive<double>(
  mobile: 24.rr,
  desktop: 28.0,
);
```

---

---

## 4. Design System Tokens

### Semantic Colors & Dynamic Palette Switching (`context.colors`)

Never write `final isDark = context.isDark` and ternary checks (`isDark ? darkColor : lightColor`) across your widgets.

Use `context.colors`, which automatically adapts to the active light/dark mode AND active brand theme preset (`goldLuxury`, `fintechBlue`, `emerald`, `corporateIndigo`):

```dart
Container(
  color: context.colors.card,             // Automatic card background
  borderColor: context.colors.cardBorder, // Automatic theme-aware border
  child: Text(
    'Title',
    style: AppTextStyles.subtitle1.copyWith(color: context.colors.textPrimary),
  ),
)
```

All UI screens and components must import design tokens strictly from `lib/core/theme/theme.dart`. This ensures UI consistency across all modules and enables dynamic palette switching without hardcoded color overrides.

#### Available Semantic Color Tokens

- **Surfaces**: `background`, `surface`, `card`, `cardBorder`, `dialogBackground`, `bottomSheetBackground`, `pillBackground`, `chipBackground`
- **Typography & Icons**: `textPrimary`, `textSecondary`, `textTertiary`, `icon`, `divider`
- **Brand & Accents**: `primary`, `secondary`, `accent`, `brandGold`
- **Feedback**: `success`, `successContainer`, `error`, `errorContainer`, `warning`, `warningContainer`, `info`

#### Generating Perfect Material Shades (`.shade50` - `.shade900`)

Through the `MaterialColorExtension` (imported automatically via `theme.dart`), you can request precise 10-level shade swatches (50-900) for **any** color token in the system—whether it was predefined as a `MaterialColor` or is just a regular `Color`.

```dart
// Fetching precise shades for UI elements dynamically:
Container(
  // Darken the primary color for a button press state
  color: context.colors.primary.shade700, 
)

Text(
  "Alert", 
  // Automatically generate a light 100-shade tint for a text warning
  style: TextStyle(color: context.colors.error.shade100), 
)
```

**How it works:**
- If the token (like `context.colors.primary`) is explicitly defined as a `MaterialColor` in the preset, it returns the exact, hand-crafted designer swatches.
- If the token is a standard `Color` (like `context.colors.error`), the extension mathematically generates the shades (tinting for < 500, shading for > 500) perfectly on the fly!

---

---

### Typography & One-Line Font Switching

All text styles are centralized in `app_typography.dart` and backward-compatible `app_text_styles.dart`.

#### How to Switch the Font Family in 1 Line

Before running `runApp` (or anywhere in setup), assign a font to `AppTypography.font`:

```dart
// Switch to Inter:
AppTypography.font = GoogleFonts.inter;

// Switch to Roboto:
AppTypography.font = GoogleFonts.roboto;

// Switch to Plus Jakarta Sans:
AppTypography.font = GoogleFonts.plusJakartaSans;

// Switch to a custom local asset font:
AppTypography.font = ({fontSize, fontWeight, color, height, ...}) => TextStyle(
  fontFamily: 'MyCustomFont',
  fontSize: fontSize,
  fontWeight: fontWeight,
  color: color,
  height: height,
);
```

#### Using Typography in Widgets

```dart
Text('Dashboard', style: AppTextStyles.headline1);
Text('Recent Activities', style: AppTextStyles.subtitle1);
Text('Description text', style: AppTextStyles.body1);
Text('Updated 2m ago', style: AppTextStyles.caption);
```

---

---

### Spacing & Adaptive Gap Widgets (`AppSpacing`)

Eliminate hardcoded `SizedBox(height: 16)` and `16.h` scattered everywhere.

#### Fixed (Compile-Time `const`)

- `AppSpacing.vXs` (4px), `AppSpacing.vSm` (8px), `AppSpacing.vMd` (16px), `AppSpacing.vLg` (24px), `AppSpacing.vXl` (32px)
- `AppSpacing.hXs` (4px), `AppSpacing.hSm` (8px), `AppSpacing.hMd` (16px), `AppSpacing.hLg` (24px), `AppSpacing.hXl` (32px)

#### Adaptive (Scales on Mobile, Raw on Desktop)

- `AppSpacing.vXsResponsive`, `AppSpacing.vSmResponsive`, `AppSpacing.vMdResponsive`, `AppSpacing.vLgResponsive`, `AppSpacing.vXlResponsive`
- `AppSpacing.hXsResponsive`, `AppSpacing.hSmResponsive`, `AppSpacing.hMdResponsive`, `AppSpacing.hLgResponsive`, `AppSpacing.hXlResponsive`

```dart
Column(
  children: [
    const UserCard(),
    AppSpacing.vMdResponsive, // Scales vertically on mobile, unscaled on desktop
    const RecentTransactions(),
  ],
)
```

---

---

### Padding & Insets (`AppInsets` & `context.*Padding`)

#### Convenience Context Getters

- `context.screenPadding` -> Adaptive screen margin (`16.rw` horizontal, `16.rh` vertical)
- `context.cardPadding` -> Adaptive card margin (`16.rr` all)
- `context.dialogPadding` -> Adaptive dialog margin (`24.rr` all)

#### Direct Insets

- `AppInsets.screenPaddingResponsive`
- `AppInsets.cardPaddingResponsive`
- `AppInsets.buttonPaddingResponsive`
- `AppInsets.allSmResponsive`, `AppInsets.allMdResponsive`, `AppInsets.allLgResponsive`
- `AppInsets.hMdResponsive`, `AppInsets.vMdResponsive`

```dart
Scaffold(
  body: Padding(
    padding: context.screenPadding,
    child: child,
  ),
)
```

---

---

### Shapes & Corner Radii (`AppRadius` & `AppShapes`)

#### Standard Radius Values

- `AppRadius.xs` (4px)
- `AppRadius.sm` (8px)
- `AppRadius.md` (12px)
- `AppRadius.lg` (16px)
- `AppRadius.xl` (20px)
- `AppRadius.xxl` (24px)
- `AppRadius.pill` (999px)

#### Adaptive BorderRadius

- `AppBorderRadius.allSmResponsive`
- `AppBorderRadius.allMdResponsive`
- `AppBorderRadius.allLgResponsive`
- `AppBorderRadius.pillResponsive`
- `AppBorderRadius.topLgResponsive` / `AppBorderRadius.topXlResponsive` (for modal sheets)

#### Adaptive Shapes

- `AppShapes.roundedMdResponsive`
- `AppShapes.roundedLgResponsive`
- `AppShapes.bottomSheetResponsive`

```dart
Container(
  decoration: BoxDecoration(
    borderRadius: AppBorderRadius.allMdResponsive, // Scales with ScreenUtil on mobile
  ),
)
```

---

---

### Shadows & Elevation (`AppShadows`)

Pre-tuned shadows that render subtly in light mode and rich in dark mode:

- `AppShadows.card(isDark: context.isDark)`
- `AppShadows.subtle(isDark: context.isDark)`
- `AppShadows.elevated(isDark: context.isDark)`
- `AppShadows.dialog(isDark: context.isDark)`
- `AppShadows.glow(color)`

```dart
Container(
  decoration: BoxDecoration(
    color: context.colors.card,
    borderRadius: AppBorderRadius.allLgResponsive,
    boxShadow: AppShadows.card(isDark: context.isDark),
  ),
)
```

---

---

## 5. Theme Switching & Brand Presets

Switching the visual identity of your entire app requires **one line of code**:

### Available Brand Presets

```dart
// 1. Gold Luxury Preset (Champagne, Gold, Warm Charcoal)
AppThemeConfig.setPreset(AppThemePreset.goldLuxury);

// 2. Modern Fintech Blue (Electric Blue, Crisp Slate, Deep Navy)
AppThemeConfig.setPreset(AppThemePreset.fintechBlue);

// 3. Emerald Wealth (Forest Green, Mint, Dark Green-Grey)
AppThemeConfig.setPreset(AppThemePreset.emerald);

// 4. Corporate Indigo (Deep Indigo, Royal Accents, Slate)
AppThemeConfig.setPreset(AppThemePreset.corporateIndigo);
```


### How to Add a New Brand Preset
Adding a new brand identity (preset) is a 2-step process that automatically syncs across the entire application (including the settings UI).

1. Open `lib/core/theme/app_theme_config.dart`.
2. Define a new `AppThemeConfig` static constant inside `AppThemePreset` and add it to the `all` list.

```dart
// 1. Define your preset
static final AppThemeConfig crimsonRed = AppThemeConfig(
  name: 'Crimson Power',
  // Use a full MaterialColor to provide exact designer shades (50-900) when .shadeXXX is called
  primaryColor: const MaterialColor(
    0xFFDC2626,
    <int, Color>{
      50: Color(0xFFFEF2F2),
      100: Color(0xFFFEE2E2),
      200: Color(0xFFFECACA),
      300: Color(0xFFFCA5A5),
      400: Color(0xFFF87171),
      500: Color(0xFFDC2626),
      600: Color(0xFFB91C1C),
      700: Color(0xFF991B1B),
      800: Color(0xFF7F1D1D),
      900: Color(0xFF450A0A),
    },
  ),
  secondaryColor: const Color(0xFFF87171), // Normal colors work too, shades are mathematically calculated!
  scaffoldBgLight: const Color(0xFFFEF2F2),
  scaffoldBgDark: const Color(0xFF450A0A),
  cardRadius: AppRadius.xl, // E.g., heavily rounded cards
  elevationStyle: ElevationStyle.elevated,
  lightColors: AppThemeColors.light.copyWith(/* Custom overrides */) as AppThemeColors,
  darkColors: AppThemeColors.dark.copyWith(/* Custom overrides */) as AppThemeColors,
);

// 2. Add to the `all` list so it populates in the UI automatically
static List<AppThemeConfig> get all => [
  goldLuxury,
  fintechBlue,
  emerald,
  corporateIndigo,
  crimsonRed, // <---

--- Added here
];
```
Once added to the `all` getter, it will automatically appear in the `PremiumThemeSwitcherWidget` and be selectable by the user without modifying any UI code!

---

---

### Customizing a Preset & Global Corner Radius

You can customize specific properties (like card corner radius or primary color) using `.copyWith()`:

```dart
AppThemeConfig.current = AppThemePreset.goldLuxury.copyWith(
  cardRadius: AppRadius.sm, // Make cards sharp (8px)
  primaryColor: const Color(0xFF0066FF),
);
```

---

---

## 6. Real-World Copy-Paste Component Recipes

### Recipe 1: Complete Responsive Card

```dart
import 'package:flutter/material.dart';
import 'package:your_project/core/theme/theme.dart';

class PaymentCard extends StatelessWidget {
  final String title;
  final String amount;
  final VoidCallback onTap;

  const PaymentCard({
    super.key,
    required this.title,
    required this.amount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: context.cardPadding,
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: AppBorderRadius.allLgResponsive,
        border: Border.all(color: context.colors.cardBorder),
        boxShadow: AppShadows.card(isDark: context.isDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTextStyles.subtitle1),
              Icon(Icons.arrow_forward_ios, size: 14.rr, color: context.colors.icon),
            ],
          ),
          AppSpacing.vSmResponsive,
          Text(amount, style: AppTextStyles.headline1),
          AppSpacing.vMdResponsive,
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: AppShapes.roundedMdResponsive,
              padding: AppInsets.buttonPaddingResponsive,
            ),
            onPressed: onTap,
            child: const Text('View Statement'),
          ),
        ],
      ),
    );
  }
}
```

### Recipe 2: Responsive Modal Bottom Sheet

```dart
void showCustomModalSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: context.colors.bottomSheetBackground,
    shape: AppShapes.bottomSheetResponsive,
    builder: (context) {
      return Padding(
        padding: context.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.rw,
              height: 4.rh,
              decoration: BoxDecoration(
                color: context.colors.divider,
                borderRadius: AppBorderRadius.pill,
              ),
            ),
            AppSpacing.vMdResponsive,
            Text('Select Payment Option', style: AppTextStyles.headline2),
            AppSpacing.vLgResponsive,
            // ... options list
          ],
        ),
      );
    },
  );
}
```

### Recipe 3: Responsive Grid / Dashboard

```dart
class ResponsiveDashboard extends StatelessWidget {
  const ResponsiveDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final columns = context.responsive<int>(
      mobile: 1,
      tablet: 2,
      desktop: 4,
    );

    return Scaffold(
      backgroundColor: context.colors.background,
      body: GridView.builder(
        padding: context.screenPadding,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          crossAxisSpacing: AppSpacing.md.rw,
          mainAxisSpacing: AppSpacing.md.rh,
          childAspectRatio: context.responsive<double>(mobile: 2.2, desktop: 1.5),
        ),
        itemCount: 4,
        itemBuilder: (context, index) => const PaymentCard(
          title: 'Total Collection',
          amount: '₹ 8,40,000',
          onTap: null,
        ),
      ),
    );
  }
}
```

---

---

## 7. FAQ & Best Practices

### Q: Why did elements look giant on desktop before, and how does this fix it?
>
> Standard `flutter_screenutil` `.w` and `.h` assume screen width is relative to 375px. On a 1920px monitor, a `16.w` padding becomes ~`80px`!
>
> Our **`.rw`**, **`.rh`**, **`.rsp`**, and **`.rr`** extensions check `ResponsiveHelper.isDesktopOrWeb`. On mobile, they scale gracefully with ScreenUtil. On desktop and web, they automatically return the unscaled logical pixel value (`toDouble()`), keeping UI elements crisp and proportional!

### Q: Can I copy this into a project without `google_fonts`?
>
> Yes! In `app_typography.dart`, set `AppTypography.font` to return a standard `TextStyle(fontFamily: 'YourFont', ...)`. You don't even need `google_fonts` in `pubspec.yaml` if you use local asset fonts or system fonts.

### Q: Can I copy this into a project with a completely different name?
>
> Yes! Neither `core/theme` nor `core/responsive` contains any `package:...` application-specific imports. All imports within the modules use clean relative paths.

---

---

### 🧭 Module Navigation

|                        ⬅️ Previous Module                         |        🏠 Documentation Hub         |              ➡️ Next Module              |
| :---

---------------------------------------------------------------: | :---------------------------------: | :--------------------------------------: |
| [⬅️ Master Architecture Flow](./project_architecture_and_flow.md) | **[📚 Connected Hub](./README.md)** | [Splash & Bootstrapping ➡️](./splash.md) |
