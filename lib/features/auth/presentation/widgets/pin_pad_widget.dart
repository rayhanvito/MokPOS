import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

/// Custom PIN pad widget for employee login
/// 3x4 grid with numbers 1-9, 0, clear, and backspace
class PinPadWidget extends StatelessWidget {
  final ValueChanged<String> onPinChanged;
  final String currentPin;
  final int maxLength;
  final bool enabled;

  const PinPadWidget({
    super.key,
    required this.onPinChanged,
    required this.currentPin,
    this.maxLength = 6,
    this.enabled = true,
  });

  void _onNumberPressed(String number) {
    if (!enabled) return;
    if (currentPin.length >= maxLength) return;

    HapticFeedback.lightImpact();
    onPinChanged(currentPin + number);
  }

  void _onBackspace() {
    if (!enabled) return;
    if (currentPin.isEmpty) return;

    HapticFeedback.lightImpact();
    onPinChanged(currentPin.substring(0, currentPin.length - 1));
  }

  void _onClear() {
    if (!enabled) return;
    if (currentPin.isEmpty) return;

    HapticFeedback.lightImpact();
    onPinChanged('');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row 1: 1, 2, 3
          _buildRow(['1', '2', '3']),
          const SizedBox(height: AppSpacing.lg),
          // Row 2: 4, 5, 6
          _buildRow(['4', '5', '6']),
          const SizedBox(height: AppSpacing.lg),
          // Row 3: 7, 8, 9
          _buildRow(['7', '8', '9']),
          const SizedBox(height: AppSpacing.lg),
          // Row 4: Clear, 0, Backspace
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _PinButton(
                onPressed: _onClear,
                enabled: enabled && currentPin.isNotEmpty,
                child: const Icon(
                  Icons.clear,
                  color: AppColors.error,
                  size: 28,
                ),
              ),
              _PinButton(
                text: '0',
                onPressed: () => _onNumberPressed('0'),
                enabled: enabled,
              ),
              _PinButton(
                onPressed: _onBackspace,
                enabled: enabled && currentPin.isNotEmpty,
                child: const Icon(
                  Icons.backspace_outlined,
                  color: AppColors.textPrimary,
                  size: 28,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> numbers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: numbers
          .map(
            (number) => _PinButton(
              text: number,
              onPressed: () => _onNumberPressed(number),
              enabled: enabled,
            ),
          )
          .toList(),
    );
  }
}

class _PinButton extends StatelessWidget {
  final String? text;
  final Widget? child;
  final VoidCallback onPressed;
  final bool enabled;

  const _PinButton({
    this.text,
    this.child,
    required this.onPressed,
    this.enabled = true,
  }) : assert(text != null || child != null);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: BorderRadius.circular(AppSpacing.radiusRound),
        child: Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: enabled ? AppColors.border : AppColors.disabled,
              width: 1,
            ),
          ),
          child: Center(
            child: child ??
                Text(
                  text!,
                  style: AppTypography.headingLarge.copyWith(
                    color: enabled ? AppColors.textPrimary : AppColors.disabled,
                  ),
                ),
          ),
        ),
      ),
    );
  }
}
