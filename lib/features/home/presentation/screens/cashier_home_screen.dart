import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/date_formatter.dart';

/// Cashier Home Screen
/// Employee's starting point - simplified dashboard
class CashierHomeScreen extends StatefulWidget {
  const CashierHomeScreen({super.key});

  @override
  State<CashierHomeScreen> createState() => _CashierHomeScreenState();
}

class _CashierHomeScreenState extends State<CashierHomeScreen> {
  // TODO: Replace with actual data from provider
  final String _employeeName = 'Andi';
  final String _storeName = 'Toko Berkah';
  final String _shiftStartTime = '08:00';
  final int _shiftTransactions = 12;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          _storeName,
          style: AppTypography.headingSmall,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.lg),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: Text(
                    _employeeName[0].toUpperCase(),
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  _employeeName,
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting
            Text(
              '${DateFormatter.getGreeting()}, $_employeeName',
              style: AppTypography.headingLarge,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              DateFormatter.formatDateWithDay(DateTime.now()),
              style: AppTypography.bodySmall,
            ),
            const SizedBox(height: AppSpacing.xxxl),
            // Shift Info Card
            _buildShiftInfoCard(),
            const SizedBox(height: AppSpacing.xxxl),
            // Main Action Button
            SizedBox(
              width: double.infinity,
              height: 120,
              child: ElevatedButton(
                onPressed: () => context.goNamed(AppRoutes.posName),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.add_shopping_cart,
                      size: 48,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Mulai Transaksi',
                      style: AppTypography.headingMedium.copyWith(
                        color: AppColors.textWhite,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            // Quick Actions
            Text(
              'Aksi Cepat',
              style: AppTypography.headingSmall,
            ),
            const SizedBox(height: AppSpacing.md),
            _buildQuickActions(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
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
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
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
              const Icon(
                Icons.access_time,
                color: AppColors.textWhite,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Shift Aktif',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textWhite.withOpacity(0.9),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mulai Shift',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textWhite.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _shiftStartTime,
                    style: AppTypography.headingMedium.copyWith(
                      color: AppColors.textWhite,
                    ),
                  ),
                ],
              ),
              Container(
                width: 1,
                height: 40,
                color: AppColors.textWhite.withOpacity(0.3),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Transaksi',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textWhite.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$_shiftTransactions',
                    style: AppTypography.headingMedium.copyWith(
                      color: AppColors.textWhite,
                    ),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      children: [
        _QuickActionCard(
          icon: Icons.history,
          title: 'Riwayat Transaksi',
          subtitle: 'Lihat transaksi shift ini',
          onTap: () => context.goNamed(AppRoutes.historyName),
        ),
        const SizedBox(height: AppSpacing.md),
        _QuickActionCard(
          icon: Icons.exit_to_app,
          title: 'Tutup Kasir',
          subtitle: 'Akhiri shift dan tutup kasir',
          color: AppColors.error,
          onTap: () => _showCloseShiftDialog(),
        ),
      ],
    );
  }

  void _showCloseShiftDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tutup Kasir'),
        content: const Text(
          'Apakah Anda yakin ingin mengakhiri shift dan tutup kasir?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.goNamed(AppRoutes.shiftCloseName);
            },
            child: const Text('Ya, Tutup'),
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
          label: 'Riwayat',
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
            context.goNamed(AppRoutes.profileName);
            break;
        }
      },
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color? color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final actionColor = color ?? AppColors.primary;

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
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: actionColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Icon(
                icon,
                color: actionColor,
                size: 24,
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.bodyLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTypography.caption,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
