import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/core/router/app_router.dart';
import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/theme/app_text_styles.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:ecommerce_app/core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../cubit/onboarding_cubit.dart';

class OnboardingPageBody extends StatefulWidget {
  const OnboardingPageBody({super.key});

  @override
  State<OnboardingPageBody> createState() => _OnboardingPageBodyState();
}

class _OnboardingPageBodyState extends State<OnboardingPageBody> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OnboardingCubit>();
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: cubit.updateIndex,
              itemCount: cubit.onboardingPages.length,
              itemBuilder: (context, index) {
                final page = cubit.onboardingPages[index];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 300.h,
                        child: Lottie.asset(
                          page.image,
                          fit: BoxFit.contain,
                          repeat: false,
                        ),
                      ),
                      AppSpacing.h40,
                      Text(
                        page.title.tr(),
                        textAlign: TextAlign.center,
                        style: AppTextStyles.headlineLarge.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      AppSpacing.h16,
                      Text(
                        page.description.tr(),
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          _buildFooter(cubit),
        ],
      ),
    );
  }

  Widget _buildFooter(OnboardingCubit cubit) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        final isLastPage =
            cubit.currentIndex == cubit.onboardingPages.length - 1;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  cubit.onboardingPages.length,
                  (index) => _buildDot(index, cubit.currentIndex),
                ),
              ),
              AppSpacing.h40,
              AppButton(
                text: isLastPage
                    ? 'onboarding.get_started'.tr()
                    : 'onboarding.next'.tr(),
                onPressed: () {
                  if (isLastPage) {
                    context.go(AppRouter.auth);
                  } else {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDot(int index, int currentIndex) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      height: 8.h,
      width: index == currentIndex ? 24.w : 8.w,
      decoration: BoxDecoration(
        color: index == currentIndex ? AppColors.primary : Colors.grey[300],
        borderRadius: BorderRadius.circular(4.r),
      ),
    );
  }
}
