import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';

class MainWrapperPage extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainWrapperPage({
    super.key,
    required this.navigationShell,
  });

  void _onBranchTapped(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        height: 75.h,
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _CustomNavItem(
                icon: IconlyLight.home,
                selectedIcon: IconlyBold.home,
                label: 'navbar.home'.tr(),
                isSelected: navigationShell.currentIndex == 0,
                onTap: () => _onBranchTapped(0),
              ),
              _CustomNavItem(
                icon: IconlyLight.category,
                selectedIcon: IconlyBold.category,
                label: 'navbar.categories'.tr(),
                isSelected: navigationShell.currentIndex == 1,
                onTap: () => _onBranchTapped(1),
              ),
              _CustomNavItem(
                icon: IconlyLight.bag,
                selectedIcon: IconlyBold.bag,
                label: 'navbar.cart'.tr(),
                isSelected: navigationShell.currentIndex == 2,
                onTap: () => _onBranchTapped(2),
              ),
              _CustomNavItem(
                icon: IconlyLight.profile,
                selectedIcon: IconlyBold.profile,
                label: 'navbar.profile'.tr(),
                isSelected: navigationShell.currentIndex == 3,
                onTap: () => _onBranchTapped(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomNavItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CustomNavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? selectedIcon : icon,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: 24.sp,
            ),
            if (isSelected) ...[
              SizedBox(width: 8.w),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 350),
                opacity: isSelected ? 1 : 0,
                child: Text(
                  label,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
