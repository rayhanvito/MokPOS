import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_empty_state.dart';

/// Cart Screen
/// Review order before payment
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // TODO: Replace with actual cart data from provider
  final List<Map<String, dynamic>> _cartItems = [
    {
      'id': '1',
      'name': 'Kopi Susu',
      'price': 15000,
      'quantity': 2,
      'image': null,
    },
    {
      'id': '2',
      'name': 'Nasi Goreng',
      'price': 25000,
      'quantity': 1,
      'image': null,
    },
  ];

  String? _selectedCustomer;
  int _discount = 0;
  String _note = '';

  int get _subtotal {
    return _cartItems.fold(
      0,
      (sum, item) => sum + ((item['price'] as int) * (item['quantity'] as int)),
    );
  }

  int get _total => _subtotal - _discount;

  void _updateQuantity(String itemId, int newQuantity) {
    setState(() {
      final index = _cartItems.indexWhere((item) => item['id'] == itemId);
      if (index != -1) {
        if (newQuantity <= 0) {
          _cartItems.removeAt(index);
        } else {
          _cartItems[index]['quantity'] = newQuantity;
        }
      }
    });
  }

  void _showDiscountDialog() {
    final discountController = TextEditingController(
      text: _discount > 0 ? _discount.toString() : '',
    );
    bool isPercentage = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Tambah Diskon'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Nominal (Rp)'),
                      selected: !isPercentage,
                      onSelected: (selected) {
                        setDialogState(() => isPercentage = false);
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Persen (%)'),
                      selected: isPercentage,
                      onSelected: (selected) {
                        setDialogState(() => isPercentage = true);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              TextField(
                controller: discountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: isPercentage ? 'Diskon (%)' : 'Diskon (Rp)',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Total setelah diskon: ${CurrencyFormatter.format(_calculateDiscountPreview(discountController.text, isPercentage))}',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.success,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                final value = num.tryParse(discountController.text) ?? 0;
                setState(() {
                  if (isPercentage) {
                    _discount = (_subtotal * value / 100).round();
                  } else {
                    _discount = value.toInt();
                  }
                });
                Navigator.pop(context);
              },
              child: const Text('Terapkan'),
            ),
          ],
        ),
      ),
    );
  }

  int _calculateDiscountPreview(String value, bool isPercentage) {
    final discountValue = num.tryParse(value) ?? 0;
    final discount = isPercentage
        ? (_subtotal * discountValue / 100).round()
        : discountValue.toInt();
    return _subtotal - discount;
  }

  @override
  Widget build(BuildContext context) {
    if (_cartItems.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Pesanan'),
        ),
        body: AppEmptyState(
          icon: Icons.shopping_cart_outlined,
          title: 'Keranjang Kosong',
          message: 'Tambahkan produk untuk memulai transaksi',
          actionText: 'Kembali ke POS',
          onAction: () => context.pop(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Pesanan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Hapus Semua?'),
                  content: const Text(
                    'Apakah Anda yakin ingin menghapus semua item dari keranjang?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() => _cartItems.clear());
                        Navigator.pop(context);
                      },
                      child: const Text('Hapus'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cart Items
                  ..._cartItems.map((item) => _CartItemCard(
                        name: item['name'],
                        price: item['price'],
                        quantity: item['quantity'],
                        image: item['image'],
                        onQuantityChanged: (newQty) {
                          _updateQuantity(item['id'], newQty);
                        },
                        onDelete: () {
                          _updateQuantity(item['id'], 0);
                        },
                      )),
                  const SizedBox(height: AppSpacing.lg),
                  const Divider(),
                  const SizedBox(height: AppSpacing.lg),
                  // Customer Section
                  _buildCustomerSection(),
                  const SizedBox(height: AppSpacing.lg),
                  // Discount Section
                  _buildDiscountSection(),
                  const SizedBox(height: AppSpacing.lg),
                  // Note Section
                  _buildNoteSection(),
                  const SizedBox(height: AppSpacing.lg),
                  const Divider(),
                  const SizedBox(height: AppSpacing.lg),
                  // Order Summary
                  _buildOrderSummary(),
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
            child: SafeArea(
              child: AppButton(
                text: 'Bayar ${CurrencyFormatter.format(_total)}',
                onPressed: () => context.goNamed(AppRoutes.paymentCashName),
                icon: Icons.payment,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerSection() {
    return InkWell(
      onTap: () => context.goNamed(AppRoutes.customerInputName),
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Row(
          children: [
            const Icon(Icons.person_outline, color: AppColors.primary),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedCustomer ?? 'Tambah Pelanggan',
                    style: AppTypography.bodyLarge,
                  ),
                  if (_selectedCustomer == null)
                    Text(
                      'Opsional',
                      style: AppTypography.caption,
                    ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscountSection() {
    return InkWell(
      onTap: _showDiscountDialog,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Row(
          children: [
            const Icon(Icons.discount_outlined, color: AppColors.primary),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _discount > 0 ? 'Diskon' : 'Tambah Diskon',
                    style: AppTypography.bodyLarge,
                  ),
                  if (_discount > 0)
                    Text(
                      CurrencyFormatter.format(_discount),
                      style: AppTypography.caption.copyWith(
                        color: AppColors.success,
                      ),
                    ),
                ],
              ),
            ),
            if (_discount > 0)
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: () => setState(() => _discount = 0),
              )
            else
              const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteSection() {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Catatan Pesanan',
        hintText: 'Tambahkan catatan (opsional)',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        prefixIcon: const Icon(Icons.note_outlined),
      ),
      maxLines: 2,
      onChanged: (value) => _note = value,
    );
  }

  Widget _buildOrderSummary() {
    return Column(
      children: [
        _SummaryRow(
          label: 'Subtotal',
          value: CurrencyFormatter.format(_subtotal),
        ),
        if (_discount > 0) ...[
          const SizedBox(height: AppSpacing.md),
          _SummaryRow(
            label: 'Diskon',
            value: '- ${CurrencyFormatter.format(_discount)}',
            valueColor: AppColors.success,
          ),
        ],
        const SizedBox(height: AppSpacing.md),
        const Divider(),
        const SizedBox(height: AppSpacing.md),
        _SummaryRow(
          label: 'Total',
          value: CurrencyFormatter.format(_total),
          isTotal: true,
        ),
      ],
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final String name;
  final int price;
  final int quantity;
  final String? image;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onDelete;

  const _CartItemCard({
    required this.name,
    required this.price,
    required this.quantity,
    this.image,
    required this.onQuantityChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        children: [
          // Image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: const Icon(
              Icons.shopping_bag_outlined,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTypography.bodyLarge,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  CurrencyFormatter.format(price),
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          // Quantity Controls
          Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => onQuantityChanged(quantity - 1),
                    icon: const Icon(Icons.remove_circle_outline),
                    color: AppColors.primary,
                    iconSize: 24,
                  ),
                  Text(
                    '$quantity',
                    style: AppTypography.bodyLarge,
                  ),
                  IconButton(
                    onPressed: () => onQuantityChanged(quantity + 1),
                    icon: const Icon(Icons.add_circle_outline),
                    color: AppColors.primary,
                    iconSize: 24,
                  ),
                ],
              ),
              Text(
                CurrencyFormatter.format(price * quantity),
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isTotal;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? AppTypography.headingSmall
              : AppTypography.bodyRegular,
        ),
        Text(
          value,
          style: isTotal
              ? AppTypography.headingMedium.copyWith(
                  color: AppColors.primary,
                )
              : AppTypography.bodyLarge.copyWith(
                  color: valueColor ?? AppColors.textPrimary,
                ),
        ),
      ],
    );
  }
}
