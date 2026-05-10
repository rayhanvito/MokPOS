# SCREENS.md — MokPOS Flutter App
# Complete Screen List with Design Concept & Visual Style

> Reference this file when building each screen.
> Every screen description includes: purpose, user role, layout concept, key components, and UX notes.
> Visual style follows the Figma design — update color/font tokens here once extracted from Figma.

---

## Screen Index

| # | Screen Name | Route | Role | Batch |
|---|-------------|-------|------|-------|
| 01 | Splash Screen | `/splash` | All | 1 |
| 02 | Role Selection | `/role-selection` | All | 1 |
| 03 | Login — Owner | `/login/owner` | Owner | 1 |
| 04 | Login — Employee (PIN) | `/login/employee` | Employee | 1 |
| 05 | Register — Owner | `/register` | Owner | 1 |
| 06 | Store Setup | `/onboarding/store-setup` | Owner | 1 |
| 07 | Choose Plan | `/onboarding/choose-plan` | Owner | 1 |
| 08 | Dashboard — Owner | `/home` | Owner | 1 |
| 09 | Cashier Home — Employee | `/home` | Employee | 1 |
| 10 | POS — Product Grid (Phone) | `/pos` | All | 1 |
| 11 | POS — Split View (Tablet) | `/pos` | All | 1 |
| 12 | POS — Favorites Tab | `/pos` (tab) | All | 1 |
| 13 | POS — Manual Input | `/pos/manual-input` | All | 1 |
| 14 | Cart / Place Order | `/cart` | All | 1 |
| 15 | Customer Input | `/cart/customer` | All | 1 |
| 16 | Payment — Cash | `/payment/cash` | All | 1 |
| 17 | Payment — QRIS | `/payment/qris` | All | 1 |
| 18 | Payment — Split | `/payment/split` | All | 1 |
| 19 | Transaction Success | `/transaction/success` | All | 1 |
| 20 | Receipt Preview | `/transaction/receipt` | All | 1 |
| 21 | Void / Refund | `/transaction/void` | Owner | 1 |
| 22 | History — Transaction List | `/history` | All | 2 |
| 23 | History — Filter | `/history/filter` | All | 2 |
| 24 | Transaction Detail | `/history/:id` | All | 2 |
| 25 | Report — Sales | `/reports` | Owner | 2 |
| 26 | Shift Close | `/shift/close` | All | 2 |
| 27 | Product List | `/products` | Owner | 2 |
| 28 | Product Form (Add/Edit) | `/products/add` or `/products/:id/edit` | Owner | 2 |
| 29 | Category Management | `/products/categories` | Owner | 2 |
| 30 | Stock & Inventory | `/products/stock` | Owner | 2 |
| 31 | Barcode Scanner | `/scanner` | All | 2 |
| 32 | Customer List | `/customers` | Owner | 3 |
| 33 | Customer Detail | `/customers/:id` | Owner | 3 |
| 34 | Employee List | `/employees` | Owner | 3 |
| 35 | Employee Performance | `/employees/performance` | Owner | 3 |
| 36 | Profile & Account | `/settings/profile` | All | 3 |
| 37 | Store Settings | `/settings/store` | Owner | 3 |
| 38 | Receipt Settings | `/settings/receipt` | Owner | 3 |
| 39 | Payment Method Settings | `/settings/payment-methods` | Owner | 3 |
| 40 | Subscription & Billing | `/settings/subscription` | Owner | 3 |
| 41 | Notification Settings | `/settings/notifications` | All | 3 |

---

## Global Design Language

Before reading individual screen specs, internalize these rules. They apply to every screen.

### Visual Personality
Clean, minimal, fast. This is a tool for cashiers who process dozens of transactions per day — every tap must feel instant and every element must be immediately scannable. No decorative elements. No unnecessary animations. Purposeful white space.

### Layout Principles
- Safe area respected on all sides
- Bottom navigation always visible (except full-screen flows: payment, scanner, success)
- All touch targets minimum 48x48dp
- Primary action always bottom-right or full-width bottom button
- Destructive actions always require confirmation

### Typography Hierarchy
- Screen title: large, heavy weight, top-left aligned
- Section labels: small, medium weight, muted color, uppercase or sentence case (follow Figma)
- Body content: regular weight, primary text color
- Metadata / timestamps: small, muted color

### Color Usage
- Primary color: CTAs, active states, highlights
- Background: page background (off-white or white)
- Surface: cards, input fields, bottom sheets
- Muted/secondary text: labels, captions, inactive states
- Success green: payment confirmed, stock OK
- Warning amber: low stock, expiring plan
- Error red: failed payment, validation errors

### Component Patterns
- Cards: subtle border or soft shadow, rounded corners (12dp), white surface
- Input fields: outlined style, label floats on focus, clear error state below field
- Buttons: primary (filled, primary color), secondary (outlined), ghost (text only)
- Bottom sheets: draggable handle, rounded top corners (20dp), max height 90% screen
- Loading: skeleton shimmer (not spinner) for list content, centered CircularProgressIndicator for full-page load
- Empty state: centered illustration area + heading + subtext + optional CTA button
- Snackbar: bottom, brief, action optional — success/error variants

### Phone vs Tablet Differences
- Phone: single column, bottom navigation bar, portrait-first
- Tablet: two-column where applicable (POS, History), rail navigation (side), landscape-friendly
- Font sizes scale up slightly on tablet
- Padding increases on tablet (use adaptive spacing)

---

## Batch 1 — Auth, POS Core & Transactions

---

### Screen 01 — Splash Screen

**File**: `lib/features/auth/presentation/screens/splash_screen.dart`
**Route**: `/splash`
**Role**: All users
**Duration**: ~2 seconds, then auto-navigate

**Purpose**
App entry point. Verify token, determine redirect destination.

**Logic**
- Check flutter_secure_storage for existing JWT token
- If valid token exists → navigate to `/home` (role-appropriate dashboard)
- If no token → navigate to `/role-selection`
- Show logo during check — no user interaction needed

**Layout**
- Full screen, centered vertically and horizontally
- Background: primary brand color OR white (follow Figma)
- App logo / wordmark at center
- Tagline text below logo (optional, follow Figma)
- No loading indicator — the check is fast enough
- StatusBar: hidden or match background color

**Visual Style**
- This is the brand moment — logo should be crisp and well-padded
- No buttons, no text input, nothing interactive
- Subtle fade-in animation on logo (200ms) — keep it minimal
- If brand color background: logo is white/light version
- If white background: logo is full color version

