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
import '../cubits/forgot_password_cubit.dart';
import '../widgets/labeled_input.dart';

/// Forgot-password screen (T029). Submitting a valid email requests a reset
/// code; success shows the confirmation copy and routes to
/// `/reset-password?email=<email>`.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();

  late final ForgotPasswordCubit _cubit;
  late final FormValidators _validators;
  bool _showConfirmation = false;

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    final AppLocalizations l10n = AppLocalizations.of(context);
    _validators = FormValidators(l10n);
    _cubit = ForgotPasswordCubit(
      repository: getIt<AuthRepository>(),
      l10n: l10n,
    );
  }

  @override
  void dispose() {
    _email.dispose();
    _cubit.close();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    _cubit.submit(email: _email.text);
  }

  void _onState(BuildContext context, ForgotPasswordState state) {
    if (!state.isSuccess) return;
    setState(() => _showConfirmation = true);
  }

  void _goToReset() {
    context.go(
      '/reset-password?email=${Uri.encodeQueryComponent(_email.text.trim())}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.authForgotPasswordTitle)),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
                bloc: _cubit,
                listener: _onState,
                builder: (BuildContext context, ForgotPasswordState state) {
                  if (_showConfirmation) {
                    return _buildConfirmation(l10n);
                  }
                  return _buildForm(l10n, state);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmation(AppLocalizations l10n) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.mark_email_read_outlined,
            size: 48, color: AppColors.success),
        const SizedBox(height: AppSpacing.lg),
        Text(
          l10n.authForgotPasswordCheckEmail(_email.text.trim()),
          textAlign: TextAlign.center,
          style: AppTypography.heading4,
        ),
        const SizedBox(height: AppSpacing.xl),
        SizedBox(
          height: 48,
          child: FilledButton(
            onPressed: _goToReset,
            child: Text(l10n.authResetPassword),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        TextButton(
          onPressed: () => context.go('/login'),
          child: Text(l10n.authBackToLogin),
        ),
      ],
    );
  }

  Widget _buildForm(AppLocalizations l10n, ForgotPasswordState state) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.authForgotPasswordTitle, style: AppTypography.heading2),
          const SizedBox(height: AppSpacing.xl),
          LabeledInput(
            label: l10n.authEmailLabel,
            controller: _email,
            validator: _validators.email,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            prefixIcon: Icons.alternate_email_outlined,
            autofillHints: const [AutofillHints.email],
            onFieldSubmitted: (_) => _submit(),
          ),
          if (state.errorMessage != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              state.errorMessage!,
              style:
                  AppTypography.bodyMedium.copyWith(color: AppColors.error),
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
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.authForgotPasswordSubmit),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: TextButton(
              onPressed: () => context.go('/login'),
              child: Text(l10n.authBackToLogin),
            ),
          ),
        ],
      ),
    );
  }
}
