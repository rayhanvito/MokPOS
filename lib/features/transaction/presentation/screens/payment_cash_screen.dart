import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_button.dart';

/// Payment Cash Screen
/// Process cash payment with change calculator
class PaymentCashScreen extends StatefulWidget {
  const PaymentCashScreen({super.key});

  @override
  State<PaymentCashScreen> createState() => _PaymentCashScreenState();
}

class _PaymentCashScreenState extends State<PaymentCashScreen> {
  // TODO: Get from cart provider
  final int _totalAmount = 55000;
  String _amountReceived = '';

  int get _receivedAmount {
    return _amountReceived.isEmpty ? 0 : int.tryParse(_amountReceived) ?? 0;
  }

  int get _change {
    return _receivedAmount - _totalAmount;
  }

  bool get _canConfirm {
    return _receivedAmount >= _totalAmount;
  }

  void _onNumberPressed(String number) {
    setState(() {
      _amountReceived += number;
    });
  }

  void _onBackspace() {
    if (_amountReceived.isNotEmpty) {
      setState(() {
        _amountReceived = _amountReceived.substring(0, _amountReceived.length - 1);
      });
    }
  }

  void _onClear() {
    setState(() {
      _amountReceived = '';
    });
  }

  void _onQuickAmount(int amount) {
    setState(() {
      _amountReceived = amount.toString();
    });
  }

  Future<void> _handleConfirmPayment() async {
    // TODO: Process payment
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    context.goNamed(AppRoutes.transactionSuccessName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Pembayaran Tunai'),
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
                    // Amount Received Display
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Uang Diterima',
                            style: AppTypography.label,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            _amountReceived.isEmpty
                                ? 'Rp 0'
                                : CurrencyFormatter.format(_receivedAmount),
                            style: AppTypography.displayLarge.copyWith(
                              fontSize: 36,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    // Change Display
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      decoration: BoxDecoration(
                        color: _change >= 0
                            ? AppColors.success.withOpacity(0.1)
                            : AppColors.error.withOpacity(0.1),
                        border: Border.all(
                          color: _change >= 0
                              ? AppColors.success.withOpacity(0.3)
                              : AppColors.error.withOpacity(0.3),
                        ),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Kembalian',
                            style: AppTypography.label.copyWith(
                              color: _change >= 0
                                  ? AppColors.success
                                  : AppColors.error,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          if (_change == 0 && _receivedAmount > 0)
                            Text(
                              'Pas, tidak ada kembalian',
                              style: AppTypography.bodyLarge.copyWith(
                                color: AppColors.success,
                              ),
                            )
                          else if (_change < 0)
                            Text(
                              'Kurang ${CurrencyFormatter.format(_change.abs())}',
                              style: AppTypography.headingMedium.copyWith(
                                color: AppColors.error,
                              ),
                            )
                          else
                            Text(
                              CurrencyFormatter.format(_change),
                              style: AppTypography.displayLarge.copyWith(
                                fontSize: 32,
                                color: AppColors.success,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    // Quick Amount Buttons
                    _buildQuickAmountButtons(),
                  ],
                ),
              ),
            ),
            // Custom Keypad
            _buildKeypad(),
            // Confirm Button
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: const BoxDecoration(
                color: AppColors.background,
                border: Border(
                  top: BorderSide(color: AppColors.divider),
                ),
              ),
              child: AppButton(
                text: 'Konfirmasi Pembayaran',
                onPressed: _canConfirm ? _handleConfirmPayment : null,
                icon: Icons.check_circle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAmountButtons() {
    final quickAmounts = [
      _totalAmount, // Exact amount
      (_totalAmount / 1000).ceil() * 1000, // Round up to nearest 1000
      ((_totalAmount / 10000).ceil() * 10000), // Round up to nearest 10000
      ((_totalAmount / 50000).ceil() * 50000), // Round up to nearest 50000
    ].toSet().toList()..sort();

    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      alignment: WrapAlignment.center,
      children: quickAmounts.map((amount) {
        return OutlinedButton(
          onPressed: () => _onQuickAmount(amount),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
          ),
          child: Text(CurrencyFormatter.format(amount)),
        );
      }).toList(),
    );
  }

  Widget _buildKeypad() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          _buildKeypadRow(['1', '2', '3']),
          const SizedBox(height: AppSpacing.md),
          _buildKeypadRow(['4', '5', '6']),
          const SizedBox(height: AppSpacing.md),
          _buildKeypadRow(['7', '8', '9']),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _KeypadButton(
                  label: 'C',
                  onPressed: _onClear,
                  color: AppColors.error,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _KeypadButton(
                  label: '0',
                  onPressed: () => _onNumberPressed('0'),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _KeypadButton(
                  icon: Icons.backspace_outlined,
                  onPressed: _onBackspace,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKeypadRow(List<String> numbers) {
    return Row(
      children: numbers.map((number) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: number != numbers.last ? AppSpacing.md : 0,
            ),
            child: _KeypadButton(
              label: number,
              onPressed: () => _onNumberPressed(number),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _KeypadButton extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final VoidCallback onPressed;
  final Color? color;

  const _KeypadButton({
    this.label,
    this.icon,
    required this.onPressed,
    this.color,
  }) : assert(label != null || icon != null);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.surface,
          foregroundColor: color ?? AppColors.textPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            side: const BorderSide(color: AppColors.border),
          ),
        ),
        child: icon != null
            ? Icon(icon, size: 28)
            : Text(
                label!,
                style: AppTypography.headingLarge,
              ),
      ),
    );
  }
}
