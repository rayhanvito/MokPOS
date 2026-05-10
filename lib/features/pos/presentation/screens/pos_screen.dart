import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../widgets/product_card_widget.dart';

/// POS Screen - Phone Layout
/// Main selling screen with product grid and cart summary
class PosScreen extends StatefulWidget {
  const PosScreen({super.key});

  @override
  State<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  
  String _selectedCategory = 'Semua';
  final List<String> _categories = [
    'Semua',
    'Makanan',
    'Minuman',
    'Snack',
    'Lainnya',
  ];

  // TODO: Replace with actual data from provider
  final List<Map<String, dynamic>> _products = [
    {
      'id': '1',
      'name': 'Kopi Susu',
      'price': 15000,
      'image': null,
      'stock': 50,
      'category': 'Minuman',
      'isFavorite': true,
    },
    {
      'id': '2',
      'name': 'Nasi Goreng',
      'price': 25000,
      'image': null,
      'stock': 30,
      'category': 'Makanan',
      'isFavorite': true,
    },
    {
      'id': '3',
      'name': 'Es Teh',
      'price': 5000,
      'image': null,
      'stock': 100,
      'category': 'Minuman',
      'isFavorite': false,
    },
    {
      'id': '4',
      'name': 'Mie Goreng',
      'price': 20000,
      'image': null,
      'stock': 25,
      'category': 'Makanan',
      'isFavorite': false,
    },
    {
      'id': '5',
      'name': 'Keripik',
      'price': 10000,
      'image': null,
      'stock': 5,
      'category': 'Snack',
      'isFavorite': false,
    },
    {
      'id': '6',
      'name': 'Jus Jeruk',
      'price': 12000,
      'image': null,
      'stock': 0,
      'category': 'Minuman',
      'isFavorite': false,
    },
  ];

  final Map<String, int> _cart = {}; // productId: quantity

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

    // Filter by tab (All or Favorites)
    if (_tabController.index == 1) {
      products = products.where((p) => p['isFavorite'] == true).toList();
    }

    // Filter by category
    if (_selectedCategory != 'Semua') {
      products = products.where((p) => p['category'] == _selectedCategory).toList();
    }

    // Filter by search
    if (_searchController.text.isNotEmpty) {
      products = products
          .where((p) => p['name']
              .toString()
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    }

    return products;
  }

  int get _cartItemCount {
    return _cart.values.fold(0, (sum, qty) => sum + qty);
  }

  int get _cartTotal {
    int total = 0;
    _cart.forEach((productId, quantity) {
      final product = _products.firstWhere((p) => p['id'] == productId);
      total += (product['price'] as int) * quantity;
    });
    return total;
  }

  void _addToCart(String productId) {
    setState(() {
      _cart[productId] = (_cart[productId] ?? 0) + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Point of Sale'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () => context.goNamed(AppRoutes.scannerName),
          ),
          IconButton(
            icon: const Icon(Icons.edit_note),
            onPressed: () => context.goNamed(AppRoutes.posManualInputName),
          ),
        ],
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
                onTap: (index) => setState(() {}),
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.primary,
                tabs: const [
                  Tab(text: 'Semua Produk'),
                  Tab(text: 'Favorit'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Category Chips
          _buildCategoryChips(),
          // Product Grid
          Expanded(
            child: _buildProductGrid(),
          ),
        ],
      ),
      bottomNavigationBar: _cart.isNotEmpty ? _buildCartSummary() : null,
    );
  }

  Widget _buildCategoryChips() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: ChoiceChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() => _selectedCategory = category);
              },
              backgroundColor: AppColors.surface,
              selectedColor: AppColors.primary,
              labelStyle: AppTypography.bodySmall.copyWith(
                color: isSelected ? AppColors.textWhite : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductGrid() {
    final products = _filteredProducts;

    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: AppColors.disabled,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Produk tidak ditemukan',
              style: AppTypography.bodyLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Coba kata kunci lain',
              style: AppTypography.bodySmall,
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        final quantity = _cart[product['id']] ?? 0;

        return ProductCardWidget(
          name: product['name'],
          price: product['price'],
          image: product['image'],
          stock: product['stock'],
          isFavorite: product['isFavorite'],
          quantity: quantity,
          onTap: () => _addToCart(product['id']),
          onLongPress: () => _showProductDetail(product),
        );
      },
    );
  }

  Widget _buildCartSummary() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(color: AppColors.divider),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowDark,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$_cartItemCount item',
                    style: AppTypography.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    CurrencyFormatter.format(_cartTotal),
                    style: AppTypography.headingMedium,
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => context.goNamed(AppRoutes.cartName),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textWhite,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.lg,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
              ),
              child: Row(
                children: [
                  const Text('Lihat Pesanan'),
                  const SizedBox(width: AppSpacing.sm),
                  const Icon(Icons.arrow_forward, size: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProductDetail(Map<String, dynamic> product) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            // Product Info
            Text(
              product['name'],
              style: AppTypography.headingMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              CurrencyFormatter.format(product['price']),
              style: AppTypography.headingSmall.copyWith(
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Stok: ${product['stock']} unit',
              style: AppTypography.bodySmall,
            ),
            const SizedBox(height: AppSpacing.xl),
            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      // TODO: Toggle favorite
                    },
                    icon: Icon(
                      product['isFavorite']
                          ? Icons.star
                          : Icons.star_border,
                    ),
                    label: Text(
                      product['isFavorite']
                          ? 'Hapus dari Favorit'
                          : 'Tambah ke Favorit',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}
