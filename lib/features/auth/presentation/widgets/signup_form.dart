import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/validation/form_validators.dart';
import '../cubits/google_sign_in_cubit.dart';
import '../cubits/signup_cubit.dart';
import 'auth_cta_button.dart';
import 'auth_or_divider.dart';
import 'labeled_input.dart';
import 'social_button.dart';

/// Signup form (T014) hosted inside the tabbed [AuthScreen]'s [TabBarView],
/// mirroring the login layout. Successful signup routes to OTP verification
/// (product rule: signup always goes to OTP, never straight to login).
class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _password = TextEditingController();

  late final SignupCubit _cubit;
  late final GoogleSignInCubit _googleCubit;
  late final FormValidators _validators;
  bool _obscurePassword = true;

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    final AppLocalizations l10n = AppLocalizations.of(context);
    _validators = FormValidators(l10n);
    // Provided by AuthScreen's BlocProviders; they own the cubits' lifecycles.
    _cubit = context.read<SignupCubit>();
    _googleCubit = context.read<GoogleSignInCubit>();
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    _cubit.submit(
      firstName: _firstName.text,
      lastName: _lastName.text,
      email: _email.text,
      phone: _phone.text,
      password: _password.text,
    );
  }

  void _onState(BuildContext context, SignupState state) {
    if (!state.isSuccess) return;
    context.go('/otp?email=${Uri.encodeQueryComponent(_email.text.trim())}');
  }

  void _onGoogleState(BuildContext context, GoogleSignInState state) {
    if (!state.isSuccess) return;
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.xl.h),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: BlocConsumer<SignupCubit, SignupState>(
          bloc: _cubit,
          listener: _onState,
          builder: (BuildContext context, SignupState state) {
            return Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.authSignupTitle,
                    style: AppTypography.heading3.copyWith(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm.h),
                  Text(
                    l10n.authSignupSubtitle,
                    style: AppTypography.bodyMedium.copyWith(
                      fontSize: 15.sp,
                      color: AppColors.textMuted,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xl.h),
                  LabeledInput(
                    label: l10n.authFirstNameLabel,
                    controller: _firstName,
                    validator: _validators.name,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    autofillHints: const [AutofillHints.givenName],
                  ),
                  SizedBox(height: AppSpacing.lg.h),
                  LabeledInput(
                    label: l10n.authLastNameLabel,
                    controller: _lastName,
                    validator: _validators.name,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    autofillHints: const [AutofillHints.familyName],
                  ),
                  SizedBox(height: AppSpacing.lg.h),
                  LabeledInput(
                    label: l10n.authEmailLabel,
                    controller: _email,
                    validator: _validators.email,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.email],
                  ),
                  SizedBox(height: AppSpacing.lg.h),
                  LabeledInput(
                    label: l10n.authPhoneLabel,
                    controller: _phone,
                    validator: _validators.phone,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.telephoneNumber],
                  ),
                  SizedBox(height: AppSpacing.lg.h),
                  LabeledInput(
                    label: l10n.authPasswordLabel,
                    controller: _password,
                    validator: _validators.password,
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.done,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.textTertiary,
                      ),
                      onPressed: () => setState(
                        () => _obscurePassword = !_obscurePassword,
                      ),
                    ),
                    autofillHints: const [AutofillHints.newPassword],
                    onFieldSubmitted: (_) => _submit(),
                  ),
                  if (state.errorMessage != null) ...[
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      state.errorMessage!,
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ],
                  SizedBox(height: AppSpacing.xl.h),
                  AuthCtaButton(
                    label: l10n.authSignupSubmit,
                    loading: state.isSubmitting,
                    onPressed: _submit,
                  ),
                  SizedBox(height: AppSpacing.xl.h),
                  const AuthOrDivider(),
                  SizedBox(height: AppSpacing.xl.h),
                  BlocConsumer<GoogleSignInCubit, GoogleSignInState>(
                    bloc: _googleCubit,
                    listener: _onGoogleState,
                    builder:
                        (BuildContext context, GoogleSignInState state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SocialButton(
                                onPressed: _googleCubit.signInWithGoogle,
                                loading: state.isSubmitting,
                                enabled:
                                    !state.isSubmitting &&
                                    !_cubit.state.isSubmitting,
                              ),
                              if (state.errorMessage != null) ...[
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  state.errorMessage!,
                                  textAlign: TextAlign.center,
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: AppColors.error,
                                  ),
                                ),
                              ],
                            ],
                          );
                        },
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
