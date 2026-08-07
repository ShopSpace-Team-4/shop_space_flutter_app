import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Six-slot OTP entry (T011) backed by `pin_code_fields`' [MaterialPinField].
///
/// The [controller] (a [PinInputController]) owns the underlying text field
/// and focus; callers only watch [onChanged] (to drive button state) and
/// [onSubmitted]. Cell styling maps the Figma OTP field onto existing tokens.
class OtpInput extends StatelessWidget {
  const OtpInput({
    super.key,
    required this.controller,
    this.semanticsLabel,
    this.enabled = true,
    this.onChanged,
    this.onSubmitted,
  });

  static const int length = 6;

  final PinInputController controller;
  final String? semanticsLabel;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return MaterialPinField(
      length: length,
      pinController: controller,
      semanticLabel: semanticsLabel,
      enabled: enabled,
      enableAutofill: true,
      autofillHints: const [AutofillHints.oneTimeCode],
      textInputAction: TextInputAction.done,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      theme: MaterialPinTheme(
        shape: MaterialPinShape.outlined,
        cellSize: const Size(48, 56),
        spacing: AppSpacing.sm,
        borderRadius: BorderRadius.circular(12),
        borderWidth: 1,
        focusedBorderWidth: 2,
        fillColor: AppColors.surface,
        focusedFillColor: AppColors.surface,
        filledFillColor: AppColors.surface,
        borderColor: AppColors.outline,
        focusedBorderColor: AppColors.primary,
        filledBorderColor: AppColors.outline,
        cursorColor: AppColors.primary,
        textStyle: AppTypography.heading3.copyWith(color: AppColors.textPrimary),
      ),
    );
  }
}
