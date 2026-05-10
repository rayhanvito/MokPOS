import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_text_field.dart';

/// Category Screen
/// Manage product categories (Owner only)
class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  // TODO: Replace with actual data from provider
  final List<Map<String, dynamic>> _categories = [
    {'id': '1', 'name': 'Makanan', 'productCount': 25, 'color': 0xFFE74C3C},
    {'id': '2', 'name': 'Minuman', 'productCount': 18, 'color': 0xFF3498DB},
    {'id': '3', 'name': 'Snack', 'productCount': 12, 'color': 0xFFF39C12},
    {'id': '4', 'name': 'Lainnya', 'productCount': 5, 'color': 0xFF95A5A6},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Kelola Kategori'),
      ),
      body: _categories.isEmpty
          ? AppEmptyState(
              icon: Icons.category,
              title: 'Belum ada kategori',
              message: 'Tambah kategori untuk mengorganisir produk',
              actionText: 'Tambah Kategori',
              onAction: _showAddCategoryDialog,
            )
          : ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return _CategoryCard(
                  category: category,
                  onEdit: () => _showEditCategoryDialog(category),
                  onDelete: () => _showDeleteConfirmation(category),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddCategoryDialog,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddCategoryDialog() {
    final nameController = TextEditingController();
    int selectedColor = 0xFF1A72DD;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Tambah Kategori'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(
                controller: nameController,
                label: 'Nama Kategori',
                hintText: 'Contoh: Makanan',
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Pilih Warna',
                style: AppTypography.label.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  0xFFE74C3C, // Red
                  0xFF3498DB, // Blue
                  0xFF2ECC71, // Green
                  0xFFF39C12, // Orange
                  0xFF9B59B6, // Purple
                  0xFF1ABC9C, // Turquoise
                  0xFF34495E, // Dark Gray
                  0xFF95A5A6, // Gray
                ].map((color) {
                  final isSelected = selectedColor == color;
                  return InkWell(
                    onTap: () {
                      setDialogState(() => selectedColor = color);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(color),
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(
                                color: AppColors.textPrimary,
                                width: 3,
                              )
                            : null,
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 20,
                            )
                          : null,
                    ),
                  );
                }).toList(),
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
                if (nameController.text.isNotEmpty) {
                  setState(() {
                    _categories.add({
                      'id': DateTime.now().toString(),
                      'name': nameController.text,
                      'productCount': 0,
                      'color': selectedColor,
                    });
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Kategori berhasil ditambahkan')),
                  );
                }
              },
              child: const Text('Tambah'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditCategoryDialog(Map<String, dynamic> category) {
    final nameController = TextEditingController(text: category['name']);
    int selectedColor = category['color'];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Edit Kategori'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(
                controller: nameController,
                label: 'Nama Kategori',
                hintText: 'Contoh: Makanan',
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Pilih Warna',
                style: AppTypography.label.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  0xFFE74C3C,
                  0xFF3498DB,
                  0xFF2ECC71,
                  0xFFF39C12,
                  0xFF9B59B6,
                  0xFF1ABC9C,
                  0xFF34495E,
                  0xFF95A5A6,
                ].map((color) {
                  final isSelected = selectedColor == color;
                  return InkWell(
                    onTap: () {
                      setDialogState(() => selectedColor = color);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(color),
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(
                                color: AppColors.textPrimary,
                                width: 3,
                              )
                            : null,
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 20,
                            )
                          : null,
                    ),
                  );
                }).toList(),
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
                if (nameController.text.isNotEmpty) {
                  setState(() {
                    category['name'] = nameController.text;
                    category['color'] = selectedColor;
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Kategori berhasil diperbarui')),
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

  void _showDeleteConfirmation(Map<String, dynamic> category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Kategori?'),
        content: Text(
          'Kategori "${category['name']}" akan dihapus. ${category['productCount']} produk akan dipindahkan ke kategori "Lainnya".',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _categories.remove(category);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Kategori berhasil dihapus')),
              );
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

class _CategoryCard extends StatelessWidget {
  final Map<String, dynamic> category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CategoryCard({
    required this.category,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: InkWell(
        onTap: onEdit,
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
              // Color Indicator
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Color(category['color']),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Icon(
                  Icons.category,
                  color: AppColors.textWhite,
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category['name'],
                      style: AppTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${category['productCount']} produk',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Actions
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                onPressed: onEdit,
                color: AppColors.primary,
              ),
              IconButton(
                icon: const Icon(Icons.delete, size: 20),
                onPressed: onDelete,
                color: AppColors.error,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