**UX Notes**
- Never show this screen more than 2 seconds — if API check takes longer, navigate anyway and handle auth error at destination
- Do not show error messages on this screen

---

### Screen 02 — Role Selection

**File**: `lib/features/auth/presentation/screens/role_selection_screen.dart`
**Route**: `/role-selection`
**Role**: All users (pre-login)

**Purpose**
Let the user declare who they are before entering credentials. Determines which login flow they enter.

**Layout**
- No app bar
- Top area: app logo (smaller than splash) + tagline
- Center: two large role cards, stacked vertically or side-by-side
  - Card 1: Owner / Pemilik Toko
  - Card 2: Employee / Karyawan
- Each card: icon + role label + short description (1 line)
- Bottom: small text link "Belum punya akun? Daftar sekarang" → `/register`

**Role Cards Design**
- Large tappable area (min height 100dp each)
- Border + rounded corners, surface background
- On tap: card gets primary color border + background tint
- Then navigate immediately — no confirm button needed
- Icon: meaningful (store/shop icon for Owner, person/badge for Employee)

**Visual Style**
- Clean, welcoming, not overwhelming
- Two cards feel like a deliberate choice, not a form
- The word "Owner" and "Karyawan" should be large and confident
- Description text is small and muted

**UX Notes**
- This is the first real screen — set the tone of the app
- No back button (this is the root of auth flow)
- If user presses Android back → exit app (show confirm dialog)

---

### Screen 03 — Login — Owner

**File**: `lib/features/auth/presentation/screens/login_owner_screen.dart`
**Route**: `/login/owner`
**Role**: Owner

**Purpose**
Owner authenticates with email and password.

**Layout**
- Back arrow top-left (goes back to Role Selection)
- Screen title: "Masuk sebagai Pemilik" (large, top)
- Subtitle: short welcome or instruction text (muted)
- Form fields:
  - Email field (keyboard: emailAddress, autocorrect off)
  - Password field (obscured, toggle visibility icon)
- "Lupa password?" text link, right-aligned below password
- Primary CTA button: "Masuk" — full width, bottom of form
- Spacing between fields: 16dp

**Validation**
- Email: required, valid format
- Password: required, min 8 characters
- Inline error below each field on submit attempt
- Button shows loading state (disabled + spinner) during API call

**Visual Style**
- Minimal, form-focused
- Fields are the hero — generous padding, clear label
- CTA button is bold and prominent

**UX Notes**
- Auto-focus email field on screen open
- On success: navigate to `/home` (Owner dashboard), clear back stack
- On error: show error snackbar, keep form filled
- Remember email option (optional, use SharedPreferences)

---

### Screen 04 — Login — Employee (PIN)

**File**: `lib/features/auth/presentation/screens/login_employee_screen.dart`
**Route**: `/login/employee`
**Role**: Employee

**Purpose**
Employee logs in with a 6-digit PIN. Faster than typing email/password — designed for quick shift start.

**Layout**
- Back arrow top-left
- Screen title: "Masuk sebagai Karyawan"
- Store name display: "Masuk ke [Nama Toko]" — employee needs to identify which store
  - Store identifier field (store code or QR scan) → then PIN entry
  - OR: employee selects their name from a list, then enters PIN
  - Follow the Figma design for which pattern is used
- PIN display: 6 circles in a row (filled/empty dots) — no visible digits
- Custom numeric PIN pad (3x4 grid: 1-9, bottom row: clear / 0 / backspace)
- No keyboard — only the custom pad

**PIN Pad Design**
- Large circular or rounded square buttons
- Numbers centered, large font (24sp)
- Backspace: icon (←)
- Clear: "Hapus" or × icon
- Each button tap: haptic feedback if available

**Visual Style**
- PIN entry should feel like a kiosk/ATM — large, chunky, impossible to mispress
- Dark or high-contrast option (tablet in bright retail environment)
- PIN dots animate when filled (scale or color transition)

**UX Notes**
- After 3 wrong PIN attempts: show "Hubungi pemilik toko" message, briefly lock entry
- On success: navigate to Cashier Home, clear back stack
- Auto-submit when 6th digit is entered (no submit button needed)

---

### Screen 05 — Register — Owner

**File**: `lib/features/auth/presentation/screens/register_screen.dart`
**Route**: `/register`
**Role**: Owner (new merchant)

**Purpose**
New merchant creates their MokPOS account. Entry point into the SaaS onboarding flow.

**Layout**
- Back arrow top-left (back to Role Selection)
- Screen title: "Buat Akun Baru"
- Subtitle: "Daftar gratis, mulai 14 hari trial"
- Form fields (scrollable):
  - Full name (owner name)
  - Email address
  - Phone number (format: 08xx — Indonesian)
  - Password
  - Confirm password
- Terms of service checkbox + link text
- CTA button: "Daftar Sekarang" — full width
- Bottom: "Sudah punya akun? Masuk" → `/login/owner`

**Validation**
- All fields required
- Email: valid format, unique (checked on submit)
- Phone: Indonesian format validation
- Password: min 8 chars, 1 uppercase, 1 number (show requirements as checklist below field)
- Confirm password: must match
- Terms checkbox: must be checked

**Visual Style**
- Scrollable form — don't cram everything above the fold
- Password requirement checklist: small text items, green check when met
- Progress feel: this is step 1 of 3 (Register → Store Setup → Choose Plan)
- Optional: step indicator at top (1 ●○○)

---

### Screen 06 — Store Setup

**File**: `lib/features/auth/presentation/screens/store_setup_screen.dart`
**Route**: `/onboarding/store-setup`
**Role**: Owner (onboarding)

**Purpose**
After registration, owner configures their store profile. This data appears on receipts and the dashboard.

**Layout**
- No back button (or back = cancel onboarding with confirm dialog)
- Step indicator: step 2 of 3
- Screen title: "Atur Toko Kamu"
- Form fields:
  - Store logo: tap to upload image (camera or gallery) — shows preview circle
  - Store name (required)
  - Business category (dropdown: Makanan & Minuman / Retail / Fashion / Elektronik / Lainnya)
  - Store address (optional, text area)
  - Store phone number (optional)
- CTA button: "Lanjut" — full width bottom

**Logo Upload Area**
- Circle placeholder with camera icon center
- On tap: show bottom sheet with "Ambil Foto" / "Pilih dari Galeri"
- After upload: show cropped image in circle
- "Ubah foto" text below circle

