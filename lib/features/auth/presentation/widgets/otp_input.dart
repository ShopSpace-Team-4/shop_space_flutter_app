import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Six-slot OTP entry (T011) backed by a single real numeric field.
///
/// The field is kept invisible and captured by [focusNode]; the visible
/// boxes are display-only and translate `controller.text` into slots. The
/// whole surface is one a11y node labelled by [semanticsLabel]. Listens to
/// [controller] so slots track input without parent coordination.
class OtpInput extends StatefulWidget {
  const OtpInput({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.semanticsLabel,
    this.enabled = true,
    this.onChanged,
    this.onSubmitted,
  });

  static const int length = 6;

  final TextEditingController controller;
  final FocusNode focusNode;
  final String semanticsLabel;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  static const double _boxSize = 48;
  static const double _boxGap = AppSpacing.sm;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onInputChanged);
  }

  @override
  void didUpdateWidget(OtpInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onInputChanged);
      widget.controller.addListener(_onInputChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onInputChanged);
    super.dispose();
  }

  void _onInputChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final String value = widget.controller.text;
    final bool focused = widget.focusNode.hasFocus;

    return Semantics(
      container: true,
      label: widget.semanticsLabel,
      child: ExcludeSemantics(
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          onTap: widget.enabled ? widget.focusNode.requestFocus : null,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int index = 0; index < OtpInput.length; index++) ...[
                    if (index > 0) const SizedBox(width: _boxGap),
                    _slot(
                      digit: index < value.length ? value[index] : '',
                      filled: index < value.length,
                      focused: focused && index == value.length,
                    ),
                  ],
                ],
              ),
              Opacity(
                opacity: 0,
                child: TextFormField(
                  controller: widget.controller,
                  focusNode: widget.focusNode,
                  enabled: widget.enabled,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  maxLength: OtpInput.length,
                  maxLines: 1,
                  autofillHints: const [AutofillHints.oneTimeCode],
                  style: AppTypography.bodyLarge,
                  onChanged: widget.onChanged,
                  onFieldSubmitted: widget.onSubmitted,
                  onTapOutside: (_) => widget.focusNode.unfocus(),
                  decoration: const InputDecoration(
                    counterText: '',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _slot({
    required String digit,
    required bool filled,
    required bool focused,
  }) {
    return Container(
      width: _boxSize,
      height: _boxSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(
          color: focused ? AppColors.primary : AppColors.outline,
          width: focused ? 2 : 1,
        ),
      ),
      child: Text(
        digit,
        style: AppTypography.heading3.copyWith(
          color: filled ? AppColors.textPrimary : AppColors.textTertiary,
        ),
      ),
    );
  }
}
