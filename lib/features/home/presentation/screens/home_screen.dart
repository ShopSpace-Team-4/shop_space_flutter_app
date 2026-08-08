import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injectable.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading_view.dart';
import '../../../listing/repository/listing_repository.dart';
import '../../../user/repository/user_repository.dart';
import '../cubits/home_cubit.dart';
import '../widgets/home_advisor_card.dart';
import '../widgets/home_category_chips.dart';
import '../widgets/home_hero_header.dart';
import '../widgets/home_nearby_section.dart';
import '../widgets/home_recommended_rail.dart';

/// Content width cap for medium/expanded so the home sections (Figma `95:4028`
/// 343-wide cards, carousels) don't stretch edge-to-edge on wide screens.
/// This is a deliberate, non-scaling layout-structure constant (constitution
/// §5 allowed exception) — screenutil never picks structure.
const double _maxContentWidth = 720;

/// Tenant-facing home feed (Figma `95:4028`): hero header + AI Space Advisor
/// CTA + Categories chips + Recommended carousel + Nearby Listings, all driven
/// by [HomeCubit] via `GET /listings/meta` and `GET /listings`. No AppBar (the
/// design has none). Content is a scrollable column, centered with a max width
/// on medium/expanded; the hero stays full-bleed. Rendered inside
/// [AppAdaptiveShell].
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeCubit _cubit;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    _cubit = HomeCubit(
      listingRepository: getIt<ListingRepository>(),
      userRepository: getIt<UserRepository>(),
    );
    _cubit.load();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeCubit, HomeState>(
        bloc: _cubit,
        builder: (context, state) {
          if (state.isLoading) {
            return const AppLoadingView();
          }
          if (state.failure != null) {
            return AppErrorView(failure: state.failure!, onRetry: _cubit.load);
          }
          return _HomeContent(state: state);
        },
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.state});

  final HomeState state;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        HomeHeroHeader(user: state.user),
        SizedBox(height: AppSpacing.lg.h),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maxContentWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: const HomeAdvisorCard(),
                ),
                SizedBox(height: 8.h),
                HomeCategoryChips(categories: state.categories),
                SizedBox(height: 8.h),
                HomeRecommendedRail(listings: state.recommended),
                SizedBox(height: 8.h),
                HomeNearbySection(listings: state.nearby),
                SizedBox(height: AppSpacing.xxl.h),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
