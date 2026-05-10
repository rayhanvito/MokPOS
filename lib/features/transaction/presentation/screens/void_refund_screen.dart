import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';

/// Void/Refund Screen
/// Owner only - Cancel or refund transaction
class VoidRefundScreen extends StatefulWidget {
  const VoidRefundScreen({super.key});

  @override
  State<VoidRefundScreen> createState() => _VoidRefundScreenState();
}

class _VoidRefundScreenState extends State<VoidRefundScreen> {
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();

  // TODO: Get from transaction data
  final String _transactionId = 'TRX20260510001';
  final DateTime _transactionTime = DateTime.now();
  final int _totalAmount = 55000;
  final String _paymentMethod = 'Tunai';
  final String _cashierName = 'Andi';

  final List<Map<String, dynamic>> _items = [
    {'name': 'Kopi Susu', 'qty': 2, 'price': 15000},
    {'name': 'Nasi Goreng', 'qty': 1, 'price': 25000},
  ];

  String _selectedAction = 'void'; // void or refund
  bool _isProcessing = false;

  @override
  void dispose() {
    _reasonController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _handleConfirm() async {
    if (_reasonController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Alasan wajib diisi'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_pinController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PIN Owner wajib diisi (6 digit)'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_selectedAction == 'void' ? 'Batalkan Transaksi?' : 'Refund Transaksi?'),
        content: Text(
          _selectedAction == 'void'
              ? 'Transaksi akan dibatalkan dan tidak dapat dikembalikan.'
              : 'Uang akan dikembalikan ke pelanggan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text('Ya, Lanjutkan'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isProcessing = true);

    // TODO: Process void/refund
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() => _isProcessing = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _selectedAction == 'void'
              ? 'Transaksi berhasil dibatalkan'
              : 'Refund berhasil diproses',
        ),
        backgroundColor: AppColors.success,
      ),
    );

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Batalkan / Refund'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Warning Box
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.1),
                        border: Border.all(
                          color: AppColors.error.withOpacity(0.3),
                        ),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.warning_amber_rounded,
                            color: AppColors.error,
                            size: 32,
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Text(
                              'Tindakan ini memerlukan otorisasi Owner dan tidak dapat dibatalkan',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    // Transaction Info
                    Text(
                      'Detail Transaksi',
                      style: AppTypography.headingSmall,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildTransactionInfo(),
                    const SizedBox(height: AppSpacing.xl),
                    // Action Type
                    Text(
                      'Jenis Tindakan',
                      style: AppTypography.headingSmall,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildActionSelector(),
                    const SizedBox(height: AppSpacing.xl),
                    // Reason
                    AppTextField(
                      label: 'Alasan *',
                      hint: 'Jelaskan alasan pembatalan/refund',
                      controller: _reasonController,
                      maxLines: 3,
                      prefixIcon: const Icon(Icons.note_outlined),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    // Owner PIN
                    AppTextField(
                      label: 'PIN Owner *',
                      hint: 'Masukkan PIN 6 digit',
                      controller: _pinController,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      prefixIcon: const Icon(Icons.lock_outline),
                    ),
                  ],
                ),
              ),
            ),
            // Bottom Button
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: const BoxDecoration(
                color: AppColors.background,
                border: Border(
                  top: BorderSide(color: AppColors.divider),
                ),
              ),
              child: AppButton(
                text: _selectedAction == 'void' ? 'Batalkan Transaksi' : 'Proses Refund',
                onPressed: _handleConfirm,
                isLoading: _isProcessing,
                variant: AppButtonVariant.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionInfo() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        children: [
          _InfoRow(label: 'ID Transaksi', value: _transactionId),
          const SizedBox(height: AppSpacing.sm),
          _InfoRow(
            label: 'Waktu',
            value: DateFormatter.formatDateTime(_transactionTime),
          ),
          const SizedBox(height: AppSpacing.sm),
          _InfoRow(label: 'Kasir', value: _cashierName),
          const SizedBox(height: AppSpacing.sm),
          _InfoRow(label: 'Metode', value: _paymentMethod),
          const SizedBox(height: AppSpacing.md),
          const Divider(),
          const SizedBox(height: AppSpacing.md),
          ..._items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${item['qty']}x ${item['name']}',
                      style: AppTypography.bodySmall,
                    ),
                    Text(
                      CurrencyFormatter.format(item['price'] * item['qty']),
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
              )),
          const SizedBox(height: AppSpacing.md),
          const Divider(),
          const SizedBox(height: AppSpacing.md),
          _InfoRow(
            label: 'TOTAL',
            value: CurrencyFormatter.format(_totalAmount),
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildActionSelector() {
    return Column(
      children: [
        _ActionOption(
          icon: Icons.cancel,
          title: 'Void (Batalkan)',
          description: 'Batalkan transaksi sepenuhnya',
          isSelected: _selectedAction == 'void',
          onTap: () => setState(() => _selectedAction = 'void'),
        ),
        const SizedBox(height: AppSpacing.md),
        _ActionOption(
          icon: Icons.replay,
          title: 'Refund (Kembalikan Uang)',
          description: 'Kembalikan uang ke pelanggan',
          isSelected: _selectedAction == 'refund',
          onTap: () => setState(() => _selectedAction = 'refund'),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _InfoRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isBold
              ? AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600)
              : AppTypography.bodySmall,
        ),
        Text(
          value,
          style: isBold
              ? AppTypography.headingSmall
              : AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _ActionOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const _ActionOption({
    required this.icon,
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.1)
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: AppTypography.caption,
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.primary,
              )
            else
              const Icon(
                Icons.circle_outlined,
                color: AppColors.border,
              ),
          ],
        ),
      ),
    );
  }
}
