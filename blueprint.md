# CLAUDE.md — MokPOS Flutter App

> Written in English for optimal Claude Code processing.

---

## 1. Project Overview

- **Name**: MokPOS
- **Description**: Mobile Point of Sale (POS) application for Android and tablet, built with Flutter. Designed as a SaaS platform where multiple merchants can register and manage their own store.
- **Goal**: Provide a reliable, fast, and user-friendly POS experience for small-to-medium merchants in Indonesia — supporting transactions, product management, sales reports, and employee management.
- **Target Users**: Two roles — Owner (merchant/store owner) and Employee (cashier). Super Admin (platform operator) is handled separately via web panel.
- **Version**: v0.1.0
- **Status**: Active development — MVP phase

---

## 2. Tech Stack

- **Language**: Dart
- **Framework**: Flutter 3.x
- **State Management**: Riverpod (flutter_riverpod + hooks_riverpod)
- **Navigation**: GoRouter
- **HTTP Client**: Dio (with interceptors for JWT auth)
- **Local Storage**: flutter_secure_storage (tokens), Hive (cache, offline data)
- **UI**: Custom design system based on Figma — do NOT use Material widgets directly unless explicitly specified. Use the custom widget library in `lib/core/widgets/`.
- **Barcode Scanner**: mobile_scanner
- **QR Generator**: qr_flutter
- **Image Handling**: cached_network_image, image_picker
- **Formatting**: intl (Rupiah currency, Indonesian date format)
- **Fonts**: Google Fonts — match the Figma design
- **Deployment**: Android (primary), Tablet adaptive layout support

---

## 3. Commands

```bash
# Development
flutter run                          # Run on connected device
flutter run -d emulator-5554         # Run on specific emulator
flutter run --flavor development     # Run development flavor

# Build
flutter build apk --release          # Build release APK
flutter build apk --debug            # Build debug APK
flutter build appbundle              # Build for Play Store

# Code Generation (run after adding/changing models or providers)
dart run build_runner build --delete-conflicting-outputs
dart run build_runner watch          # Watch mode during development

# Testing
flutter test                         # Run all tests
flutter test test/unit/              # Unit tests only
flutter test test/widget/            # Widget tests only

# Linting & Formatting
flutter analyze                      # Analyze code
dart format .                        # Format all dart files

# Dependencies
flutter pub get                      # Install dependencies
flutter pub upgrade                  # Upgrade dependencies
flutter pub add [package]            # Add new package — confirm first
```

> Never add a new package without confirmation. Always check if the functionality can be achieved with existing packages first.

---

## 4. Project Structure

**Architecture**: Feature-first with clean architecture layers per feature.

