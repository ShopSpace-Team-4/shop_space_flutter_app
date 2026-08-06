import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injectable.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/validation/form_validators.dart';
import '../../repository/auth_repository.dart';
import '../cubits/signup_cubit.dart';
import '../widgets/labeled_input.dart';

/// Signup form (T014). Successful signup routes to OTP verification
/// (product rule: signup always goes to OTP, never straight to login).
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _password = TextEditingController();

  late final SignupCubit _cubit;
  late final FormValidators _validators;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _validators = FormValidators(AppLocalizations.of(context));
    _cubit = SignupCubit(
      repository: getIt<AuthRepository>(),
      l10n: AppLocalizations.of(context),
    );
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    _cubit.close();
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
    context.go(
      '/otp?email=${Uri.encodeQueryComponent(_email.text.trim())}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.authSignup)),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
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
                        Text(l10n.authSignupTitle, style: AppTypography.heading2),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          l10n.authEmailLabel,
                          style: AppTypography.bodyMedium
                              .copyWith(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        LabeledInput(
                          label: l10n.authFirstNameLabel,
                          controller: _firstName,
                          validator: _validators.name,
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                          autofillHints: const [AutofillHints.givenName],
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        LabeledInput(
                          label: l10n.authLastNameLabel,
                          controller: _lastName,
                          validator: _validators.name,
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                          autofillHints: const [AutofillHints.familyName],
                        ),
                        const SizedBox(height: AppSpacing.lg),
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
                          label: l10n.authPhoneLabel,
                          controller: _phone,
                          validator: _validators.phone,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          prefixIcon: Icons.phone_outlined,
                          autofillHints: const [AutofillHints.telephoneNumber],
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        LabeledInput(
                          label: l10n.authPasswordLabel,
                          controller: _password,
                          validator: _validators.password,
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
                          autofillHints: const [AutofillHints.newPassword],
                          onFieldSubmitted: (_) => _submit(),
                        ),
                        if (state.errorMessage != null) ...[
                          const SizedBox(height: AppSpacing.lg),
                          Text(
                            state.errorMessage!,
                            style: AppTypography.bodyMedium
                                .copyWith(color: AppColors.error),
                          ),
                        ],
                        const SizedBox(height: AppSpacing.xl),
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
                                : Text(l10n.authSignupSubmit),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              l10n.authSignupHaveAccount,
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            TextButton(
                              onPressed: () => context.go('/login'),
                              child: Text(l10n.authSignupSignIn),
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
