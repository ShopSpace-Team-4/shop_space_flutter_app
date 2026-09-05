import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../localization/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_elevation.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'window_size.dart';

/// Hand-rolled adaptive app shell (decision D1), driven by a go_router
/// [StatefulNavigationShell].
///
/// Renders the app's 4-tab navigation on every screen inside the shell so it
/// stays visible across all tabs: a Figma-fidelity bottom bar (`Frame 51`:
/// Home · Search · [Add] · Saved · Profile) on compact widths and a
/// [NavigationRail] on medium/expanded widths. The rail mirrors the bottom bar
/// with an "Add listing" destination in the same center slot (Home · Search ·
/// [Add] · Saved · Profile). go_router's `IndexedStack` container keeps each
/// branch's navigator alive, so content state survives tab switches and
/// resize/rotation. All values scale with screenutil; the nav bar
/// heights/icon sizes/label sizes adapt to the reference frame.
class AppAdaptiveShell extends StatelessWidget {
  const AppAdaptiveShell({
    super.key,
    required this.navigationShell,
    this.onAddPressed,
  });

  /// Index of the center Add slot in both the bottom bar and the nav rail
  /// (Home · Search · [Add] · Saved · Profile).
  static const int _addIndex = 2;

  /// The go_router branch navigator; rendered as the shell's content pane.
  final StatefulNavigationShell navigationShell;

  /// Invoked when the center Add button is tapped (→ Add Listing).
  final VoidCallback? onAddPressed;

  void _selectBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final List<_NavTab> tabs = _tabs(l10n);

    switch (breakpointOf(context)) {
      case AppBreakpoint.compact:
        return Scaffold(
          body: navigationShell,
          bottomNavigationBar: _FigmaBottomBar(
            tabs: tabs,
            selectedIndex: navigationShell.currentIndex,
            onSelected: _selectBranch,
            onAddPressed: onAddPressed,
          ),
        );
      case AppBreakpoint.medium:
      case AppBreakpoint.expanded:
        final bool extended = breakpointOf(context) == AppBreakpoint.expanded;
        return Scaffold(
          body: Row(
            children: [
              NavigationRail(
                selectedIndex: _railIndexForBranch(navigationShell.currentIndex),
                extended: extended,
                onDestinationSelected: _onRailSelected,
                selectedIconTheme: const IconThemeData(
                  color: AppColors.primary,
                ),
                unselectedIconTheme: const IconThemeData(
                  color: AppColors.textTertiary,
                ),
                selectedLabelTextStyle: AppTypography.railLabelSelected.copyWith(
                  color: AppColors.primary,
                ),
                unselectedLabelTextStyle: AppTypography.railLabel.copyWith(
                  color: AppColors.textTertiary,
                ),
                destinations: [
                  for (final _NavTab tab in tabs.take(_addIndex))
                    _railDestination(tab),
                  NavigationRailDestination(
                    icon: Icon(Icons.add, size: 24.sp),
                    selectedIcon: Icon(Icons.add, size: 24.sp),
                    label: Text(l10n.navAdd),
                  ),
                  for (final _NavTab tab in tabs.skip(_addIndex))
                    _railDestination(tab),
                ],
              ),
              const VerticalDivider(width: 1, thickness: 1),
              Expanded(child: navigationShell),
            ],
          ),
        );
    }
  }

  /// The Add destination sits at rail index [_addIndex], so branch indices
  /// at/after it shift by +1 on the rail (branch 2 → rail 3, branch 3 → rail 4).
  static int _railIndexForBranch(int branchIndex) =>
      branchIndex >= _addIndex ? branchIndex + 1 : branchIndex;

  /// Maps a rail tap back to a branch, except the Add destination which fires
  /// [onAddPressed] instead of selecting a tab.
  void _onRailSelected(int index) {
    if (index == _addIndex) {
      onAddPressed?.call();
      return;
    }
    _selectBranch(index > _addIndex ? index - 1 : index);
  }

  static NavigationRailDestination _railDestination(_NavTab tab) {
    return NavigationRailDestination(
      icon: Icon(tab.icon, size: 24.sp),
      selectedIcon: Icon(tab.selectedIcon, size: 24.sp),
      label: Text(tab.label),
    );
  }
}

/// Figma `Frame 51` bottom bar: Home · Search · [Add] · Saved · Profile.
///
/// White bar with an `outline` top stroke; active tab is `primary`
/// (bold Inter 10px label), inactive tabs are `textTertiary` (regular). The
/// center Add button is a `primary` circle with the Figma drop shadow. Bar
/// height, icons, labels and the add button all scale with screenutil.
class _FigmaBottomBar extends StatelessWidget {
  const _FigmaBottomBar({
    required this.tabs,
    required this.selectedIndex,
    required this.onSelected,
    this.onAddPressed,
  });

  /// Index in [tabs] where the center Add button is placed.
  static const int _addIndex = 2;

  final List<_NavTab> tabs;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final VoidCallback? onAddPressed;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final List<_NavTab> leftTabs = tabs.take(_addIndex).toList();
    final List<_NavTab> rightTabs = tabs.skip(_addIndex).toList();

    return SafeArea(
      top: false,
      child: Container(
        height: 62.h,
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.outline)),
        ),
        child: Row(
          children: [
            for (int i = 0; i < leftTabs.length; i++)
              Expanded(
                child: _BottomTab(
                  tab: leftTabs[i],
                  selected: selectedIndex == i,
                  onTap: () => onSelected(i),
                ),
              ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs.w),
              child: _AddButton(label: l10n.navAdd, onPressed: onAddPressed),
            ),
            for (int i = 0; i < rightTabs.length; i++)
              Expanded(
                child: _BottomTab(
                  tab: rightTabs[i],
                  selected: selectedIndex == _addIndex + i,
                  onTap: () => onSelected(_addIndex + i),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _BottomTab extends StatelessWidget {
  const _BottomTab({
    required this.tab,
    required this.selected,
    required this.onTap,
  });

  final _NavTab tab;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color color = selected ? AppColors.primary : AppColors.textTertiary;
    return Semantics(
      selected: selected,
      button: true,
      label: tab.label,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              selected ? tab.selectedIcon : tab.icon,
              size: 20.sp,
              color: color,
            ),
            SizedBox(height: 1.h),
            Text(
              tab.label,
              style: (selected
                      ? AppTypography.navLabelSelected
                      : AppTypography.navLabel)
                  .copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.label, this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: Container(
        width: 40.w,
        height: 40.h,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary,
          boxShadow: AppElevation.high,
        ),
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onPressed,
            child: Icon(Icons.add, color: AppColors.onPrimary, size: 24.sp),
          ),
        ),
      ),
    );
  }
}

class _NavTab {
  const _NavTab({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

/// The shell's navigation tabs, matching Figma `Frame 51` (Home, Search,
/// Saved, Profile) with the center Add button rendered separately.
List<_NavTab> _tabs(AppLocalizations l10n) {
  return [
    _NavTab(
      label: l10n.navHome,
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
    ),
    _NavTab(
      label: l10n.navSearch,
      icon: Icons.search,
      selectedIcon: Icons.search,
    ),
    _NavTab(
      label: l10n.navSaved,
      icon: Icons.bookmark_outline,
      selectedIcon: Icons.bookmark,
    ),
    _NavTab(
      label: l10n.navProfile,
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
    ),
  ];
}
