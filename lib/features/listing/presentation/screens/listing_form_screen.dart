import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injectable.dart';
import '../../../../core/errors/failure_messages.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/responsive/window_size.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading_view.dart';
import '../../repository/listing_repository.dart';
import '../cubits/listing_form_cubit.dart';
import '../widgets/listing_form_controllers.dart';
import '../widgets/listing_form_step_details.dart';
import '../widgets/listing_form_step_photos.dart';
import '../widgets/listing_form_step_price.dart';
import '../widgets/listing_form_step_review.dart';

/// Create and edit listing form (US1/T045, US3/T054, FR-001). A 4-step flow —
/// Details → Photos → Price & lease → Review — with a step indicator,
/// Next/Back navigation, a single centered column at EVERY size (FR-015/D8),
/// and meta load failure kept retryable (FR-004).
///
/// Two entry points share one cubit (D1): create (no [listingId]) submits via
/// `submitCreate`; edit ([listingId]) preloads the fresh snapshot
/// (`loadForEdit`) and submits via the strict all-or-nothing `submitEdit`
/// (D6, US3). Success → the listing's My Listings detail; failure → inline
/// "Nothing was saved" banner + retry keeping entered data.
class ListingFormScreen extends StatefulWidget {
  const ListingFormScreen({super.key, this.listingId});

  /// When set, the form runs in edit mode for this listing (US3/T054).
  final String? listingId;

  @override
  State<ListingFormScreen> createState() => _ListingFormScreenState();
}

class _ListingFormScreenState extends State<ListingFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final ListingFormCubit _cubit;
  late final ListingFormControllers _controllers;
  bool _initialized = false;
  bool _prefilled = false;
  bool _notFoundHandled = false;

  bool get _isEditMode => widget.listingId != null;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    _cubit = ListingFormCubit(
      repository: getIt<ListingRepository>(),
      isEditMode: _isEditMode,
      listingId: widget.listingId,
    );
    _controllers = ListingFormControllers();
    _cubit.fetchMeta();
    if (_isEditMode) {
      _cubit.loadForEdit(widget.listingId!);
    }
  }

  @override
  void dispose() {
    _controllers.dispose();
    _cubit.close();
    super.dispose();
  }

  void _next() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _cubit.nextStep();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_isEditMode) {
      _cubit.submitEdit();
    } else {
      _cubit.submitCreate();
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? l10n.formTitleEdit : l10n.formTitleCreate),
        leading: BackButton(
          onPressed: () {
            final NavigatorState navigator = Navigator.of(context);
            if (navigator.canPop()) {
              navigator.pop();
            } else {
              context.go('/');
            }
          },
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<ListingFormCubit, ListingFormState>(
          bloc: _cubit,
          listener: _onState,
          builder: (context, state) {
            if (state.preloading) {
              return const AppLoadingView();
            }
            if (_isEditMode && state.preloadFailure != null) {
              return AppErrorView(
                failure: state.preloadFailure!,
                onRetry: () => _cubit.loadForEdit(widget.listingId!),
              );
            }
            if (state.isUploading || state.isSubmitting) {
              return _UploadingProgress(
                state: state,
                onCancel: () => Navigator.of(context).maybePop(),
              );
            }
            if (state.meta == null && state.metaFailure != null) {
              return AppErrorView(
                failure: state.metaFailure!,
                onRetry: _cubit.fetchMeta,
              );
            }
            if (state.meta == null) {
              return const AppLoadingView();
            }
            return _FormBody(
              formKey: _formKey,
              cubit: _cubit,
              controllers: _controllers,
              isEditMode: _isEditMode,
              onNext: _next,
              onSubmit: _submit,
            );
          },
        ),
      ),
    );
  }

  void _onState(BuildContext context, ListingFormState state) {
    if (_isEditMode &&
        !_prefilled &&
        state.preloading == false &&
        state.preloadFailure == null &&
        state.fields.isNotEmpty) {
      _prefilled = true;
      _prefillControllers(state);
    }
    // US3 edge: the listing was deleted elsewhere — a 404 during preload or
    // save. Show "listing no longer exists" and return to My Listings once
    // (D6/T053), instead of a dead-end retry.
    final ListingNotFound? notFound = state.preloadFailure is ListingNotFound
        ? state.preloadFailure! as ListingNotFound
        : state.submitFailure is ListingNotFound
        ? state.submitFailure! as ListingNotFound
        : null;
    if (notFound != null && !_notFoundHandled) {
      _notFoundHandled = true;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(failureMessage(AppLocalizations.of(context), notFound)),
        ),
      );
      context.go('/my-listings');
      return;
    }
    final String? createdId = state.createdId;
    if (createdId != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${AppLocalizations.of(context).formCreatedTitle}\n'
            '${AppLocalizations.of(context).formCreatedMessage}',
          ),
        ),
      );
      context.go('/my-listings/$createdId');
      return;
    }
    final String? updatedId = state.updatedId;
    if (updatedId != null) {
      context.go('/my-listings/$updatedId');
    }
  }

  /// Mirrors the loaded listing's text fields into the controller-backed form
  /// inputs (D6 prefill). Dropdowns and the date read straight from `fields`,
  /// so only the `TextEditingController` values need syncing here.
  void _prefillControllers(ListingFormState state) {
    final Map<String, dynamic> fields = state.fields;
    _controllers.title.text = _string(fields, ListingFormFieldKeys.title);
    _controllers.area.text = _string(fields, ListingFormFieldKeys.areaSqm);
    _controllers.address.text = _string(fields, ListingFormFieldKeys.address);
    _controllers.description.text = _string(
      fields,
      ListingFormFieldKeys.description,
    );
    _controllers.numberOfFloors.text = _string(
      fields,
      ListingFormFieldKeys.numberOfFloors,
    );
    _controllers.floorNumber.text = _string(
      fields,
      ListingFormFieldKeys.floorNumber,
    );
    _controllers.minimumLeaseTerm.text = _string(
      fields,
      ListingFormFieldKeys.minimumLeaseTerm,
    );
    _controllers.annualRent.text = _string(
      fields,
      ListingFormFieldKeys.annualRent,
    );
    _controllers.securityDepositMonths.text = _string(
      fields,
      ListingFormFieldKeys.securityDepositMonths,
    );
  }

  static String _string(Map<String, dynamic> fields, String key) {
    final dynamic value = fields[key];
    return value == null ? '' : value.toString();
  }
}

