import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/validation/form_validators.dart';
import '../../../auth/presentation/widgets/labeled_input.dart';
import '../../data/models/user.dart';
import '../cubits/profile_cubit.dart';

/// Shared edit-profile bottom sheet (Profile → "Edit Profile" and Settings →
/// Account → "Edit profile"): a prefilled form for first name / last name /
/// phone, validated with the existing [FormValidators]. Submitting calls
/// [ProfileCubit.updateProfile]; the sheet pops with `true` on success (inline
/// error stays open for retry on failure). Fully responsive (screenutil + flex).
class EditProfileSheet extends StatefulWidget {
  const EditProfileSheet({
    super.key,
    required this.cubit,
    required this.validators,
    required this.user,
  });

  final ProfileCubit cubit;
  final FormValidators validators;
  final User user;

  static Future<bool?> show(
    BuildContext context, {
    required ProfileCubit cubit,
    required FormValidators validators,
    required User user,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) =>
          EditProfileSheet(cubit: cubit, validators: validators, user: user),
    );
  }

  /// Converts the stored phone (E.164 `+20…` or local form) to the 11-digit
  /// local form the edit form validates and submits (D4).
  static String localPhone(String phone) {
    final String digits = phone.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 11 && digits.startsWith('01')) return digits;
    if (digits.length == 13 && digits.startsWith('20')) {
      return digits.substring(2);
    }
    return phone;
  }

  @override
  State<EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<EditProfileSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _phone;

  @override
  void initState() {
    super.initState();
    _firstName = TextEditingController(text: widget.user.firstName);
    _lastName = TextEditingController(text: widget.user.lastName);
    _phone = TextEditingController(
      text: EditProfileSheet.localPhone(widget.user.phone),
    );
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _phone.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    widget.cubit.updateProfile(
      firstName: _firstName.text,
      lastName: _lastName.text,
      phone: _phone.text,
    );
  }

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
        child: BlocConsumer<ProfileCubit, ProfileState>(
          bloc: widget.cubit,
          listener: (BuildContext context, ProfileState state) {
            if (!state.updateSuccess) return;
            // The sheet may have been dismissed mid-request; never pop a
            // route that isn't this sheet anymore.
            if (!context.mounted) return;
            Navigator.of(context).pop(true);
          },
          builder: (BuildContext context, ProfileState state) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.profileEditTitle,
                    style: AppTypography.heading4.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg.h),
                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        LabeledInput(
                          label: l10n.authFirstNameLabel,
                          controller: _firstName,
                          validator: widget.validators.name,
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                        ),
                        SizedBox(height: AppSpacing.lg.h),
                        LabeledInput(
                          label: l10n.authLastNameLabel,
                          controller: _lastName,
                          validator: widget.validators.name,
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                        ),
                        SizedBox(height: AppSpacing.lg.h),
                        LabeledInput(
                          label: l10n.authPhoneLabel,
                          controller: _phone,
                          validator: widget.validators.phone,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _submit(),
                        ),
                      ],
                    ),
                  ),
                  if (state.updateError != null) ...[
                    SizedBox(height: AppSpacing.sm.h),
                    Text(
                      state.updateError!,
                      textAlign: TextAlign.center,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ],
                  SizedBox(height: AppSpacing.lg.h),
                  SizedBox(
                    height: 48.h,
                    child: FilledButton(
                      onPressed: state.isUpdating ? null : _submit,
                      child: state.isUpdating
                          ? SizedBox(
                              width: 20.r,
                              height: 20.r,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.onPrimary,
                              ),
                            )
                          : Text(l10n.profileEditSave),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}