```
lib/
├── main.dart                        # Entry point, ProviderScope, GoRouter init
├── core/
│   ├── constants/
│   │   ├── app_colors.dart          # Color palette matching Figma design
│   │   ├── app_typography.dart      # Text styles matching Figma
│   │   ├── app_spacing.dart         # Spacing constants (8, 12, 16, 24, 32...)
│   │   └── app_strings.dart         # Static string constants (non-translated)
│   ├── theme/
│   │   └── app_theme.dart           # ThemeData config — light mode only for now
│   ├── router/
│   │   ├── app_router.dart          # GoRouter instance and all routes
│   │   └── route_guards.dart        # Auth guard, role guard (Owner vs Employee)
│   ├── network/
│   │   ├── dio_client.dart          # Dio instance with base URL and interceptors
│   │   ├── auth_interceptor.dart    # Attach JWT, handle 401 refresh
│   │   └── api_endpoints.dart       # All API endpoint constants
│   ├── storage/
│   │   ├── secure_storage.dart      # Token read/write via flutter_secure_storage
│   │   └── hive_storage.dart        # Hive box init and helpers
│   ├── utils/
│   │   ├── currency_formatter.dart  # Format to Rupiah (Rp 10.000)
│   │   ├── date_formatter.dart      # Indonesian date format helpers
│   │   └── validators.dart          # Form validators (email, phone, PIN, etc.)
│   ├── errors/
│   │   ├── app_exception.dart       # Custom exception classes
│   │   └── failure.dart             # Failure sealed class for result pattern
│   └── widgets/                     # Shared reusable UI components
│       ├── app_button.dart
│       ├── app_text_field.dart
│       ├── app_bottom_nav.dart
│       ├── app_loading.dart
│       ├── app_snackbar.dart
│       └── app_empty_state.dart
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── models/              # AuthModel, UserModel (JSON serializable)
│   │   │   ├── repositories/        # AuthRepositoryImpl
│   │   │   └── datasources/         # AuthRemoteDataSource (Dio calls)
│   │   ├── domain/
│   │   │   ├── entities/            # User, AuthToken (pure Dart, no JSON)
│   │   │   ├── repositories/        # AuthRepository abstract
│   │   │   └── usecases/            # LoginOwner, LoginEmployee, Register, Logout
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── splash_screen.dart
│   │       │   ├── role_selection_screen.dart
│   │       │   ├── login_owner_screen.dart
│   │       │   ├── login_employee_screen.dart
│   │       │   ├── register_screen.dart
│   │       │   ├── store_setup_screen.dart
│   │       │   └── choose_plan_screen.dart
│   │       ├── providers/           # authProvider, userSessionProvider
│   │       └── widgets/             # PinPadWidget, RoleCard, etc.
│   │
│   ├── home/
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── dashboard_owner_screen.dart
│   │       │   └── cashier_home_screen.dart
│   │       └── widgets/             # SalesSummaryCard, QuickStatWidget
│   │
│   ├── pos/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── pos_screen.dart              # Phone layout
│   │       │   ├── pos_tablet_screen.dart       # Tablet split-view layout
│   │       │   ├── pos_favorites_tab.dart
│   │       │   └── pos_manual_input_screen.dart
│   │       ├── providers/           # cartProvider, productSearchProvider
│   │       └── widgets/             # ProductCard, CartItem, CategoryChip
│   │
│   ├── transaction/
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── cart_screen.dart
│   │       │   ├── customer_input_screen.dart
│   │       │   ├── payment_cash_screen.dart
│   │       │   ├── payment_qris_screen.dart
│   │       │   ├── payment_split_screen.dart
│   │       │   ├── transaction_success_screen.dart
│   │       │   ├── receipt_preview_screen.dart
│   │       │   └── void_refund_screen.dart
│   │       └── providers/
│   │
│   ├── history/
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── history_screen.dart
│   │       │   ├── history_filter_screen.dart
│   │       │   ├── transaction_detail_screen.dart
│   │       │   ├── report_screen.dart
│   │       │   └── shift_close_screen.dart
│   │       └── providers/
│   │
│   ├── product/
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── product_list_screen.dart
│   │       │   ├── product_form_screen.dart     # Add + Edit (same screen, different mode)
│   │       │   ├── category_screen.dart
│   │       │   ├── stock_screen.dart
│   │       │   └── barcode_scanner_screen.dart
│   │       └── providers/
│   │
│   ├── customer/
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── customer_list_screen.dart
│   │       │   └── customer_detail_screen.dart
│   │       └── providers/
│   │
│   ├── employee/
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── employee_list_screen.dart
│   │       │   └── employee_performance_screen.dart
│   │       └── providers/
│   │
│   └── settings/
│       └── presentation/
│           ├── screens/
│           │   ├── profile_screen.dart
│           │   ├── store_settings_screen.dart
│           │   ├── receipt_settings_screen.dart
│           │   ├── payment_method_settings_screen.dart
│           │   ├── subscription_screen.dart
│           │   └── notification_settings_screen.dart
│           └── providers/
│
└── l10n/                            # Localization (Bahasa Indonesia + English, future)
```

**File placement rules:**
- All new screens go inside `features/[feature]/presentation/screens/`
- All shared UI widgets go inside `core/widgets/`
- Feature-specific widgets go inside `features/[feature]/presentation/widgets/`
- Never put business logic inside screen files — use providers and use cases
- Do not create new top-level folders without confirmation

---

## 5. Naming Conventions

