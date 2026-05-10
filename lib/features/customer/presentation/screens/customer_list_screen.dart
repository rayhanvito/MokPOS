import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_empty_state.dart';

/// Customer List Screen
/// Manage customers (Owner only)
class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  final TextEditingController _searchController = TextEditingController();

  // TODO: Replace with actual data from provider
  final List<Map<String, dynamic>> _customers = [
    {
      'id': '1',
      'name': 'Budi Santoso',
      'phone': '081234567890',
      'email': 'budi@email.com',
      'totalTransactions': 45,
      'totalSpent': 2340000,
      'lastVisit': DateTime.now().subtract(const Duration(days: 2)),
    },
    {
      'id': '2',
      'name': 'Siti Aminah',
      'phone': '081298765432',
      'email': null,
      'totalTransactions': 28,
      'totalSpent': 1560000,
      'lastVisit': DateTime.now().subtract(const Duration(days: 5)),
    },
    {
      'id': '3',
      'name': 'Ahmad Rizki',
      'phone': '081345678901',
      'email': 'ahmad@email.com',
      'totalTransactions': 12,
      'totalSpent': 680000,
      'lastVisit': DateTime.now().subtract(const Duration(days: 15)),
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredCustomers {
    if (_searchController.text.isEmpty) return _customers;

    return _customers.where((c) {
      final query = _searchController.text.toLowerCase();
      return c['name'].toString().toLowerCase().contains(query) ||
          c['phone'].toString().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Pelanggan'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari nama atau nomor telepon...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => _searchController.clear()),
                      )
                    : null,
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),
        ),
      ),
      body: _filteredCustomers.isEmpty
          ? AppEmptyState(
              icon: Icons.people,
              title: 'Tidak ada pelanggan',
              message: _searchController.text.isNotEmpty
                  ? 'Coba kata kunci lain'
                  : 'Pelanggan akan muncul setelah transaksi pertama',
            )
          : ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: _filteredCustomers.length,
              itemBuilder: (context, index) {
                final customer = _filteredCustomers[index];
                return _CustomerCard(
                  customer: customer,
                  onTap: () {
                    context.goNamed(
                      AppRoutes.customerDetailName,
                      pathParameters: {'id': customer['id']},
                    );
                  },
                );
              },
            ),
    );
  }
}

class _CustomerCard extends StatelessWidget {
  final Map<String, dynamic> customer;
  final VoidCallback onTap;

  const _CustomerCard({
    required this.customer,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.background,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Text(
                  customer['name'][0].toUpperCase(),
                  style: AppTypography.headingMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer['name'],
                      style: AppTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      customer['phone'],
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Icon(Icons.shopping_bag, size: 14, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          '${customer['totalTransactions']} transaksi',
                          style: AppTypography.caption,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Icon(Icons.payments, size: 14, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          CurrencyFormatter.formatCompact(customer['totalSpent']),
                          style: AppTypography.caption,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
