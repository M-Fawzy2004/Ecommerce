import 'dart:ui';
import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';
import 'package:ecommerce_app/core/cubits/network_cubit.dart';
import 'package:ecommerce_app/core/di/init_dependencies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainWrapperPage extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainWrapperPage({super.key, required this.navigationShell});

  @override
  State<MainWrapperPage> createState() => _MainWrapperPageState();
}

class _MainWrapperPageState extends State<MainWrapperPage> {
  void _onBranchTapped(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<NetworkCubit>()..checkConnection(),
      child: BlocBuilder<NetworkCubit, NetworkState>(
        builder: (context, state) {
          final bool isDisconnected =
              state.status == NetworkStatus.disconnected;

          return Scaffold(
            extendBody: true,
            body: Stack(
              fit: StackFit.expand,
              children: [
                // 1. Always show content so loaded data stays visible
                widget.navigationShell,

                // 2. Premium Top Offline Banner
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  top: isDisconnected ? 40.h : -100.h,
                  left: 20.w,
                  right: 20.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.error.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.wifi_off_rounded,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          "No Internet Connection",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 3. Always show the Navigation Bar
                _buildFloatingNavBar(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFloatingNavBar() {
    return Positioned(
      left: 30.w,
      right: 30.w,
      bottom: 10.h,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 68.h,
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(100.r),
              border: Border.all(color: AppColors.surfaceDark),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                _CustomNavItem(
                  icon: IconlyLight.home,
                  selectedIcon: IconlyBold.home,
                  isSelected: widget.navigationShell.currentIndex == 0,
                  onTap: () => _onBranchTapped(0),
                ),
                _CustomNavItem(
                  icon: IconlyLight.category,
                  selectedIcon: IconlyBold.category,
                  isSelected: widget.navigationShell.currentIndex == 1,
                  onTap: () => _onBranchTapped(1),
                ),
                _CustomNavItem(
                  icon: IconlyLight.bag,
                  selectedIcon: IconlyBold.bag,
                  isSelected: widget.navigationShell.currentIndex == 2,
                  onTap: () => _onBranchTapped(2),
                ),
                _CustomNavItem(
                  icon: IconlyLight.profile,
                  selectedIcon: IconlyBold.profile,
                  isSelected: widget.navigationShell.currentIndex == 3,
                  onTap: () => _onBranchTapped(3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomNavItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final bool isSelected;
  final VoidCallback onTap;

  const _CustomNavItem({
    required this.icon,
    required this.selectedIcon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Active State Indicator (Light Beam effect)
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: isSelected ? 1 : 0,
              child: Column(
                children: [
                  // Top Pill
                  Container(
                    width: 35.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(4.r),
                        bottomRight: Radius.circular(4.r),
                      ),
                    ),
                  ),
                  // Beam Gradient
                  Expanded(
                    child: Container(
                      width: 50.w,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withOpacity(0.15),
                            Colors.white.withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Icon
            AnimatedScale(
              duration: const Duration(milliseconds: 300),
              scale: isSelected ? 1.1 : 1.0,
              child: Icon(
                isSelected ? selectedIcon : icon,
                color: isSelected
                    ? Colors.white
                    : Colors.white.withOpacity(0.4),
                size: 26.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
