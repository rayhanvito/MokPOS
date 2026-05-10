import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';

class StoreSettingsScreen extends StatefulWidget {
  const StoreSettingsScreen({super.key});

  @override
  State<StoreSettingsScreen> createState() => _StoreSettingsScreenState();
}

class _StoreSettingsScreenState extends State<StoreSettingsScreen> {
  final _storeNameController = TextEditingController(text: 'Warung Makan Sederhana');
  final _addressController = TextEditingController(text: 'Jl. Raya No. 123');
  final _phoneController = TextEditingController(text: '021-12345678');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Pengaturan Toko')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            AppTextField(controller: _storeNameController, label: 'Nama Toko'),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(controller: _addressController, label: 'Alamat', maxLines: 3),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(controller: _phoneController, label: 'Telepon Toko'),
            const SizedBox(height: AppSpacing.xl),
            AppButton(text: 'Simpan Perubahan', onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
