import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_empty_state.dart';

/// Product List Screen
/// Manage products (Owner only)
class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategory;

  // TODO: Replace with actual data from provider
  final List<Map<String, dynamic>> _products = [
    {
      'id': '1',
      'name': 'Nasi Goreng Special',
      'category': 'Makanan',
      'price': 25000,
      'stock': 50,
      'lowStockThreshold': 10,
      'isActive': true,
      'isFavorite': true,
      'image': null,
    },
    {
      'id': '2',
      'name': 'Es Teh Manis',
      'category': 'Minuman',
      'price': 5000,
      'stock': 5,
      'lowStockThreshold': 10,
      'isActive': true,
      'isFavorite': false,
      'image': null,
    },
    {
      'id': '3',
      'name': 'Ayam Bakar',
      'category': 'Makanan',
      'price': 30000,
      'stock': 0,
      'lowStockThreshold': 5,
      'isActive': false,
      'isFavorite': false,
      'image': null,
    },
  ];

  final List<String> _categories = [
    'Semua',
    'Makanan',
    'Minuman',
    'Snack',
    'Lainnya',
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

    // Filter by tab
    if (_tabController.index == 1) {
      // Low Stock tab
      products = products.where((p) {
        return p['stock'] <= p['lowStockThreshold'];
      }).toList();
    }

    // Filter by category
    if (_selectedCategory != null && _selectedCategory != 'Semua') {
      products = products.where((p) => p['category'] == _selectedCategory).toList();
    }

    // Filter by search
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
        title: const Text('Kelola Produk'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () {
              context.goNamed(AppRoutes.barcodeScannerName);
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'categories') {
                context.goNamed(AppRoutes.categoryName);
              } else if (value == 'stock') {
                context.goNamed(AppRoutes.stockName);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'categories',
                child: Row(
                  children: [
                    Icon(Icons.category, size: 20),
                    SizedBox(width: 12),
                    Text('Kelola Kategori'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'stock',
                child: Row(
                  children: [
                    Icon(Icons.inventory, size: 20),
                    SizedBox(width: 12),
                    Text('Kelola Stok'),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(150),
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
              // Category Chips
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isSelected = _selectedCategory == category ||
                        (_selectedCategory == null && category == 'Semua');
                    return Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
                      child: FilterChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = category == 'Semua' ? null : category;
                          });
                        },
                        backgroundColor: AppColors.surface,
                        selectedColor: AppColors.primary.withOpacity(0.1),
                        checkmarkColor: AppColors.primary,
                        labelStyle: AppTypography.bodySmall.copyWith(
                          color: isSelected ? AppColors.primary : AppColors.textSecondary,
                        ),
                        side: BorderSide(
                          color: isSelected ? AppColors.primary : AppColors.border,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              // Tabs
              TabBar(
                controller: _tabController,
                onTap: (index) => setState(() {}),
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.primary,
                tabs: const [
                  Tab(text: 'Semua Produk'),
                  Tab(text: 'Stok Menipis'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: _buildProductList(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.goNamed(AppRoutes.productAddName);
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'Tambah Produk',
          style: AppTypography.bodyRegular.copyWith(
            color: AppColors.textWhite,
          ),
        ),
      ),
    );
  }

  Widget _buildProductList() {
    final products = _filteredProducts;

    if (products.isEmpty) {
      return AppEmptyState(
        icon: Icons.inventory_2,
        title: 'Tidak ada produk',
        message: _searchController.text.isNotEmpty
            ? 'Coba kata kunci lain'
            : 'Tambah produk pertama Anda',
        actionText: 'Tambah Produk',
        onAction: () {
          context.goNamed(AppRoutes.productAddName);
        },
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _ProductCard(
          product: product,
          onTap: () {
            context.goNamed(
              AppRoutes.productEditName,
              pathParameters: {'id': product['id']},
            );
          },
          onToggleFavorite: () {
            setState(() {
              product['isFavorite'] = !product['isFavorite'];
            });
          },
          onToggleActive: () {
            setState(() {
              product['isActive'] = !product['isActive'];
            });
          },
        );
      },
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;
  final VoidCallback onToggleActive;

  const _ProductCard({
    required this.product,
    required this.onTap,
    required this.onToggleFavorite,
    required this.onToggleActive,
  });

  @override
  Widget build(BuildContext context) {
    final isLowStock = product['stock'] <= product['lowStockThreshold'];
    final isOutOfStock = product['stock'] == 0;
    final isActive = product['isActive'] as bool;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: isActive ? AppColors.background : AppColors.surface,
            border: Border.all(
              color: isOutOfStock
                  ? AppColors.error.withOpacity(0.3)
                  : (isLowStock ? AppColors.warning.withOpacity(0.3) : AppColors.border),
            ),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: Row(
            children: [
              // Image
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  image: product['image'] != null
                      ? DecorationImage(
                          image: NetworkImage(product['image']),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: product['image'] == null
                    ? Icon(
                        Icons.shopping_bag,
                        color: AppColors.textSecondary,
                        size: 32,
                      )
                    : null,
              ),
              const SizedBox(width: AppSpacing.lg),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            product['name'],
                            style: AppTypography.bodyRegular.copyWith(
                              fontWeight: FontWeight.w600,
                              decoration: !isActive ? TextDecoration.lineThrough : null,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            product['isFavorite'] ? Icons.star : Icons.star_border,
                            color: product['isFavorite'] ? AppColors.secondary : AppColors.textSecondary,
                            size: 20,
                          ),
                          onPressed: onToggleFavorite,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product['category'],
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Text(
                          CurrencyFormatter.format(product['price']),
                          style: AppTypography.bodyLarge.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isOutOfStock
                                ? AppColors.error.withOpacity(0.1)
                                : (isLowStock
                                    ? AppColors.warning.withOpacity(0.1)
                                    : AppColors.success.withOpacity(0.1)),
                            borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                          ),
                          child: Text(
                            isOutOfStock
                                ? 'Habis'
                                : 'Stok: ${product['stock']}',
                            style: AppTypography.caption.copyWith(
                              color: isOutOfStock
                                  ? AppColors.error
                                  : (isLowStock ? AppColors.warning : AppColors.success),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Switch(
                          value: isActive,
                          onChanged: (value) => onToggleActive(),
                          activeColor: AppColors.success,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
