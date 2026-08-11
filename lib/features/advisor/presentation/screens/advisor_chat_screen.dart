import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injectable.dart';
import '../../../../core/errors/failure_messages.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/models/advisor_message.dart';
import '../cubits/advisor_chat_cubit.dart';
import '../cubits/advisor_chat_state.dart';
import '../widgets/advisor_chat_header.dart';
import '../widgets/advisor_welcome_empty_state.dart';
import '../widgets/chat_message_bubble.dart';
import '../widgets/chat_message_input.dart';
import '../widgets/disclaimer_banner.dart';
import '../widgets/recommended_listings_section.dart';
import '../widgets/sources_disclosure.dart';
import '../widgets/thinking_indicator.dart';

/// AI Space Advisor chat (US1, T014/T020).
///
/// Single centered chat pane at EVERY breakpoint (FR-013): `Center` →
/// `ConstrainedBox(maxWidth: 480.w)` — the exact auth-screen pattern. The pane
/// is a `Column` = [AdvisorChatHeader] + `Expanded` message thread + pinned
/// [ChatMessageInput].
///
/// Q5/D3 retention contract: the cubit is resolved from get_it as a lazy
/// singleton and **never closed** here. Leaving/returning (back, tab switch)
/// disposes only this screen's widgets — the thread and `sessionId` survive for
/// the life of the app run; only app restart or logout clears them.
class AdvisorChatScreen extends StatefulWidget {
  const AdvisorChatScreen({super.key});

  @override
  State<AdvisorChatScreen> createState() => _AdvisorChatScreenState();
}

class _AdvisorChatScreenState extends State<AdvisorChatScreen> {
  final ScrollController _scrollController = ScrollController();
  AdvisorChatCubit? _cubit;
  StreamSubscription<AdvisorChatState>? _subscription;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    // Q5 retention: resolve the app-run singleton — never create or close it.
    _cubit = getIt<AdvisorChatCubit>();
    _subscription = _cubit!.stream.listen((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    // Deliberately do NOT close the cubit (Q5): it outlives this screen so a
    // return renders the same conversation. Only the subscription is dropped.
    _subscription?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSend(String message) {
    _cubit?.sendMessage(message);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 480.w),
            child: Column(
              children: [
                const AdvisorChatHeader(),
                Expanded(
                  child: BlocBuilder<AdvisorChatCubit, AdvisorChatState>(
                    bloc: _cubit,
                    builder: (BuildContext context, AdvisorChatState state) {
                      return _buildThread(l10n, state);
                    },
                  ),
                ),
                BlocBuilder<AdvisorChatCubit, AdvisorChatState>(
                  bloc: _cubit,
                  builder: (BuildContext context, AdvisorChatState state) {
                    return ChatMessageInput(
                      enabled: !state.isSending,
                      onSend: _onSend,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThread(AppLocalizations l10n, AdvisorChatState state) {
    if (state.messages.isEmpty && !state.isSending) {
      return AdvisorWelcomeEmptyState(onAsk: _onSend);
    }

    final List<Widget> children = <Widget>[];
    for (final AdvisorMessage message in state.messages) {
      if (message.role == AdvisorRole.assistant) {
        children.add(ChatMessageBubble(message: message));
        children.add(SizedBox(height: AppSpacing.md.h));
        children.add(SourcesDisclosure(sources: message.sources));
        if (message.sources.isNotEmpty) {
          children.add(SizedBox(height: AppSpacing.md.h));
        }
        children.add(DisclaimerBanner(disclaimer: message.disclaimer));
        children.add(SizedBox(height: AppSpacing.lg.h));
        // US3 (T027): recommendations render beneath the disclaimer only when
        // the message carries at least one valid listing. The section itself
        // returns `SizedBox.shrink()` for null/empty/fully-malformed data, so
        // the answer + sources + disclaimer always render and the app never
        // crashes (FR-006/007).
        children.add(
          RecommendedListingsSection(listings: message.recommendedListings),
        );
        children.add(SizedBox(height: AppSpacing.lg.h));
      } else {
        children.add(ChatMessageBubble(message: message));
        if (state.failedMessageId == message.id) {
          children.add(SizedBox(height: AppSpacing.xs.h));
          children.add(_buildFailure(l10n, state));
        }
        children.add(SizedBox(height: AppSpacing.lg.h));
      }
    }
    if (state.isSending) {
      children.add(const ThinkingIndicator());
      children.add(SizedBox(height: AppSpacing.lg.h));
    }

    return ListView(
      controller: _scrollController,
      padding: EdgeInsets.zero,
      children: children,
    );
  }

  Widget _buildFailure(AppLocalizations l10n, AdvisorChatState state) {
    final String errorText =
        state.failure == null ? l10n.errorGeneric : failureMessage(l10n, state.failure!);

    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.only(right: 4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              errorText,
              style: AppTypography.bodySmall.copyWith(color: AppColors.error),
            ),
            SizedBox(height: AppSpacing.xs.h),
            TextButton.icon(
              onPressed: state.isSending ? null : _cubit?.retry,
              icon: Icon(Icons.refresh, size: 16.sp),
              label: Text(l10n.retry),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm.w,
                  vertical: AppSpacing.xs.h,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