```
# Files and Folders
- Screens         : snake_case + _screen.dart     e.g. login_owner_screen.dart
- Widgets         : snake_case + _widget.dart      e.g. product_card_widget.dart
                    OR descriptive name            e.g. pin_pad.dart
- Providers       : snake_case + _provider.dart    e.g. cart_provider.dart
- Models          : snake_case + _model.dart       e.g. product_model.dart
- Entities        : snake_case + _entity.dart      e.g. product_entity.dart (or just product.dart)
- Repositories    : snake_case + _repository.dart
- Use cases       : snake_case + _usecase.dart     e.g. login_owner_usecase.dart
- Folders         : snake_case                     e.g. auth/, product_management/

# Inside Code (Dart)
- Variables       : camelCase      e.g. cartItems, isLoading
- Constants       : camelCase      e.g. baseUrl (top-level), kMaxPinLength (k prefix for local const)
- Functions       : camelCase      e.g. formatRupiah(), addToCart()
- Classes         : PascalCase     e.g. ProductCard, AuthRepository
- Enums           : PascalCase     e.g. UserRole, PaymentMethod, OrderStatus
- Enum values     : camelCase      e.g. UserRole.owner, PaymentMethod.qris
- Providers       : camelCase      e.g. cartProvider, authSessionProvider

# Routes (GoRouter)
- Route names     : camelCase constant   e.g. AppRoutes.posHome
- Route paths     : kebab-case strings   e.g. '/pos-home', '/product/add'
```

---

## 6. Code Conventions

```dart
// General Approach
// - Clean, readable code over clever one-liners
// - DRY: extract to function or widget if used more than once
// - SOLID principles where applicable in Dart/Flutter context
// - Prefer immutable data — use copyWith pattern on models

// Result Pattern for Repository and Use Cases
// Always return Either<Failure, T> or use sealed classes for error handling
// Do not throw exceptions from repository layer upward — wrap them in Failure

// Async
// Always use async/await, never .then() chains
// Always wrap in try-catch inside data source layer
// Repository layer catches DataSource exceptions and returns Failure

// Riverpod
// Use AsyncNotifier for providers with async initialization
// Use Notifier for sync state
// Use Provider for computed/derived state
// Use FutureProvider for one-time async reads
// Always use ref.watch in build(), ref.read in callbacks/handlers

// Imports Order (enforced by dart format + linting)
// 1. dart: core libraries
// 2. package: external packages
// 3. Relative internal imports (from lib/)
// No need to separate — dart format handles ordering

// Widget Structure Order
// 1. Class declaration
// 2. Constructor + key
// 3. State variables (if StatefulWidget)
// 4. initState / dispose (if needed)
// 5. Build method
// 6. Private helper build methods (_buildHeader, _buildProductList, etc.)
// 7. Handler methods (_onTapProduct, _onConfirmPayment, etc.)

// String Formatting
// Always use intl for currency: NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0)
// Always use intl for dates: DateFormat('d MMMM yyyy', 'id')
```

---

## 7. Widget & Screen Rules

```
# Screen Rules
- Every screen is a ConsumerWidget or ConsumerStatefulWidget (Riverpod)
- Never put API calls or business logic directly in screen build()
- All screens must handle 3 states: loading, error, success
- Use AppLoading widget for loading state (from core/widgets/)
- Use AppEmptyState widget for empty data
- Use AppSnackbar for error/success feedback (not ScaffoldMessenger directly)

# Adaptive Layout (Phone vs Tablet)
- Detect using: MediaQuery.of(context).size.shortestSide >= 600 for tablet
- Or use a LayoutBuilder + breakpoint constant: kTabletBreakpoint = 600
- Phone screens: standard single-column layout, portrait
- Tablet screens: split-view where applicable (POS screen, History screen)
- POS tablet screen is a separate file: pos_tablet_screen.dart — not a conditional inside pos_screen.dart
- All other screens use responsive padding and font scaling, same file

# Custom Widgets Priority
- ALWAYS check core/widgets/ before creating a new widget
- ALWAYS use AppButton instead of ElevatedButton / TextButton
- ALWAYS use AppTextField instead of TextFormField directly
- Do NOT use Material design components that conflict with the Figma design system
- Allowed Material widgets: Scaffold, SafeArea, GestureDetector, InkWell, LayoutBuilder, MediaQuery

# Design System
- All colors from AppColors constants — never hardcode hex values in widgets
- All text styles from AppTypography constants — never hardcode fontSize or fontWeight
- All spacing from AppSpacing constants — never hardcode padding/margin numbers
- The Figma design is the source of truth for visual output
- When in doubt about a color or size, ask — do not guess

# State Handling Template
// Always follow this pattern in screens:
final state = ref.watch(someProvider);
return state.when(
  loading: () => const AppLoading(),
  error: (err, _) => AppEmptyState(message: err.toString()),
  data: (data) => _buildContent(data),
);
```

