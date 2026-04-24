import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/theme/app_text_styles.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:ecommerce_app/core/ui/app_radius.dart';
import 'package:ecommerce_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

class CheckoutAddressSection extends StatelessWidget {
  const CheckoutAddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Address',
              style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
            ),
            AppSpacing.h12,
            GestureDetector(
              onTap: () async {
                final Map<String, dynamic>? result =
                    await context.pushNamed<Map<String, dynamic>>('address_picker');
                if (result != null && context.mounted) {
                  final LatLng location = result['location'];
                  final String address = result['address'];
                  context.read<CartCubit>().updateAddress(
                        lat: location.latitude,
                        lng: location.longitude,
                        address: address,
                      );
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Map Thumbnail
                  Container(
                    width: 100.w,
                    height: 70.h,
                    decoration: BoxDecoration(
                      borderRadius: AppRadius.r12,
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://static-maps.yandex.ru/1.x/?lang=en_US&ll=${state.longitude},${state.latitude}&z=13&l=map&size=300,200',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: Icon(Icons.location_on, color: AppColors.error, size: 24.sp),
                    ),
                  ),
                  AppSpacing.w16,
                  // Address Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'House',
                          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                        ),
                        AppSpacing.h4,
                        Text(
                          state.shippingAddress,
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
