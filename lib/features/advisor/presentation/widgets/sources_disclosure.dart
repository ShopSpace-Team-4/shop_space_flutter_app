import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/models/advisor_source.dart';

/// Grounding disclosure under an assistant answer (contract
/// `contracts/advisor-chat-api.md`): the localized `advisorSourcesTitle` + one
/// row per [AdvisorSource] (title when present, then `category`/`businessType`/
/// `documentId` as secondary text). A title-only source still renders. Returns
/// [SizedBox.shrink] when `sources` is empty — an answer without sources
/// renders without a disclosure.
class SourcesDisclosure extends StatelessWidget {
  const SourcesDisclosure({super.key, required this.sources});

  final List<AdvisorSource> sources;

  @override
  Widget build(BuildContext context) {
    if (sources.isEmpty) {
      return const SizedBox.shrink();
    }
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.advisorSourcesTitle,
          style: AppTypography.caption.copyWith(color: AppColors.textMuted),
        ),
        SizedBox(height: AppSpacing.sm.h),
        for (final AdvisorSource source in sources) ...[
          _SourceRow(source: source),
          SizedBox(height: AppSpacing.xs.h),
        ],
      ],
    );
  }
}

class _SourceRow extends StatelessWidget {
  const _SourceRow({required this.source});

  final AdvisorSource source;

  @override
  Widget build(BuildContext context) {
    final List<String> details = <String>[
      if (source.category != null && source.category!.isNotEmpty)
        source.category!,
      if (source.businessType != null && source.businessType!.isNotEmpty)
        source.businessType!,
      if (source.documentId != null && source.documentId!.isNotEmpty)
        source.documentId!,
    ];
    final String title = source.title ?? '';
    final String primary = title.isNotEmpty ? title : details.join(' · ');
    final String secondary = title.isNotEmpty ? details.join(' · ') : '';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 5.h),
          child: Icon(
            Icons.circle,
            size: 6.w,
            color: AppColors.textTertiary,
          ),
        ),
        SizedBox(width: AppSpacing.sm.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (primary.isNotEmpty)
                Text(
                  primary,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              if (secondary.isNotEmpty)
                Text(
                  secondary,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
