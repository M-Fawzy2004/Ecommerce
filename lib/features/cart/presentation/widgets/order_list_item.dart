import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/theme/app_text_styles.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:ecommerce_app/features/checkout/domain/entities/order_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderListItem extends StatefulWidget {
  final OrderEntity order;

  const OrderListItem({super.key, required this.order});

  @override
  State<OrderListItem> createState() => _OrderListItemState();
}

class _OrderListItemState extends State<OrderListItem> {
  bool _isExpanded = false;
  late String _currentStatus;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.order.status;
  }

  @override
  void didUpdateWidget(covariant OrderListItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.order.status != widget.order.status) {
      _currentStatus = widget.order.status;
    }
  }

  Future<void> _refreshOrder() async {
    setState(() => _isRefreshing = true);
    try {
      final data = await Supabase.instance.client
          .from('orders')
          .select('status')
          .eq('id', widget.order.id)
          .single();
      if (mounted) {
        setState(() {
          _currentStatus = data['status'] as String;
          _isRefreshing = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isRefreshing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = _currentStatus;
    final date = widget.order.createdAt.toLocal();
    final total = widget.order.totalAmount;

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
      onTap: () async {
        if (!_isExpanded) {
          // Expanding → fetch latest status
          await _refreshOrder();
        }
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
                  '#${widget.order.orderCode}',
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
                  child: _isRefreshing
                      ? SizedBox(
                          width: 16.sp,
                          height: 16.sp,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: statusColor,
                          ),
                        )
                      : Row(
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
                      widget.order.shippingAddress.isNotEmpty
                          ? widget.order.shippingAddress
                          : 'orders.no_address'.tr(),
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
                      widget.order.phone.isNotEmpty
                          ? widget.order.phone
                          : 'orders.no_phone'.tr(),
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
          isCompleted: false,
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
    final color = isActive ? AppColors.primary : AppColors.textHint;

    return Column(
      children: [
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 600),
          curve: Curves.elasticOut,
          tween: Tween(begin: 0.8, end: isActive ? 1.0 : 0.8),
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                width: 48.r,
                height: 48.r,
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.primary.withOpacity(0.05)
                      : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: isActive ? 2 : 1),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.2),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: isCompleted
                        ? Icon(
                            Icons.check,
                            key: const ValueKey('check'),
                            color: AppColors.primary,
                            size: 24.sp,
                          )
                        : Icon(
                            icon,
                            key: const ValueKey('icon'),
                            color: color,
                            size: 24.sp,
                          ),
                  ),
                ),
              ),
            );
          },
        ),
        AppSpacing.h8,
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 300),
          style: AppTextStyles.bodySmall.copyWith(
            color: color,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 10.sp,
          ),
          child: Text(title),
        ),
      ],
    );
  }

  Widget _buildTrackingLine({required bool isActive}) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(bottom: 24.h), // Align with icons
        child: Stack(
          children: [
            Container(height: 2.h, color: AppColors.textHint.withOpacity(0.2)),
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOut,
              tween: Tween(begin: 0.0, end: isActive ? 1.0 : 0.0),
              builder: (context, value, child) {
                return FractionallySizedBox(
                  widthFactor: value,
                  child: Container(height: 2.h, color: AppColors.primary),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
