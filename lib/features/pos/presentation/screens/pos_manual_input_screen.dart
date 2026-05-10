import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/utils/currency_formatter.dart';

/// POS Manual Input Screen
/// Add custom item to cart without registered product
class PosManualInputScreen extends StatefulWidget {
  const PosManualInputScreen({super.key});

  @override
  State<PosManualInputScreen> createState() => _PosManualInputScreenState();
}

class _PosManualInputScreenState extends State<PosManualInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _noteController = TextEditingController();
  
  int _quantity = 1;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _incrementQuantity() {
    setState(() => _quantity++);
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() => _quantity--);
    }
  }

  void _handleAddToCart() {
    if (!_formKey.currentState!.validate()) return;

    // TODO: Add to cart provider
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_nameController.text} ditambahkan ke keranjang'),
        backgroundColor: AppColors.success,
      ),
    );

    context.pop();
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }
    return null;
  }

  String? _validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }
    final price = CurrencyFormatter.parse(value);
    if (price <= 0) {
      return 'Harga harus lebih dari 0';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Input Manual'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Info
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: AppColors.info.withOpacity(0.1),
                          border: Border.all(
                            color: AppColors.info.withOpacity(0.3),
                          ),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: AppColors.info,
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Text(
                                'Gunakan untuk item yang tidak terdaftar di sistem',
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.info,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      // Item Name
                      AppTextField(
                        label: 'Nama Item *',
                        hint: 'Contoh: Jasa Service',
                        controller: _nameController,
                        textInputAction: TextInputAction.next,
                        validator: _validateName,
                        prefixIcon: const Icon(Icons.label_outline),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      // Price
                      AppTextField(
                        label: 'Harga *',
                        hint: '0',
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        validator: _validatePrice,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          child: Text(
                            'Rp',
                            style: AppTypography.bodyRegular,
                          ),
                        ),
                        onChanged: (value) {
                          // Format as typing
                          final formatted = CurrencyFormatter.formatAsTyping(value);
                          if (formatted != value) {
                            _priceController.value = TextEditingValue(
                              text: formatted,
                              selection: TextSelection.collapsed(
                                offset: formatted.length,
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      // Quantity
                      Text(
                        'Jumlah',
                        style: AppTypography.label,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _buildQuantitySelector(),
                      const SizedBox(height: AppSpacing.lg),
                      // Note
                      AppTextField(
                        label: 'Catatan (Opsional)',
                        hint: 'Tambahkan catatan...',
                        controller: _noteController,
                        maxLines: 3,
                        textInputAction: TextInputAction.done,
                        prefixIcon: const Icon(Icons.note_outlined),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      // Total Preview
                      _buildTotalPreview(),
                    ],
                  ),
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
                text: 'Tambah ke Keranjang',
                onPressed: _handleAddToCart,
                icon: Icons.add_shopping_cart,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantitySelector() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: _decrementQuantity,
            icon: const Icon(Icons.remove),
            color: _quantity > 1 ? AppColors.primary : AppColors.disabled,
          ),
          Expanded(
            child: Text(
              '$_quantity',
              style: AppTypography.headingMedium,
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            onPressed: _incrementQuantity,
            icon: const Icon(Icons.add),
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildTotalPreview() {
    final priceText = _priceController.text.replaceAll('.', '');
    final price = num.tryParse(priceText) ?? 0;
    final total = price * _quantity;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total',
            style: AppTypography.bodyLarge,
          ),
          Text(
            CurrencyFormatter.format(total),
            style: AppTypography.headingMedium.copyWith(
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
