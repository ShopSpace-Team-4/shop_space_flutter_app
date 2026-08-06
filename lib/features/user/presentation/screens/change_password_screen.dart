import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injectable.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/validation/form_validators.dart';
import '../../../auth/presentation/cubits/auth_session_cubit.dart';
import '../../repository/user_repository.dart';
import '../cubits/change_password_cubit.dart';
import '../../../auth/presentation/widgets/labeled_input.dart';

/// Change-password screen (T037, US6). On success the cubit clears the session
/// (constitution §6 — never wait for a 401) and this screen returns to
/// `/login`.
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();

  late final ChangePasswordCubit _cubit;
  late final FormValidators _validators;
  bool _obscureCurrent = true;
  bool _obscureNew = true;

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    final AppLocalizations l10n = AppLocalizations.of(context);
    _validators = FormValidators(l10n);
    _cubit = ChangePasswordCubit(
      repository: getIt<UserRepository>(),
      session: getIt<AuthSessionCubit>(),
      l10n: l10n,
    );
  }

  @override
  void dispose() {
    _currentPassword.dispose();
    _newPassword.dispose();
    _cubit.close();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    _cubit.submit(
      currentPassword: _currentPassword.text,
      newPassword: _newPassword.text,
    );
  }

  void _onState(BuildContext context, ChangePasswordState state) {
    if (!state.isSuccess) return;
    context.go('/login');
  }

  String? _currentPasswordValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context).authCurrentPasswordRequired;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.changePasswordTitle)),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
                bloc: _cubit,
                listener: _onState,
                builder: (BuildContext context, ChangePasswordState state) {
                  return Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        LabeledInput(
                          label: l10n.authCurrentPasswordLabel,
                          controller: _currentPassword,
                          validator: _currentPasswordValidator,
                          obscureText: _obscureCurrent,
                          textInputAction: TextInputAction.next,
                          prefixIcon: Icons.lock_outline,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureCurrent
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () => setState(
                              () => _obscureCurrent = !_obscureCurrent,
                            ),
                          ),
                          autofillHints: const [AutofillHints.password],
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        LabeledInput(
                          label: l10n.authNewPasswordLabel,
                          controller: _newPassword,
                          validator: _validators.password,
                          obscureText: _obscureNew,
                          textInputAction: TextInputAction.done,
                          prefixIcon: Icons.lock_outline,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureNew
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () => setState(
                              () => _obscureNew = !_obscureNew,
                            ),
                          ),
                          autofillHints: const [AutofillHints.newPassword],
                          onFieldSubmitted: (_) => _submit(),
                        ),
                        if (state.errorMessage != null) ...[
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            state.errorMessage!,
                            textAlign: TextAlign.center,
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
                                : Text(l10n.changePasswordSubmit),
                          ),
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
