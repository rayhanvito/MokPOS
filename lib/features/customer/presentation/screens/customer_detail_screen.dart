import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';

/// Customer Detail Screen
/// View customer information and transaction history (Owner only)
class CustomerDetailScreen extends StatelessWidget {
  final String customerId;

  const CustomerDetailScreen({
    super.key,
    required this.customerId,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Fetch customer data from provider
    final customer = _getMockCustomer();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Detail Pelanggan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Edit customer
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildCustomerHeader(customer),
            _buildStatsSection(customer),
            _buildTransactionHistory(customer),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerHeader(Map<String, dynamic> customer) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.textWhite.withOpacity(0.2),
            child: Text(
              customer['name'][0].toUpperCase(),
              style: AppTypography.displayLarge.copyWith(
                color: AppColors.textWhite,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            customer['name'],
            style: AppTypography.headingLarge.copyWith(
              color: AppColors.textWhite,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            customer['phone'],
            style: AppTypography.bodyRegular.copyWith(
              color: AppColors.textWhite.withOpacity(0.9),
            ),
          ),
          if (customer['email'] != null) ...[
            const SizedBox(height: 4),
            Text(
              customer['email'],
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textWhite.withOpacity(0.8),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatsSection(Map<String, dynamic> customer) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Total Transaksi',
              '${customer['totalTransactions']}',
              Icons.shopping_bag,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: _buildStatCard(
              'Total Belanja',
              CurrencyFormatter.formatCompact(customer['totalSpent']),
              Icons.payments,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: AppTypography.headingMedium.copyWith(
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionHistory(Map<String, dynamic> customer) {
    final transactions = customer['transactions'] as List;

    return Container(
      margin: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Riwayat Transaksi',
            style: AppTypography.label,
          ),
          const SizedBox(height: AppSpacing.md),
          ...transactions.map((t) => _buildTransactionItem(t)),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction['id'],
                  style: AppTypography.bodyRegular.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormatter.formatFull(transaction['date']),
                  style: AppTypography.caption,
                ),
              ],
            ),
          ),
          Text(
            CurrencyFormatter.format(transaction['total']),
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getMockCustomer() {
    return {
      'id': customerId,
      'name': 'Budi Santoso',
      'phone': '081234567890',
      'email': 'budi@email.com',
      'totalTransactions': 45,
      'totalSpent': 2340000,
      'transactions': [
        {'id': 'TRX001', 'date': DateTime.now(), 'total': 125000},
        {'id': 'TRX002', 'date': DateTime.now().subtract(const Duration(days: 2)), 'total': 85000},
      ],
    };
  }
}
