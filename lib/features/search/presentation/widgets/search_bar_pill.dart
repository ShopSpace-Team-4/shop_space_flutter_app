import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';

/// Stadium quick-filter search pill (Figma 97:5219) for the Search screen.
///
/// Replaces the plain title in the compact/medium `AppBar` and sits in the
/// expanded results-area header. Purely presentational: the owning screen
/// supplies [controller] + [focusNode] and receives [onChanged] on every
/// keystroke (the screen debounces + resolves the text into existing filters).
/// The trailing clear affordance appears only while the field has text and
/// just empties the field — it never resets filters itself.
class SearchBarPill extends StatefulWidget {
  const SearchBarPill({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hint,
    required this.clearTooltip,
    required this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final String clearTooltip;
  final ValueChanged<String> onChanged;

  @override
  State<SearchBarPill> createState() => _SearchBarPillState();
}

class _SearchBarPillState extends State<SearchBarPill> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _hasText = widget.controller.text.isNotEmpty;
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(SearchBarPill oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onControllerChanged);
      widget.controller.addListener(_onControllerChanged);
      _hasText = widget.controller.text.isNotEmpty;
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    final bool hasText = widget.controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  void _onClear() {
    widget.controller.clear();
    widget.onChanged('');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        onChanged: widget.onChanged,
        textInputAction: TextInputAction.search,
        style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: AppTypography.bodyMedium.copyWith(
            color: AppColors.textTertiary,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 11.h),
          prefixIcon: Padding(
            padding: EdgeInsetsDirectional.only(start: 14.w, end: 8.w),
            child: Icon(
              Icons.search,
              size: 20.sp,
              color: AppColors.textSecondary,
            ),
          ),
          suffixIcon: _hasText
              ? Padding(
                  padding: EdgeInsetsDirectional.only(end: 4.w),
                  child: IconButton(
                    onPressed: _onClear,
                    tooltip: widget.clearTooltip,
                    icon: Icon(
                      Icons.close,
                      size: 18.sp,
                      color: AppColors.textTertiary,
                    ),
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    constraints: BoxConstraints(minWidth: 24.w, minHeight: 24.h),
                    splashRadius: 20.r,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
