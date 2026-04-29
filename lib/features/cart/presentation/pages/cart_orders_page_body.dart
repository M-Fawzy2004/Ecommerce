import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/theme/app_text_styles.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:ecommerce_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:ecommerce_app/features/cart/presentation/widgets/cart_item_card.dart';
import 'package:ecommerce_app/features/cart/presentation/widgets/cart_summary.dart';
import 'package:ecommerce_app/features/checkout/domain/entities/order_entity.dart';
import 'package:ecommerce_app/features/checkout/presentation/cubit/orders_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:ecommerce_app/features/cart/presentation/widgets/order_list_item.dart';

class CartOrdersPageBody extends StatefulWidget {
  const CartOrdersPageBody({super.key});

  @override
  State<CartOrdersPageBody> createState() => _CartOrdersPageBodyState();
}

class _CartOrdersPageBodyState extends State<CartOrdersPageBody> {
  String? _userId;

  @override
  void initState() {
    super.initState();
    _userId = Supabase.instance.client.auth.currentUser?.id;
    if (_userId != null) {
      context.read<OrdersCubit>().watchOrders(_userId!);
    }
  }

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
    if (_userId == null) {
      return const Center(child: Text('Please log in to view orders.'));
    }

    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        if (state is OrdersLoading) {
          return Skeletonizer(
            enabled: true,
            child: ListView.builder(
              padding: EdgeInsets.all(16.r),
              itemCount: 4,
              itemBuilder: (context, index) {
                return OrderListItem(
                  order: OrderEntity(
                    id: 'skeleton',
                    orderCode: 'SKELETON123',
                    userId: 'skeleton_user',
                    items: const [],
                    totalAmount: 999.99,
                    status: 'pending',
                    paymentMethod: 'cash',
                    createdAt: DateTime.now(),
                    shippingAddress: '',
                    phone: '',
                  ),
                );
              },
            ),
          );
        }

        if (state is OrdersError) {
          return Center(child: Text('Error loading orders: ${state.message}'));
        }

        if (state is OrdersLoaded) {
          if (state.orders.isEmpty) {
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
            itemCount: state.orders.length,
            itemBuilder: (context, index) {
              final order = state.orders[index];
              return OrderListItem(
                key: ValueKey('${order.id}_${order.status}'),
                order: order,
              );
            },
          );
        }

        return const SizedBox();
      },
    );
  }
}