---

## 8. Navigation Rules (GoRouter)

```
# Route Structure
- All routes defined in core/router/app_router.dart
- Use named routes — never navigate by path string directly in screens
- Use GoRouter.of(context).goNamed('routeName') or context.goNamed()

# Guards
- Auth guard: redirect to role_selection if no valid token
- Role guard: Owner routes are not accessible by Employee
  - Employee sees: POS, Cart, Payment, Success, History (own shifts only)
  - Owner sees: everything
- Plan guard (future): restrict features based on subscription plan

# Route Groups
/splash                    → SplashScreen
/role-selection            → RoleSelectionScreen
/login/owner               → LoginOwnerScreen
/login/employee            → LoginEmployeeScreen
/register                  → RegisterScreen
/onboarding/store-setup    → StoreSetupScreen
/onboarding/choose-plan    → ChoosePlanScreen

/home                      → DashboardOwnerScreen (Owner) or CashierHomeScreen (Employee)
/pos                       → PosScreen (phone) / PosTabletScreen (tablet — auto redirect)
/pos/manual-input          → PosManualInputScreen

/cart                      → CartScreen
/cart/customer             → CustomerInputScreen
/payment/cash              → PaymentCashScreen
/payment/qris              → PaymentQrisScreen
/payment/split             → PaymentSplitScreen
/transaction/success       → TransactionSuccessScreen
/transaction/receipt       → ReceiptPreviewScreen
/transaction/void          → VoidRefundScreen (Owner only)

/history                   → HistoryScreen
/history/filter            → HistoryFilterScreen
/history/:id               → TransactionDetailScreen
/reports                   → ReportScreen (Owner only)
/shift/close               → ShiftCloseScreen

/products                  → ProductListScreen (Owner only)
/products/add              → ProductFormScreen (mode: add)
/products/:id/edit         → ProductFormScreen (mode: edit)
/products/categories       → CategoryScreen (Owner only)
/products/stock            → StockScreen (Owner only)
/scanner                   → BarcodeScannerScreen

/customers                 → CustomerListScreen (Owner only)
/customers/:id             → CustomerDetailScreen (Owner only)

/employees                 → EmployeeListScreen (Owner only)
/employees/performance     → EmployeePerformanceScreen (Owner only)

/settings/profile          → ProfileScreen
/settings/store            → StoreSettingsScreen (Owner only)
/settings/receipt          → ReceiptSettingsScreen (Owner only)
/settings/payment-methods  → PaymentMethodSettingsScreen (Owner only)
/settings/subscription     → SubscriptionScreen (Owner only)
/settings/notifications    → NotificationSettingsScreen
```

---

## 9. API & Data Rules

```
# API Communication
- All API calls go through DioClient in core/network/
- Base URL comes from environment config — never hardcode
- Every request automatically attaches Bearer JWT via AuthInterceptor
- On 401 response: attempt token refresh, then logout if refresh fails

# Response Handling
- Backend returns: { success: bool, data: T, message: string }
- Always parse in the Model layer — screens never touch raw JSON
- Use json_serializable + build_runner for all models

# Offline Behavior (Phase 1 — basic)
- Cache product list in Hive on first load
- Cart state persists in Hive (user can close app and return to cart)
- Transactions queue locally if network unavailable — sync on reconnect (Phase 2)

# Data Flow Direction
  Screen → Provider (Riverpod) → UseCase → Repository → DataSource → Dio → API
  API → DataSource → Repository → UseCase → Provider → Screen

# Environment Config
- Use --dart-define for environment variables
- Never hardcode API URL, keys, or secrets in source code
- .env or dart-define values:
    API_BASE_URL     # Backend base URL
    MIDTRANS_CLIENT_KEY  # Payment (client-safe key only)
```

---

## 10. State Management Rules (Riverpod)

