import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/notification_button.dart';
import '../widgets/home_banners.dart';
import '../widgets/hot_sales_section.dart';
import '../widgets/recently_viewed_section.dart';

class HomePageBody extends StatelessWidget {
  const HomePageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 9.h),
          sliver: SliverToBoxAdapter(
            child: Row(
              children: [
                Expanded(child: HomeSearchBar(onTap: () {})),
                AppSpacing.w16,
                NotificationButton(
                  onTap: () {},
                  hasUnread: true, // Represents a new notification badge
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(child: AppSpacing.h12),
        const SliverToBoxAdapter(child: HomeBanners()),
        SliverToBoxAdapter(child: AppSpacing.h24),
        const SliverToBoxAdapter(child: HotSalesSection()),
        SliverToBoxAdapter(child: AppSpacing.h24),
        const SliverToBoxAdapter(child: RecentlyViewedSection()),
        SliverToBoxAdapter(child: AppSpacing.h64),
        // Future Slivers like Categories Grids, and Products Lists will be added here
      ],
    );
  }
}
