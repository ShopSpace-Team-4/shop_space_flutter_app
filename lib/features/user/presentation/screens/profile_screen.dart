import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injectable.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/storage/preferences_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_loading_view.dart';
import '../../../auth/google/auth_google_service.dart';
import '../../../auth/presentation/cubits/auth_session_cubit.dart';
import '../../../listing/repository/listing_repository.dart';
import '../../data/models/user.dart';
import '../../data/models/user_role.dart';
import '../../repository/user_repository.dart';
import '../cubits/profile_cubit.dart';
import '../cubits/roles_cubit.dart';

/// Account screen (US6, Figma `242:2958`): a gradient header with the avatar,
/// name/email, tappable role chips (each held role renders as a pill; the
/// active one is solid white) and a Listings stat card, above a 4-row menu —
/// My Listings, Verification (read-only), Settings and Sign Out. Role chips
/// switch the active dashboard via [RolesCubit.switchActiveRole]; Sign Out
/// clears the session through [AuthSessionCubit.signOut] (the router's
/// [AuthGuard] redirects to `/login`). Rows/navigation use `context.push`
/// (Settings, My Listings) so a back affordance stays available. Fully
/// responsive (screenutil + flex).
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileCubit _cubit;
  late final RolesCubit _rolesCubit;
  late final AuthSessionCubit _session;

  bool _signingOut = false;
  bool _roleSwitchHandled = false;

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    final AppLocalizations l10n = AppLocalizations.of(context);
    _cubit = ProfileCubit(
      repository: getIt<UserRepository>(),
      googleAuth: getIt<AuthGoogleService>(),
      listingRepository: getIt<ListingRepository>(),
      l10n: l10n,
    );
    _rolesCubit = RolesCubit(
      repository: getIt<UserRepository>(),
      session: getIt<AuthSessionCubit>(),
      preferences: getIt<PreferencesService>(),
      l10n: l10n,
    );
    _session = getIt<AuthSessionCubit>();
    _cubit.load();
    _cubit.loadListingStats();
  }

  @override
  void dispose() {
    _cubit.close();
    _rolesCubit.close();
    super.dispose();
  }

  void _signOut() {
    setState(() => _signingOut = true);
    _session.signOut();
  }

  void _switchRole(UserRole role) {
    if (_rolesCubit.state.isSwitchingRole) return;
    _roleSwitchHandled = false;
    _rolesCubit.switchActiveRole(role);
  }

  void _onRolesState(BuildContext context, RolesState state) {
    if (_roleSwitchHandled) return;
    final AppLocalizations l10n = AppLocalizations.of(context);
    final String? message = state.isSuccess
        ? l10n.profileRoleSwitchSuccess
        : state.errorMessage;
    if (message == null) return;
    _roleSwitchHandled = true;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  String _fullName(User user) => '${user.firstName} ${user.lastName}'.trim();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocListener<RolesCubit, RolesState>(
        bloc: _rolesCubit,
        listener: _onRolesState,
        child: BlocBuilder<AuthSessionCubit, AuthSessionState>(
          bloc: _session,
          builder: (BuildContext context, AuthSessionState sessionState) {
            return BlocBuilder<RolesCubit, RolesState>(
              bloc: _rolesCubit,
              builder: (BuildContext context, RolesState rolesState) {
                return BlocBuilder<ProfileCubit, ProfileState>(
                  bloc: _cubit,
                  builder: (BuildContext context, ProfileState state) {
                    final User? user = state.user;
                    if (user != null) {
                      return _ProfileContent(
                        fullName: _fullName(user),
                        email: user.email,
                        roles: user.roles,
                        isVerified: user.isVerified,
                        avatarUrl: user.avatarUrl,
                        activeRole: sessionState is AuthSessionAuthenticated
                            ? sessionState.activeRole
                            : UserRole.tenant,
                        isSwitchingRole: rolesState.isSwitchingRole,
                        signingOut: _signingOut,
                        listingsCount: state.listingsCount,
                        activeListingsCount: state.activeListingsCount,
                        onRoleSwitch: _switchRole,
                        onSignOut: _signOut,
                      );
                    }
                    if (state.errorMessage != null) {
                      return _ProfileError(
                        message: state.errorMessage!,
                        onRetry: _cubit.load,
                      );
                    }
                    return const AppLoadingView();
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({
    required this.fullName,
    required this.email,
    required this.roles,
    required this.isVerified,
    required this.avatarUrl,
    required this.activeRole,
    required this.isSwitchingRole,
    required this.signingOut,
    required this.listingsCount,
    required this.activeListingsCount,
    required this.onRoleSwitch,
    required this.onSignOut,
  });

  final String fullName;
  final String email;
  final List<UserRole> roles;
  final bool isVerified;
  final String? avatarUrl;
  final UserRole activeRole;
  final bool isSwitchingRole;
  final bool signingOut;
  final int listingsCount;
  final int activeListingsCount;
  final ValueChanged<UserRole> onRoleSwitch;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final bool isLandlord = roles.contains(UserRole.landlord);
    // Decided: show the active count ONLY when > 0, fall back to the total
    // otherwise; hide the line entirely for tenant-only accounts so a
    // non-landlord never sees "0 active listings".
    final int? listingSubtitleCount =
        isLandlord && (activeListingsCount > 0 || listingsCount > 0)
            ? (activeListingsCount > 0 ? activeListingsCount : listingsCount)
            : null;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ProfileHeader(
            fullName: fullName,
            email: email,
            roles: roles,
            avatarUrl: avatarUrl,
            activeRole: activeRole,
            isSwitchingRole: isSwitchingRole,
            listingsCount: listingsCount,
            onRoleSwitch: onRoleSwitch,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.xl.w,
              AppSpacing.lg.h,
              AppSpacing.xl.w,
              AppSpacing.xl.h,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 560.w),
                child: _ProfileMenu(
                  l10n: l10n,
                  isVerified: isVerified,
                  listingSubtitleCount: listingSubtitleCount,
                  signingOut: signingOut,
                  onSignOut: onSignOut,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.fullName,
    required this.email,
    required this.roles,
    required this.avatarUrl,
    required this.activeRole,
    required this.isSwitchingRole,
    required this.listingsCount,
    required this.onRoleSwitch,
  });

  final String fullName;
  final String email;
  final List<UserRole> roles;
  final String? avatarUrl;
  final UserRole activeRole;
  final bool isSwitchingRole;
  final int listingsCount;
  final ValueChanged<UserRole> onRoleSwitch;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    // Figma renders landlord first, then tenant; only roles the user actually
    // holds render, so a tenant-only account shows a single active chip.
    final List<UserRole> held = [
      if (roles.contains(UserRole.landlord)) UserRole.landlord,
      if (roles.contains(UserRole.tenant)) UserRole.tenant,
    ];

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.heroGradientStart, AppColors.heroGradientEnd],
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl.w,
        AppSpacing.md.h,
        AppSpacing.xl.w,
        AppSpacing.xl.h,
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _ProfileAvatar(url: avatarUrl),
                SizedBox(width: AppSpacing.md.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fullName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodyLarge.copyWith(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textInverse,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 12.sp,
                          color: AppColors.textInverse.withValues(alpha: 0.55),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.md.h),
            if (held.isNotEmpty) ...[
              Wrap(
                spacing: AppSpacing.sm.w,
                runSpacing: AppSpacing.sm.h,
                children: [
                  for (final UserRole role in held)
                    _RoleChip(
                      label: role == UserRole.landlord
                          ? '🏢 ${l10n.roleLandlord}'
                          : '🔍 ${l10n.roleTenant}',
                      isActive: role == activeRole,
                      isSwitching: isSwitchingRole && role == activeRole,
                      onTap: role == activeRole
                          ? null
                          : () => onRoleSwitch(role),
                    ),
                ],
              ),
              SizedBox(height: AppSpacing.md.h),
            ],
            _StatCard(listingsCount: listingsCount, l10n: l10n),
          ],
        ),
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    final String? imageUrl = url;
    final Widget fallback = Container(
      color: AppColors.surface.withValues(alpha: 0.20),
      child: Icon(Icons.person, size: 28.sp, color: AppColors.textInverse),
    );

    return ClipOval(
      child: SizedBox(
        width: 56.r,
        height: 56.r,
        child: (imageUrl == null || imageUrl.isEmpty)
            ? fallback
            : CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                errorWidget: (context, _, _) => fallback,
              ),
      ),
    );
  }
}

class _RoleChip extends StatelessWidget {
  const _RoleChip({
    required this.label,
    required this.isActive,
    required this.isSwitching,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final bool isSwitching;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isActive
          ? AppColors.surface
          : AppColors.surface.withValues(alpha: 0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isActive
                      ? AppColors.surfaceInverse
                      : AppColors.textInverse,
                ),
              ),
              if (isSwitching) ...[
                SizedBox(width: 6.w),
                SizedBox(
                  width: 12.r,
                  height: 12.r,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.listingsCount, required this.l10n});

  final int listingsCount;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg.w,
        vertical: AppSpacing.md.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppRadius.medium.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$listingsCount',
            style: AppTypography.bodyLarge.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textInverse,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            l10n.profileListingsStat,
            style: AppTypography.caption.copyWith(
              fontSize: 10.sp,
              fontWeight: FontWeight.w400,
              letterSpacing: 0,
              color: AppColors.textInverse.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileMenu extends StatelessWidget {
  const _ProfileMenu({
    required this.l10n,
    required this.isVerified,
    required this.listingSubtitleCount,
    required this.signingOut,
    required this.onSignOut,
  });

  final AppLocalizations l10n;
  final bool isVerified;
  final int? listingSubtitleCount;
  final bool signingOut;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card.r),
      ),
      child: Column(
        children: [
          _ProfileRow(
            icon: Icon(Icons.grid_view_outlined, size: 20.sp),
            title: l10n.myListingsTitle,
            subtitle: listingSubtitleCount == null
                ? null
                : l10n.profileActiveListings(listingSubtitleCount!),
            onTap: () => context.push('/my-listings'),
          ),
          const _ProfileDivider(),
          _ProfileRow(
            icon: Icon(Icons.verified_outlined, size: 20.sp),
            title: l10n.profileVerification,
            subtitle: isVerified
                ? l10n.profileVerificationVerified
                : l10n.profileVerificationNotVerified,
            onTap: null,
            showChevron: false,
          ),
          const _ProfileDivider(),
          _ProfileRow(
            icon: Icon(Icons.settings_outlined, size: 20.sp),
            title: l10n.profileSettingsRow,
            subtitle: l10n.profileSettingsSubtitle,
            onTap: () => context.push('/settings'),
          ),
          const _ProfileDivider(),
          _ProfileRow(
            icon: Icon(Icons.logout, size: 20.sp),
            title: l10n.profileSignOut,
            onTap: signingOut ? null : onSignOut,
            showChevron: false,
            destructive: true,
            trailing: signingOut
                ? SizedBox(
                    width: 14.r,
                    height: 14.r,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  )
                : null,
          ),
        ],
      ),
    );
  }
}

class _ProfileDivider extends StatelessWidget {
  const _ProfileDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1.h,
      thickness: 1,
      indent: AppSpacing.lg.w,
      endIndent: AppSpacing.lg.w,
      color: AppColors.outlineSubtle,
    );
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.showChevron = true,
    this.destructive = false,
    this.trailing,
  });

  final Widget icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool showChevron;
  final bool destructive;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final Color boxColor =
        destructive ? AppColors.errorContainer : AppColors.surfaceVariant;
    final Color iconColor =
        destructive ? AppColors.error : AppColors.surfaceInverse;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 65.h,
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
          child: Row(
            children: [
              Container(
                width: 38.r,
                height: 38.r,
                decoration: BoxDecoration(
                  color: boxColor,
                  borderRadius: BorderRadius.circular(AppRadius.medium.r),
                ),
                child: Center(
                  child: IconTheme.merge(
                    data: IconThemeData(color: iconColor),
                    child: icon,
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.md.w),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: destructive
                            ? AppColors.error
                            : AppColors.textPrimary,
                      ),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: 2.h),
                      Text(
                        subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.caption.copyWith(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                SizedBox(width: AppSpacing.sm.w),
                trailing!,
              ] else if (showChevron)
                Icon(
                  Icons.chevron_right,
                  size: 14.sp,
                  color: AppColors.textTertiary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileError extends StatelessWidget {
  const _ProfileError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48.sp, color: AppColors.error),
            SizedBox(height: AppSpacing.lg.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.bodyLarge,
            ),
            SizedBox(height: AppSpacing.xl.h),
            FilledButton(
              onPressed: onRetry,
              child: Text(l10n.retry),
            ),
          ],
        ),
      ),
    );
  }
}