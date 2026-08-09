import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/shop_listing.dart';

/// The "Contact via WhatsApp" button (trimmed US3): a self-contained widget
/// that launches the listing's own [ShopListing.whatsappLink]
/// (`https://wa.me/<phone>`) directly — no profile lookup, no inquiry record.
///
/// Per user decisions (2026-08-09): the backend link carries no `?text=`, so
/// the button appends the localized prefilled message about the shop when the
/// link has none. The primary `wa.me` launch is attempted directly; `launchUrl`
/// only fails when the OS truly has no handler, and only then does it fall back
/// to `sms:` with the same body → `tel:` (D6). When the link is absent a
/// localized snackbar surfaces; when every channel fails, the localized
/// launch-failure snackbar shows. Nothing happens in-app after a successful
/// launch — no navigation, no dialog. A single in-flight guard prevents
/// double-taps (FR-014). All values scale with screenutil.
class WhatsAppContactButton extends StatefulWidget {
  const WhatsAppContactButton({super.key, required this.listing});

  final ShopListing listing;

  @override
  State<WhatsAppContactButton> createState() => _WhatsAppContactButtonState();
}

class _WhatsAppContactButtonState extends State<WhatsAppContactButton> {
  bool _launching = false;

  Future<void> _contact(AppLocalizations l10n) async {
    if (_launching) return;

    final String? rawLink = widget.listing.whatsappLink?.trim();
    if (rawLink == null || rawLink.isEmpty) {
      _showSnackBar(l10n.whatsappContactUnavailable);
      return;
    }

    final Uri? link = _parseLink(rawLink);
    if (link == null) {
      _showSnackBar(l10n.errorContactLaunchFailed);
      return;
    }

    final String message = l10n.whatsappContactMessage(
      widget.listing.title,
      widget.listing.city,
      widget.listing.district,
    );

    setState(() => _launching = true);
    final bool reached = await _tryContact(link, message);
    if (!mounted) return;
    setState(() => _launching = false);

    if (!reached) {
      _showSnackBar(l10n.errorContactLaunchFailed);
    }
  }

  Uri? _parseLink(String rawLink) {
    try {
      return Uri.parse(rawLink);
    } catch (_) {
      return null;
    }
  }

  /// Launches the primary `wa.me` link (appending the localized [message] as
  /// `?text=` when the link has none), then degrades to `sms:` → `tel:` built
  /// from the phone in the link's path (D6). Returns whether any channel
  /// opened. A malformed/foreign link with no derivable phone only tries the
  /// primary launch. A channel only counts as failed when `launchUrl` itself
  /// throws — `canLaunchUrl` is deliberately not consulted (its false
  /// negatives are common on emulators and Android 11+ package visibility).
  Future<bool> _tryContact(Uri link, String message) async {
    final String? digits = _phoneFromLink(link);

    final bool hasText = link.queryParameters['text']?.isNotEmpty == true;
    final Uri primary = hasText
        ? link
        : link.replace(
            queryParameters: {...link.queryParameters, 'text': message},
          );
    if (await _launch(primary)) {
      return true;
    }

    if (digits == null) {
      return false;
    }
    if (await _launch(Uri(scheme: 'sms', queryParameters: {'body': message}))) {
      return true;
    }
    return _launch(Uri(scheme: 'tel', path: digits));
  }

  /// The `wa.me` path is the E.164 digits (leading `+` stripped) used by the
  /// sms/tel fallbacks. Returns null for any non-`wa.me` link.
  String? _phoneFromLink(Uri link) {
    if (link.host != 'wa.me') {
      return null;
    }
    final String path = link.path.replaceFirst(RegExp(r'^/+'), '');
    return path.isEmpty ? null : path;
  }

  Future<bool> _launch(Uri uri) async {
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: _launching ? null : () => _contact(l10n),
        icon: _launching
            ? SizedBox(
                width: 18.r,
                height: 18.r,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.onPrimary,
                ),
              )
            : const Icon(Icons.chat_outlined),
        label: Text(l10n.shopDetailContactLandlord),
      ),
    );
  }
}
