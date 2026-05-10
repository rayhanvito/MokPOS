import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/app_button.dart';

/// Shift Close Screen
/// End shift summary and cash reconciliation
class ShiftCloseScreen extends StatefulWidget {
  const ShiftCloseScreen({super.key});

  @override
  State<ShiftCloseScreen> createState() => _ShiftCloseScreenState();
}

class _ShiftCloseScreenState extends State<ShiftCloseScreen> {
  final TextEditingController _actualCashController = TextEditingController();
  bool _isReconciled = false;

  // TODO: Replace with actual data from provider
  final Map<String, dynamic> _shiftData = {
    'cashier': 'Andi Wijaya',
    'shiftStart': DateTime.now().subtract(const Duration(hours: 8)),
    'shiftEnd': DateTime.now(),
    'transactions': 45,
    'totalSales': 2340000,
    'cashSales': 1450000,
    'qrisSales': 680000,
    'transferSales': 210000,
    'expectedCash': 1450000,
    'voidTransactions': 2,
    'voidAmount': 85000,
  };

  @override
  void dispose() {
    _actualCashController.dispose();
    super.dispose();
  }

  int get _actualCash {
    final text = _actualCashController.text.replaceAll(RegExp(r'[^0-9]'), '');
    return text.isEmpty ? 0 : int.parse(text);
  }

  int get _cashDifference {
    return _actualCash - (_shiftData['expectedCash'] as int);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Tutup Kasir'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shift Info
            _buildShiftInfoCard(),
            const SizedBox(height: AppSpacing.lg),

            // Sales Summary
            _buildSalesSummaryCard(),
            const SizedBox(height: AppSpacing.lg),

            // Payment Method Breakdown
            _buildPaymentBreakdownCard(),
            const SizedBox(height: AppSpacing.lg),

            // Cash Reconciliation
            _buildCashReconciliationCard(),
            const SizedBox(height: AppSpacing.xxxl),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: AppButton(
            text: 'Tutup Shift',
            onPressed: _isReconciled ? _closeShift : null,
          ),
        ),
      ),
    );
  }

  Widget _buildShiftInfoCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A72DD), Color(0xFF1557B0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowPrimary,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.textWhite.withOpacity(0.2),
                child: Text(
                  _shiftData['cashier'][0],
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _shiftData['cashier'],
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.textWhite,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Shift ${DateFormatter.formatTime(_shiftData['shiftStart'])} - ${DateFormatter.formatTime(_shiftData['shiftEnd'])}',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textWhite.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            height: 1,
            color: AppColors.textWhite.withOpacity(0.2),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Durasi Shift',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textWhite.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _calculateShiftDuration(),
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.textWhite,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Transaksi',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textWhite.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_shiftData['transactions']}',
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.textWhite,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSalesSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ringkasan Penjualan',
            style: AppTypography.label.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildSummaryRow(
            'Total Penjualan',
            CurrencyFormatter.format(_shiftData['totalSales']),
            isTotal: true,
          ),
          const Divider(height: AppSpacing.xl),
          _buildSummaryRow(
            'Transaksi Berhasil',
            '${_shiftData['transactions']}',
          ),
          const SizedBox(height: AppSpacing.md),
          _buildSummaryRow(
            'Transaksi Void',
            '${_shiftData['voidTransactions']} (${CurrencyFormatter.format(_shiftData['voidAmount'])})',
            isNegative: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentBreakdownCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rincian Metode Pembayaran',
            style: AppTypography.label.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildPaymentMethodRow(
            'Tunai',
            _shiftData['cashSales'],
            Icons.payments,
          ),
          const SizedBox(height: AppSpacing.md),
          _buildPaymentMethodRow(
            'QRIS',
            _shiftData['qrisSales'],
            Icons.qr_code,
          ),
          const SizedBox(height: AppSpacing.md),
          _buildPaymentMethodRow(
            'Transfer',
            _shiftData['transferSales'],
            Icons.account_balance,
          ),
        ],
      ),
    );
  }

  Widget _buildCashReconciliationCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rekonsiliasi Kas',
            style: AppTypography.label.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildSummaryRow(
            'Kas yang Diharapkan',
            CurrencyFormatter.format(_shiftData['expectedCash']),
          ),
          const SizedBox(height: AppSpacing.lg),
          // Actual Cash Input
          Text(
            'Kas Aktual',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _actualCashController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Masukkan jumlah kas aktual',
              prefixText: 'Rp ',
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                borderSide: BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                borderSide: BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
            onChanged: (value) {
              setState(() {
                // Format as currency
                final number = value.replaceAll(RegExp(r'[^0-9]'), '');
                if (number.isNotEmpty) {
                  final formatted = int.parse(number).toString().replaceAllMapped(
                        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                        (Match m) => '${m[1]}.',
                      );
                  _actualCashController.value = TextEditingValue(
                    text: formatted,
                    selection: TextSelection.collapsed(offset: formatted.length),
                  );
                }
                _isReconciled = _actualCash > 0;
              });
            },
          ),
          if (_actualCash > 0) ...[
            const SizedBox(height: AppSpacing.lg),
            const Divider(),
            const SizedBox(height: AppSpacing.lg),
            _buildDifferenceRow(),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false, bool isNegative = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600)
              : AppTypography.bodyRegular.copyWith(
                  color: AppColors.textSecondary,
                ),
        ),
        Text(
          value,
          style: isTotal
              ? AppTypography.headingMedium.copyWith(
                  color: AppColors.primary,
                )
              : AppTypography.bodyRegular.copyWith(
                  color: isNegative ? AppColors.error : AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodRow(String method, int amount, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            method,
            style: AppTypography.bodyRegular,
          ),
        ),
        Text(
          CurrencyFormatter.format(amount),
          style: AppTypography.bodyRegular.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildDifferenceRow() {
    final difference = _cashDifference;
    final isExact = difference == 0;
    final isOver = difference > 0;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isExact
            ? AppColors.success.withOpacity(0.1)
            : (isOver ? AppColors.warning.withOpacity(0.1) : AppColors.error.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: isExact
              ? AppColors.success
              : (isOver ? AppColors.warning : AppColors.error),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isExact ? Icons.check_circle : Icons.warning,
            color: isExact
                ? AppColors.success
                : (isOver ? AppColors.warning : AppColors.error),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isExact
                      ? 'Kas Sesuai'
                      : (isOver ? 'Kas Lebih' : 'Kas Kurang'),
                  style: AppTypography.bodyRegular.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (!isExact) ...[
                  const SizedBox(height: 4),
                  Text(
                    CurrencyFormatter.format(difference.abs()),
                    style: AppTypography.bodyLarge.copyWith(
                      color: isOver ? AppColors.warning : AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _calculateShiftDuration() {
    final start = _shiftData['shiftStart'] as DateTime;
    final end = _shiftData['shiftEnd'] as DateTime;
    final duration = end.difference(start);

    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    return '${hours}j ${minutes}m';
  }

  void _closeShift() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tutup Shift?'),
        content: const Text(
          'Setelah shift ditutup, Anda akan keluar dari sistem. Pastikan semua data sudah benar.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Close shift and logout
              Navigator.pop(context);
              context.goNamed(AppRoutes.roleSelectionName);
            },
            child: const Text('Tutup Shift'),
          ),
        ],
      ),
    );
  }
}
