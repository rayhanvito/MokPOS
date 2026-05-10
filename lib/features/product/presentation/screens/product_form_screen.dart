import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';

/// Product Form Screen
/// Add or Edit product (Owner only)
class ProductFormScreen extends StatefulWidget {
  final String? productId;

  const ProductFormScreen({
    super.key,
    this.productId,
  });

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _lowStockController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedCategory;
  bool _isActive = true;
  bool _isFavorite = false;
  String? _imagePath;

  final List<String> _categories = [
    'Makanan',
    'Minuman',
    'Snack',
    'Lainnya',
  ];

  bool get _isEditMode => widget.productId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      _loadProductData();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _lowStockController.dispose();
    _barcodeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _loadProductData() {
    // TODO: Load product data from provider
    _nameController.text = 'Nasi Goreng Special';
    _priceController.text = '25000';
    _stockController.text = '50';
    _lowStockController.text = '10';
    _barcodeController.text = '1234567890';
    _descriptionController.text = 'Nasi goreng dengan bumbu special';
    _selectedCategory = 'Makanan';
    _isActive = true;
    _isFavorite = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Produk' : 'Tambah Produk'),
        actions: [
          if (_isEditMode)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: _showDeleteConfirmation,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Upload
              _buildImageUploadSection(),
              const SizedBox(height: AppSpacing.xl),

              // Product Name
              AppTextField(
                controller: _nameController,
                label: 'Nama Produk',
                hintText: 'Contoh: Nasi Goreng Special',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama produk wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.lg),

              // Category
              _buildSectionTitle('Kategori'),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: _categories.map((category) {
                  final isSelected = _selectedCategory == category;
                  return FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _selectedCategory = category);
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
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Price
              AppTextField(
                controller: _priceController,
                label: 'Harga',
                hintText: '0',
                prefixText: 'Rp ',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga wajib diisi';
                  }
                  return null;
                },
                onChanged: (value) {
                  // Format as currency
                  final number = value.replaceAll(RegExp(r'[^0-9]'), '');
                  if (number.isNotEmpty) {
                    final formatted = int.parse(number).toString().replaceAllMapped(
                          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                          (Match m) => '${m[1]}.',
                        );
                    _priceController.value = TextEditingValue(
                      text: formatted,
                      selection: TextSelection.collapsed(offset: formatted.length),
                    );
                  }
                },
              ),
              const SizedBox(height: AppSpacing.lg),

              // Stock
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: _stockController,
                      label: 'Stok',
                      hintText: '0',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Stok wajib diisi';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: AppTextField(
                      controller: _lowStockController,
                      label: 'Batas Stok Minimum',
                      hintText: '0',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Barcode
              AppTextField(
                controller: _barcodeController,
                label: 'Barcode (Opsional)',
                hintText: 'Scan atau input manual',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.qr_code_scanner),
                  onPressed: () {
                    // TODO: Open barcode scanner
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Description
              AppTextField(
                controller: _descriptionController,
                label: 'Deskripsi (Opsional)',
                hintText: 'Deskripsi produk',
                maxLines: 3,
              ),
              const SizedBox(height: AppSpacing.xl),

              // Settings
              _buildSectionTitle('Pengaturan'),
              const SizedBox(height: AppSpacing.md),
              _buildSettingTile(
                title: 'Produk Aktif',
                subtitle: 'Tampilkan produk di POS',
                value: _isActive,
                onChanged: (value) {
                  setState(() => _isActive = value);
                },
              ),
              _buildSettingTile(
                title: 'Produk Favorit',
                subtitle: 'Tampilkan di tab favorit',
                value: _isFavorite,
                onChanged: (value) {
                  setState(() => _isFavorite = value);
                },
              ),
              const SizedBox(height: AppSpacing.xxxl),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: AppButton(
            text: _isEditMode ? 'Simpan Perubahan' : 'Tambah Produk',
            onPressed: _saveProduct,
          ),
        ),
      ),
    );
  }

  Widget _buildImageUploadSection() {
    return Center(
      child: Column(
        children: [
          InkWell(
            onTap: _pickImage,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(
                  color: AppColors.border,
                  style: BorderStyle.solid,
                  width: 2,
                ),
                image: _imagePath != null
                    ? DecorationImage(
                        image: NetworkImage(_imagePath!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: _imagePath == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate,
                          size: 40,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Tambah Foto',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    )
                  : null,
            ),
          ),
          if (_imagePath != null) ...[
            const SizedBox(height: AppSpacing.sm),
            TextButton(
              onPressed: () {
                setState(() => _imagePath = null);
              },
              child: const Text('Hapus Foto'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTypography.label.copyWith(
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildSettingTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
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
                Text(
                  title,
                  style: AppTypography.bodyRegular.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.success,
          ),
        ],
      ),
    );
  }

  void _pickImage() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Ambil Foto'),
              onTap: () {
                // TODO: Open camera
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pilih dari Galeri'),
              onTap: () {
                // TODO: Open gallery
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pilih kategori produk')),
        );
        return;
      }

      // TODO: Save product to provider
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEditMode ? 'Produk berhasil diperbarui' : 'Produk berhasil ditambahkan'),
        ),
      );
      context.pop();
    }
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Produk?'),
        content: const Text(
          'Produk yang dihapus tidak dapat dikembalikan. Yakin ingin menghapus?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Delete product
              Navigator.pop(context);
              context.pop();
            },
            child: const Text(
              'Hapus',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
