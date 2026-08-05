import 'package:flutter/material.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_typography.dart';

/// Phase 0 placeholder home screen.
///
/// Rendered inside [AppAdaptiveShell]; replaced by the tenant/landlord
/// dashboards in later phases.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.appTitle,
              style: AppTypography.heading1,
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                l10n.placeholderBody,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
