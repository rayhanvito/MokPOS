import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController(text: 'Budi Santoso');
  final _emailController = TextEditingController(text: 'budi@email.com');
  final _phoneController = TextEditingController(text: '081234567890');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Profil Saya')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: Icon(Icons.person, size: 50, color: AppColors.primary),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextButton(onPressed: () {}, child: const Text('Ubah Foto')),
            const SizedBox(height: AppSpacing.xl),
            AppTextField(controller: _nameController, label: 'Nama Lengkap'),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(controller: _emailController, label: 'Email'),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(controller: _phoneController, label: 'Nomor Telepon'),
            const SizedBox(height: AppSpacing.xl),
            AppButton(text: 'Simpan Perubahan', onPressed: () {}),
            const SizedBox(height: AppSpacing.md),
            AppButton(text: 'Ubah Password', variant: AppButtonVariant.secondary, onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
