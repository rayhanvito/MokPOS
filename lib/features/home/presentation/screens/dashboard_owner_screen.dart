import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';

/// Dashboard Owner Screen
/// Daily overview of store performance for Owner
class DashboardOwnerScreen extends StatefulWidget {
  const DashboardOwnerScreen({super.key});

  @override
  State<DashboardOwnerScreen> createState() => _DashboardOwnerScreenState();
}

class _DashboardOwnerScreenState extends State<DashboardOwnerScreen> {
  // TODO: Replace with actual data from provider
  final String _ownerName = 'Budi Santoso';
  final String _storeName = 'Toko Berkah';
  final int _todaySales = 2450000;
  final int _todayTransactions = 45;
  final String _bestProduct = 'Kopi Susu';
  final int _lowStockCount = 3;

  final List<Map<String, dynamic>> _recentTransactions = [
    {
      'id': 'TRX001',
      'time': '14:30',
      'amount': 125000,
      'items': 3,
      'customer': 'Walk-in',
    },
    {
      'id': 'TRX002',
      'time': '14:15',
      'amount': 85000,
      'items': 2,
      'customer': 'Andi',
    },
    {
      'id': 'TRX003',
      'time': '13:45',
      'amount': 250000,
      'items': 5,
      'customer': 'Siti',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: const Icon(
                Icons.store,
                color: AppColors.secondary,
                size: 18,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Text(
              _storeName,
              style: AppTypography.headingSmall,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // TODO: Refresh data
          await Future.delayed(const Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Text(
                '${DateFormatter.getGreeting()}, $_ownerName',
                style: AppTypography.headingMedium,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                DateFormatter.formatDateWithDay(DateTime.now()),
                style: AppTypography.bodySmall,
              ),
              const SizedBox(height: AppSpacing.xl),
              // Summary Cards
              _buildSummaryCards(),
              const SizedBox(height: AppSpacing.xl),
              // Start Transaction Button
              SizedBox(
                width: double.infinity,
                height: AppSpacing.buttonHeight,
                child: ElevatedButton.icon(
                  onPressed: () => context.goNamed(AppRoutes.posName),
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('Mulai Transaksi'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textWhite,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              // Recent Transactions
              _buildSectionHeader(
                'Transaksi Terakhir',
                onViewAll: () => context.goNamed(AppRoutes.historyName),
              ),
              const SizedBox(height: AppSpacing.md),
              _buildRecentTransactions(),
              const SizedBox(height: AppSpacing.xl),
              // Low Stock Alert
              if (_lowStockCount > 0) ...[
                _buildLowStockAlert(),
                const SizedBox(height: AppSpacing.xl),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildSummaryCards() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.md,
      crossAxisSpacing: AppSpacing.md,
      childAspectRatio: 1.5,
      children: [
        _SummaryCard(
          icon: Icons.payments,
          label: 'Penjualan Hari Ini',
          value: CurrencyFormatter.format(_todaySales),
          color: AppColors.success,
        ),
        _SummaryCard(
          icon: Icons.receipt_long,
          label: 'Transaksi',
          value: '$_todayTransactions',
          color: AppColors.primary,
        ),
        _SummaryCard(
          icon: Icons.star,
          label: 'Produk Terlaris',
          value: _bestProduct,
          color: AppColors.secondary,
        ),
        _SummaryCard(
          icon: Icons.warning,
          label: 'Stok Menipis',
          value: '$_lowStockCount Produk',
          color: AppColors.error,
          onTap: () => context.goNamed(AppRoutes.stockName),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onViewAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTypography.headingSmall,
        ),
        if (onViewAll != null)
          TextButton(
            onPressed: onViewAll,
            child: Text(
              'Lihat Semua',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildRecentTransactions() {
    return Column(
      children: _recentTransactions.map((transaction) {
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
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: const Icon(
                  Icons.shopping_bag,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction['id'],
                      style: AppTypography.bodyLarge,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${transaction['items']} item · ${transaction['customer']}',
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    CurrencyFormatter.format(transaction['amount']),
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    transaction['time'],
                    style: AppTypography.caption,
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLowStockAlert() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.error,
            size: 32,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Stok Produk Menipis',
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$_lowStockCount produk perlu diisi ulang',
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => context.goNamed(AppRoutes.stockName),
            child: const Text('Lihat'),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: 0,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long),
          label: 'Transaksi',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assessment),
          label: 'Laporan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory),
          label: 'Produk',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Akun',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            // Already on home
            break;
          case 1:
            context.goNamed(AppRoutes.historyName);
            break;
          case 2:
            context.goNamed(AppRoutes.reportsName);
            break;
          case 3:
            context.goNamed(AppRoutes.productsName);
            break;
          case 4:
            context.goNamed(AppRoutes.profileName);
            break;
        }
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final VoidCallback? onTap;

  const _SummaryCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.background,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
                const Spacer(),
                if (onTap != null)
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: AppColors.textSecondary,
                  ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: AppTypography.headingSmall.copyWith(fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: AppTypography.caption,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
