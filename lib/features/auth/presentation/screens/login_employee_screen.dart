import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_typography.dart';
import '../widgets/pin_pad_widget.dart';

/// Login Employee Screen
/// Employee logs in with 6-digit PIN
class LoginEmployeeScreen extends StatefulWidget {
  const LoginEmployeeScreen({super.key});

  @override
  State<LoginEmployeeScreen> createState() => _LoginEmployeeScreenState();
}

class _LoginEmployeeScreenState extends State<LoginEmployeeScreen> {
  String _pin = '';
  bool _isLoading = false;
  int _failedAttempts = 0;
  static const int _maxPinLength = 6;
  static const int _maxFailedAttempts = 3;

  void _onPinChanged(String pin) {
    setState(() => _pin = pin);

    // Auto-submit when PIN is complete
    if (pin.length == _maxPinLength) {
      _handleLogin();
    }
  }

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);

    // TODO: Implement actual PIN verification
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    // Simulate failed login for demo
    final isSuccess = false; // TODO: Replace with actual verification

    if (isSuccess) {
      // TODO: Navigate to employee home
      // context.goNamed(AppRoutes.homeName);
    } else {
      setState(() {
        _failedAttempts++;
        _pin = '';
        _isLoading = false;
      });

      if (_failedAttempts >= _maxFailedAttempts) {
        _showMaxAttemptsDialog();
      } else {
        _showErrorSnackbar();
      }
    }
  }

  void _showErrorSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'PIN salah. Sisa percobaan: ${_maxFailedAttempts - _failedAttempts}',
        ),
        backgroundColor: AppColors.error,
      ),
    );
  }

  void _showMaxAttemptsDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Terlalu Banyak Percobaan'),
        content: const Text(
          'Anda telah salah memasukkan PIN sebanyak 3 kali. Silakan hubungi pemilik toko.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Title
                    Text(
                      AppStrings.loginAsEmployee,
                      style: AppTypography.headingLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Masukkan PIN 6 digit Anda',
                      style: AppTypography.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xxxl),
                    // Store Name (TODO: Get from actual store data)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.md,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.store,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'Toko Demo', // TODO: Replace with actual store name
                            style: AppTypography.bodyLarge.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxxl),
                    // PIN Dots Display
                    _buildPinDots(),
                    const SizedBox(height: AppSpacing.xxxl),
                    if (_isLoading)
                      const CircularProgressIndicator()
                    else
                      const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            // PIN Pad
            PinPadWidget(
              onPinChanged: _onPinChanged,
              currentPin: _pin,
              maxLength: _maxPinLength,
              enabled: !_isLoading,
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildPinDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _maxPinLength,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: index < _pin.length
                  ? AppColors.primary
                  : AppColors.border,
            ),
          ),
        ),
      ),
    );
  }
}