**Visual Style**
- Onboarding should feel encouraging, not like a burden
- Large form fields, generous spacing
- Category chips could be a visual grid instead of a plain dropdown (follow Figma)

---

### Screen 07 — Choose Plan

**File**: `lib/features/auth/presentation/screens/choose_plan_screen.dart`
**Route**: `/onboarding/choose-plan`
**Role**: Owner (onboarding)

**Purpose**
Owner selects their subscription tier. This is the monetization moment — design it to convert.

**Layout**
- Step indicator: step 3 of 3
- Screen title: "Pilih Paket"
- Subtitle: "14 hari trial gratis untuk semua paket"
- Plan cards (vertical scroll, 2-3 plan options):
  - Plan name (Free / Pro / Business)
  - Price per month
  - Feature list (checkmarks)
  - "Paling Populer" badge on recommended plan
- Toggle: Bulanan / Tahunan (annual shows discount %)
- Selected plan: highlighted card with primary border
- CTA button: "Mulai Trial Gratis" — full width
- Fine print: "Tidak perlu kartu kredit untuk trial"

**Plan Card Design**
- Each card is clearly bounded
- Recommended plan card: primary color border, slightly elevated or tinted background
- Feature list: green checkmark icons, concise one-line features
- Price: large number, "/bulan" suffix in muted text
- Grayed-out features on lower plans (shows upgrade incentive)

**Visual Style**
- Pricing page energy — clean, confident, value-focused
- The recommended plan should clearly stand out without feeling pushy
- Annual toggle should clearly show the savings (e.g., "Hemat 20%")

**UX Notes**
- If user skips (X button or "Lewati"): enter app on Free plan with limitations visible
- After selecting: navigate to Owner Dashboard, onboarding complete

---

### Screen 08 — Dashboard — Owner

**File**: `lib/features/home/presentation/screens/dashboard_owner_screen.dart`
**Route**: `/home` (Owner role)
**Role**: Owner only

**Purpose**
Daily overview of store performance. First screen Owner sees after login.

**Layout**
- App bar: store name + store logo (left), notification bell (right)
- Greeting: "Selamat pagi, [Nama Owner]" + today's date
- Summary cards row (horizontal scroll or 2x2 grid):
  - Total sales today (Rp amount)
  - Number of transactions today
  - Best-selling product today
  - Low stock alert count (tappable → goes to Stock screen)
- Section: "Transaksi Terakhir" — last 5 transactions, list style
- Section: "Produk Hampir Habis" — low stock products (if any)
- FAB or prominent button: "Mulai Transaksi" → goes to POS screen

**Summary Cards Design**
- Each card: label (small muted top), value (large bold), optional trend arrow
- Cards use surface background, rounded corners, subtle border
- Sales card can have a mini sparkline or just the number

**Visual Style**
- Data-dense but organized — owner wants information at a glance
- Use color to signal status: red for low stock, green for good performance
- The "Mulai Transaksi" button should be impossible to miss

**UX Notes**
- Pull-to-refresh for all data
- Summary resets daily at midnight (show timezone)
- Tap any summary card → navigate to relevant detail screen

---

### Screen 09 — Cashier Home — Employee

**File**: `lib/features/home/presentation/screens/cashier_home_screen.dart`
**Route**: `/home` (Employee role)
**Role**: Employee only

**Purpose**
Employee's starting point. Simplified — no revenue data, just tools they need.

**Layout**
- App bar: store name (center), employee name/avatar (right)
- Greeting: "Selamat datang, [Nama Karyawan]"
- Shift info: shift start time, number of transactions this shift
- Large primary button: "Mulai Transaksi" → POS screen
- Quick actions row (small cards):
  - Riwayat Transaksi (own shifts only)
  - Tutup Kasir (end shift)
- No revenue numbers, no reports, no product management

**Visual Style**
- Focused and uncluttered — only what the cashier needs
- The transaction button dominates the screen
- Minimal color — functional, not decorative

**UX Notes**
- Employee CANNOT see total revenue — only their transaction count
- Shift data auto-starts when employee logs in
- "Tutup Kasir" shows confirmation dialog before closing shift

---

### Screen 10 — POS — Product Grid (Phone)

**File**: `lib/features/pos/presentation/screens/pos_screen.dart`
**Route**: `/pos`
**Role**: All

**Purpose**
Main selling screen. Browse products, tap to add to cart, then checkout.

**Layout**
- App bar: search bar (tappable → inline search or search screen), barcode scanner icon
- Category filter chips: horizontal scroll row below app bar (All, Makanan, Minuman, etc.)
- Product grid: 2 columns on phone, 3 columns on wider phone
- Each product card: product image (top), name, price, stock badge if low
- Bottom panel: cart summary bar (always visible when cart is not empty)
  - Shows: item count + subtotal + "Lihat Pesanan" button
  - Tapping "Lihat Pesanan" → Cart screen
- Bottom navigation: visible (Home, Transaksi/POS, Riwayat, Produk, Akun)

**Product Card Design**
- Square or 4:3 image on top
- Product name: 2-line max, ellipsis
- Price: bold, primary text color
- If out of stock: card is grayed out, "Habis" badge
- If favorited: small star/heart icon top-right
- On tap: add to cart with count badge animation (+1 on card)
- On long press: quick view bottom sheet with description and options

**Cart Summary Bar**
- Sticky bottom bar, appears when cart has ≥1 item
- Surface background, top border
- Left: "[n] item · Rp xx.xxx"
- Right: "Lihat Pesanan →" button
- This bar sits above bottom navigation

**Visual Style**
- Product grid is the hero — images should be large and clear
- Category chips are the primary filter mechanism — first chip (Semua) always selected by default
- Fast scrolling performance is critical — use ListView.builder with cacheExtent

**UX Notes**
- Search should filter in real-time (debounced 300ms)
- Category chips update grid instantly (no page transition)
- "Produk tidak ditemukan" empty state with search tip

---

### Screen 11 — POS — Split View (Tablet)

**File**: `lib/features/pos/presentation/screens/pos_tablet_screen.dart`
**Route**: `/pos` (auto-redirect when shortestSide >= 600)
**Role**: All

**Purpose**
Tablet-optimized POS with simultaneous product browsing and cart view.

