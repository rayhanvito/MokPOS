import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_button.dart';

/// Choose Plan Screen
/// Owner selects subscription tier
class ChoosePlanScreen extends StatefulWidget {
  const ChoosePlanScreen({super.key});

  @override
  State<ChoosePlanScreen> createState() => _ChoosePlanScreenState();
}

class _ChoosePlanScreenState extends State<ChoosePlanScreen> {
  bool _isAnnual = false;
  String _selectedPlan = 'Pro';
  bool _isLoading = false;

  final List<Map<String, dynamic>> _plans = [
    {
      'name': 'Free',
      'price': 0,
      'priceAnnual': 0,
      'features': [
        {'text': '1 Kasir', 'included': true},
        {'text': '50 Produk', 'included': true},
        {'text': '100 Transaksi/bulan', 'included': true},
        {'text': 'Laporan Dasar', 'included': true},
        {'text': 'Multi Kasir', 'included': false},
        {'text': 'Laporan Lengkap', 'included': false},
        {'text': 'Integrasi Payment', 'included': false},
      ],
    },
    {
      'name': 'Pro',
      'price': 99000,
      'priceAnnual': 990000,
      'popular': true,
      'features': [
        {'text': '3 Kasir', 'included': true},
        {'text': 'Unlimited Produk', 'included': true},
        {'text': 'Unlimited Transaksi', 'included': true},
        {'text': 'Laporan Lengkap', 'included': true},
        {'text': 'Integrasi Payment', 'included': true},
        {'text': 'Customer Management', 'included': true},
        {'text': 'Priority Support', 'included': false},
      ],
    },
    {
      'name': 'Business',
      'price': 199000,
      'priceAnnual': 1990000,
      'features': [
        {'text': 'Unlimited Kasir', 'included': true},
        {'text': 'Unlimited Produk', 'included': true},
        {'text': 'Unlimited Transaksi', 'included': true},
        {'text': 'Laporan Advanced', 'included': true},
        {'text': 'Integrasi Payment', 'included': true},
        {'text': 'Customer Management', 'included': true},
        {'text': 'Priority Support', 'included': true},
        {'text': 'Multi-Store', 'included': true},
      ],
    },
  ];

  Future<void> _handleStartTrial() async {
    setState(() => _isLoading = true);

    // TODO: Save selected plan to backend
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() => _isLoading = false);

    // Navigate to home (owner dashboard)
    context.goNamed(AppRoutes.homeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Progress Indicator
                    _buildProgressIndicator(3, 3),
                    const SizedBox(height: AppSpacing.xl),
                    // Title
                    Text(
                      'Pilih Paket',
                      style: AppTypography.headingLarge,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      '14 hari trial gratis untuk semua paket',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.success,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    // Billing Toggle
                    _buildBillingToggle(),
                    const SizedBox(height: AppSpacing.xl),
                    // Plan Cards
                    ..._plans.map((plan) => Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                          child: _PlanCard(
                            name: plan['name'],
                            price: _isAnnual
                                ? plan['priceAnnual']
                                : plan['price'],
                            isAnnual: _isAnnual,
                            features: plan['features'],
                            isPopular: plan['popular'] ?? false,
                            isSelected: _selectedPlan == plan['name'],
                            onTap: () {
                              setState(() => _selectedPlan = plan['name']);
                            },
                          ),
                        )),
                    const SizedBox(height: AppSpacing.lg),
                    // Fine Print
                    Text(
                      'Tidak perlu kartu kredit untuk trial',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            // Bottom Button
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: const BoxDecoration(
                color: AppColors.background,
                border: Border(
                  top: BorderSide(color: AppColors.divider),
                ),
              ),
              child: AppButton(
                text: 'Mulai Trial Gratis',
                onPressed: _handleStartTrial,
                isLoading: _isLoading,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(int current, int total) {
    return Row(
      children: [
        Text(
          'Langkah $current dari $total',
          style: AppTypography.caption,
        ),
        const Spacer(),
        Row(
          children: List.generate(
            total,
            (index) => Container(
              margin: const EdgeInsets.only(left: AppSpacing.sm),
              width: 18,
              height: 5,
              decoration: BoxDecoration(
                color: index < current ? AppColors.primary : AppColors.border,
                borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBillingToggle() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xs),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _BillingOption(
              label: 'Bulanan',
              isSelected: !_isAnnual,
              onTap: () => setState(() => _isAnnual = false),
            ),
            _BillingOption(
              label: 'Tahunan',
              badge: 'Hemat 20%',
              isSelected: _isAnnual,
              onTap: () => setState(() => _isAnnual = true),
            ),
          ],
        ),
      ),
    );
  }
}

class _BillingOption extends StatelessWidget {
  final String label;
  final String? badge;
  final bool isSelected;
  final VoidCallback onTap;

  const _BillingOption({
    required this.label,
    this.badge,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.background : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
            if (badge != null) ...[
              const SizedBox(width: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                ),
                child: Text(
                  badge!,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textWhite,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String name;
  final int price;
  final bool isAnnual;
  final List<Map<String, dynamic>> features;
  final bool isPopular;
  final bool isSelected;
  final VoidCallback onTap;

  const _PlanCard({
    required this.name,
    required this.price,
    required this.isAnnual,
    required this.features,
    required this.isPopular,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.background,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          boxShadow: isPopular
              ? [
                  BoxShadow(
                    color: AppColors.shadowPrimary,
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Text(
                  name,
                  style: AppTypography.headingMedium,
                ),
                const Spacer(),
                if (isPopular)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                    ),
                    child: Text(
                      'Paling Populer',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textWhite,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            // Price
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rp ${price == 0 ? '0' : '${price ~/ 1000}rb'}',
                  style: AppTypography.displayLarge.copyWith(fontSize: 28),
                ),
                const SizedBox(width: AppSpacing.xs),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    price == 0 ? '' : (isAnnual ? '/tahun' : '/bulan'),
                    style: AppTypography.bodySmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            const Divider(),
            const SizedBox(height: AppSpacing.lg),
            // Features
            ...features.map((feature) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: Row(
                    children: [
                      Icon(
                        feature['included']
                            ? Icons.check_circle
                            : Icons.cancel,
                        size: 20,
                        color: feature['included']
                            ? AppColors.success
                            : AppColors.disabled,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          feature['text'],
                          style: AppTypography.bodySmall.copyWith(
                            color: feature['included']
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
