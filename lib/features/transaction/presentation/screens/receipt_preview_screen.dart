import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/app_button.dart';

/// Receipt Preview Screen
/// Display transaction receipt for print or share
class ReceiptPreviewScreen extends StatelessWidget {
  const ReceiptPreviewScreen({super.key});

  // TODO: Get from transaction data
  static const String _storeName = 'Toko Berkah';
  static const String _storeAddress = 'Jl. Contoh No. 123, Jakarta';
  static const String _storePhone = '081234567890';
  static const String _transactionId = 'TRX20260510001';
  static final DateTime _transactionTime = DateTime.now();
  static const String _cashierName = 'Andi';
  static const String _customerName = 'Budi Santoso';
  static const String _paymentMethod = 'Tunai';

  static final List<Map<String, dynamic>> _items = [
    {'name': 'Kopi Susu', 'qty': 2, 'price': 15000, 'total': 30000},
    {'name': 'Nasi Goreng', 'qty': 1, 'price': 25000, 'total': 25000},
  ];

  static const int _subtotal = 55000;
  static const int _discount = 5000;
  static const int _total = 50000;
  static const int _paid = 50000;
  static const int _change = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Struk Pembayaran'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Share receipt
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Membagikan struk...'),
                  backgroundColor: AppColors.info,
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Receipt Preview
                  Container(
                    margin: const EdgeInsets.all(AppSpacing.lg),
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadowDark,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: _buildReceiptContent(),
                  ),
                ],
              ),
            ),
          ),
          // Bottom Actions
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: const BoxDecoration(
              color: AppColors.background,
              border: Border(
                top: BorderSide(color: AppColors.divider),
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  AppButton(
                    text: 'Cetak Struk',
                    icon: Icons.print,
                    onPressed: () {
                      // TODO: Print receipt
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Mencetak struk...'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppButton.secondary(
                    text: 'Kembali',
                    onPressed: () => context.pop(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Store Logo/Icon
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: const Icon(
            Icons.store,
            color: AppColors.secondary,
            size: 32,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        // Store Info
        Text(
          _storeName,
          style: AppTypography.headingMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          _storeAddress,
          style: AppTypography.caption,
          textAlign: TextAlign.center,
        ),
        Text(
          'Telp: $_storePhone',
          style: AppTypography.caption,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xl),
        _buildDivider(),
        const SizedBox(height: AppSpacing.lg),
        // Transaction Info
        _buildInfoRow('No. Transaksi', _transactionId),
        _buildInfoRow('Tanggal', DateFormatter.formatDateTime(_transactionTime)),
        _buildInfoRow('Kasir', _cashierName),
        if (_customerName.isNotEmpty)
          _buildInfoRow('Pelanggan', _customerName),
        const SizedBox(height: AppSpacing.lg),
        _buildDivider(),
        const SizedBox(height: AppSpacing.lg),
        // Items
        ..._items.map((item) => _buildItemRow(
              item['name'],
              item['qty'],
              item['price'],
              item['total'],
            )),
        const SizedBox(height: AppSpacing.lg),
        _buildDivider(),
        const SizedBox(height: AppSpacing.lg),
        // Summary
        _buildSummaryRow('Subtotal', _subtotal),
        if (_discount > 0) _buildSummaryRow('Diskon', -_discount),
        const SizedBox(height: AppSpacing.sm),
        _buildDivider(),
        const SizedBox(height: AppSpacing.sm),
        _buildSummaryRow('TOTAL', _total, isBold: true),
        const SizedBox(height: AppSpacing.lg),
        _buildSummaryRow('Bayar ($_paymentMethod)', _paid),
        if (_change > 0) _buildSummaryRow('Kembalian', _change),
        const SizedBox(height: AppSpacing.xl),
        _buildDivider(),
        const SizedBox(height: AppSpacing.lg),
        // Footer
        Text(
          'Terima kasih atas kunjungan Anda',
          style: AppTypography.bodySmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Barang yang sudah dibeli tidak dapat ditukar',
          style: AppTypography.caption,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Powered by ${AppStrings.appName}',
          style: AppTypography.caption.copyWith(
            color: AppColors.primary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: AppColors.border,
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.caption,
          ),
          Text(
            value,
            style: AppTypography.caption.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemRow(String name, int qty, int price, int total) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: AppTypography.bodySmall,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$qty x ${CurrencyFormatter.format(price)}',
                style: AppTypography.caption,
              ),
              Text(
                CurrencyFormatter.format(total),
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, int amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isBold
                ? AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600)
                : AppTypography.bodySmall,
          ),
          Text(
            CurrencyFormatter.format(amount.abs()),
            style: isBold
                ? AppTypography.headingSmall
                : AppTypography.bodySmall.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
          ),
        ],
      ),
    );
  }
}
