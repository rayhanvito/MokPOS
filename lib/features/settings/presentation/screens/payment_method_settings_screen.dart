import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

class PaymentMethodSettingsScreen extends StatefulWidget {
  const PaymentMethodSettingsScreen({super.key});

  @override
  State<PaymentMethodSettingsScreen> createState() => _PaymentMethodSettingsScreenState();
}

class _PaymentMethodSettingsScreenState extends State<PaymentMethodSettingsScreen> {
  final Map<String, bool> _methods = {
    'Tunai': true,
    'QRIS': true,
    'Transfer Bank': true,
    'Kartu Debit': false,
    'Kartu Kredit': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Metode Pembayaran')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: _methods.entries.map((entry) {
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
                Icon(
                  entry.key == 'Tunai' ? Icons.payments :
                  entry.key == 'QRIS' ? Icons.qr_code :
                  entry.key == 'Transfer Bank' ? Icons.account_balance :
                  Icons.credit_card,
                  color: AppColors.primary,
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Text(entry.key, style: AppTypography.bodyRegular.copyWith(fontWeight: FontWeight.w600)),
                ),
                Switch(
                  value: entry.value,
                  onChanged: (v) => setState(() => _methods[entry.key] = v),
                  activeColor: AppColors.success,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
