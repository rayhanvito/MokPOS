import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_empty_state.dart';

/// Customer Input Screen
/// Select existing customer or add new one
class CustomerInputScreen extends StatefulWidget {
  const CustomerInputScreen({super.key});

  @override
  State<CustomerInputScreen> createState() => _CustomerInputScreenState();
}

class _CustomerInputScreenState extends State<CustomerInputScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _showAddForm = false;
  String? _selectedCustomerId;

  // TODO: Replace with actual customer data from provider
  final List<Map<String, dynamic>> _customers = [
    {
      'id': '1',
      'name': 'Budi Santoso',
      'phone': '081234567890',
      'lastPurchase': '2 hari yang lalu',
    },
    {
      'id': '2',
      'name': 'Siti Aminah',
      'phone': '081234567891',
      'lastPurchase': '1 minggu yang lalu',
    },
    {
      'id': '3',
      'name': 'Andi Wijaya',
      'phone': '081234567892',
      'lastPurchase': '3 hari yang lalu',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredCustomers {
    if (_searchController.text.isEmpty) {
      return _customers;
    }
    return _customers.where((customer) {
      final name = customer['name'].toString().toLowerCase();
      final phone = customer['phone'].toString();
      final query = _searchController.text.toLowerCase();
      return name.contains(query) || phone.contains(query);
    }).toList();
  }

  void _handleSelectCustomer(String customerId) {
    setState(() => _selectedCustomerId = customerId);
    // TODO: Save to cart provider
    context.pop();
  }

  void _handleAddNewCustomer() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nama pelanggan wajib diisi'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // TODO: Save new customer
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_nameController.text} berhasil ditambahkan'),
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
        title: const Text('Pilih Pelanggan'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: AppTextField(
              controller: _searchController,
              hint: 'Cari nama atau nomor telepon...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() => _searchController.clear());
                      },
                    )
                  : null,
              onChanged: (value) => setState(() {}),
            ),
          ),
          // Add New Customer Button
          if (!_showAddForm)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: AppButton.secondary(
                text: 'Tambah Pelanggan Baru',
                icon: Icons.person_add,
                onPressed: () {
                  setState(() => _showAddForm = true);
                },
              ),
            ),
          const SizedBox(height: AppSpacing.lg),
          // Content
          Expanded(
            child: _showAddForm ? _buildAddForm() : _buildCustomerList(),
          ),
          // Continue Without Customer
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: const BoxDecoration(
              color: AppColors.background,
              border: Border(
                top: BorderSide(color: AppColors.divider),
              ),
            ),
            child: SafeArea(
              child: AppButton.ghost(
                text: 'Lanjut Tanpa Pelanggan',
                onPressed: () => context.pop(),
                isFullWidth: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerList() {
    final customers = _filteredCustomers;

    if (customers.isEmpty) {
      return AppEmptyState(
        icon: Icons.person_search,
        title: 'Pelanggan tidak ditemukan',
        message: 'Coba kata kunci lain atau tambah pelanggan baru',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      itemCount: customers.length,
      itemBuilder: (context, index) {
        final customer = customers[index];
        return _CustomerCard(
          name: customer['name'],
          phone: customer['phone'],
          lastPurchase: customer['lastPurchase'],
          isSelected: _selectedCustomerId == customer['id'],
          onTap: () => _handleSelectCustomer(customer['id']),
        );
      },
    );
  }

  Widget _buildAddForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back to List
          TextButton.icon(
            onPressed: () {
              setState(() => _showAddForm = false);
            },
            icon: const Icon(Icons.arrow_back),
            label: const Text('Kembali ke Daftar'),
          ),
          const SizedBox(height: AppSpacing.lg),
          // Form Title
          Text(
            'Tambah Pelanggan Baru',
            style: AppTypography.headingMedium,
          ),
          const SizedBox(height: AppSpacing.xl),
          // Name Field
          AppTextField(
            label: 'Nama Pelanggan *',
            hint: 'Masukkan nama lengkap',
            controller: _nameController,
            textInputAction: TextInputAction.next,
            prefixIcon: const Icon(Icons.person_outline),
          ),
          const SizedBox(height: AppSpacing.lg),
          // Phone Field
          AppTextField(
            label: 'Nomor Telepon',
            hint: '08xxxxxxxxxx',
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            prefixIcon: const Icon(Icons.phone_outlined),
          ),
          const SizedBox(height: AppSpacing.xl),
          // Save Button
          AppButton(
            text: 'Simpan & Pilih',
            onPressed: _handleAddNewCustomer,
            icon: Icons.check,
          ),
        ],
      ),
    );
  }
}

class _CustomerCard extends StatelessWidget {
  final String name;
  final String phone;
  final String lastPurchase;
  final bool isSelected;
  final VoidCallback onTap;

  const _CustomerCard({
    required this.name,
    required this.phone,
    required this.lastPurchase,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.background,
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Text(
                  name[0].toUpperCase(),
                  style: AppTypography.headingSmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTypography.bodyLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      phone,
                      style: AppTypography.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Terakhir belanja: $lastPurchase',
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              ),
              // Selected Indicator
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: AppColors.primary,
                  size: 28,
                )
              else
                const Icon(
                  Icons.circle_outlined,
                  color: AppColors.border,
                  size: 28,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