class _FormBody extends StatelessWidget {
  const _FormBody({
    required this.formKey,
    required this.cubit,
    required this.controllers,
    required this.isEditMode,
    required this.onNext,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final ListingFormCubit cubit;
  final ListingFormControllers controllers;
  final bool isEditMode;
  final VoidCallback onNext;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ListingFormState state = cubit.state;
    final bool expanded = breakpointOf(context) == AppBreakpoint.expanded;

    final Widget content = switch (state.step) {
      0 => ListingFormStepDetails(cubit: cubit, controllers: controllers),
      1 => ListingFormStepPhotos(cubit: cubit),
      2 => ListingFormStepPrice(cubit: cubit, controllers: controllers),
      _ => ListingFormStepReview(cubit: cubit, controllers: controllers),
    };

    return Column(
      children: [
        _StepIndicator(step: state.step, l10n: l10n),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppSpacing.lg.h),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: expanded ? 720.w : 520.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (state.submitFailure != null &&
                        state.submitFailure is! InvalidMediaFile &&
                        state.submitFailure is! PhotoLimitReached) ...[
                      _SaveFailureBanner(
                        failure: state.submitFailure!,
                        l10n: l10n,
                      ),
                      SizedBox(height: AppSpacing.lg.h),
                    ],
                    Form(key: formKey, child: content),
                  ],
                ),
              ),
            ),
          ),
        ),
        _BottomBar(
          step: state.step,
          isEditMode: isEditMode,
          canSubmit: state.meta != null,
          l10n: l10n,
          onBack: cubit.previousStep,
          onExit: () => Navigator.of(context).maybePop(),
          onNext: onNext,
          onSubmit: onSubmit,
        ),
      ],
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.step, required this.l10n});

  final int step;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final String label = switch (step) {
      0 => l10n.formStepDetails,
      1 => l10n.formStepPhotos,
      2 => l10n.formStepPrice,
      _ => l10n.formStepReview,
    };
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg.w,
        vertical: AppSpacing.md.h,
      ),
      color: AppColors.background,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                l10n.formStepOf(step + 1, 4),
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
              const Spacer(),
              Text(
                label,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm.h),
          Row(
            children: [
              for (int i = 0; i < 4; i++)
                Expanded(
                  child: Container(
                    height: 4.h,
                    margin: EdgeInsets.only(
                      right: i == 3 ? 0 : AppSpacing.xs.w,
                    ),
                    decoration: BoxDecoration(
                      color: i <= step
                          ? AppColors.primary
                          : AppColors.outlineVariant,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.step,
    required this.isEditMode,
    required this.canSubmit,
    required this.l10n,
    required this.onBack,
    required this.onExit,
    required this.onNext,
    required this.onSubmit,
  });

  final int step;
  final bool isEditMode;
  final bool canSubmit;
  final AppLocalizations l10n;
  final VoidCallback onBack;
  final VoidCallback onExit;
  final VoidCallback onNext;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final bool isLast = step == 3;
    // Edit mode: Back on step 1 (Details) exits to the detail screen
    // (T054); Back on later steps moves back through the form.
    final VoidCallback? backAction = step == 0
        ? (isEditMode ? onExit : null)
        : onBack;
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg.w,
        AppSpacing.md.h,
        AppSpacing.lg.w,
        AppSpacing.lg.h,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.outline)),
      ),
      child: Row(
        children: [
          if (backAction != null)
            Expanded(
              child: OutlinedButton(
                onPressed: backAction,
                child: Text(
                  isEditMode && step == 0 ? l10n.commonBack : l10n.formBack,
                ),
              ),
            ),
          if (backAction != null) SizedBox(width: AppSpacing.md.w),
          Expanded(
            flex: 2,
            child: FilledButton(
              onPressed: canSubmit ? (isLast ? onSubmit : onNext) : null,
              child: Text(
                isLast
                    ? (isEditMode ? l10n.formSubmitSave : l10n.formSubmitCreate)
                    : l10n.formNext,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Inline, non-blocking save-failure banner (US3/D6): "Nothing was saved" +
/// the underlying typed error. The form and its data stay visible so the
/// landlord can fix the issue and re-Save (create-mode failures use the same
/// pattern). Only hidden for [InvalidMediaFile] / [PhotoLimitReached], which
/// render inline in the Photos step instead.
class _SaveFailureBanner extends StatelessWidget {
  const _SaveFailureBanner({required this.failure, required this.l10n});

  final Failure failure;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md.r),
      decoration: BoxDecoration(
        color: AppColors.errorContainer,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(color: AppColors.error),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline, color: AppColors.error, size: 20.sp),
          SizedBox(width: AppSpacing.sm.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.formNothingSaved,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.errorOnContainer,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: AppSpacing.xs.h),
                Text(
                  failureMessage(l10n, failure),
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.errorOnContainer,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UploadingProgress extends StatelessWidget {
  const _UploadingProgress({required this.state, required this.onCancel});

  final ListingFormState state;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xl.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (state.submitFailure != null) ...[
              Text(
                failureMessage(l10n, state.submitFailure!),
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.error,
                ),
              ),
              SizedBox(height: AppSpacing.lg.h),
              FilledButton(onPressed: onCancel, child: Text(l10n.formBack)),
            ] else ...[
              Text(
                l10n.formPhotoProgress,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSpacing.lg.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.pill),
                child: LinearProgressIndicator(
                  value: state.uploadProgress.clamp(0.0, 1.0),
                  minHeight: 8.h,
                ),
              ),
              SizedBox(height: AppSpacing.lg.h),
              Text(
                '${(state.uploadProgress * 100).toStringAsFixed(0)}%',
                style: AppTypography.caption.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
