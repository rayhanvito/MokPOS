import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _transactionNotif = true;
  bool _lowStockNotif = true;
  bool _dailyReportNotif = true;
  bool _promotionNotif = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Notifikasi')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _buildNotifTile('Notifikasi Transaksi', 'Terima notifikasi setiap ada transaksi baru', _transactionNotif, (v) => setState(() => _transactionNotif = v)),
          _buildNotifTile('Stok Menipis', 'Peringatan saat stok produk hampir habis', _lowStockNotif, (v) => setState(() => _lowStockNotif = v)),
          _buildNotifTile('Laporan Harian', 'Ringkasan penjualan harian', _dailyReportNotif, (v) => setState(() => _dailyReportNotif = v)),
          _buildNotifTile('Promosi & Update', 'Info promo dan fitur baru', _promotionNotif, (v) => setState(() => _promotionNotif = v)),
        ],
      ),
    );
  }

  Widget _buildNotifTile(String title, String subtitle, bool value, Function(bool) onChanged) {
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
                Text(title, style: AppTypography.bodyRegular.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(subtitle, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged, activeColor: AppColors.success),
        ],
      ),
    );
  }
}
