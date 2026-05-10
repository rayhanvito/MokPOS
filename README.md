# MokPOS - Mobile Point of Sale System

![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)
![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

Mobile Point of Sale (POS) application for Android and tablet, built with Flutter. Designed as a SaaS platform where multiple merchants can register and manage their own store.

## 📱 Features

### Authentication & User Management
- ✅ Role-based authentication (Owner & Employee)
- ✅ Owner login with email/password
- ✅ Employee login with 6-digit PIN
- ✅ Registration for new merchants
- ✅ Store setup wizard
- ✅ Subscription plan selection

### Point of Sale
- 🛒 Product grid with search and categories
- ⭐ Favorites tab for quick access
- 📱 Barcode scanner integration
- ✍️ Manual product input
- 🛍️ Shopping cart management
- 💰 Multiple payment methods (Cash, QRIS, Split)
- 🧾 Receipt generation and sharing

### Product Management (Owner Only)
- 📦 Product CRUD operations
- 🏷️ Category management
- 📊 Stock & inventory tracking
- 🔍 Product search and filtering

### Reports & Analytics (Owner Only)
- 📈 Sales dashboard
- 📊 Transaction history
- 💵 Revenue reports
- 👥 Employee performance tracking
- 📅 Shift management

### Customer Management
- 👤 Customer database
- 📞 Customer contact info
- 📜 Purchase history

## 🎨 Design System

The app follows a custom design system extracted from Figma:

### Colors
- **Primary**: `#1A72DD` (Blue)
- **Secondary**: `#F8CF33` (Yellow)
- **Background**: `#FFFFFF` (White)
- **Surface**: `#F5F7FA` (Light Gray)
- **Text Primary**: `#2A3256` (Dark Blue-Gray)
- **Text Secondary**: `#545454` (Medium Gray)

### Typography
- **Font Family**: Rubik (via Google Fonts)
- **Sizes**: 12px - 32px
- **Weights**: Regular (400), Medium (500), SemiBold (600)

### Spacing
- **Scale**: 4, 8, 12, 16, 24, 32, 48
- **Border Radius**: 4, 8, 12, 16, 20, 999 (round)

## 🏗️ Architecture

The project follows **Clean Architecture** with **Feature-First** organization:

```
lib/
├── main.dart
├── core/
│   ├── constants/      # Colors, typography, spacing, strings
│   ├── theme/          # App theme configuration
│   ├── router/         # GoRouter configuration
│   ├── widgets/        # Reusable UI components
│   ├── network/        # Dio client, interceptors
│   ├── storage/        # Secure storage, Hive
│   └── utils/          # Formatters, validators
└── features/
    ├── auth/           # Authentication feature
    ├── home/           # Dashboard feature
    ├── pos/            # Point of Sale feature
    ├── transaction/    # Transaction processing
    ├── history/        # Transaction history
    ├── product/        # Product management
    ├── customer/       # Customer management
    ├── employee/       # Employee management
    └── settings/       # App settings
```

Each feature follows this structure:
```
feature/
├── data/
│   ├── models/
│   ├── repositories/
│   └── datasources/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── screens/
    ├── widgets/
    └── providers/
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.0 or higher
- Dart SDK 3.0 or higher
- Android Studio / VS Code
- Android SDK / iOS SDK

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/mokpos.git
   cd mokpos
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run code generation**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Build Commands

```bash
# Development
flutter run                          # Run on connected device
flutter run -d emulator-5554         # Run on specific emulator

# Build
flutter build apk --release          # Build release APK
flutter build apk --debug            # Build debug APK
flutter build appbundle              # Build for Play Store

# Code Generation
dart run build_runner build --delete-conflicting-outputs
dart run build_runner watch          # Watch mode

# Testing
flutter test                         # Run all tests
flutter analyze                      # Analyze code
dart format .                        # Format code
```

## 📦 Dependencies

### Core
- `flutter_riverpod` - State management
- `go_router` - Navigation
- `dio` - HTTP client
- `hive` - Local database
- `flutter_secure_storage` - Secure token storage

### UI
- `google_fonts` - Rubik font family
- `flutter_svg` - SVG support
- `cached_network_image` - Image caching

### Features
- `mobile_scanner` - Barcode scanning
- `qr_flutter` - QR code generation
- `image_picker` - Image selection
- `intl` - Internationalization & formatting

### Development
- `build_runner` - Code generation
- `json_serializable` - JSON serialization
- `freezed` - Immutable models
- `flutter_lints` - Linting rules

## 📖 Documentation

- [Blueprint](blueprint.md) - Complete technical specification
- [Screens](screen.md) - Detailed screen specifications
- [Design Figma](designfigma.md) - Figma design links

## 🎯 Development Roadmap

### ✅ Phase 1 - Foundation (Current)
- [x] Project setup & structure
- [x] Design system implementation
- [x] Core widgets (Button, TextField, Loading, Empty State)
- [x] Router configuration
- [x] Splash screen
- [x] Role selection screen
- [x] Login screens (Owner & Employee)
- [x] Register screen

### 🚧 Phase 2 - Core POS Features
- [ ] Store setup wizard
- [ ] Plan selection
- [ ] Dashboard (Owner & Employee)
- [ ] POS screen (Phone & Tablet)
- [ ] Product grid with search
- [ ] Favorites tab
- [ ] Manual input
- [ ] Shopping cart
- [ ] Payment screens (Cash, QRIS, Split)
- [ ] Transaction success
- [ ] Receipt preview

### 📋 Phase 3 - Management Features
- [ ] Transaction history
- [ ] Reports & analytics
- [ ] Product management (CRUD)
- [ ] Category management
- [ ] Stock management
- [ ] Barcode scanner
- [ ] Customer management
- [ ] Employee management

### 🎨 Phase 4 - Polish & Optimization
- [ ] Settings screens
- [ ] Profile management
- [ ] Subscription management
- [ ] Offline mode
- [ ] Performance optimization
- [ ] Testing & bug fixes
- [ ] Deployment preparation

## 🤝 Contributing

Contributions are welcome! Please read our contributing guidelines before submitting PRs.

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👥 Team

- **Developer**: Your Name
- **Designer**: Design Team
- **Product Owner**: Product Team

## 📞 Support

For support, email support@mokpos.com or join our Slack channel.

---

**Made with ❤️ using Flutter**
