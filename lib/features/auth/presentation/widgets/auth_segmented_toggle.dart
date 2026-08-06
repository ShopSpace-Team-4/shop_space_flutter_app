import 'package:flutter/material.dart';

import '../../../user/data/models/user_role.dart';
import '../../../../core/localization/app_localizations.dart';

/// Tenant/landlord segmented control for auth screens (T019).
class AuthSegmentedToggle extends StatelessWidget {
  const AuthSegmentedToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  final UserRole value;
  final ValueChanged<UserRole> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return SegmentedButton<UserRole>(
      segments: <ButtonSegment<UserRole>>[
        ButtonSegment<UserRole>(
          value: UserRole.tenant,
          label: Text(l10n.roleTenant),
          icon: const Icon(Icons.person_outline),
        ),
        ButtonSegment<UserRole>(
          value: UserRole.landlord,
          label: Text(l10n.roleLandlord),
          icon: const Icon(Icons.storefront_outlined),
        ),
      ],
      selected: <UserRole>{value},
      showSelectedIcon: false,
      onSelectionChanged: enabled
          ? (Set<UserRole> selection) => onChanged(selection.first)
          : null,
    );
  }
}
