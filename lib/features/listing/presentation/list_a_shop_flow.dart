import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/injectable.dart';
import '../../auth/presentation/cubits/auth_session_cubit.dart';
import 'widgets/become_landlord_sheet.dart';

/// Shared "List a shop" / "+" entry (FR-001/FR-002, US1/T047): reads
/// `roles[]` — contains `landlord` → go straight to the create form; else show
/// the Become-a-Landlord sheet and navigate on confirm success. Never gates on
/// `activeRole` (FR-013). The sheet owns its loading / failure-keeps-open /
/// dismiss contracts; on success it navigates into `/listing-form`.
void openCreateListingFlow(BuildContext context) {
  final AuthSessionCubit session = getIt<AuthSessionCubit>();
  if (session.roles.contains('landlord')) {
    context.go('/listing-form');
    return;
  }
  BecomeLandlordSheet.show(
    context,
    onSuccess: () => context.go('/listing-form'),
  );
}
