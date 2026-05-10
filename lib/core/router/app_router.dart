import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/role_selection_screen.dart';
import '../../features/auth/presentation/screens/login_owner_screen.dart';
import '../../features/auth/presentation/screens/login_employee_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/store_setup_screen.dart';
import '../../features/auth/presentation/screens/choose_plan_screen.dart';
import '../../features/home/presentation/screens/dashboard_owner_screen.dart';
import '../../features/home/presentation/screens/cashier_home_screen.dart';
import '../../features/pos/presentation/screens/pos_screen.dart';
import '../../features/pos/presentation/screens/pos_manual_input_screen.dart';
import '../../features/transaction/presentation/screens/cart_screen.dart';
import '../../features/transaction/presentation/screens/customer_input_screen.dart';
import '../../features/transaction/presentation/screens/payment_cash_screen.dart';
import '../../features/transaction/presentation/screens/payment_qris_screen.dart';
import '../../features/transaction/presentation/screens/payment_split_screen.dart';
import '../../features/transaction/presentation/screens/transaction_success_screen.dart';
import '../../features/transaction/presentation/screens/receipt_preview_screen.dart';
import '../../features/transaction/presentation/screens/void_refund_screen.dart';

/// App router provider
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
      // Auth Routes
      GoRoute(
        path: AppRoutes.splash,
        name: AppRoutes.splashName,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.roleSelection,
        name: AppRoutes.roleSelectionName,
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: AppRoutes.loginOwner,
        name: AppRoutes.loginOwnerName,
        builder: (context, state) => const LoginOwnerScreen(),
      ),
      GoRoute(
        path: AppRoutes.loginEmployee,
        name: AppRoutes.loginEmployeeName,
        builder: (context, state) => const LoginEmployeeScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: AppRoutes.registerName,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.storeSetup,
        name: AppRoutes.storeSetupName,
        builder: (context, state) => const StoreSetupScreen(),
      ),
      GoRoute(
        path: AppRoutes.choosePlan,
        name: AppRoutes.choosePlanName,
        builder: (context, state) => const ChoosePlanScreen(),
      ),

      // Home Routes
      GoRoute(
        path: AppRoutes.home,
        name: AppRoutes.homeName,
        builder: (context, state) {
          // TODO: Check user role and return appropriate screen
          // For now, return owner dashboard
          return const DashboardOwnerScreen();
        },
      ),

      // POS Routes
      GoRoute(
        path: AppRoutes.pos,
        name: AppRoutes.posName,
        builder: (context, state) => const PosScreen(),
      ),
      GoRoute(
        path: AppRoutes.posManualInput,
        name: AppRoutes.posManualInputName,
        builder: (context, state) => const PosManualInputScreen(),
      ),

      // Transaction Routes
      GoRoute(
        path: AppRoutes.cart,
        name: AppRoutes.cartName,
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: AppRoutes.customerInput,
        name: AppRoutes.customerInputName,
        builder: (context, state) => const CustomerInputScreen(),
      ),
      GoRoute(
        path: AppRoutes.paymentCash,
        name: AppRoutes.paymentCashName,
        builder: (context, state) => const PaymentCashScreen(),
      ),
      GoRoute(
        path: AppRoutes.paymentQris,
        name: AppRoutes.paymentQrisName,
        builder: (context, state) => const PaymentQrisScreen(),
      ),
      GoRoute(
        path: AppRoutes.paymentSplit,
        name: AppRoutes.paymentSplitName,
        builder: (context, state) => const PaymentSplitScreen(),
      ),
      GoRoute(
        path: AppRoutes.transactionSuccess,
        name: AppRoutes.transactionSuccessName,
        builder: (context, state) => const TransactionSuccessScreen(),
      ),
      GoRoute(
        path: AppRoutes.receiptPreview,
        name: AppRoutes.receiptPreviewName,
        builder: (context, state) => const ReceiptPreviewScreen(),
      ),
      GoRoute(
        path: AppRoutes.voidRefund,
        name: AppRoutes.voidRefundName,
        builder: (context, state) => const VoidRefundScreen(),
      ),
    ],
  );
});

