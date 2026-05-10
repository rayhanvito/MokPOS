import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';

class ReceiptSettingsScreen extends StatefulWidget {
  const ReceiptSettingsScreen({super.key});

  @override
  State<ReceiptSettingsScreen> createState() => _ReceiptSettingsScreenState();
}

class _ReceiptSettingsScreenState extends State<ReceiptSettingsScreen> {
  final _headerController = TextEditingController(text: 'Terima kasih atas kunjungan Anda');
  final _footerController = TextEditingController(text: 'Barang yang sudah dibeli tidak dapat dikembalikan');
  bool _showLogo = true;
  bool _showAddress = true;
  bool _autoPrint = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Pengaturan Struk')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(controller: _headerController, label: 'Header Struk', maxLines: 2),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(controller: _footerController, label: 'Footer Struk', maxLines: 2),
            const SizedBox(height: AppSpacing.xl),
            _buildSwitch('Tampilkan Logo', _showLogo, (v) => setState(() => _showLogo = v)),
            _buildSwitch('Tampilkan Alamat', _showAddress, (v) => setState(() => _showAddress = v)),
            _buildSwitch('Cetak Otomatis', _autoPrint, (v) => setState(() => _autoPrint = v)),
            const SizedBox(height: AppSpacing.xl),
            AppButton(text: 'Simpan Pengaturan', onPressed: () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitch(String title, bool value, Function(bool) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTypography.bodyRegular),
          Switch(value: value, onChanged: onChanged, activeColor: AppColors.success),
        ],
      ),
    );
  }
}
