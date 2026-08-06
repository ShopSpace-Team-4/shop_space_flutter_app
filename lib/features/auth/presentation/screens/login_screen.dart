import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injectable.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/validation/form_validators.dart';
import '../../../user/data/models/user_role.dart';
import '../../repository/auth_repository.dart';
import '../cubits/auth_session_cubit.dart';
import '../cubits/login_cubit.dart';
import '../widgets/auth_segmented_toggle.dart';
import '../widgets/labeled_input.dart';

/// Sign-in screen (T018 presentation). On success the session cubit persists
/// the token pair and the app returns to the dashboard. "Forgot your
/// password?" (US5) and "Continue with Google" (US4) render as visible,
/// inert placeholders for a later phase.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  late final LoginCubit _cubit;
  late final FormValidators _validators;
  bool _obscurePassword = true;
  UserRole _selectedRole = UserRole.tenant;

  @override
  void initState() {
    super.initState();
    _validators = FormValidators(AppLocalizations.of(context));
    _cubit = LoginCubit(
      repository: getIt<AuthRepository>(),
      l10n: AppLocalizations.of(context),
      session: getIt<AuthSessionCubit>(),
    );
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _cubit.close();
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

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.authLogin)),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
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
                        Text(l10n.authLoginTitle, style: AppTypography.heading2),
                        const SizedBox(height: AppSpacing.xl),
                        AuthSegmentedToggle(
                          value: _selectedRole,
                          onChanged: (UserRole role) =>
                              setState(() => _selectedRole = role),
                          enabled: !state.isSubmitting,
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        LabeledInput(
                          label: l10n.authEmailLabel,
                          controller: _email,
                          validator: _validators.email,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          prefixIcon: Icons.alternate_email_outlined,
                          autofillHints: const [AutofillHints.email],
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        LabeledInput(
                          label: l10n.authPasswordLabel,
                          controller: _password,
                          validator: _validators.passwordRequired,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          prefixIcon: Icons.lock_outline,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
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
                            onPressed: null,
                            child: Text(l10n.authLoginForgotPassword),
                          ),
                        ),
                        if (state.errorMessage != null) ...[
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            state.errorMessage!,
                            style: AppTypography.bodyMedium
                                .copyWith(color: AppColors.error),
                          ),
                        ],
                        const SizedBox(height: AppSpacing.lg),
                        SizedBox(
                          height: 48,
                          child: FilledButton(
                            onPressed: state.isSubmitting ? null : _submit,
                            child: state.isSubmitting
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(l10n.authLoginSubmit),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        SizedBox(
                          height: 48,
                          child: OutlinedButton.icon(
                            onPressed: null,
                            icon: const Icon(Icons.g_mobiledata_outlined),
                            label: Text(l10n.authGoogleButton),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              l10n.authLoginNoAccount,
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            TextButton(
                              onPressed: () => context.go('/signup'),
                              child: Text(l10n.authLoginCreateAccount),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
