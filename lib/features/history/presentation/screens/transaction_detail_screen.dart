import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/app_button.dart';

/// Transaction Detail Screen
/// Display complete transaction information
class TransactionDetailScreen extends StatelessWidget {
  final String transactionId;

  const TransactionDetailScreen({
    super.key,
    required this.transactionId,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Fetch transaction data from provider
    final transaction = _getMockTransaction();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Detail Transaksi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Share transaction
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'print') {
                // TODO: Print receipt
              } else if (value == 'void') {
                context.goNamed(AppRoutes.voidRefundName);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'print',
                child: Row(
                  children: [
                    Icon(Icons.print, size: 20),
                    SizedBox(width: 12),
                    Text('Cetak Struk'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'void',
                child: Row(
                  children: [
                    Icon(Icons.cancel, size: 20, color: Colors.red),
                    SizedBox(width: 12),
                    Text('Void/Refund', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Status Header
            _buildStatusHeader(transaction),

            // Transaction Info
            _buildInfoSection(transaction),

            // Items
            _buildItemsSection(transaction),

            // Payment Summary
            _buildPaymentSummary(transaction),

            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Expanded(
                child: AppButton(
                  text: 'Cetak Struk',
                  variant: AppButtonVariant.secondary,
                  onPressed: () {
                    context.goNamed(AppRoutes.receiptPreviewName);
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppButton(
                  text: 'Transaksi Baru',
                  onPressed: () {
                    context.goNamed(AppRoutes.posName);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusHeader(Map<String, dynamic> transaction) {
    final isVoid = transaction['status'] == 'void';
    final isSuccess = transaction['status'] == 'success';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isVoid
              ? [AppColors.error, AppColors.error.withOpacity(0.8)]
              : [AppColors.success, AppColors.success.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Icon(
            isVoid ? Icons.cancel : Icons.check_circle,
            size: 64,
            color: AppColors.textWhite,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            isVoid ? 'TRANSAKSI DIBATALKAN' : 'TRANSAKSI BERHASIL',
            style: AppTypography.headingMedium.copyWith(
              color: AppColors.textWhite,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            transaction['id'],
            style: AppTypography.bodyRegular.copyWith(
              color: AppColors.textWhite.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            DateFormatter.formatFull(transaction['date']),
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textWhite.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(Map<String, dynamic> transaction) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        children: [
          _buildInfoRow('Kasir', transaction['cashier']),
          const Divider(height: AppSpacing.xl),
          _buildInfoRow('Pelanggan', transaction['customer']),
          const Divider(height: AppSpacing.xl),
          _buildInfoRow('Metode Pembayaran', transaction['paymentMethod']),
          if (transaction['paymentMethod'] == 'Tunai') ...[
            const Divider(height: AppSpacing.xl),
            _buildInfoRow(
              'Uang Diterima',
              CurrencyFormatter.format(transaction['cashReceived']),
            ),
            const Divider(height: AppSpacing.xl),
            _buildInfoRow(
              'Kembalian',
              CurrencyFormatter.format(transaction['change']),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodyRegular.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: AppTypography.bodyRegular.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildItemsSection(Map<String, dynamic> transaction) {
    final items = transaction['items'] as List<Map<String, dynamic>>;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
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
            'Item Pesanan',
            style: AppTypography.label.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          ...items.map((item) => _buildItemRow(item)),
        ],
      ),
    );
  }

  Widget _buildItemRow(Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              image: item['image'] != null
                  ? DecorationImage(
                      image: NetworkImage(item['image']),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: item['image'] == null
                ? Icon(
                    Icons.shopping_bag,
                    color: AppColors.textSecondary,
                    size: 24,
                  )
                : null,
          ),
          const SizedBox(width: AppSpacing.md),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'],
                  style: AppTypography.bodyRegular,
                ),
                const SizedBox(height: 4),
                Text(
                  '${item['quantity']}x ${CurrencyFormatter.format(item['price'])}',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                if (item['note'] != null && item['note'].isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Catatan: ${item['note']}',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Total
          Text(
            CurrencyFormatter.format(item['price'] * item['quantity']),
            style: AppTypography.bodyRegular.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSummary(Map<String, dynamic> transaction) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        children: [
          _buildSummaryRow('Subtotal', transaction['subtotal']),
          if (transaction['discount'] > 0) ...[
            const SizedBox(height: AppSpacing.md),
            _buildSummaryRow(
              'Diskon',
              -transaction['discount'],
              isDiscount: true,
            ),
          ],
          if (transaction['tax'] > 0) ...[
            const SizedBox(height: AppSpacing.md),
            _buildSummaryRow('Pajak', transaction['tax']),
          ],
          const Divider(height: AppSpacing.xl),
          _buildSummaryRow(
            'Total',
            transaction['total'],
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    int amount, {
    bool isTotal = false,
    bool isDiscount = false,
  }) {
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
          CurrencyFormatter.format(amount),
          style: isTotal
              ? AppTypography.headingMedium.copyWith(
                  color: AppColors.primary,
                )
              : AppTypography.bodyRegular.copyWith(
                  color: isDiscount ? AppColors.success : AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
        ),
      ],
    );
  }

  Map<String, dynamic> _getMockTransaction() {
    return {
      'id': transactionId,
      'date': DateTime.now(),
      'status': 'success',
      'cashier': 'Andi Wijaya',
      'customer': 'Budi Santoso',
      'paymentMethod': 'Tunai',
      'cashReceived': 150000,
      'change': 25000,
      'items': [
        {
          'name': 'Nasi Goreng Special',
          'price': 25000,
          'quantity': 2,
          'note': 'Pedas sedang',
          'image': null,
        },
        {
          'name': 'Es Teh Manis',
          'price': 5000,
          'quantity': 3,
          'note': null,
          'image': null,
        },
        {
          'name': 'Ayam Bakar',
          'price': 30000,
          'quantity': 2,
          'note': null,
          'image': null,
        },
      ],
      'subtotal': 125000,
      'discount': 0,
      'tax': 0,
      'total': 125000,
    };
  }
}