**Layout**
- Two-panel layout (Row):
  - Left panel (60% width): product grid — same as phone POS but 3 columns
    - Category chips
    - Search bar
    - Product grid
  - Right panel (40% width): cart / order summary
    - "Pesanan" title
    - List of cart items (scrollable)
    - Subtotal, discount, total
    - Customer name field (inline, optional)
    - "Proses Pembayaran" button — bottom of right panel
- No bottom navigation bar — use side navigation rail instead

**Navigation Rail (Tablet)**
- Left edge: vertical icon rail
- Icons: Home, POS, History, Products, Account
- Active icon: filled, primary color
- Labels below icons (optional, follow Figma)

**Right Panel Cart Design**
- Each cart item: product name + qty controls (− qty +) + line price
- Qty controls: tappable minus and plus, large touch targets
- Delete item: swipe left or trash icon
- Discount row: optional, shows if discount applied
- Total row: large, prominent

**Visual Style**
- Professional cashier workstation feel
- Clear visual separation between left and right panels (divider line or background tint difference)
- Right panel feels like a receipt in progress

---

### Screen 12 — POS — Favorites Tab

**File**: `lib/features/pos/presentation/pos_favorites_tab.dart`
**Route**: Tab within `/pos`
**Role**: All

**Purpose**
Quick access to most-sold or manually-pinned products. Reduces taps for repeat transactions.

**Layout**
- Same structure as product grid screen
- Tab bar at top: "Semua Produk" | "Favorit" (or integrated with category chips)
- Favorites grid: same product card design
- Empty state: "Belum ada produk favorit. Tekan lama produk untuk menambahkan ke favorit."
- No category chips needed (favorites are already filtered)

**How Products Become Favorites**
- Long press on any product card → bottom sheet: "Tambah ke Favorit" / "Hapus dari Favorit"
- Owner can also set favorites from Product List screen

**Visual Style**
- Identical to main product grid for visual consistency
- Favorites tab indicator: subtle star icon or just the tab label

---

### Screen 13 — POS — Manual Input

**File**: `lib/features/pos/presentation/screens/pos_manual_input_screen.dart`
**Route**: `/pos/manual-input`
**Role**: All

**Purpose**
Add a custom item to cart without a registered product — for one-off items or services.

**Layout**
- App bar: "Input Manual" title + back arrow
- Form:
  - Item name (text field, required)
  - Price (numeric keyboard, Rupiah format)
  - Quantity (number stepper: − n +)
  - Note / description (optional, text area)
- "Tambah ke Keranjang" button — full width, bottom

**Visual Style**
- Simple form, nothing fancy
- Price field shows live Rupiah format as user types (e.g., 50000 → Rp 50.000)
- Quantity stepper is large and tappable

**UX Notes**
- Pre-fill quantity = 1
- After adding: navigate back to POS, show cart summary bar update
- Item appears in cart as custom item (no product image, placeholder icon)

---

### Screen 14 — Cart / Place Order

**File**: `lib/features/transaction/presentation/screens/cart_screen.dart`
**Route**: `/cart`
**Role**: All

**Purpose**
Review order before payment. Adjust quantities, apply discount, add customer.

**Layout**
- App bar: "Pesanan" title + back arrow (back to POS)
- Cart item list (scrollable):
  - Each item: image thumbnail, name, qty controls, line price, delete swipe
- Divider
- Order summary section:
  - Subtotal
  - Discount row (show only if discount applied, tappable to edit)
  - Tax row (if enabled in store settings)
  - Total (large, bold)
- Customer section: "Tambah Pelanggan" → navigates to Customer Input screen
  - If customer already selected: shows name + phone + "Ganti" option
- Discount button: "Tambah Diskon" (opens bottom sheet: % or flat amount)
- Note field: "Catatan pesanan" (optional)
- Bottom CTA: "Bayar Rp xx.xxx" — full width, primary button

**Cart Item Design**
- Image: small square thumbnail (40dp) or placeholder
- Name: medium, 2-line max
- Qty controls: − [n] + inline
- Line price: right-aligned
- Swipe left: shows red delete button

**Discount Bottom Sheet**
- Toggle: Persen (%) / Nominal (Rp)
- Input field with keyboard
- Preview: shows resulting total
- "Terapkan" button

**Visual Style**
- This is the review step — make totals large and unambiguous
- Customer section should feel optional but available
- The "Bayar" button carries the total — no surprises at payment screen

**UX Notes**
- If cart is empty: show empty state with "Kembali ke POS" button
- If quantity reduced to 0: auto-remove item
- Swipe-to-delete with undo snackbar (3s timer)

---

### Screen 15 — Customer Input

**File**: `lib/features/transaction/presentation/screens/customer_input_screen.dart`
**Route**: `/cart/customer`
**Role**: All

**Purpose**
Attach a customer to the transaction. Optional but useful for loyalty and history tracking.

**Layout**
- App bar: "Pilih Pelanggan" + back arrow
- Search bar at top: search by name or phone
- Two sections:
  - "Pelanggan Tersimpan" — list of existing customers (search-filtered)
  - "Tambah Pelanggan Baru" — collapsible form or button to mini-form
- Each customer list item: avatar/initials, name, phone, last purchase date
- On tap: select customer and navigate back to Cart
- "Lanjut Tanpa Pelanggan" text button at bottom

**New Customer Mini Form**
- Name (required)
- Phone number (optional)
- "Simpan & Pilih" button

**Visual Style**
- Search-first interaction — most common case is finding an existing customer
- Customer list item feels like a contact entry
- "Lanjut Tanpa Pelanggan" is clearly de-emphasized (text/ghost button)

---

### Screen 16 — Payment — Cash

**File**: `lib/features/transaction/presentation/screens/payment_cash_screen.dart`
**Route**: `/payment/cash`
**Role**: All

**Purpose**
Process cash payment. Calculate and display change automatically.

**Layout**
- App bar: "Pembayaran Tunai" + back arrow
- Total amount display: large center (e.g., "Rp 85.000")
- "Uang Diterima" label
- Amount received: large number display (like a calculator readout)
- Kembalian (change): prominent, auto-calculated
  - Green when positive (change to give)
  - Zero when exact
  - Red if amount entered is less than total
- Quick amount buttons: row of suggested amounts (total, round up options)
  - e.g., if total is Rp 85.000 → show buttons: Rp 85.000 / Rp 100.000 / Rp 150.000 / Rp 200.000
- Custom numeric keypad (large, easy to press)
- "Konfirmasi Pembayaran" button: enabled only when received ≥ total

