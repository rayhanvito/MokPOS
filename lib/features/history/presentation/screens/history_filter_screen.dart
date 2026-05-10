import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/app_button.dart';

/// History Filter Screen
/// Advanced filters for transaction history
class HistoryFilterScreen extends StatefulWidget {
  const HistoryFilterScreen({super.key});

  @override
  State<HistoryFilterScreen> createState() => _HistoryFilterScreenState();
}

class _HistoryFilterScreenState extends State<HistoryFilterScreen> {
  // Filter state
  DateTimeRange? _dateRange;
  String? _selectedPaymentMethod;
  String? _selectedStatus;
  String? _selectedCashier;
  RangeValues _amountRange = const RangeValues(0, 1000000);

  final List<String> _paymentMethods = [
    'Semua',
    'Tunai',
    'QRIS',
    'Transfer',
    'Split Payment',
  ];

  final List<String> _statuses = [
    'Semua',
    'Berhasil',
    'Void',
    'Refund',
  ];

  final List<String> _cashiers = [
    'Semua',
    'Andi',
    'Budi',
    'Citra',
    'Dedi',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Filter Transaksi'),
        actions: [
          TextButton(
            onPressed: _resetFilters,
            child: Text(
              'Reset',
              style: AppTypography.bodyRegular.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Range
            _buildSectionTitle('Rentang Tanggal'),
            const SizedBox(height: AppSpacing.md),
            _buildDateRangeSelector(),
            const SizedBox(height: AppSpacing.xl),

            // Payment Method
            _buildSectionTitle('Metode Pembayaran'),
            const SizedBox(height: AppSpacing.md),
            _buildChipSelector(
              items: _paymentMethods,
              selectedItem: _selectedPaymentMethod,
              onSelected: (value) {
                setState(() {
                  _selectedPaymentMethod = value == 'Semua' ? null : value;
                });
              },
            ),
            const SizedBox(height: AppSpacing.xl),

            // Status
            _buildSectionTitle('Status Transaksi'),
            const SizedBox(height: AppSpacing.md),
            _buildChipSelector(
              items: _statuses,
              selectedItem: _selectedStatus,
              onSelected: (value) {
                setState(() {
                  _selectedStatus = value == 'Semua' ? null : value;
                });
              },
            ),
            const SizedBox(height: AppSpacing.xl),

            // Cashier
            _buildSectionTitle('Kasir'),
            const SizedBox(height: AppSpacing.md),
            _buildChipSelector(
              items: _cashiers,
              selectedItem: _selectedCashier,
              onSelected: (value) {
                setState(() {
                  _selectedCashier = value == 'Semua' ? null : value;
                });
              },
            ),
            const SizedBox(height: AppSpacing.xl),

            // Amount Range
            _buildSectionTitle('Rentang Nominal'),
            const SizedBox(height: AppSpacing.md),
            _buildAmountRangeSlider(),
            const SizedBox(height: AppSpacing.xxxl),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: AppButton(
            text: 'Terapkan Filter',
            onPressed: _applyFilters,
          ),
        ),
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

  Widget _buildDateRangeSelector() {
    return InkWell(
      onTap: _selectDateRange,
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
            Icon(
              Icons.calendar_today,
              color: AppColors.primary,
              size: 20,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                _dateRange == null
                    ? 'Pilih rentang tanggal'
                    : '${_formatDate(_dateRange!.start)} - ${_formatDate(_dateRange!.end)}',
                style: AppTypography.bodyRegular.copyWith(
                  color: _dateRange == null
                      ? AppColors.textSecondary
                      : AppColors.textPrimary,
                ),
              ),
            ),
            if (_dateRange != null)
              IconButton(
                icon: const Icon(Icons.clear, size: 20),
                onPressed: () {
                  setState(() => _dateRange = null);
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildChipSelector({
    required List<String> items,
    required String? selectedItem,
    required Function(String) onSelected,
  }) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: items.map((item) {
        final isSelected = selectedItem == item || (selectedItem == null && item == 'Semua');
        return FilterChip(
          label: Text(item),
          selected: isSelected,
          onSelected: (selected) => onSelected(item),
          backgroundColor: AppColors.background,
          selectedColor: AppColors.primary.withOpacity(0.1),
          checkmarkColor: AppColors.primary,
          labelStyle: AppTypography.bodySmall.copyWith(
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
          ),
          side: BorderSide(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAmountRangeSlider() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Rp ${_amountRange.start.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              'Rp ${_amountRange.end.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        RangeSlider(
          values: _amountRange,
          min: 0,
          max: 1000000,
          divisions: 20,
          activeColor: AppColors.primary,
          inactiveColor: AppColors.border,
          onChanged: (values) {
            setState(() => _amountRange = values);
          },
        ),
      ],
    );
  }

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _dateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.textWhite,
              surface: AppColors.background,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _dateRange = picked);
    }
  }

  void _resetFilters() {
    setState(() {
      _dateRange = null;
      _selectedPaymentMethod = null;
      _selectedStatus = null;
      _selectedCashier = null;
      _amountRange = const RangeValues(0, 1000000);
    });
  }

  void _applyFilters() {
    // TODO: Apply filters to history provider
    // For now, just go back
    context.pop();
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
