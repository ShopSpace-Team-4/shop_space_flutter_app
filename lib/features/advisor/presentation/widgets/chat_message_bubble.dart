import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/models/advisor_message.dart';

/// One conversation bubble (data-model §1.3).
///
/// Assistant bubbles follow the welcome-bubble style (Figma `97:6479`): white
/// fill + `AppColors.outline` border; user bubbles are the FLAGGED-GAP design
/// (`AppColors.primary` fill, `AppColors.onPrimary` text). The user bubble is
/// anchored to the trailing edge in LTR / leading in RTL (both = the right
/// edge), the assistant bubble to the opposite side — deterministic, so no
/// direction-dependent code.
class ChatMessageBubble extends StatelessWidget {
  const ChatMessageBubble({super.key, required this.message});

  final AdvisorMessage message;

  @override
  Widget build(BuildContext context) {
    final bool isUser = message.role == AdvisorRole.user;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.75,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg.w,
            vertical: AppSpacing.md.h,
          ),
          decoration: BoxDecoration(
            color: isUser ? AppColors.primary : AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.medium.r),
            border: isUser
                ? null
                : Border.all(color: AppColors.outline),
          ),
          child: Text(
            message.content,
            style: AppTypography.bodyMedium.copyWith(
              color: isUser ? AppColors.onPrimary : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