**Change Display**
- "Kembalian: Rp xx.xxx" — large text
- Animate the number when it changes
- If exact: "Pas, tidak ada kembalian" message

**Visual Style**
- Calculator aesthetic — clear, numerical, no distraction
- The change number is the most important visual element
- Quick amount buttons save time for common transactions

**UX Notes**
- Backspace on custom keypad
- If cashier enters amount then edits: recalculate instantly
- On confirm: proceed to Success screen

---

### Screen 17 — Payment — QRIS / Non-Cash

**File**: `lib/features/transaction/presentation/screens/payment_qris_screen.dart`
**Route**: `/payment/qris`
**Role**: All

**Purpose**
Display QR code for customer to scan and pay. Cashier confirms receipt.

**Layout**
- App bar: "Pembayaran QRIS" + back arrow
- Payment amount: "Total: Rp xx.xxx" — prominent top
- QR code: large square, centered, plenty of white space padding
- QRIS logo below QR code
- Timer: "QR berlaku selama 05:00" — countdown
- Instructions: "Minta pelanggan scan QR ini"
- Two buttons at bottom:
  - "Sudah Dibayar" (primary) — manual confirmation
  - "Ganti Metode Pembayaran" (ghost) — go back

**QR Code Design**
- White background card around QR (even in dark environments, must be scannable)
- Border around QR card: rounded corners
- QR should be 200-220dp minimum

**Visual Style**
- QR takes center stage — everything else is secondary
- Instructions are calm and clear
- Timer adds urgency without stress (refresh QR automatically on expire)

**UX Notes**
- If payment gateway integration is active: poll for payment status every 3 seconds
- On payment confirmed: auto-navigate to Success (no manual confirm needed)
- If no integration (manual confirm): "Sudah Dibayar" button triggers success flow

---

### Screen 18 — Payment — Split Payment

**File**: `lib/features/transaction/presentation/screens/payment_split_screen.dart`
**Route**: `/payment/split`
**Role**: All

**Purpose**
Handle transactions paid with a combination of cash and QRIS/transfer.

**Layout**
- App bar: "Bayar Sebagian" + back arrow
- Total amount at top
- Two payment sections:
  - Section 1: "Tunai" — amount input + label
  - Section 2: "QRIS / Transfer" — remaining amount (auto-calculated)
- Both amounts are editable — changing one auto-adjusts the other
- Summary: Total = Cash + Non-Cash (must balance)
- "Proses Pembayaran" button — enabled when amounts balance

**Visual Style**
- Two clearly separated input areas
- Real-time balance calculation is the core interaction
- Error state: "Jumlah tidak sesuai" if amounts don't match total

---

### Screen 19 — Transaction Success

**File**: `lib/features/transaction/presentation/screens/transaction_success_screen.dart`
**Route**: `/transaction/success`
**Role**: All

**Purpose**
Confirm that transaction is complete. Give options for next action.

**Layout**
- Full screen, no app bar, no bottom navigation
- Center: success icon (large checkmark, animated in)
- "Transaksi Berhasil!" heading
- Transaction summary:
  - Total paid
  - Payment method
  - Transaction ID / reference number
  - Time
- Action buttons (stacked or row):
  - "Cetak Struk" (primary or secondary)
  - "Bagikan Struk" (via WhatsApp or share sheet)
  - "Transaksi Baru" (primary) — clears cart, back to POS
- Optional: animated confetti or checkmark draw animation (subtle, not distracting)

**Visual Style**
- Positive, clean, celebratory but not excessive
- The success icon should be instantly recognizable (green circle + check)
- "Transaksi Baru" button is the most common next action — make it prominent

**UX Notes**
- Android back press from this screen → POS (not back to payment)
- This screen must not be dismissible until user takes action
- Auto-print if Bluetooth printer is connected and auto-print is enabled in settings

---

### Screen 20 — Receipt Preview

**File**: `lib/features/transaction/presentation/screens/receipt_preview_screen.dart`
**Route**: `/transaction/receipt`
**Role**: All

**Purpose**
Show digital receipt. Options to print or share.

**Layout**
- App bar: "Struk" + back + share icon (top right)
- Receipt card (scrollable, white background, receipt-style):
  - Store logo + name (header)
  - Address, phone
  - Divider (dashed line)
  - Transaction date + time + transaction ID
  - Divider
  - Item list: name | qty | price per line
  - Divider
  - Subtotal, discount, tax, total
  - Divider
  - Payment method + amount paid + change
  - Divider
  - Footer text (from receipt settings)
  - QR code (optional, for digital verification)
- Bottom buttons:
  - "Cetak via Bluetooth" (if printer connected)
  - "Bagikan" (system share sheet — image or PDF)

**Receipt Card Design**
- Monospaced font or receipt-style layout (simulate thermal print aesthetic)
- Dashed dividers (- - - - -)
- Store logo at top, centered
- All amounts right-aligned
- This card can be screenshotted or converted to image for sharing

**Visual Style**
- The receipt itself should look like an actual receipt
- Surrounding app chrome is minimal — the receipt is the content
- Clean white card on neutral background

---

### Screen 21 — Void / Refund

**File**: `lib/features/transaction/presentation/screens/void_refund_screen.dart`
**Route**: `/transaction/void`
**Role**: Owner only

**Purpose**
Cancel or reverse a completed transaction with an audit trail.

**Layout**
- App bar: "Batalkan Transaksi" + back arrow
- Transaction summary card (read-only):
  - Transaction ID
  - Date/time
  - Items list
  - Total amount
  - Payment method
- Reason selection:
  - Radio options: "Salah input" / "Pelanggan membatalkan" / "Produk tidak tersedia" / "Lainnya"
  - If "Lainnya": text area for custom reason
- Warning text: "Tindakan ini tidak dapat dibatalkan. Stok akan dikembalikan."
- Two buttons:
  - "Batalkan" (ghost) — go back without voiding
  - "Konfirmasi Void" (destructive red button)
- Confirmation dialog before executing

**Visual Style**
- Serious, deliberate UI — this is a destructive action
- Red confirmation button with confirmation dialog
- Warning text in amber/warning color
- Reason is required — button disabled until reason selected

**UX Notes**
- Only Owner can access this screen — route guard enforced
- After void: transaction marked as voided in history, stock restored
- Audit log created with who voided, when, and reason

---

## Batch 2 — History, Reports, Products

---

### Screen 22 — History — Transaction List

**File**: `lib/features/history/presentation/screens/history_screen.dart`
**Route**: `/history`
**Role**: All (Employee sees only their own transactions)

