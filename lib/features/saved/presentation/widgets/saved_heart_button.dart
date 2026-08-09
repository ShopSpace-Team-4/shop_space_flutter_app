import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';

/// Save/unsave heart for the saved-list card (US5, T055; D8). Presentational —
/// the optimistic flip + revert + messaging live in
/// [SavedListingsCubit]/the caller. Filled primary when saved, outline
/// otherwise; tooltip is the localized save/unsave accessibility label.
/// Fully responsive: size scales with screenutil.
class SavedHeartButton extends StatelessWidget {
  const SavedHeartButton({
    super.key,
    required this.saved,
    required this.onPressed,
  });

  /// True when the item is currently saved.
  final bool saved;

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return IconButton(
      onPressed: onPressed,
      tooltip: saved ? l10n.savedUnsaveTooltip : l10n.savedSaveTooltip,
      icon: Icon(
        saved ? Icons.favorite : Icons.favorite_border,
        size: 20.sp,
        color: saved ? AppColors.primary : AppColors.textTertiary,
      ),
    );
  }
}
