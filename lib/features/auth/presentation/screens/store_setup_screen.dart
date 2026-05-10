import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';

/// Store Setup Screen
/// Owner configures their store profile after registration
class StoreSetupScreen extends StatefulWidget {
  const StoreSetupScreen({super.key});

  @override
  State<StoreSetupScreen> createState() => _StoreSetupScreenState();
}

class _StoreSetupScreenState extends State<StoreSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _storeNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();

  String? _selectedCategory;
  String? _logoPath;
  bool _isLoading = false;

  final List<String> _categories = [
    'Makanan & Minuman',
    'Retail',
    'Fashion',
    'Elektronik',
    'Kesehatan & Kecantikan',
    'Lainnya',
  ];

  @override
  void dispose() {
    _storeNameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: source,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() => _logoPath = image.path);
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppColors.primary),
                title: const Text('Ambil Foto'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: AppColors.primary),
                title: const Text('Pilih dari Galeri'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleContinue() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih kategori bisnis'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // TODO: Save store data to backend
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() => _isLoading = false);

    // Navigate to choose plan
    context.goNamed(AppRoutes.choosePlanName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            // Show confirmation dialog
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Batalkan Setup?'),
                content: const Text(
                  'Anda akan keluar dari proses setup toko. Data yang sudah diisi akan hilang.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Tidak'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.goNamed(AppRoutes.roleSelectionName);
                    },
                    child: const Text('Ya, Batalkan'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress Indicator
                _buildProgressIndicator(2, 3),
                const SizedBox(height: AppSpacing.xl),
                // Title
                Text(
                  'Atur Toko Kamu',
                  style: AppTypography.headingLarge,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Informasi ini akan muncul di struk dan dashboard',
                  style: AppTypography.bodySmall,
                ),
                const SizedBox(height: AppSpacing.xxxl),
                // Logo Upload
                Center(
                  child: _buildLogoUpload(),
                ),
                const SizedBox(height: AppSpacing.xxxl),
                // Store Name
                AppTextField(
                  label: 'Nama Toko *',
                  hint: 'Contoh: Toko Berkah',
                  controller: _storeNameController,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStrings.fieldRequired;
                    }
                    return null;
                  },
                  prefixIcon: const Icon(Icons.store),
                ),
                const SizedBox(height: AppSpacing.lg),
                // Category
                _buildCategorySelector(),
                const SizedBox(height: AppSpacing.lg),
                // Address
                AppTextField(
                  label: 'Alamat Toko',
                  hint: 'Jl. Contoh No. 123',
                  controller: _addressController,
                  maxLines: 3,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.location_on_outlined),
                ),
                const SizedBox(height: AppSpacing.lg),
                // Phone
                AppTextField(
                  label: 'Nomor Telepon Toko',
                  hint: '08xxxxxxxxxx',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                  prefixIcon: const Icon(Icons.phone_outlined),
                ),
                const SizedBox(height: AppSpacing.xxxl),
                // Continue Button
                AppButton(
                  text: AppStrings.continue_,
                  onPressed: _handleContinue,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
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

  Widget _buildLogoUpload() {
    return Column(
      children: [
        GestureDetector(
          onTap: _showImageSourceDialog,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface,
              border: Border.all(color: AppColors.border, width: 2),
            ),
            child: _logoPath != null
                ? ClipOval(
                    child: Image.network(
                      _logoPath!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.store,
                          size: 40,
                          color: AppColors.textSecondary,
                        );
                      },
                    ),
                  )
                : const Icon(
                    Icons.camera_alt,
                    size: 40,
                    color: AppColors.textSecondary,
                  ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        TextButton(
          onPressed: _showImageSourceDialog,
          child: Text(
            _logoPath != null ? 'Ubah Logo' : 'Upload Logo',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kategori Bisnis *',
          style: AppTypography.label,
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: _categories.map((category) {
            final isSelected = _selectedCategory == category;
            return ChoiceChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() => _selectedCategory = selected ? category : null);
              },
              backgroundColor: AppColors.surface,
              selectedColor: AppColors.primary.withOpacity(0.1),
              labelStyle: AppTypography.bodySmall.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              ),
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.border,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