**Purpose**
Browse completed transactions. Search and filter.

**Layout**
- App bar: "Riwayat" title + filter icon (top right) → opens Filter screen
- Search bar below app bar (search by transaction ID or customer name)
- Date tab or chip row: Hari ini / Kemarin / 7 Hari / 30 Hari / Custom
- Transaction list:
  - Each item: date/time (left), customer name or "Umum", total (right), payment method badge
  - Status badge: Selesai (green), Void (red)
  - On tap → Transaction Detail screen

**Transaction List Item Design**
- Left: date + time (stacked, small)
- Center: customer name + item count summary ("3 produk")
- Right: total amount (bold) + payment method badge (Cash/QRIS)
- Bottom border separator

**Visual Style**
- List-heavy screen — keep items compact but scannable
- Payment method badges: small pill, color-coded (Cash = amber, QRIS = blue)
- Void transactions: muted/struck-through

---

### Screen 23 — History — Filter

**File**: `lib/features/history/presentation/screens/history_filter_screen.dart`
**Route**: `/history/filter`
**Role**: All

**Purpose**
Filter transaction history by date range, payment method, status, and cashier.

**Layout**
- Bottom sheet (slides up from bottom, handle at top)
- OR full screen with app bar — follow Figma
- Filter sections:
  - "Rentang Tanggal": date range picker (from → to)
  - "Metode Pembayaran": chips (Semua / Tunai / QRIS / Transfer / Split)
  - "Status": chips (Semua / Selesai / Void)
  - "Kasir" (Owner only): dropdown or chips with employee names
- Bottom buttons:
  - "Reset Filter" (ghost)
  - "Terapkan Filter" (primary)

**Visual Style**
- Filter as bottom sheet feels native on mobile
- Chips for multiple-choice filters, date picker for range
- Active filter count badge on the filter icon in History screen

---

### Screen 24 — Transaction Detail

**File**: `lib/features/history/presentation/screens/transaction_detail_screen.dart`
**Route**: `/history/:id`
**Role**: All

**Purpose**
Full detail of a single transaction. View items, totals, receipt, initiate void.

**Layout**
- App bar: "Detail Transaksi" + back + share icon
- Transaction info card:
  - Transaction ID (copyable)
  - Date and time
  - Kasir name
  - Payment method
  - Status badge
- Items section:
  - Each product: name + qty + price
- Summary section: subtotal, discount, tax, total, paid, change
- Customer section (if attached): name + phone
- Notes section (if any)
- Action buttons (Owner only, if status = Selesai):
  - "Void Transaksi" (red outline button)
- "Lihat Struk" button for all users

**Visual Style**
- Information-dense but organized with clear sections
- Section headings help scan quickly
- Void button is present but not prominent — it's an edge case action

---

### Screen 25 — Report — Sales

**File**: `lib/features/history/presentation/screens/report_screen.dart`
**Route**: `/reports`
**Role**: Owner only

**Purpose**
Sales analytics and business insights. Revenue trends, top products, payment breakdown.

**Layout**
- App bar: "Laporan" + date range selector (top right)
- Period tabs: Hari ini / Minggu ini / Bulan ini / Custom
- Summary metrics row:
  - Total omzet (revenue)
  - Total transaksi
  - Rata-rata nilai transaksi
  - Total item terjual
- Revenue chart: bar chart or line chart, daily/weekly breakdown
- "Produk Terlaris" section: ranked list with rank number, name, qty sold, revenue
- "Metode Pembayaran" section: pie or horizontal bar breakdown (Cash vs QRIS vs Transfer)
- Export button: "Ekspor ke Excel / PDF" (based on plan)

**Chart Design**
- Bar chart: bars in primary color, selected bar highlighted
- Axis labels: compact (e.g., "Sen", "Sel", "Rab" for days)
- Tap on bar: show tooltip with exact value
- Use fl_chart or syncfusion_flutter_charts package (confirm package choice)

**Visual Style**
- Dashboard energy but mobile-appropriate — no overcrowded charts
- Metric cards at top give instant answer; charts provide context
- Product list is clean ranked list, not a complex table

---

### Screen 26 — Shift Close

**File**: `lib/features/history/presentation/screens/shift_close_screen.dart`
**Route**: `/shift/close`
**Role**: All (Employee closes their shift, Owner sees all shifts)

**Purpose**
End-of-shift summary. Shows transaction count, total cash, total QRIS, discrepancy.

**Layout**
- App bar: "Tutup Kasir" + close/back
- Shift info: shift start time → now
- Cashier name
- Summary cards:
  - Total transaksi
  - Total tunai (cash)
  - Total QRIS / non-tunai
  - Total semua metode
- Cash drawer reconciliation:
  - "Modal awal" (opening cash — entered at shift start)
  - "Total tunai masuk"
  - "Uang di laci seharusnya" = modal + tunai masuk
  - "Uang dihitung aktual" — input field (cashier counts physical cash)
  - "Selisih" — auto-calculated (green = match, red = discrepancy)
- Notes field (optional)
- "Tutup Shift" button (primary)
- "Batal" button (ghost)

**Visual Style**
- Financial summary layout — clean, tabular
- Discrepancy number is the most important: green 0 = perfect, red = problem
- Serious but not intimidating

---

### Screen 27 — Product List

**File**: `lib/features/product/presentation/screens/product_list_screen.dart`
**Route**: `/products`
**Role**: Owner only

**Purpose**
View and manage all products. Search, filter by category, CRUD actions.

**Layout**
- App bar: "Produk" + add button (+ icon top right)
- Search bar
- Category filter chips (horizontal scroll)
- Sort option (by name / price / stock / newest)
- Product list (list view, not grid — more info per row):
  - Each item: thumbnail, name, category, price, stock count, active/inactive toggle
  - On tap → Product Form (edit mode)
  - Swipe left → delete (with confirmation)

**Product List Item Design**
- Small square thumbnail (48dp)
- Name: medium, bold
- Category + stock: small, muted
- Price: right-aligned, primary color
- Toggle: active/inactive (published or hidden from POS)

**Visual Style**
- Management tool feel — more data per row than POS grid
- Low stock indicator: amber badge on stock number
- Out of stock: stock number in red

---

### Screen 28 — Product Form (Add / Edit)

**File**: `lib/features/product/presentation/screens/product_form_screen.dart`
**Route**: `/products/add` or `/products/:id/edit`
**Role**: Owner only

