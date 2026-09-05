import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injectable.dart';
import '../../../../core/errors/failure_messages.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/storage/preferences_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../auth/presentation/cubits/auth_session_cubit.dart';
import '../../../user/repository/user_repository.dart';
import '../cubits/become_landlord_cubit.dart';

/// Bottom sheet explaining the landlord role (US1/T039, contract
/// `become-landlord-flow.md`): one "Become a Landlord" action, loading state
/// on the button, failure kept open for retry, dismissal stays in My Listings
/// (no listing created). On success it calls [onSuccess] so the caller can
/// navigate straight into the create form. Fully responsive (screenutil + flex).
class BecomeLandlordSheet extends StatefulWidget {
  const BecomeLandlordSheet({super.key, this.onSuccess});

  /// Invoked after the role upgrade succeeds (the sheet dismisses itself
  /// first; the caller navigates to `/listing-form`).
  final VoidCallback? onSuccess;

  static Future<void> show(BuildContext context, {VoidCallback? onSuccess}) {
    return showModalBottomSheet<void>(
      context: context,
      isDismissible: true,
      showDragHandle: true,
      builder: (context) => BlocProvider(
        // The provider owns this sheet-scoped cubit's lifecycle (destroyed
        // with the bottom-sheet route).
        create: (_) => BecomeLandlordCubit(
          repository: getIt<UserRepository>(),
          session: getIt<AuthSessionCubit>(),
          preferences: getIt<PreferencesService>(),
        ),
        child: BecomeLandlordSheet(onSuccess: onSuccess),
      ),
    );
  }

  @override
  State<BecomeLandlordSheet> createState() => _BecomeLandlordSheetState();
}

class _BecomeLandlordSheetState extends State<BecomeLandlordSheet> {
  late final BecomeLandlordCubit _cubit;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    // Provided by the BlocProvider in [BecomeLandlordSheet.show]; it owns this
    // bottom-sheet-scoped cubit's lifecycle.
    _cubit = context.read<BecomeLandlordCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BecomeLandlordCubit, BecomeLandlordState>(
      bloc: _cubit,
      listener: (context, state) {
        if (!state.isSuccess) return;
        Navigator.of(context).pop();
        widget.onSuccess?.call();
      },
      child: BlocBuilder<BecomeLandlordCubit, BecomeLandlordState>(
        bloc: _cubit,
        builder: (context, state) => _BecomeLandlordContent(
          isSubmitting: state.isSubmitting,
          failure: state.failure,
          onConfirm: _cubit.becomeLandlord,
        ),
      ),
    );
  }
}

class _BecomeLandlordContent extends StatelessWidget {
  const _BecomeLandlordContent({
    required this.isSubmitting,
    required this.failure,
    required this.onConfirm,
  });

  final bool isSubmitting;
  final Failure? failure;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.lg.w,
          0,
          AppSpacing.lg.w,
          AppSpacing.xl.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 64.r,
              height: 64.r,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(AppRadius.large),
              ),
              child: Icon(
                Icons.storefront,
                size: 32.sp,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: AppSpacing.lg.h),
            Text(
              l10n.becomeLandlordTitle,
              style: AppTypography.heading4.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSpacing.sm.h),
            Text(
              l10n.becomeLandlordBody,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: AppSpacing.lg.h),
            if (failure != null) ...[
              Text(
                failureMessage(l10n, failure!),
                textAlign: TextAlign.center,
                style: AppTypography.bodySmall.copyWith(color: AppColors.error),
              ),
              SizedBox(height: AppSpacing.sm.h),
            ],
            SizedBox(
              height: 48.h,
              child: FilledButton(
                onPressed: isSubmitting ? null : onConfirm,
                child: isSubmitting
                    ? SizedBox(
                        width: 20.w,
                        height: 20.h,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.onPrimary,
                        ),
                      )
                    : Text(l10n.becomeLandlordConfirm),
              ),
            ),
            SizedBox(height: AppSpacing.sm.h),
            Text(
              l10n.becomeLandlordDismissHint,
              textAlign: TextAlign.center,
              style: AppTypography.caption.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
