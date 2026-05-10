import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_text_field.dart';

/// Employee List Screen
/// Manage employees (Owner only)
class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  final List<Map<String, dynamic>> _employees = [
    {'id': '1', 'name': 'Andi Wijaya', 'pin': '123456', 'isActive': true, 'totalTransactions': 156},
    {'id': '2', 'name': 'Budi Santoso', 'pin': '234567', 'isActive': true, 'totalTransactions': 98},
    {'id': '3', 'name': 'Citra Dewi', 'pin': '345678', 'isActive': false, 'totalTransactions': 45},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Kelola Karyawan'),
      ),
      body: _employees.isEmpty
          ? AppEmptyState(
              icon: Icons.people,
              title: 'Belum ada karyawan',
              message: 'Tambah karyawan untuk mulai',
              actionText: 'Tambah Karyawan',
              onAction: _showAddEmployeeDialog,
            )
          : ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: _employees.length,
              itemBuilder: (context, index) {
                final employee = _employees[index];
                return _EmployeeCard(
                  employee: employee,
                  onEdit: () => _showEditEmployeeDialog(employee),
                  onToggleActive: () {
                    setState(() => employee['isActive'] = !employee['isActive']);
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddEmployeeDialog,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('Tambah Karyawan', style: TextStyle(color: AppColors.textWhite)),
      ),
    );
  }

  void _showAddEmployeeDialog() {
    final nameController = TextEditingController();
    final pinController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Karyawan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(controller: nameController, label: 'Nama', hintText: 'Nama karyawan'),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              controller: pinController,
              label: 'PIN (6 digit)',
              hintText: '123456',
              keyboardType: TextInputType.number,
              maxLength: 6,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && pinController.text.length == 6) {
                setState(() {
                  _employees.add({
                    'id': DateTime.now().toString(),
                    'name': nameController.text,
                    'pin': pinController.text,
                    'isActive': true,
                    'totalTransactions': 0,
                  });
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }

  void _showEditEmployeeDialog(Map<String, dynamic> employee) {
    final nameController = TextEditingController(text: employee['name']);
    final pinController = TextEditingController(text: employee['pin']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Karyawan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(controller: nameController, label: 'Nama', hintText: 'Nama karyawan'),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              controller: pinController,
              label: 'PIN (6 digit)',
              hintText: '123456',
              keyboardType: TextInputType.number,
              maxLength: 6,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              setState(() {
                employee['name'] = nameController.text;
                employee['pin'] = pinController.text;
              });
              Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}

class _EmployeeCard extends StatelessWidget {
  final Map<String, dynamic> employee;
  final VoidCallback onEdit;
  final VoidCallback onToggleActive;

  const _EmployeeCard({
    required this.employee,
    required this.onEdit,
    required this.onToggleActive,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = employee['isActive'] as bool;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isActive ? AppColors.background : AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: Text(employee['name'][0], style: TextStyle(color: AppColors.primary)),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(employee['name'], style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text('${employee['totalTransactions']} transaksi', style: AppTypography.caption),
              ],
            ),
          ),
          Switch(value: isActive, onChanged: (v) => onToggleActive(), activeColor: AppColors.success),
          IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: onEdit),
        ],
      ),
    );
  }
}