**Purpose**
Create a new product or edit an existing one. Same screen, different mode.

**Layout**
- App bar: "Tambah Produk" or "Edit Produk" + back + save icon (checkmark)
- Scrollable form:
  - Product photo: tap to upload (rectangle, 16:9 or square — follow Figma)
  - Product name (required)
  - Category (dropdown/select — from category list)
  - Selling price (required, Rupiah format)
  - Cost price (optional, for profit tracking)
  - SKU / Barcode (optional — text input + scan icon to open scanner)
  - Stock count (number input)
  - Minimum stock alert (number — triggers low stock notification)
  - Description (optional, text area)
  - Active toggle: "Tampilkan di POS"
  - Favorite toggle: "Tambah ke Favorit"
- Save button: full width at bottom (or app bar icon)

**Visual Style**
- Clean form — same style as Register/Login forms
- Photo upload area is prominent (product image matters)
- Barcode field has scan icon that opens camera scanner inline
- Cost price field is muted — it's internal data, not shown to cashiers

**UX Notes**
- In edit mode: pre-fill all fields
- Unsaved changes: show "Buang perubahan?" dialog on back press
- Image upload: compress to 800px max before upload

---

### Screen 29 — Category Management

**File**: `lib/features/product/presentation/screens/category_screen.dart`
**Route**: `/products/categories`
**Role**: Owner only

**Purpose**
Create and manage product categories that appear as filter chips in POS and product list.

**Layout**
- App bar: "Kategori" + add button
- Category list:
  - Each item: color dot, category name, product count, edit + delete icons
  - Drag handle for reordering
- Add/Edit category: inline editing or small bottom sheet
  - Category name
  - Color selector (small palette of preset colors)
  - "Simpan" button

**Visual Style**
- Simple list management
- Color dots make categories visually distinct in POS
- Drag-to-reorder shows priority/order in POS chips

---

### Screen 30 — Stock & Inventory

**File**: `lib/features/product/presentation/screens/stock_screen.dart`
**Route**: `/products/stock`
**Role**: Owner only

**Purpose**
Monitor and adjust stock levels across all products.

**Layout**
- App bar: "Stok & Inventori" + filter icon
- Filter chips: Semua / Stok Menipis / Stok Habis
- Stock list:
  - Each item: product name, current stock, min stock threshold, quick +/− adjustment
  - Stock indicator: green (OK), amber (low), red (out)
- "Sesuaikan Stok" action on each row: tap to open stock adjustment sheet
  - Type: Masuk (in) / Keluar (out) / Koreksi
  - Amount
  - Notes (required for adjustments)
  - "Simpan" button

**Visual Style**
- Inventory management feel — scannable rows, color-coded status
- Stock adjustment is a common action — make it easy inline, not a new screen

---

### Screen 31 — Barcode Scanner

**File**: `lib/features/product/presentation/screens/barcode_scanner_screen.dart`
**Route**: `/scanner`
**Role**: All

**Purpose**
Camera-based barcode scanner. Used in POS (find product) and Product Form (assign barcode).

**Layout**
- Full screen camera view
- App bar: back button + "Scan Barcode" title (overlay on camera)
- Scanner viewfinder: centered square with corner marks (not a full rectangle overlay)
- Instruction text below viewfinder: "Arahkan kamera ke barcode"
- Manual input fallback: "Input manual" text button at bottom
- Torch/flashlight toggle icon (top right)

**Visual Style**
- Dark overlay around the scan area to focus attention
- Corner marks are the only UI inside camera view
- Clean, minimal — the camera is the UI

**UX Notes**
- On scan success: haptic feedback + beep (if sound enabled) + auto-navigate
- If barcode not found in products: show "Produk tidak ditemukan. Tambah produk baru?" dialog
- Handle both 1D (barcodes) and 2D (QR codes)

---

## Batch 3 — CRM, Employees, Settings

---

### Screen 32 — Customer List

**File**: `lib/features/customer/presentation/screens/customer_list_screen.dart`
**Route**: `/customers`
**Role**: Owner only

**Purpose**
View and manage all customers who have been saved through transactions.

**Layout**
- App bar: "Pelanggan" + add button
- Search bar (by name or phone)
- Sort: by name / total spent / last purchase
- Customer list:
  - Each item: initials avatar, name, phone, total transactions, total spent
  - On tap → Customer Detail

**Customer List Item**
- Circle avatar with initials (color generated from name)
- Name: bold
- Phone: muted, small
- Right: total spent amount + transaction count

---

### Screen 33 — Customer Detail

**File**: `lib/features/customer/presentation/screens/customer_detail_screen.dart`
**Route**: `/customers/:id`
**Role**: Owner only

**Purpose**
Full customer profile with purchase history and lifetime value.

**Layout**
- App bar: customer name + edit icon
- Profile header: large avatar, name, phone, member since date
- Stats row: total transaksi, total belanja, rata-rata nilai transaksi
- "Riwayat Transaksi" section: list of past transactions (same style as History list)
- Edit button: edit name/phone

---

### Screen 34 — Employee List

**File**: `lib/features/employee/presentation/screens/employee_list_screen.dart`
**Route**: `/employees`
**Role**: Owner only

**Purpose**
Manage employee accounts. Add, edit, set PIN, and deactivate.

**Layout**
- App bar: "Karyawan" + add button
- Employee list:
  - Each item: avatar, name, role label, status (Active/Inactive), last active time
  - On tap → Employee detail / edit sheet
- Add employee: bottom sheet or new screen
  - Full name
  - PIN (6 digits, set by owner)
  - Confirm PIN
  - Active toggle

**Visual Style**
- Similar to Customer List but simpler — employees don't have financial stats
- Status badge: green Active, gray Inactive

---

### Screen 35 — Employee Performance

**File**: `lib/features/employee/presentation/screens/employee_performance_screen.dart`
**Route**: `/employees/performance`
**Role**: Owner only

**Purpose**
Compare cashier performance across a time period.

**Layout**
- App bar: "Performa Karyawan" + date range
- Period tabs: Hari ini / Minggu ini / Bulan ini
- Performance list (ranked):
  - Each item: rank number, name, transaction count, total revenue handled, average transaction value
- Tap on employee → their filtered transaction history

**Visual Style**
- Leaderboard feel — rank numbers, top performer highlighted subtly
- No gamification pressure — just informational

---

### Screen 36 — Profile & Account

