import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';

/// Employee Performance Screen
/// View employee performance metrics (Owner only)
class EmployeePerformanceScreen extends StatelessWidget {
  const EmployeePerformanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final employees = [
      {'name': 'Andi Wijaya', 'transactions': 156, 'revenue': 5250000, 'avgTransaction': 33654},
      {'name': 'Budi Santoso', 'transactions': 98, 'revenue': 3420000, 'avgTransaction': 34898},
      {'name': 'Citra Dewi', 'transactions': 45, 'revenue': 1560000, 'avgTransaction': 34667},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Performa Karyawan')),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.lg),
        itemCount: employees.length,
        itemBuilder: (context, index) {
          final employee = employees[index];
          return Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.md),
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.background,
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      child: Text(employee['name']![0], style: TextStyle(color: AppColors.primary)),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        employee['name']!,
                        style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                      ),
                      child: Text('#${index + 1}', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: _buildMetric('Transaksi', '${employee['transactions']}', Icons.shopping_bag),
                    ),
                    Expanded(
                      child: _buildMetric('Revenue', CurrencyFormatter.formatCompact(employee['revenue']!), Icons.payments),
                    ),
                    Expanded(
                      child: _buildMetric('Rata-rata', CurrencyFormatter.formatCompact(employee['avgTransaction']!), Icons.analytics),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetric(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondary),
        const SizedBox(height: 4),
        Text(value, style: AppTypography.bodyRegular.copyWith(fontWeight: FontWeight.w600)),
        Text(label, style: AppTypography.caption),
      ],
    );
  }
}
