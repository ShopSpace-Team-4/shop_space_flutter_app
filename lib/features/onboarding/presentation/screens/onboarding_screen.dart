import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injectable.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../cubits/onboarding_cubit.dart';
import '../widgets/onboarding_page.dart';
import '../widgets/onboarding_page_buttons.dart';
import '../widgets/onboarding_page_dots.dart';

/// First-launch onboarding (public route, outside the shell, no nav bar).
///
/// A [PageView] renders the three onboarding pages and stays synced with
/// [OnboardingCubit.pageIndex]: swiping calls `cubit.setPage`, navigating
/// with the pill buttons animates the controller, and the persistent
/// dots/buttons row sits below the carousel. `Skip` (page 1) and
/// `Let's Go` (page 3) both call `cubit.complete()`, which persists the flag —
/// the router's refresh listener then re-evaluates and routes to `/` or
/// `/login`. Every value scales with screenutil and layout uses flex widgets.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  late final OnboardingCubit _cubit;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    _cubit = getIt<OnboardingCubit>();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// A user swipe landed on [index]: mirror it into the cubit so the dots and
  /// button layout follow the current page.
  void _onPageChanged(int index) {
    if (index != _cubit.state.pageIndex) {
      _cubit.setPage(index);
    }
  }

  /// A button moved the page via the cubit: animate the [PageView] to follow.
  /// Swipes are skipped because the controller is already at (or gliding to)
  /// the target page.
  void _onState(BuildContext context, OnboardingState state) {
    if (!_pageController.hasClients) return;
    final int current = _pageController.page!.round();
    if (current != state.pageIndex) {
      _pageController.animateToPage(
        state.pageIndex,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    }
  }

  List<OnboardingPageData> _pages(AppLocalizations l10n) {
    return [
      OnboardingPageData(
        imageAsset: 'assets/pngs/onboarding/first_image_onboarding.png',
        title: l10n.onboardingPage1Title,
        subtitle: l10n.onboardingPage1Subtitle,
      ),
      OnboardingPageData(
        imageAsset: 'assets/pngs/onboarding/second_image_onboarding.png',
        title: l10n.onboardingPage2Title,
        subtitle: l10n.onboardingPage2Subtitle,
      ),
      OnboardingPageData(
        imageAsset: 'assets/pngs/onboarding/third_image_onboarding.png',
        title: l10n.onboardingPage3Title,
        subtitle: l10n.onboardingPage3Subtitle,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final List<OnboardingPageData> pages = _pages(l10n);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: BlocListener<OnboardingCubit, OnboardingState>(
          bloc: _cubit,
          listener: _onState,
          child: BlocBuilder<OnboardingCubit, OnboardingState>(
            bloc: _cubit,
            builder: (BuildContext context, OnboardingState state) {
              final bool isLast = state.pageIndex == pages.length - 1;
              return Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: pages.length,
                      onPageChanged: _onPageChanged,
                      itemBuilder: (BuildContext context, int index) {
                        return OnboardingPage(data: pages[index]);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.xl.w,
                      AppSpacing.lg.h,
                      AppSpacing.xl.w,
                      AppSpacing.lg.h,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 480),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            OnboardingPageDots(
                              count: pages.length,
                              activeIndex: state.pageIndex,
                            ),
                            SizedBox(height: AppSpacing.xl.h),
                            OnboardingPageButtons(
                              index: state.pageIndex,
                              nextLabel: isLast
                                  ? l10n.onboardingLetsGo
                                  : l10n.onboardingNext,
                              backLabel: l10n.commonBack,
                              skipLabel: l10n.onboardingSkip,
                              onNext: isLast ? _cubit.complete : _cubit.next,
                              onBack: _cubit.back,
                              onSkip: _cubit.complete,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}