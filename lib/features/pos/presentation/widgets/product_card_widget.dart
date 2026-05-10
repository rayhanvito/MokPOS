import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';

/// Product Card Widget for POS screen
class ProductCardWidget extends StatelessWidget {
  final String name;
  final int price;
  final String? image;
  final int stock;
  final bool isFavorite;
  final int quantity;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const ProductCardWidget({
    super.key,
    required this.name,
    required this.price,
    this.image,
    required this.stock,
    this.isFavorite = false,
    this.quantity = 0,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final isOutOfStock = stock == 0;
    final isLowStock = stock > 0 && stock <= 10;

    return GestureDetector(
      onTap: isOutOfStock ? null : onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          border: Border.all(
            color: quantity > 0 ? AppColors.primary : AppColors.border,
            width: quantity > 0 ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(AppSpacing.radiusMd),
                      ),
                    ),
                    child: Center(
                      child: image != null
                          ? Image.network(
                              image!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return _buildPlaceholder();
                              },
                            )
                          : _buildPlaceholder(),
                    ),
                  ),
                ),
                // Info
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: AppTypography.bodySmall.copyWith(
                          fontWeight: FontWeight.w500,
                          color: isOutOfStock
                              ? AppColors.textSecondary
                              : AppColors.textPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        CurrencyFormatter.format(price),
                        style: AppTypography.bodyLarge.copyWith(
                          color: isOutOfStock
                              ? AppColors.textSecondary
                              : AppColors.primary,
                          fontSize: 14,
                        ),
                      ),
                      if (isLowStock) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.warning.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                          ),
                          child: Text(
                            'Stok: $stock',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.warning,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            // Favorite Badge
            if (isFavorite)
              Positioned(
                top: AppSpacing.sm,
                right: AppSpacing.sm,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.secondary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.star,
                    color: AppColors.textWhite,
                    size: 14,
                  ),
                ),
              ),
            // Out of Stock Overlay
            if (isOutOfStock)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.background.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                      child: Text(
                        'HABIS',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textWhite,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            // Quantity Badge
            if (quantity > 0)
              Positioned(
                top: AppSpacing.sm,
                left: AppSpacing.sm,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Text(
                    '$quantity',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textWhite,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Icon(
      Icons.shopping_bag_outlined,
      size: 48,
      color: AppColors.textSecondary.withOpacity(0.3),
    );
  }
}
