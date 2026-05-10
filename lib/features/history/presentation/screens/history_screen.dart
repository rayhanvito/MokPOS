import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/app_empty_state.dart';

/// History Screen
/// Display transaction history with search and filter
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  // TODO: Replace with actual data from provider
  final List<Map<String, dynamic>> _transactions = [
    {
      'id': 'TRX001',
      'date': DateTime.now(),
      'total': 125000,
      'items': 3,
      'customer': 'Budi Santoso',
      'paymentMethod': 'Tunai',
      'status': 'success',
      'cashier': 'Andi',
    },
    {
      'id': 'TRX002',
      'date': DateTime.now().subtract(const Duration(hours: 2)),
      'total': 85000,
      'items': 2,
      'customer': 'Walk-in',
      'paymentMethod': 'QRIS',
      'status': 'success',
      'cashier': 'Andi',
    },
    {
      'id': 'TRX003',
      'date': DateTime.now().subtract(const Duration(hours: 5)),
      'total': 250000,
      'items': 5,
      'customer': 'Siti Aminah',
      'paymentMethod': 'Transfer',
      'status': 'success',
      'cashier': 'Budi',
    },
    {
      'id': 'TRX004',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'total': 50000,
      'items': 1,
      'customer': 'Walk-in',
      'paymentMethod': 'Tunai',
      'status': 'void',
      'cashier': 'Andi',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredTransactions {
    var transactions = _transactions;

    // Filter by tab
    switch (_tabController.index) {
      case 1: // Hari Ini
        transactions = transactions.where((t) {
          final date = t['date'] as DateTime;
          return date.day == DateTime.now().day;
        }).toList();
        break;
      case 2: // Minggu Ini
        transactions = transactions.where((t) {
          final date = t['date'] as DateTime;
          final now = DateTime.now();
          final weekAgo = now.subtract(const Duration(days: 7));
          return date.isAfter(weekAgo);
        }).toList();
        break;
      case 3: // Bulan Ini
        transactions = transactions.where((t) {
          final date = t['date'] as DateTime;
          return date.month == DateTime.now().month;
        }).toList();
        break;
    }

    // Filter by search
    if (_searchController.text.isNotEmpty) {
      transactions = transactions.where((t) {
        final query = _searchController.text.toLowerCase();
        return t['id'].toString().toLowerCase().contains(query) ||
            t['customer'].toString().toLowerCase().contains(query);
      }).toList();
    }

    return transactions;
  }

  int get _totalAmount {
    return _filteredTransactions.fold(
      0,
      (sum, t) => sum + (t['total'] as int),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => context.goNamed(AppRoutes.historyFilterName),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari ID transaksi atau pelanggan...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() => _searchController.clear());
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.md,
                    ),
                  ),
                  onChanged: (value) => setState(() {}),
                ),
              ),
              // Tabs
              TabBar(
                controller: _tabController,
                onTap: (index) => setState(() {}),
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.primary,
                isScrollable: true,
                tabs: const [
                  Tab(text: 'Semua'),
                  Tab(text: 'Hari Ini'),
                  Tab(text: 'Minggu Ini'),
                  Tab(text: 'Bulan Ini'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Summary Card
          _buildSummaryCard(),
          // Transaction List
          Expanded(
            child: _buildTransactionList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    final transactions = _filteredTransactions;
    return Container(
      margin: const EdgeInsets.all(AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A72DD), Color(0xFF1557B0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowPrimary,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Transaksi',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textWhite.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${transactions.length}',
                  style: AppTypography.headingLarge.copyWith(
                    color: AppColors.textWhite,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: AppColors.textWhite.withOpacity(0.3),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Nilai',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textWhite.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  CurrencyFormatter.formatCompact(_totalAmount),
                  style: AppTypography.headingLarge.copyWith(
                    color: AppColors.textWhite,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList() {
    final transactions = _filteredTransactions;

    if (transactions.isEmpty) {
      return AppEmptyState(
        icon: Icons.receipt_long,
        title: 'Tidak ada transaksi',
        message: _searchController.text.isNotEmpty
            ? 'Coba kata kunci lain'
            : 'Belum ada transaksi untuk periode ini',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return _TransactionCard(
          id: transaction['id'],
          date: transaction['date'],
          total: transaction['total'],
          items: transaction['items'],
          customer: transaction['customer'],
          paymentMethod: transaction['paymentMethod'],
          status: transaction['status'],
          cashier: transaction['cashier'],
          onTap: () {
            // TODO: Navigate to transaction detail
            context.goNamed(
              AppRoutes.transactionDetailName,
              pathParameters: {'id': transaction['id']},
            );
          },
        );
      },
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final String id;
  final DateTime date;
  final int total;
  final int items;
  final String customer;
  final String paymentMethod;
  final String status;
  final String cashier;
  final VoidCallback onTap;

  const _TransactionCard({
    required this.id,
    required this.date,
    required this.total,
    required this.items,
    required this.customer,
    required this.paymentMethod,
    required this.status,
    required this.cashier,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isVoid = status == 'void';

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.background,
            border: Border.all(
              color: isVoid ? AppColors.error.withOpacity(0.3) : AppColors.border,
            ),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  // Icon
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isVoid
                          ? AppColors.error.withOpacity(0.1)
                          : AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                    child: Icon(
                      isVoid ? Icons.cancel : Icons.check_circle,
                      color: isVoid ? AppColors.error : AppColors.success,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              id,
                              style: AppTypography.bodyLarge.copyWith(
                                fontWeight: FontWeight.w600,
                                decoration: isVoid ? TextDecoration.lineThrough : null,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            if (isVoid)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.sm,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.error,
                                  borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                                ),
                                child: Text(
                                  'VOID',
                                  style: AppTypography.caption.copyWith(
                                    color: AppColors.textWhite,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormatter.formatRelative(date),
                          style: AppTypography.caption,
                        ),
                      ],
                    ),
                  ),
                  // Amount
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        CurrencyFormatter.format(total),
                        style: AppTypography.bodyLarge.copyWith(
                          color: isVoid ? AppColors.error : AppColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$items item',
                        style: AppTypography.caption,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              const Divider(),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  _InfoChip(
                    icon: Icons.person_outline,
                    label: customer,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _InfoChip(
                    icon: Icons.payment,
                    label: paymentMethod,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _InfoChip(
                    icon: Icons.badge_outlined,
                    label: cashier,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTypography.caption,
          ),
        ],
      ),
    );
  }
}