```
# Provider Types — choose correctly
- Provider          : computed/derived values, no async
- FutureProvider    : one-time async fetch (settings, config)
- StreamProvider    : real-time data (future: live order updates)
- Notifier          : sync state with actions (cart, filter state)
- AsyncNotifier     : async state with actions (product list with CRUD)

# Provider Location
- Feature providers go in features/[feature]/presentation/providers/
- Global shared providers (auth session, user role) go in core/providers/ (create if needed)

# Cart Provider is the most critical — rules:
- cartProvider is a Notifier<CartState>
- CartState holds: List<CartItem>, selectedCustomer, discountAmount
- Actions: addItem, removeItem, updateQuantity, applyDiscount, clearCart
- Cart state must persist to Hive on every change

# Never do this:
- ref.read(provider) inside build() — use ref.watch()
- setState inside ConsumerWidget — use Notifier
- Call use case directly from screen — go through provider
```

---

## 11. Role-based Access

```
# UserRole enum
enum UserRole { owner, employee }

# What Employee CAN do:
- Login with PIN
- Access POS (product grid, favorites, manual input)
- Process transactions (cart → payment → success)
- View own transaction history and shift summary
- View receipt and share

# What Employee CANNOT do:
- See revenue/sales summary numbers on dashboard
- Access Reports screen
- Add/edit/delete products
- Manage categories or stock
- See customer list or employee list
- Access any settings except their own profile
- Process void/refund (Owner must approve)

# Implementation:
- Route guards in GoRouter check userRole from authSessionProvider
- UI-level: conditionally hide menu items based on role
- API-level: backend enforces the same rules (do not rely only on UI)
```

---

## 12. Git Rules

After every completed screen or feature, commit before moving to the next task.

```
# Commit Message Format
feat     : add [screen or feature name]
fix      : resolve [issue description]
refactor : [what was refactored and why]
style    : [UI or formatting change]
docs     : update CLAUDE.md or code comments
test     : add tests for [feature]
chore    : update dependencies or config

# Examples
feat: add login owner screen with form validation
feat: add cart provider with add/remove/quantity actions
fix: resolve PIN pad input not clearing on wrong attempt
refactor: extract product card into reusable widget
chore: add go_router and configure initial routes

# Rules
- One commit per screen or logical unit of work
- Never commit generated files from build_runner (add to .gitignore)
- Never commit .env or dart-define files
- Never mix unrelated changes in one commit
```

---

## 13. Screen Build Order (Sprint Priority)

```
# Batch 1 — Auth & POS Core (build first, demo-able)
- [x] Project setup: folder structure, theme, router, Dio, Riverpod
- [x] Core constants: AppColors, AppTypography, AppSpacing, AppStrings
- [x] Core theme: AppTheme with complete design system
- [x] Core widgets: AppButton, AppTextField, AppLoading, AppEmptyState
- [x] Core utils: CurrencyFormatter, DateFormatter, Validators
- [x] Router setup with all route definitions
- [x] Splash screen
- [x] Role selection screen
- [x] Login owner screen
- [x] Login employee screen (PIN pad)
- [x] PIN pad widget (custom numeric keypad)
- [x] Register screen
- [x] Store setup screen
- [x] Choose plan screen
- [x] Dashboard owner screen
- [x] Cashier home screen (employee)
- [x] POS screen — phone layout (product grid + cart sheet)
- [ ] POS tablet screen — split view
- [ ] POS favorites tab
- [x] POS manual input screen
- [x] Cart screen
- [x] Customer input screen
- [x] Payment cash screen (change calculator)
- [x] Payment QRIS screen
- [x] Payment split screen
- [x] Transaction success screen
- [x] Receipt preview screen
- [x] Void/refund screen

# Batch 2 — History, Reports, Products
- [x] History screen
- [x] History filter screen
- [x] Transaction detail screen
- [x] Report screen
- [x] Shift close screen
- [x] Product list screen
- [x] Product form screen (add + edit)
- [x] Category screen
- [x] Stock screen
- [x] Barcode scanner screen

# Batch 3 — CRM, Employees, Settings, SaaS
- [ ] Customer list screen
- [ ] Customer detail screen
- [ ] Employee list screen
- [ ] Employee performance screen
- [ ] Profile screen
- [ ] Store settings screen
- [ ] Receipt settings screen
- [ ] Payment method settings screen
- [ ] Subscription screen
- [ ] Notification settings screen
```

---

## 14. Testing

