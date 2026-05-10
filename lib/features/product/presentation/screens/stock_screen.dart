import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_text_field.dart';

/// Stock Screen
/// Manage product stock and inventory (Owner only)
class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  // TODO: Replace with actual data from provider
  final List<Map<String, dynamic>> _products = [
    {
      'id': '1',
      'name': 'Nasi Goreng Special',
      'stock': 50,
      'lowStockThreshold': 10,
      'lastUpdated': DateTime.now().subtract(const Duration(hours: 2)),
    },
    {
      'id': '2',
      'name': 'Es Teh Manis',
      'stock': 5,
      'lowStockThreshold': 10,
      'lastUpdated': DateTime.now().subtract(const Duration(hours: 5)),
    },
    {
      'id': '3',
      'name': 'Ayam Bakar',
      'stock': 0,
      'lowStockThreshold': 5,
      'lastUpdated': DateTime.now().subtract(const Duration(days: 1)),
    },
  ];

  final List<Map<String, dynamic>> _stockHistory = [
    {
      'productName': 'Nasi Goreng Special',
      'type': 'in',
      'quantity': 20,
      'note': 'Restock mingguan',
      'date': DateTime.now().subtract(const Duration(hours: 2)),
      'user': 'Admin',
    },
    {
      'productName': 'Es Teh Manis',
      'type': 'out',
      'quantity': 15,
      'note': 'Terjual',
      'date': DateTime.now().subtract(const Duration(hours: 5)),
      'user': 'Kasir Andi',
    },
    {
      'productName': 'Ayam Bakar',
      'type': 'adjustment',
      'quantity': -3,
      'note': 'Koreksi stok',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'user': 'Admin',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredProducts {
    var products = _products;

    if (_searchController.text.isNotEmpty) {
      products = products.where((p) {
        final query = _searchController.text.toLowerCase();
        return p['name'].toString().toLowerCase().contains(query);
      }).toList();
    }

    return products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Kelola Stok'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari produk...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() => _searchController.clear());
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.md,
                    ),
                  ),
                  onChanged: (value) => setState(() {}),
                ),
              ),
              // Tabs
              TabBar(
                controller: _tabController,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.primary,
                tabs: const [
                  Tab(text: 'Stok Produk'),
                  Tab(text: 'Riwayat'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildStockTab(),
          _buildHistoryTab(),
        ],
      ),
    );
  }

  Widget _buildStockTab() {
    final products = _filteredProducts;

    if (products.isEmpty) {
      return AppEmptyState(
        icon: Icons.inventory_2,
        title: 'Tidak ada produk',
        message: 'Coba kata kunci lain',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _StockCard(
          product: product,
          onAdjust: () => _showStockAdjustmentDialog(product),
        );
      },
    );
  }

  Widget _buildHistoryTab() {
    if (_stockHistory.isEmpty) {
      return const AppEmptyState(
        icon: Icons.history,
        title: 'Belum ada riwayat',
        message: 'Riwayat perubahan stok akan muncul di sini',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: _stockHistory.length,
      itemBuilder: (context, index) {
        final history = _stockHistory[index];
        return _HistoryCard(history: history);
      },
    );
  }

  void _showStockAdjustmentDialog(Map<String, dynamic> product) {
    final quantityController = TextEditingController();
    final noteController = TextEditingController();
    String adjustmentType = 'in'; // 'in', 'out', 'adjustment'

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Sesuaikan Stok\n${product['name']}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Current Stock
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Stok Saat Ini',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        '${product['stock']}',
                        style: AppTypography.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                // Adjustment Type
                Text(
                  'Jenis Penyesuaian',
                  style: AppTypography.label.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  children: [
                    ChoiceChip(
                      label: const Text('Stok Masuk'),
                      selected: adjustmentType == 'in',
                      onSelected: (selected) {
                        setDialogState(() => adjustmentType = 'in');
                      },
                      selectedColor: AppColors.success.withOpacity(0.2),
                      labelStyle: TextStyle(
                        color: adjustmentType == 'in' ? AppColors.success : AppColors.textSecondary,
                      ),
                    ),
                    ChoiceChip(
                      label: const Text('Stok Keluar'),
                      selected: adjustmentType == 'out',
                      onSelected: (selected) {
                        setDialogState(() => adjustmentType = 'out');
                      },
                      selectedColor: AppColors.error.withOpacity(0.2),
                      labelStyle: TextStyle(
                        color: adjustmentType == 'out' ? AppColors.error : AppColors.textSecondary,
                      ),
                    ),
                    ChoiceChip(
                      label: const Text('Koreksi'),
                      selected: adjustmentType == 'adjustment',
                      onSelected: (selected) {
                        setDialogState(() => adjustmentType = 'adjustment');
                      },
                      selectedColor: AppColors.warning.withOpacity(0.2),
                      labelStyle: TextStyle(
                        color: adjustmentType == 'adjustment' ? AppColors.warning : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                // Quantity
                AppTextField(
                  controller: quantityController,
                  label: 'Jumlah',
                  hintText: '0',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: AppSpacing.lg),
                // Note
                AppTextField(
                  controller: noteController,
                  label: 'Catatan (Opsional)',
                  hintText: 'Alasan penyesuaian stok',
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                if (quantityController.text.isNotEmpty) {
                  final quantity = int.parse(quantityController.text);
                  setState(() {
                    if (adjustmentType == 'in') {
                      product['stock'] += quantity;
                    } else if (adjustmentType == 'out') {
                      product['stock'] -= quantity;
                    } else {
                      // adjustment - direct set
                      product['stock'] = quantity;
                    }
                    product['lastUpdated'] = DateTime.now();

                    // Add to history
                    _stockHistory.insert(0, {
                      'productName': product['name'],
                      'type': adjustmentType,
                      'quantity': adjustmentType == 'out' ? -quantity : quantity,
                      'note': noteController.text.isEmpty ? '-' : noteController.text,
                      'date': DateTime.now(),
                      'user': 'Admin',
                    });
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Stok berhasil diperbarui')),
                  );
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StockCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback onAdjust;

  const _StockCard({
    required this.product,
    required this.onAdjust,
  });

  @override
  Widget build(BuildContext context) {
    final stock = product['stock'] as int;
    final threshold = product['lowStockThreshold'] as int;
    final isLowStock = stock <= threshold;
    final isOutOfStock = stock == 0;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(
          color: isOutOfStock
              ? AppColors.error.withOpacity(0.3)
              : (isLowStock ? AppColors.warning.withOpacity(0.3) : AppColors.border),
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'],
                      style: AppTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Diperbarui ${DateFormatter.formatRelative(product['lastUpdated'])}',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: isOutOfStock
                      ? AppColors.error.withOpacity(0.1)
                      : (isLowStock ? AppColors.warning.withOpacity(0.1) : AppColors.success.withOpacity(0.1)),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Text(
                  isOutOfStock ? 'Habis' : '$stock',
                  style: AppTypography.headingMedium.copyWith(
                    color: isOutOfStock
                        ? AppColors.error
                        : (isLowStock ? AppColors.warning : AppColors.success),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Icon(
                Icons.warning_amber,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Batas minimum: $threshold',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: onAdjust,
                icon: const Icon(Icons.edit, size: 16),
                label: const Text('Sesuaikan'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final Map<String, dynamic> history;

  const _HistoryCard({required this.history});

  @override
  Widget build(BuildContext context) {
    final type = history['type'] as String;
    final quantity = history['quantity'] as int;
    final isIncrease = quantity > 0;

    IconData icon;
    Color color;

    switch (type) {
      case 'in':
        icon = Icons.arrow_downward;
        color = AppColors.success;
        break;
      case 'out':
        icon = Icons.arrow_upward;
        color = AppColors.error;
        break;
      default:
        icon = Icons.edit;
        color = AppColors.warning;
    }

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
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  history['productName'],
                  style: AppTypography.bodyRegular.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  history['note'],
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${history['user']} • ${DateFormatter.formatRelative(history['date'])}',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${isIncrease ? '+' : ''}$quantity',
            style: AppTypography.bodyLarge.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
