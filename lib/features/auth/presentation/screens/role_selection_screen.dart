import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_button.dart';

/// Role Selection Screen
/// User chooses between Owner or Employee role before login
class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.xxl),
              // Logo
              _buildLogo(),
              const SizedBox(height: AppSpacing.xxxl),
              // Illustration
              _buildIllustration(),
              const SizedBox(height: AppSpacing.xl),
              // Tagline
              Text(
                AppStrings.appTagline,
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxxl),
              // Role Cards
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _RoleCard(
                      icon: Icons.store,
                      title: 'Pemilik Toko',
                      description: 'Kelola toko dan lihat laporan',
                      onTap: () => context.goNamed(AppRoutes.loginOwnerName),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _RoleCard(
                      icon: Icons.person,
                      title: 'Karyawan',
                      description: 'Proses transaksi kasir',
                      onTap: () => context.goNamed(AppRoutes.loginEmployeeName),
                    ),
                  ],
                ),
              ),
              // Register Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppStrings.dontHaveAccount,
                    style: AppTypography.bodySmall,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  TextButton(
                    onPressed: () => context.goNamed(AppRoutes.registerName),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      AppStrings.register,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 37,
          height: 37,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowPrimary,
                blurRadius: 48,
                offset: const Offset(0, 24),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.bookmark,
              color: AppColors.secondary,
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          AppStrings.appName,
          style: AppTypography.logo,
        ),
      ],
    );
  }

  Widget _buildIllustration() {
    // Placeholder for illustration
    // TODO: Replace with actual illustration asset
    return Container(
      width: 256,
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: const Icon(
        Icons.storefront,
        size: 80,
        color: AppColors.primary,
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: AppColors.background,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: AppSpacing.iconSizeLarge,
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.headingSmall,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    description,
                    style: AppTypography.bodySmall,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textSecondary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