```
# Approach for MVP phase
- Type: Unit tests for providers and use cases, widget tests for critical widgets
- Framework: flutter_test (built-in), mocktail for mocking

# What to test
- All providers (cartProvider actions, authProvider state transitions)
- All use cases (LoginOwner, AddToCart, ProcessTransaction)
- Currency and date formatters
- Form validators
- Critical widgets: PinPad, AppButton, CartItem

# What NOT to test (for now)
- Screen-level integration tests (manual QA for now)
- Third-party package internals

# Test File Location
- test/unit/features/[feature]/
- test/unit/core/
- test/widget/

# Naming
should [expected result] when [condition]
e.g. 'should return formatted Rupiah when given integer amount'
     'should clear cart when clearCart action is called'
```

---

## 15. Do Not

If any instruction is ambiguous, **ASK FIRST** before writing code. Do not assume.

```
# Structure
- Do not create new top-level folders in lib/ without confirmation
- Do not move or rename existing files without confirmation
- Do not delete any file without confirmation

# Code
- Do not hardcode any color, font size, or spacing — use constants
- Do not hardcode API URLs or keys
- Do not use Material widgets that override the Figma design system
- Do not use setState in ConsumerWidget — use Riverpod properly
- Do not put business logic inside build() methods
- Do not install new packages without confirmation

# Design
- Do not deviate from the Figma design system for colors, typography, and spacing
- Do not use default Flutter blue/purple Material theme colors anywhere
- Do not use placeholder/lorem ipsum text in screens — use realistic Indonesian content

# Data & Security
- Do not store sensitive data (password, token) in Hive — use flutter_secure_storage
- Do not expose raw API errors to the user — show friendly Indonesian error messages
- Do not skip loading and error states — every async screen must handle all 3 states

# Patterns to Avoid
- Do not use FutureBuilder or StreamBuilder — use Riverpod providers instead
- Do not use BuildContext across async gaps — check mounted before using context after await
- Do not use GlobalKey unnecessarily
```

---

## 16. Environment Variables

```
# Passed via --dart-define at build/run time
# Never committed to repository

API_BASE_URL              # Backend Laravel API base URL
                          # e.g. https://api.mokpos.com/api/v1
                          # local: http://10.0.2.2:8000/api/v1 (Android emulator)

MIDTRANS_CLIENT_KEY       # Midtrans client key (safe for client)
                          # Sandbox: SB-Mid-client-xxxx
                          # Production: Mid-client-xxxx

APP_ENV                   # 'development' | 'staging' | 'production'

# Access in code:
const apiBaseUrl = String.fromEnvironment('API_BASE_URL');
const midtransClientKey = String.fromEnvironment('MIDTRANS_CLIENT_KEY');
const appEnv = String.fromEnvironment('APP_ENV', defaultValue: 'development');
```

---

## 17. Design System Notes