/// App route paths and names
class AppRoutes {
  AppRoutes._();

  // Auth Routes
  static const String splash = '/splash';
  static const String splashName = 'splash';

  static const String roleSelection = '/role-selection';
  static const String roleSelectionName = 'role-selection';

  static const String loginOwner = '/login/owner';
  static const String loginOwnerName = 'login-owner';

  static const String loginEmployee = '/login/employee';
  static const String loginEmployeeName = 'login-employee';

  static const String register = '/register';
  static const String registerName = 'register';

  static const String storeSetup = '/onboarding/store-setup';
  static const String storeSetupName = 'store-setup';

  static const String choosePlan = '/onboarding/choose-plan';
  static const String choosePlanName = 'choose-plan';

  // Home Routes
  static const String home = '/home';
  static const String homeName = 'home';

  // POS Routes
  static const String pos = '/pos';
  static const String posName = 'pos';

  static const String posManualInput = '/pos/manual-input';
  static const String posManualInputName = 'pos-manual-input';

  // Transaction Routes
  static const String cart = '/cart';
  static const String cartName = 'cart';

  static const String customerInput = '/cart/customer';
  static const String customerInputName = 'customer-input';

  static const String paymentCash = '/payment/cash';
  static const String paymentCashName = 'payment-cash';

  static const String paymentQris = '/payment/qris';
  static const String paymentQrisName = 'payment-qris';

  static const String paymentSplit = '/payment/split';
  static const String paymentSplitName = 'payment-split';

  static const String transactionSuccess = '/transaction/success';
  static const String transactionSuccessName = 'transaction-success';

  static const String receiptPreview = '/transaction/receipt';
  static const String receiptPreviewName = 'receipt-preview';

  static const String voidRefund = '/transaction/void';
  static const String voidRefundName = 'void-refund';

  // History Routes
  static const String history = '/history';
  static const String historyName = 'history';

  static const String historyFilter = '/history/filter';
  static const String historyFilterName = 'history-filter';

  static String transactionDetail(String id) => '/history/$id';
  static const String transactionDetailName = 'transaction-detail';

  static const String reports = '/reports';
  static const String reportsName = 'reports';

  static const String shiftClose = '/shift/close';
  static const String shiftCloseName = 'shift-close';

  // Product Routes
  static const String products = '/products';
  static const String productsName = 'products';

  static const String productAdd = '/products/add';
  static const String productAddName = 'product-add';

  static String productEdit(String id) => '/products/$id/edit';
  static const String productEditName = 'product-edit';

  static const String categories = '/products/categories';
  static const String categoriesName = 'categories';

  static const String stock = '/products/stock';
  static const String stockName = 'stock';

  static const String scanner = '/scanner';
  static const String scannerName = 'scanner';

  // Customer Routes
  static const String customers = '/customers';
  static const String customersName = 'customers';

  static String customerDetail(String id) => '/customers/$id';
  static const String customerDetailName = 'customer-detail';

  // Employee Routes
  static const String employees = '/employees';
  static const String employeesName = 'employees';

  static const String employeePerformance = '/employees/performance';
  static const String employeePerformanceName = 'employee-performance';

  // Settings Routes
  static const String profile = '/settings/profile';
  static const String profileName = 'profile';

  static const String storeSettings = '/settings/store';
  static const String storeSettingsName = 'store-settings';

  static const String receiptSettings = '/settings/receipt';
  static const String receiptSettingsName = 'receipt-settings';

  static const String paymentMethodSettings = '/settings/payment-methods';
  static const String paymentMethodSettingsName = 'payment-method-settings';

  static const String subscription = '/settings/subscription';
  static const String subscriptionName = 'subscription';

  static const String notificationSettings = '/settings/notifications';
  static const String notificationSettingsName = 'notification-settings';
}
