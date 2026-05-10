import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

/// Barcode Scanner Screen
/// Scan product barcode to add to cart or search
class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  bool _isFlashOn = false;
  bool _isScanning = true;
  String? _scannedCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Preview (placeholder)
          // TODO: Implement mobile_scanner package
          Center(
            child: Container(
              color: Colors.black87,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.qr_code_scanner,
                    size: 120,
                    color: AppColors.textWhite.withOpacity(0.3),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    'Arahkan kamera ke barcode',
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.textWhite,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Scanner akan otomatis mendeteksi barcode',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textWhite.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Scanning Frame
          Center(
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                border: Border.all(
                  color: _isScanning ? AppColors.primary : AppColors.success,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              ),
              child: Stack(
                children: [
                  // Corner decorations
                  _buildCorner(Alignment.topLeft),
                  _buildCorner(Alignment.topRight),
                  _buildCorner(Alignment.bottomLeft),
                  _buildCorner(Alignment.bottomRight),
                  // Scanning line animation
                  if (_isScanning)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0, end: 1),
                        duration: const Duration(seconds: 2),
                        builder: (context, double value, child) {
                          return Transform.translate(
                            offset: Offset(0, value * 280),
                            child: Container(
                              height: 2,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    AppColors.primary,
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        onEnd: () {
                          if (mounted && _isScanning) {
                            setState(() {});
                          }
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Top Bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => context.pop(),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      _isFlashOn ? Icons.flash_on : Icons.flash_off,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() => _isFlashOn = !_isFlashOn);
                      // TODO: Toggle flash
                    },
                  ),
                ],
              ),
            ),
          ),

          // Bottom Info
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    if (_scannedCode != null) ...[
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                          border: Border.all(color: AppColors.success),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: AppColors.success,
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Barcode Terdeteksi',
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.textWhite,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _scannedCode!,
                                    style: AppTypography.bodyLarge.copyWith(
                                      color: AppColors.textWhite,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                    ],
                    ElevatedButton(
                      onPressed: () {
                        // Simulate scan for demo
                        setState(() {
                          _scannedCode = '1234567890123';
                          _isScanning = false;
                        });
                        // TODO: Process scanned barcode
                        Future.delayed(const Duration(seconds: 1), () {
                          if (mounted) {
                            context.pop(_scannedCode);
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        ),
                      ),
                      child: Text(
                        'Simulasi Scan (Demo)',
                        style: AppTypography.bodyLarge.copyWith(
                          color: AppColors.textWhite,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextButton(
                      onPressed: () {
                        // Show manual input dialog
                        _showManualInputDialog();
                      },
                      child: Text(
                        'Input Manual',
                        style: AppTypography.bodyRegular.copyWith(
                          color: AppColors.textWhite,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCorner(Alignment alignment) {
    return Align(
      alignment: alignment,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          border: Border(
            top: alignment.y < 0
                ? BorderSide(color: AppColors.primary, width: 4)
                : BorderSide.none,
            bottom: alignment.y > 0
                ? BorderSide(color: AppColors.primary, width: 4)
                : BorderSide.none,
            left: alignment.x < 0
                ? BorderSide(color: AppColors.primary, width: 4)
                : BorderSide.none,
            right: alignment.x > 0
                ? BorderSide(color: AppColors.primary, width: 4)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }

  void _showManualInputDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Input Barcode Manual'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: 'Masukkan kode barcode',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                Navigator.pop(context);
                context.pop(controller.text);
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
