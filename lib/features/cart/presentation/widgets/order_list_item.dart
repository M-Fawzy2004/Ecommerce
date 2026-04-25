import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/theme/app_text_styles.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderListItem extends StatefulWidget {
  final Map<String, dynamic> order;

  const OrderListItem({super.key, required this.order});

  @override
  State<OrderListItem> createState() => _OrderListItemState();
}

class _OrderListItemState extends State<OrderListItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final status = widget.order['status'] as String;
    final date = DateTime.parse(widget.order['created_at']).toLocal();
    final total = widget.order['total_amount'] as num;

    Color statusColor;
    String statusText;
    IconData statusIcon;
    int currentStep = 0; // 0: Confirmed, 1: Preparing, 2: Shipped, 3: Delivered

    switch (status.toLowerCase()) {
      case 'pending':
      case 'confirmed':
        statusColor = Colors.green;
        statusText = 'orders.status_confirmed'.tr();
        statusIcon = Icons.check_circle_outline;
        currentStep = 0;
        break;
      case 'preparing':
      case 'processing':
        statusColor = Colors.blue;
        statusText = 'orders.status_preparing'.tr();
        statusIcon = Icons.inventory_2_outlined;
        currentStep = 1;
        break;
      case 'shipped':
      case 'out_for_delivery':
        statusColor = Colors.purple;
        statusText = 'orders.status_shipped'.tr();
        statusIcon = Icons.local_shipping_outlined;
        currentStep = 2;
        break;
      case 'delivered':
        statusColor = Colors.green.shade700;
        statusText = 'orders.status_delivered'.tr();
        statusIcon = Icons.done_all;
        currentStep = 3;
        break;
      case 'cancelled':
      case 'failed':
        statusColor = Colors.red;
        statusText = status.toLowerCase() == 'failed'
            ? 'orders.status_failed'.tr()
            : 'orders.status_cancelled'.tr();
        statusIcon = Icons.cancel_outlined;
        currentStep = -1;
        break;
      default:
        statusColor = AppColors.textSecondary;
        statusText = status.toUpperCase();
        statusIcon = Icons.info_outline;
        currentStep = 0;
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: _isExpanded
                ? AppColors.primary.withOpacity(0.3)
                : Colors.transparent,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '#${widget.order['order_code']}',
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, color: statusColor, size: 16.sp),
                      AppSpacing.w4,
                      Text(
                        statusText,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AppSpacing.h12,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'orders.date'.tr(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  DateFormat('MMM dd, yyyy - hh:mm a').format(date),
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            AppSpacing.h8,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'orders.total_amount'.tr(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),

            // Expanded Section
            if (_isExpanded) ...[
              AppSpacing.h16,
              const Divider(),
              AppSpacing.h16,
              Text(
                'orders.tracking_title'.tr(),
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              AppSpacing.h24,
              _buildTrackingUI(currentStep),
              AppSpacing.h24,
              const Divider(),
              AppSpacing.h16,
              Text(
                'orders.address_details'.tr(),
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              AppSpacing.h8,
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: AppColors.primary,
                    size: 20.sp,
                  ),
                  AppSpacing.w8,
                  Expanded(
                    child: Text(
                      widget.order['shipping_address'] ??
                          'orders.no_address'.tr(),
                      style: AppTextStyles.bodyMedium,
                    ),
                  ),
                ],
              ),
              AppSpacing.h8,
              Row(
                children: [
                  Icon(Icons.phone, color: AppColors.primary, size: 20.sp),
                  AppSpacing.w8,
                  Expanded(
                    child: Text(
                      widget.order['phone'] ?? 'orders.no_phone'.tr(),
                      style: AppTextStyles.bodyMedium,
                    ),
                  ),
                ],
              ),
            ],

            AppSpacing.h8,
            Center(
              child: Icon(
                _isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: AppColors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackingUI(int currentStep) {
    if (currentStep == -1) {
      return Center(
        child: Text(
          'orders.tracking_cancelled'.tr(),
          style: AppTextStyles.bodyMedium.copyWith(color: Colors.red),
        ),
      );
    }

    return Row(
      children: [
        _buildTrackingStep(
          icon: Icons.receipt_long,
          title: 'orders.step_confirmed'.tr(),
          isActive: currentStep >= 0,
          isCompleted: currentStep > 0,
        ),
        _buildTrackingLine(isActive: currentStep > 0),
        _buildTrackingStep(
          icon: Icons.inventory_2,
          title: 'orders.step_preparing'.tr(),
          isActive: currentStep >= 1,
          isCompleted: currentStep > 1,
        ),
        _buildTrackingLine(isActive: currentStep > 1),
        _buildTrackingStep(
          icon: Icons.local_shipping,
          title: 'orders.step_shipped'.tr(),
          isActive: currentStep >= 2,
          isCompleted: currentStep > 2,
        ),
        _buildTrackingLine(isActive: currentStep > 2),
        _buildTrackingStep(
          icon: Icons.home,
          title: 'orders.step_delivered'.tr(),
          isActive: currentStep >= 3,
          isCompleted:
              false, // Last step doesn't need to show 'completed' check inside icon
        ),
      ],
    );
  }

  Widget _buildTrackingStep({
    required IconData icon,
    required String title,
    required bool isActive,
    required bool isCompleted,
  }) {
    final color = isActive
        ? AppColors.primary
        : AppColors.textHint.withOpacity(0.5);

    return Column(
      children: [
        Container(
          width: 48.r,
          height: 48.r,
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primary.withOpacity(0.1)
                : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(color: color, width: isActive ? 2 : 1),
          ),
          child: Center(
            child: isCompleted
                ? Icon(Icons.check, color: AppColors.primary, size: 24.sp)
                : Icon(icon, color: color, size: 24.sp),
          ),
        ),
        AppSpacing.h8,
        Text(
          title,
          style: AppTextStyles.bodySmall.copyWith(
            color: color,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildTrackingLine({required bool isActive}) {
    return Expanded(
      child: Container(
        height: 2.h,
        margin: EdgeInsets.only(
          bottom: 24.h,
        ), // Offset to align with circles not text
        color: isActive
            ? AppColors.primary
            : AppColors.textHint.withOpacity(0.3),
      ),
    );
  }
}
