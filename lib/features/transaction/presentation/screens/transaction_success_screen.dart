import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/app_button.dart';

/// Transaction Success Screen
/// Confirm transaction is complete with options for next action
class TransactionSuccessScreen extends StatefulWidget {
  const TransactionSuccessScreen({super.key});

  @override
  State<TransactionSuccessScreen> createState() => _TransactionSuccessScreenState();
}

class _TransactionSuccessScreenState extends State<TransactionSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  // TODO: Get from transaction result
  final String _transactionId = 'TRX20260510001';
  final int _totalAmount = 55000;
  final String _paymentMethod = 'Tunai';
  final DateTime _transactionTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  void _initAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _handleNewTransaction();
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    children: [
                      const SizedBox(height: AppSpacing.xxxl),
                      // Success Icon
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_circle,
                            size: 80,
                            color: AppColors.success,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      // Success Message
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          children: [
                            Text(
                              'Transaksi Berhasil!',
                              style: AppTypography.headingLarge,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              'Pembayaran telah diterima',
                              style: AppTypography.bodySmall,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxxl),
                      // Transaction Summary
                      _buildTransactionSummary(),
                      const SizedBox(height: AppSpacing.xxxl),
                      // Action Buttons
                      _buildActionButtons(),
                    ],
                  ),
                ),
              ),
              // New Transaction Button
              Container(
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  border: Border(
                    top: BorderSide(color: AppColors.divider),
                  ),
                ),
                child: AppButton(
                  text: 'Transaksi Baru',
                  onPressed: _handleNewTransaction,
                  icon: Icons.add_shopping_cart,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionSummary() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Column(
        children: [
          _SummaryRow(
            label: 'ID Transaksi',
            value: _transactionId,
            valueStyle: AppTypography.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const Divider(),
          const SizedBox(height: AppSpacing.lg),
          _SummaryRow(
            label: 'Total Pembayaran',
            value: CurrencyFormatter.format(_totalAmount),
            valueStyle: AppTypography.headingMedium.copyWith(
              color: AppColors.success,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _SummaryRow(
            label: 'Metode Pembayaran',
            value: _paymentMethod,
          ),
          const SizedBox(height: AppSpacing.md),
          _SummaryRow(
            label: 'Waktu',
            value: DateFormatter.formatDateTime(_transactionTime),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        _ActionButton(
          icon: Icons.receipt_long,
          label: 'Cetak Struk',
          onTap: () {
            // TODO: Print receipt
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Mencetak struk...'),
                backgroundColor: AppColors.info,
              ),
            );
          },
        ),
        const SizedBox(height: AppSpacing.md),
        _ActionButton(
          icon: Icons.share,
          label: 'Bagikan Struk',
          onTap: () {
            // TODO: Share receipt
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Membagikan struk...'),
                backgroundColor: AppColors.info,
              ),
            );
          },
        ),
        const SizedBox(height: AppSpacing.md),
        _ActionButton(
          icon: Icons.visibility,
          label: 'Lihat Detail',
          onTap: () {
            context.goNamed(AppRoutes.receiptPreviewName);
          },
        ),
      ],
    );
  }

  void _handleNewTransaction() {
    // Clear cart and go back to POS
    context.goNamed(AppRoutes.posName);
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? valueStyle;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.bodySmall,
        ),
        const SizedBox(width: AppSpacing.md),
        Flexible(
          child: Text(
            value,
            style: valueStyle ?? AppTypography.bodyLarge,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Text(
                label,
                style: AppTypography.bodyLarge,
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
