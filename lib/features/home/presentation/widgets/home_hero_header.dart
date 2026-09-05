import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../user/data/models/user.dart';

/// Home hero header (Figma `95:4028`): full-bleed `#0F172A → #3A1E8B` gradient
/// with the greeting + avatar on one row and a frosted search pill below.
/// The pill navigates to `/search`; the avatar renders `user.avatarUrl` with a
/// person placeholder fallback. [user] is best-effort — pass `null` for the
/// generic greeting when the profile fetch failed.
class HomeHeroHeader extends StatelessWidget {
  const HomeHeroHeader({super.key, this.user});

  final User? user;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final String greeting = user == null
        ? l10n.homeGreetingFallback
        : l10n.homeGreeting(user!.firstName);

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.heroGradientStart, AppColors.heroGradientEnd],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 18.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      greeting,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.heading4.copyWith(
                        color: AppColors.textInverse,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(width: AppSpacing.md.w),
                  _Avatar(url: user?.avatarUrl),
                ],
              ),
              SizedBox(height: AppSpacing.lg.h),
              _SearchPill(hint: l10n.homeSearchHint),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchPill extends StatelessWidget {
  const _SearchPill({required this.hint});

  final String hint;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface.withValues(alpha: 0.10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        side: BorderSide(color: AppColors.surface.withValues(alpha: 0.15)),
      ),
      child: InkWell(
        onTap: () => context.go('/search?focus=search'),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
          child: Row(
            children: [
              Icon(Icons.search, size: 20.sp, color: AppColors.textInverse),
              SizedBox(width: AppSpacing.sm.w),
              Expanded(
                child: Text(
                  hint,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textInverse.withValues(alpha: 0.8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(width: 38.r, height: 38.r, child: _image(url)),
    );
  }

  Widget _image(String? url) {
    if (url == null || url.isEmpty) {
      return Container(
        color: AppColors.surface.withValues(alpha: 0.20),
        child: Icon(Icons.person, size: 20.sp, color: AppColors.textInverse),
      );
    }
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      errorWidget: (context, _, _) => Container(
        color: AppColors.surface.withValues(alpha: 0.20),
        child: Icon(Icons.person, size: 20.sp, color: AppColors.textInverse),
      ),
    );
  }
}