**File**: `lib/features/settings/presentation/screens/profile_screen.dart`
**Route**: `/settings/profile`
**Role**: All

**Purpose**
View and edit own account information. Change password.

**Layout**
- App bar: "Profil" + save icon (appears when editing)
- Profile photo: circle, tappable to change
- Name field
- Email field (read-only for Employee — set by Owner)
- Phone field
- "Ganti Password" section: old password + new password + confirm (collapsible)
- "Keluar" (Logout) button — at bottom, ghost/text style
- Logout shows confirmation dialog

---

### Screen 37 — Store Settings

**File**: `lib/features/settings/presentation/screens/store_settings_screen.dart`
**Route**: `/settings/store`
**Role**: Owner only

**Purpose**
Configure store information, tax settings, and discount policies.

**Layout**
- App bar: "Pengaturan Toko"
- Scrollable form:
  - Store logo (upload)
  - Store name
  - Business category
  - Address
  - Phone
  - NPWP (optional, for tax purposes)
  - Tax section:
    - Enable tax toggle
    - Tax percentage (e.g., PPN 11%)
    - Tax label (e.g., "PPN")
  - Discount section:
    - Allow employee to apply discount toggle
    - Maximum discount percentage (if above toggle enabled)
  - Currency: IDR (locked, display only)
- Save button: full width bottom

---

### Screen 38 — Receipt Settings

**File**: `lib/features/settings/presentation/screens/receipt_settings_screen.dart`
**Route**: `/settings/receipt`
**Role**: Owner only

**Purpose**
Customize what appears on printed and digital receipts.

**Layout**
- App bar: "Pengaturan Struk"
- Live preview card at top: mini receipt preview that updates as user edits
- Settings form:
  - Show store logo toggle
  - Header text (store name + address — auto from store settings, editable here)
  - Footer message (custom text, e.g., "Terima kasih telah berbelanja!")
  - Show cashier name toggle
  - Show transaction ID toggle
  - Show tax breakdown toggle
  - Paper width: 58mm / 80mm (for Bluetooth printer)
  - Bluetooth printer pairing: "Hubungkan Printer" button
- Save button

**Visual Style**
- Live preview is the key UX feature — owner sees changes before saving
- Receipt preview widget is the scrollable center of the screen

---

### Screen 39 — Payment Method Settings

**File**: `lib/features/settings/presentation/screens/payment_method_settings_screen.dart`
**Route**: `/settings/payment-methods`
**Role**: Owner only

**Purpose**
Enable or disable payment methods available during checkout.

**Layout**
- App bar: "Metode Pembayaran"
- List of payment methods:
  - Tunai (Cash) — always enabled, toggle disabled
  - QRIS — toggle + QRIS setup (merchant ID, upload QR image)
  - Transfer Bank — toggle + bank account details (bank name, account number, account name)
- Each method: icon + method name + description + toggle
- QRIS section (if enabled): QR code upload area + preview

**Visual Style**
- Simple toggle list
- Expanded sections show additional config when method is enabled
- Upload QR image: shows preview of uploaded QRIS image

---

### Screen 40 — Subscription & Billing

**File**: `lib/features/settings/presentation/screens/subscription_screen.dart`
**Route**: `/settings/subscription`
**Role**: Owner only

**Purpose**
View current plan, billing history, and upgrade options.

**Layout**
- App bar: "Langganan"
- Current plan card:
  - Plan name + badge (e.g., "Pro")
  - Renewal date or "Trial berakhir dalam X hari"
  - Feature list of current plan
  - "Ubah Paket" button (ghost)
- Usage section (if plan has limits):
  - Transactions this month: X / Y (with progress bar)
  - Products: X / Y
  - Employees: X / Y
- Billing history: list of past payments
  - Date, amount, plan, status (Berhasil / Gagal)
  - Download invoice button per row
- Upgrade section: show next plan benefits if not on highest plan

**Visual Style**
- Account/billing page — professional and informative
- Trial urgency: if < 3 days left, show red/amber banner
- Usage bars: progress bar style, color changes as limit approaches

---

### Screen 41 — Notification Settings

**File**: `lib/features/settings/presentation/screens/notification_settings_screen.dart`
**Route**: `/settings/notifications`
**Role**: All

**Purpose**
Control which push notifications the user receives.

**Layout**
- App bar: "Notifikasi"
- Toggle list by category:
  - Transaksi:
    - Konfirmasi pembayaran masuk (QRIS auto-confirm) — toggle
  - Stok (Owner only):
    - Peringatan stok menipis — toggle
    - Stok habis — toggle
  - Laporan (Owner only):
    - Ringkasan harian (jam pengiriman) — toggle + time picker
    - Ringkasan mingguan — toggle
  - Langganan (Owner only):
    - Pengingat perpanjangan — toggle
- "Simpan" button bottom

**Visual Style**
- Simple toggle list with section grouping
- Section headers as dividers with labels
- Time picker for report delivery time (shows native time picker)

---

## Notes for Implementation

### Empty States
Every list screen must have a designed empty state. Do not show a blank screen.
- History (no transactions): "Belum ada transaksi. Mulai jual sekarang!"
- Products (no products): "Belum ada produk. Tambah produk pertamamu."
- Customers (no customers): "Belum ada pelanggan tersimpan."
- Favorites (none): "Tekan lama produk di POS untuk menambahkan ke sini."

### Loading States
- List screens: skeleton shimmer (fake rows while loading)
- Detail screens: skeleton cards
- Full-page async operation: centered CircularProgressIndicator + message
- Button during submit: button shows spinner, becomes disabled

### Error States
- API error: full-page error state with "Coba Lagi" button
- No internet: specific "Tidak ada koneksi internet" message
- 401 unauthorized: auto-logout and redirect to Role Selection
- 403 forbidden: show "Kamu tidak punya akses ke fitur ini"
- 404 not found: "Data tidak ditemukan" empty state

### Indonesian Language Rules
All UI text is in Bahasa Indonesia. Rules:
- Currency: always "Rp" prefix, thousand separator dot, no decimal (Rp 10.000)
- Date: "Senin, 1 Januari 2025" format (use intl with 'id' locale)
- Time: 24-hour format (14:30) unless Figma shows otherwise
- Error messages: friendly, clear, non-technical. Not "Error 500" but "Terjadi kesalahan, coba lagi."
- Confirmation dialogs: always "Batal" + action verb (not "OK/Cancel")

---

_Update this file as screens are built. Mark completed screens with [x] in the index table._