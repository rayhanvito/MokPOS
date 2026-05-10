import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';

/// Payment Split Screen
/// Handle split payment (cash + non-cash)
class PaymentSplitScreen extends StatefulWidget {
  const PaymentSplitScreen({super.key});

  @override
  State<PaymentSplitScreen> createState() => _PaymentSplitScreenState();
}

class _PaymentSplitScreenState extends State<PaymentSplitScreen> {
  // TODO: Get from cart provider
  final int _totalAmount = 100000;

  final TextEditingController _cashController = TextEditingController();
  final TextEditingController _nonCashController = TextEditingController();

  String _selectedNonCashMethod = 'QRIS';
  final List<String> _nonCashMethods = ['QRIS', 'Transfer', 'Debit', 'Kredit'];

  @override
  void dispose() {
    _cashController.dispose();
    _nonCashController.dispose();
    super.dispose();
  }

  int get _cashAmount {
    final text = _cashController.text.replaceAll('.', '');
    return int.tryParse(text) ?? 0;
  }

  int get _nonCashAmount {
    final text = _nonCashController.text.replaceAll('.', '');
    return int.tryParse(text) ?? 0;
  }

  int get _totalPaid => _cashAmount + _nonCashAmount;

  int get _remaining => _totalAmount - _totalPaid;

  bool get _isBalanced => _remaining == 0;

  bool get _canConfirm => _isBalanced && _cashAmount > 0 && _nonCashAmount > 0;

  void _onCashChanged(String value) {
    setState(() {
      // Auto-calculate non-cash amount
      if (_cashAmount > 0 && _cashAmount < _totalAmount) {
        final remaining = _totalAmount - _cashAmount;
        _nonCashController.text = CurrencyFormatter.formatAsTyping(remaining.toString());
      }
    });
  }

  void _onNonCashChanged(String value) {
    setState(() {
      // Auto-calculate cash amount
      if (_nonCashAmount > 0 && _nonCashAmount < _totalAmount) {
        final remaining = _totalAmount - _nonCashAmount;
        _cashController.text = CurrencyFormatter.formatAsTyping(remaining.toString());
      }
    });
  }

  Future<void> _handleConfirmPayment() async {
    if (!_canConfirm) return;

    // TODO: Process split payment
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    context.goNamed(AppRoutes.transactionSuccessName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Bayar Sebagian'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Total Amount
                    Center(
                      child: Column(
                        children: [
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
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxxl),
                    // Info Box
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppColors.info.withOpacity(0.1),
                        border: Border.all(
                          color: AppColors.info.withOpacity(0.3),
                        ),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: AppColors.info,
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Text(
                              'Masukkan jumlah untuk setiap metode pembayaran',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.info,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    // Cash Payment Section
                    _buildPaymentSection(
                      icon: Icons.payments,
                      title: 'Pembayaran Tunai',
                      color: AppColors.success,
                      controller: _cashController,
                      onChanged: _onCashChanged,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    // Non-Cash Payment Section
                    _buildNonCashSection(),
                    const SizedBox(height: AppSpacing.xl),
                    // Balance Summary
                    _buildBalanceSummary(),
                  ],
                ),
              ),
            ),
            // Bottom Button
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: const BoxDecoration(
                color: AppColors.background,
                border: Border(
                  top: BorderSide(color: AppColors.divider),
                ),
              ),
              child: AppButton(
                text: 'Proses Pembayaran',
                onPressed: _canConfirm ? _handleConfirmPayment : null,
                icon: Icons.check_circle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSection({
    required IconData icon,
    required String title,
    required Color color,
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: AppSpacing.md),
              Text(
                title,
                style: AppTypography.bodyLarge.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            controller: controller,
            hint: '0',
            keyboardType: TextInputType.number,
            prefixIcon: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text(
                'Rp',
                style: AppTypography.bodyRegular,
              ),
            ),
            onChanged: (value) {
              final formatted = CurrencyFormatter.formatAsTyping(value);
              if (formatted != value) {
                controller.value = TextEditingValue(
                  text: formatted,
                  selection: TextSelection.collapsed(
                    offset: formatted.length,
                  ),
                );
              }
              onChanged(value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNonCashSection() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.credit_card, color: AppColors.primary),
              const SizedBox(width: AppSpacing.md),
              Text(
                'Pembayaran Non-Tunai',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          // Method Selector
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: _nonCashMethods.map((method) {
              final isSelected = _selectedNonCashMethod == method;
              return ChoiceChip(
                label: Text(method),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() => _selectedNonCashMethod = method);
                },
                backgroundColor: AppColors.surface,
                selectedColor: AppColors.primary,
                labelStyle: AppTypography.bodySmall.copyWith(
                  color: isSelected ? AppColors.textWhite : AppColors.textPrimary,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            controller: _nonCashController,
            hint: '0',
            keyboardType: TextInputType.number,
            prefixIcon: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text(
                'Rp',
                style: AppTypography.bodyRegular,
              ),
            ),
            onChanged: (value) {
              final formatted = CurrencyFormatter.formatAsTyping(value);
              if (formatted != value) {
                _nonCashController.value = TextEditingValue(
                  text: formatted,
                  selection: TextSelection.collapsed(
                    offset: formatted.length,
                  ),
                );
              }
              _onNonCashChanged(value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceSummary() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: _isBalanced
            ? AppColors.success.withOpacity(0.1)
            : AppColors.error.withOpacity(0.1),
        border: Border.all(
          color: _isBalanced
              ? AppColors.success.withOpacity(0.3)
              : AppColors.error.withOpacity(0.3),
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Column(
        children: [
          _SummaryRow(
            label: 'Total',
            value: CurrencyFormatter.format(_totalAmount),
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(),
          const SizedBox(height: AppSpacing.md),
          _SummaryRow(
            label: 'Tunai',
            value: CurrencyFormatter.format(_cashAmount),
            valueColor: AppColors.success,
          ),
          const SizedBox(height: AppSpacing.sm),
          _SummaryRow(
            label: _selectedNonCashMethod,
            value: CurrencyFormatter.format(_nonCashAmount),
            valueColor: AppColors.primary,
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(),
          const SizedBox(height: AppSpacing.md),
          _SummaryRow(
            label: 'Total Dibayar',
            value: CurrencyFormatter.format(_totalPaid),
            isBold: true,
          ),
          if (!_isBalanced) ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _remaining > 0 ? Icons.warning : Icons.error,
                  color: AppColors.error,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  _remaining > 0
                      ? 'Kurang ${CurrencyFormatter.format(_remaining)}'
                      : 'Kelebihan ${CurrencyFormatter.format(_remaining.abs())}',
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ] else ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Jumlah Sesuai',
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isBold;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isBold
              ? AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600)
              : AppTypography.bodyRegular,
        ),
        Text(
          value,
          style: isBold
              ? AppTypography.headingSmall
              : AppTypography.bodyLarge.copyWith(
                  color: valueColor ?? AppColors.textPrimary,
                ),
        ),
      ],
    );
  }
}
