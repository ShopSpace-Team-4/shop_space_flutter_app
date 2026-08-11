import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Chat input row (Figma `97:6493`/`97:6494`/`97:6496`): a `TextField` pill
/// (`radius 999`, fill `AppColors.surfaceVariant`) with `maxLength: 500` +
/// counter, hint `advisorInputHint`, and a round `AppColors.primary` send
/// button (tooltip `advisorSendTooltip`).
///
/// Send-enabled predicate (Q4/Q7): `!enabled-in-flight && trimmed.isNotEmpty
/// && trimmed.length <= 500` — blank/whitespace blocked, the cap disables
/// send (blocking, not truncation), and [onSend] fires the trimmed text.
class ChatMessageInput extends StatefulWidget {
  const ChatMessageInput({
    super.key,
    required this.enabled,
    required this.onSend,
  });

  /// False while a request generates (`state.isSending`) — disables send and
  /// no-ops a tap mid-flight (Q4).
  final bool enabled;

  /// Receives the trimmed question; the field clears itself after firing.
  final ValueChanged<String> onSend;

  @override
  State<ChatMessageInput> createState() => _ChatMessageInputState();
}

class _ChatMessageInputState extends State<ChatMessageInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  bool get _canSend {
    final String trimmed = _controller.text.trim();
    return widget.enabled &&
        trimmed.isNotEmpty &&
        trimmed.length <= AdvisorChatInput.maxMessageLength;
  }

  void _submit() {
    if (!_canSend) return;
    final String message = _controller.text.trim();
    _controller.clear();
    setState(() {});
    widget.onSend(message);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg.w,
        AppSpacing.sm.h,
        AppSpacing.lg.w,
        AppSpacing.lg.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(AppRadius.pill.r),
                  ),
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    maxLength: AdvisorChatInput.maxMessageLength,
                    maxLines: 4,
                    minLines: 1,
                    textInputAction: TextInputAction.send,
                    onChanged: (_) => setState(() {}),
                    onSubmitted: (_) => _submit(),
                    decoration: InputDecoration(
                      hintText: l10n.advisorInputHint,
                      counterText: '',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg.w,
                        vertical: AppSpacing.md.h,
                      ),
                      isDense: true,
                    ),
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.sm.w),
              SizedBox(
                width: 38.w,
                height: 38.h,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: _canSend ? _submit : null,
                  tooltip: l10n.advisorSendTooltip,
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    disabledBackgroundColor:
                        AppColors.primary.withValues(alpha: 0.4),
                    disabledForegroundColor:
                        AppColors.onPrimary.withValues(alpha: 0.6),
                    shape: const CircleBorder(),
                  ),
                  icon: Icon(Icons.send_rounded, size: 18.sp),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.xs.h),
          Padding(
            padding: EdgeInsets.only(right: 4.w),
            child: Text(
              '${_controller.text.length}/${AdvisorChatInput.maxMessageLength}',
              style: AppTypography.caption.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Input cap shared by [ChatMessageInput] and `AdvisorChatCubit` (Q7).
abstract final class AdvisorChatInput {
  static const int maxMessageLength = 500;
}
