import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';

/// Report Screen
/// Sales analytics and reports for Owner
class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'Hari Ini';

  final List<String> _periods = [
    'Hari Ini',
    'Minggu Ini',
    'Bulan Ini',
    'Tahun Ini',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Laporan Penjualan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              // TODO: Export report
              _showExportDialog();
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              // Period Selector
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.md,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedPeriod,
                            isExpanded: true,
                            icon: const Icon(Icons.arrow_drop_down),
                            items: _periods.map((period) {
                              return DropdownMenuItem(
                                value: period,
                                child: Text(period),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _selectedPeriod = value);
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () {
                        // TODO: Custom date range picker
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              // Tabs
              TabBar(
                controller: _tabController,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.primary,
                tabs: const [
                  Tab(text: 'Ringkasan'),
                  Tab(text: 'Produk'),
                  Tab(text: 'Kasir'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSummaryTab(),
          _buildProductTab(),
          _buildCashierTab(),
        ],
      ),
    );
  }

  Widget _buildSummaryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Revenue Cards
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'Total Penjualan',
                  value: CurrencyFormatter.format(5250000),
                  icon: Icons.trending_up,
                  color: AppColors.success,
                  trend: '+12.5%',
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _buildStatCard(
                  title: 'Transaksi',
                  value: '156',
                  icon: Icons.receipt_long,
                  color: AppColors.primary,
                  trend: '+8.3%',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'Rata-rata',
                  value: CurrencyFormatter.format(33654),
                  icon: Icons.analytics,
                  color: AppColors.warning,
                  trend: '+5.2%',
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _buildStatCard(
                  title: 'Item Terjual',
                  value: '423',
                  icon: Icons.shopping_cart,
                  color: AppColors.secondary,
                  trend: '+15.7%',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          // Payment Method Breakdown
          _buildSectionTitle('Metode Pembayaran'),
          const SizedBox(height: AppSpacing.md),
          _buildPaymentMethodCard(),
          const SizedBox(height: AppSpacing.xl),

          // Hourly Sales Chart
          _buildSectionTitle('Penjualan per Jam'),
          const SizedBox(height: AppSpacing.md),
          _buildHourlySalesChart(),
          const SizedBox(height: AppSpacing.xl),

          // Top Categories
          _buildSectionTitle('Kategori Terlaris'),
          const SizedBox(height: AppSpacing.md),
          _buildTopCategoriesCard(),
        ],
      ),
    );
  }

  Widget _buildProductTab() {
    // TODO: Replace with actual data
    final products = [
      {'name': 'Nasi Goreng Special', 'sold': 45, 'revenue': 1125000},
      {'name': 'Ayam Bakar', 'sold': 38, 'revenue': 1140000},
      {'name': 'Es Teh Manis', 'sold': 92, 'revenue': 460000},
      {'name': 'Mie Goreng', 'sold': 32, 'revenue': 640000},
      {'name': 'Soto Ayam', 'sold': 28, 'revenue': 560000},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _buildProductReportCard(
          rank: index + 1,
          name: product['name'] as String,
          sold: product['sold'] as int,
          revenue: product['revenue'] as int,
        );
      },
    );
  }

  Widget _buildCashierTab() {
    // TODO: Replace with actual data
    final cashiers = [
      {'name': 'Andi Wijaya', 'transactions': 68, 'revenue': 2340000},
      {'name': 'Budi Santoso', 'transactions': 52, 'revenue': 1890000},
      {'name': 'Citra Dewi', 'transactions': 36, 'revenue': 1020000},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: cashiers.length,
      itemBuilder: (context, index) {
        final cashier = cashiers[index];
        return _buildCashierReportCard(
          rank: index + 1,
          name: cashier['name'] as String,
          transactions: cashier['transactions'] as int,
          revenue: cashier['revenue'] as int,
        );
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    String? trend,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
              if (trend != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                  ),
                  child: Text(
                    trend,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            title,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTypography.headingMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
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

  Widget _buildPaymentMethodCard() {
    final methods = [
      {'name': 'Tunai', 'amount': 2850000, 'percentage': 54.3},
      {'name': 'QRIS', 'amount': 1680000, 'percentage': 32.0},
      {'name': 'Transfer', 'amount': 520000, 'percentage': 9.9},
      {'name': 'Split Payment', 'amount': 200000, 'percentage': 3.8},
    ];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        children: methods.map((method) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      method['name'] as String,
                      style: AppTypography.bodyRegular,
                    ),
                    Text(
                      CurrencyFormatter.format(method['amount'] as int),
                      style: AppTypography.bodyRegular.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                  child: LinearProgressIndicator(
                    value: (method['percentage'] as double) / 100,
                    backgroundColor: AppColors.surface,
                    valueColor: AlwaysStoppedAnimation(AppColors.primary),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHourlySalesChart() {
    // Simplified bar chart representation
    final hours = [
      {'hour': '09:00', 'amount': 250000},
      {'hour': '10:00', 'amount': 380000},
      {'hour': '11:00', 'amount': 520000},
      {'hour': '12:00', 'amount': 680000},
      {'hour': '13:00', 'amount': 590000},
      {'hour': '14:00', 'amount': 420000},
      {'hour': '15:00', 'amount': 350000},
      {'hour': '16:00', 'amount': 480000},
    ];

    final maxAmount = hours.map((h) => h['amount'] as int).reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        children: hours.map((hour) {
          final amount = hour['amount'] as int;
          final percentage = amount / maxAmount;

          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Row(
              children: [
                SizedBox(
                  width: 50,
                  child: Text(
                    hour['hour'] as String,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: percentage,
                        child: Container(
                          height: 32,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppColors.primary, AppColors.primary.withOpacity(0.7)],
                            ),
                            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                          ),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: AppSpacing.sm),
                          child: Text(
                            CurrencyFormatter.formatCompact(amount),
                            style: AppTypography.caption.copyWith(
                              color: AppColors.textWhite,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTopCategoriesCard() {
    final categories = [
      {'name': 'Makanan', 'sold': 145, 'percentage': 45.2},
      {'name': 'Minuman', 'sold': 112, 'percentage': 34.9},
      {'name': 'Snack', 'sold': 64, 'percentage': 19.9},
    ];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        children: categories.map((category) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category['name'] as String,
                        style: AppTypography.bodyRegular.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${category['sold']} item terjual',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${category['percentage']}%',
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildProductReportCard({
    required int rank,
    required String name,
    required int sold,
    required int revenue,
  }) {
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
          // Rank
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: rank <= 3 ? AppColors.primary.withOpacity(0.1) : AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            alignment: Alignment.center,
            child: Text(
              '$rank',
              style: AppTypography.bodyRegular.copyWith(
                color: rank <= 3 ? AppColors.primary : AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTypography.bodyRegular.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$sold item terjual',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Revenue
          Text(
            CurrencyFormatter.format(revenue),
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCashierReportCard({
    required int rank,
    required String name,
    required int transactions,
    required int revenue,
  }) {
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
          // Avatar
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: Text(
              name[0],
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTypography.bodyRegular.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$transactions transaksi',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Revenue
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                CurrencyFormatter.format(revenue),
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                ),
                child: Text(
                  '#$rank',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ekspor Laporan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: const Text('PDF'),
              onTap: () {
                // TODO: Export as PDF
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.table_chart),
              title: const Text('Excel'),
              onTap: () {
                // TODO: Export as Excel
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
