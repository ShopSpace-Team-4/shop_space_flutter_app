import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injectable.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/validation/form_validators.dart';
import '../../google/auth_google_service.dart';
import '../../repository/auth_repository.dart';
import '../cubits/auth_session_cubit.dart';
import '../cubits/google_sign_in_cubit.dart';
import '../cubits/login_cubit.dart';
import 'auth_cta_button.dart';
import 'auth_or_divider.dart';
import 'labeled_input.dart';
import 'social_button.dart';

/// Sign-in form (T018 presentation) hosted inside the tabbed [AuthScreen]'s
/// [TabBarView]: welcome heading, borderless fields, a "Forgot password?"
/// link, and a pill CTA with a direction-aware arrow. Success persists the
/// token pair via [AuthSessionCubit] and returns to the dashboard;
/// "Continue with Google" (US4) runs through [GoogleSignInCubit].
class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  late final LoginCubit _cubit;
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
    _cubit = LoginCubit(
      repository: getIt<AuthRepository>(),
      l10n: l10n,
      session: getIt<AuthSessionCubit>(),
    );
    _googleCubit = GoogleSignInCubit(
      googleAuth: getIt<AuthGoogleService>(),
      session: getIt<AuthSessionCubit>(),
      l10n: l10n,
    );
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _cubit.close();
    _googleCubit.close();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    _cubit.submit(email: _email.text, password: _password.text);
  }

  void _onState(BuildContext context, LoginState state) {
    if (!state.isSuccess) return;
    context.go('/');
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
        child: BlocConsumer<LoginCubit, LoginState>(
          bloc: _cubit,
          listener: _onState,
          builder: (BuildContext context, LoginState state) {
            return Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.authLoginTitle,
                    style: AppTypography.heading3.copyWith(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm.h),
                  Text(
                    l10n.authLoginSubtitle,
                    style: AppTypography.bodyMedium.copyWith(
                      fontSize: 15.sp,
                      color: AppColors.textMuted,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xl.h),
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
                    label: l10n.authPasswordLabel,
                    controller: _password,
                    validator: _validators.passwordRequired,
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
                    autofillHints: const [AutofillHints.password],
                    onFieldSubmitted: (_) => _submit(),
                  ),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: TextButton(
                      onPressed: () => context.go('/forgot-password'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.textLink,
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                      ),
                      child: Text(l10n.authLoginForgotPassword),
                    ),
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
                  SizedBox(height: AppSpacing.lg.h),
                  AuthCtaButton(
                    label: l10n.authLoginSubmit,
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
