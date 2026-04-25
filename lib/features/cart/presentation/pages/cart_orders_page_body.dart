import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/theme/app_text_styles.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:ecommerce_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:ecommerce_app/features/cart/presentation/widgets/cart_item_card.dart';
import 'package:ecommerce_app/features/cart/presentation/widgets/cart_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:ecommerce_app/features/cart/presentation/widgets/order_list_item.dart';

class CartOrdersPageBody extends StatelessWidget {
  const CartOrdersPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              children: [_buildCartView(context), _buildOrdersView()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.all(16.r),
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: AppColors.gray,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4),
          ],
        ),
        labelColor: AppColors.textPrimary,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: AppTextStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: AppTextStyles.bodyMedium,
        dividerColor: Colors.transparent,
        tabs: [
          Tab(text: 'cart.title'.tr()),
          Tab(text: 'cart.orders'.tr()),
        ],
      ),
    );
  }

  Widget _buildCartView(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              if (state.items.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 80.sp,
                        color: AppColors.textHint,
                      ),
                      AppSpacing.h16,
                      Text('cart.empty'.tr(), style: AppTextStyles.bodyLarge),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: state.items.length,
                itemBuilder: (context, index) {
                  final item = state.items[index];
                  return Dismissible(
                    key: Key(item.product.id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      context.read<CartCubit>().removeItem(item.product.id);
                    },
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 20.w),
                      margin: EdgeInsets.only(bottom: 16.h),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                        size: 24.sp,
                      ),
                    ),
                    child: CartItemCard(item: item),
                  );
                },
              );
            },
          ),
        ),
        const CartSummary(),
      ],
    );
  }

  Widget _buildOrdersView() {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      return const Center(child: Text('Please log in to view orders.'));
    }

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: Supabase.instance.client
          .from('orders')
          .stream(primaryKey: ['id'])
          .eq('user_id', userId)
          .order('created_at', ascending: false),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Skeletonizer(
            enabled: true,
            child: ListView.builder(
              padding: EdgeInsets.all(16.r),
              itemCount: 4,
              itemBuilder: (context, index) {
                return OrderListItem(
                  order: {
                    'order_code': 'SKELETON123',
                    'status': 'pending',
                    'created_at': DateTime.now().toIso8601String(),
                    'total_amount': 999.99,
                    'items': const [
                      {'name': 'Skeleton Product', 'quantity': 1},
                    ],
                  },
                );
              },
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error loading orders: ${snapshot.error}'));
        }

        final orders = snapshot.data;

        if (orders == null || orders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.assignment_outlined,
                  size: 80.sp,
                  color: AppColors.textHint,
                ),
                AppSpacing.h16,
                Text('cart.no_orders'.tr(), style: AppTextStyles.bodyLarge),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(16.r),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            return OrderListItem(order: orders[index]);
          },
        );
      },
    );
  }
}
