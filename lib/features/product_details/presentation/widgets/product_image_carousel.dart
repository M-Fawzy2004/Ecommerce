import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
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
        // Main Image
        SizedBox(
          height: 250.h,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) {
              return _buildImage(widget.images[index]);
            },
          ),
        ),

        AppSpacing.h16,

        // Dot Indicator
        AnimatedSmoothIndicator(
          activeIndex: _currentIndex,
          count: widget.images.length,
          effect: ExpandingDotsEffect(
            dotHeight: 6.h,
            dotWidth: 6.w,
            activeDotColor: AppColors.primary,
            dotColor: AppColors.gray,
          ),
        ),

        AppSpacing.h24,

        // Thumbnails
        SizedBox(
          height: 85.h,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            scrollDirection: Axis.horizontal,
            itemCount: widget.images.length,
            separatorBuilder: (context, index) => AppSpacing.w12,
            itemBuilder: (context, index) {
              final isSelected = _currentIndex == index;
              return GestureDetector(
                onTap: () {
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: Container(
                  width: 80.w,
                  height: 90.h,
                  padding: EdgeInsets.all(5.r),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary.withOpacity(0.5)
                          : Colors.transparent,
                      width: 2,
                    ),
                    color: AppColors.gray.withOpacity(0.3),
                  ),
                  child: _buildImage(widget.images[index]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildImage(String url) {
    if (url.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.contain,
        placeholder: (context, url) =>
            const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      );
    }
    return Image.asset(url, fit: BoxFit.contain);
  }
}