```
# Source of Truth
- Figma design is the final authority on all visual decisions
- Do not replicate Material 3 design — follow the custom Figma system
- Design size reference: 375x812 (iPhone X/11 Pro) for phone layouts
- Tablet breakpoint: shortestSide >= 600

# AppColors (extracted from Figma)
- Primary color     : #1A72DD (Blue - main brand color)
- Secondary color   : #F8CF33 (Yellow - accent, logo icon)
- Background        : #FFFFFF (White - main background)
- Surface           : #F5F7FA (Light gray - cards, inputs)
- Error color       : #E74C3C (Red - errors, destructive actions)
- Text primary      : #2A3256 (Dark blue-gray - main text)
- Text secondary    : #545454 (Medium gray - labels, captions)
- Success           : #27AE60 (Green - success states)
- Warning           : #F39C12 (Orange - warnings)
- Border            : #C4C4C4 (Light gray - borders, dividers)
- Disabled          : #E0E0E0 (Very light gray - disabled states)
- Shadow            : rgba(26, 114, 221, 0.15) (Primary with opacity)

# AppTypography (extracted from Figma - Rubik font family)
- Display Large     : Rubik, 32px, Weight 600 (Bold) - Splash, onboarding titles
- Heading Large     : Rubik, 24px, Weight 500 (Medium) - Screen titles, logo text
- Heading Medium    : Rubik, 20px, Weight 500 (Medium) - Section headers
- Body Large        : Rubik, 16px, Weight 500 (Medium) - Buttons, important text
- Body Regular      : Rubik, 16px, Weight 400 (Regular) - Body text, descriptions
- Body Small        : Rubik, 14px, Weight 400 (Regular) - Secondary text
- Label             : Rubik, 14px, Weight 500 (Medium) - Input labels, tags
- Caption           : Rubik, 12px, Weight 400 (Regular) - Timestamps, metadata
- Button Text       : Rubik, 16px, Weight 500 (Medium) - All button labels

# AppSpacing (consistent spacing scale)
const xs   = 4.0;   // Minimal spacing, icon padding
const sm   = 8.0;   // Tight spacing, list items
const md   = 12.0;  // Default spacing between elements
const lg   = 16.0;  // Standard padding, card padding
const xl   = 24.0;  // Section spacing, screen padding
const xxl  = 32.0;  // Large section breaks
const xxxl = 48.0;  // Hero spacing, splash screens

# AppRadius (border radius scale)
const radiusXs   = 4.0;   // Small chips, badges
const radiusSm   = 8.0;   // Input fields, small cards
const radiusMd   = 12.0;  // Standard cards, product cards
const radiusLg   = 16.0;  // Buttons, large cards
const radiusXl   = 20.0;  // Bottom sheets, modals
const radiusRound = 999.0; // Fully rounded (avatars, pills)

# AppShadows (elevation system)
- Shadow Small  : 0px 2px 8px rgba(0, 0, 0, 0.06) - Cards, inputs
- Shadow Medium : 0px 6px 20px rgba(0, 0, 0, 0.06) - Elevated cards, dropdowns
- Shadow Large  : 0px 24px 48px rgba(26, 114, 221, 0.15) - Modals, important elements

# Button Styles (from Figma components)
- Primary Button:
  - Background: #1A72DD
  - Text: #FFFFFF
  - Height: 57px
  - Border Radius: 16px
  - Font: Rubik 16px Medium
  - Padding: 19px horizontal
  
- Secondary Button (Outlined):
  - Background: #FFFFFF
  - Border: 0.8px solid #1A72DD
  - Text: #1A72DD
  - Height: 57px
  - Border Radius: 16px
  - Font: Rubik 16px Medium

- Ghost Button:
  - Background: transparent
  - Text: #1A72DD
  - No border
  - Font: Rubik 16px Medium

# Input Field Styles
- Height: 56px
- Border Radius: 12px
- Border: 1px solid #C4C4C4
- Background: #FFFFFF
- Padding: 16px
- Font: Rubik 16px Regular
- Label: Rubik 14px Medium, #545454
- Error state: Border #E74C3C, error text below

# Card Styles
- Background: #FFFFFF
- Border Radius: 12px
- Border: 1px solid #E0E0E0 OR Shadow Small
- Padding: 16px
- Product Card: Image top, text below, 2-column grid

# Status Bar (iOS style from Figma)
- Time: SF Pro Text 14px, Weight 600, #545454
- Icons: WiFi, Cellular, Battery - #545454
- Height: 44px safe area

# Bottom Navigation
- Height: 60px + safe area
- Background: #FFFFFF
- Border top: 1px solid #E0E0E0
- Active icon: #1A72DD
- Inactive icon: #545454
- Label: Rubik 12px Regular

# Logo Design
- Icon: 37x37px rounded square (#1A72DD background)
- Inner icon: Yellow bookmark (#F8CF33)
- Text: "MokPOS." - Rubik 24px Medium #1A72DD
- Drop shadow: 0px 24px 48px rgba(26, 114, 221, 0.15)

# Illustrations & Images
- Onboarding illustration size: 256x284px
- Product image: Square or 4:3 ratio
- Avatar: 40px circle
- Empty state illustration: 200x200px center

# Progress Indicators
- Dot style: 18x5px rounded rectangle
- Active: #1A72DD
- Inactive: #C4C4C4
- Spacing: 8px between dots

# Before building any screen
1. Open the corresponding Figma screen
2. Match colors using AppColors constants
3. Match typography using AppTypography constants
4. Match spacing using AppSpacing constants
5. Match radius using AppRadius constants
6. If a value is missing from constants, add it to constants first — do not hardcode
```

---

_Update this file every time a new pattern, rule, or package decision is made. This file is the contract between you and Claude Code._