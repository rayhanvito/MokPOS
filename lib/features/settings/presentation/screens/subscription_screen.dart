import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/app_button.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Langganan & Paket')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)]),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Column(
                children: [
                  Text('Paket Pro', style: AppTypography.headingLarge.copyWith(color: AppColors.textWhite)),
                  const SizedBox(height: AppSpacing.sm),
                  Text('Rp 99.000/bulan', style: AppTypography.bodyLarge.copyWith(color: AppColors.textWhite)),
                  const SizedBox(height: AppSpacing.lg),
                  Text('Aktif hingga 15 Juni 2026', style: AppTypography.bodySmall.copyWith(color: AppColors.textWhite.withOpacity(0.9))),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            _buildFeature('Unlimited Produk', true),
            _buildFeature('Unlimited Transaksi', true),
            _buildFeature('Multi Karyawan', true),
            _buildFeature('Laporan Lengkap', true),
            _buildFeature('Backup Otomatis', true),
            const SizedBox(height: AppSpacing.xl),
            AppButton(text: 'Upgrade Paket', onPressed: () {}),
            const SizedBox(height: AppSpacing.md),
            AppButton(text: 'Riwayat Pembayaran', variant: AppButtonVariant.secondary, onPressed: () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildFeature(String text, bool included) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          Icon(included ? Icons.check_circle : Icons.cancel, color: included ? AppColors.success : AppColors.error, size: 20),
          const SizedBox(width: AppSpacing.md),
          Text(text, style: AppTypography.bodyRegular),
        ],
      ),
    );
  }
}
