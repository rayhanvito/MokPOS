import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_button.dart';

/// Payment QRIS Screen
/// Display QR code for customer to scan and pay
class PaymentQrisScreen extends StatefulWidget {
  const PaymentQrisScreen({super.key});

  @override
  State<PaymentQrisScreen> createState() => _PaymentQrisScreenState();
}

class _PaymentQrisScreenState extends State<PaymentQrisScreen> {
  // TODO: Get from cart provider
  final int _totalAmount = 55000;
  
  Timer? _countdownTimer;
  int _remainingSeconds = 300; // 5 minutes
  bool _isChecking = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
    // TODO: Start polling payment status from backend
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        timer.cancel();
        _showExpiredDialog();
      }
    });
  }

  void _showExpiredDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('QR Code Kadaluarsa'),
        content: const Text(
          'QR code telah kadaluarsa. Silakan buat QR code baru.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.pop();
            },
            child: const Text('Kembali'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _remainingSeconds = 300;
                _startCountdown();
              });
            },
            child: const Text('Buat Baru'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleManualConfirm() async {
    setState(() => _isChecking = true);

    // TODO: Check payment status from backend
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() => _isChecking = false);

    // Simulate payment confirmed
    context.goNamed(AppRoutes.transactionSuccessName);
  }

  String get _formattedTime {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Pembayaran QRIS'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // TODO: Navigate to other payment methods
              context.pop();
            },
            child: const Text('Ganti Metode'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  children: [
                    // Total Amount
                    Text(
                      'Total Pembayaran',
                      style: AppTypography.bodySmall,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      CurrencyFormatter.format(_totalAmount),
                      style: AppTypography.displayLarge.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxxl),
                    // QR Code
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                        border: Border.all(color: AppColors.border, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadowDark,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          QrImageView(
                            data: 'QRIS_PAYMENT_${_totalAmount}_${DateTime.now().millisecondsSinceEpoch}',
                            version: QrVersions.auto,
                            size: 240,
                            backgroundColor: AppColors.background,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          // QRIS Logo
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                              vertical: AppSpacing.sm,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.qr_code,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Text(
                                  'QRIS',
                                  style: AppTypography.bodyLarge.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    // Timer
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.md,
                      ),
                      decoration: BoxDecoration(
                        color: _remainingSeconds < 60
                            ? AppColors.error.withOpacity(0.1)
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            color: _remainingSeconds < 60
                                ? AppColors.error
                                : AppColors.textSecondary,
                            size: 20,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'QR berlaku selama $_formattedTime',
                            style: AppTypography.bodySmall.copyWith(
                              color: _remainingSeconds < 60
                                  ? AppColors.error
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    // Instructions
                    _buildInstructions(),
                  ],
                ),
              ),
            ),
            // Bottom Buttons
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: const BoxDecoration(
                color: AppColors.background,
                border: Border(
                  top: BorderSide(color: AppColors.divider),
                ),
              ),
              child: Column(
                children: [
                  AppButton(
                    text: 'Sudah Dibayar',
                    onPressed: _handleManualConfirm,
                    isLoading: _isChecking,
                    icon: Icons.check_circle,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppButton.secondary(
                    text: 'Ganti Metode Pembayaran',
                    onPressed: () => context.pop(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructions() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline,
                color: AppColors.info,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Cara Pembayaran',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.info,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _InstructionItem(
            number: '1',
            text: 'Buka aplikasi e-wallet atau mobile banking',
          ),
          const SizedBox(height: AppSpacing.sm),
          _InstructionItem(
            number: '2',
            text: 'Pilih menu Scan QR atau QRIS',
          ),
          const SizedBox(height: AppSpacing.sm),
          _InstructionItem(
            number: '3',
            text: 'Scan QR code di atas',
          ),
          const SizedBox(height: AppSpacing.sm),
          _InstructionItem(
            number: '4',
            text: 'Konfirmasi pembayaran di aplikasi Anda',
          ),
        ],
      ),
    );
  }
}

class _InstructionItem extends StatelessWidget {
  final String number;
  final String text;

  const _InstructionItem({
    required this.number,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: AppColors.info,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: AppTypography.caption.copyWith(
                color: AppColors.textWhite,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            text,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.info,
            ),
          ),
        ),
      ],
    );
  }
}
