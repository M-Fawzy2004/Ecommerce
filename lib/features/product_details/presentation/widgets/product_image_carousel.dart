import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:ecommerce_app/core/ui/app_radius.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductImageCarousel extends StatefulWidget {
  final List<String> images;

  const ProductImageCarousel({super.key, required this.images});

  @override
  State<ProductImageCarousel> createState() => _ProductImageCarouselState();
}

class _ProductImageCarouselState extends State<ProductImageCarousel> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main Image Area
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            SizedBox(
              height: 250.h,
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.images.length,
                onPageChanged: (index) => setState(
                  () => _currentIndex = index,
                ),
                itemBuilder: (context, index) {
                  return Hero(
                    tag: widget.images[index],
                    child: _buildImage(
                      widget.images[index],
                      context,
                      isThumbnail: false,
                    ),
                  );
                },
              ),
            ),
            // Floating Indicator over image
            Positioned(
              bottom: -10.h,
              child: AnimatedSmoothIndicator(
                activeIndex: _currentIndex,
                count: widget.images.length,
                effect: ScrollingDotsEffect(
                  dotHeight: 4.h,
                  dotWidth: 8.w,
                  activeDotColor: AppColors.primary,
                  dotColor: AppColors.divider,
                  spacing: 4.w,
                ),
              ),
            ),
          ],
        ),
        AppSpacing.h16,
        // Thumbnails
        if (widget.images.length > 1)
          SizedBox(
            height: 70.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: widget.images.length,
              separatorBuilder: (context, index) => AppSpacing.w12,
              itemBuilder: (context, index) {
                final isSelected = _currentIndex == index;
                return GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutQuint,
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 64.w,
                    height: 64.h,
                    padding: EdgeInsets.all(4.r),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: AppRadius.r12,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.divider.withOpacity(0.5),
                        width: isSelected ? 2.w : 1.w,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.1),
                                blurRadius: 4,
                                spreadRadius: 1,
                              )
                            ]
                          : null,
                    ),
                    child: ClipRRect(
                      borderRadius: AppRadius.r8,
                      child: _buildImage(
                        widget.images[index],
                        context,
                        isThumbnail: true,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildImage(String url, BuildContext context,
      {required bool isThumbnail}) {
    if (url.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.contain,
        placeholder: (context, url) => Center(
          child: SizedBox(
            width: 20.w,
            height: 20.h,
            child: const CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        errorWidget: (context, url, error) => Icon(
          Icons.broken_image_outlined,
          color: AppColors.textHint,
          size: 24.sp,
        ),
      );
    }
    return Image.asset(url, fit: BoxFit.contain);
  }
}
