import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/theme/app_text_styles.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:ecommerce_app/core/widgets/app_button.dart';
import 'package:ecommerce_app/core/widgets/app_text_field.dart';
import 'package:ecommerce_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:ecommerce_app/core/router/app_router.dart';
import 'package:ecommerce_app/features/checkout/presentation/cubit/checkout_state.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/order_item_entity.dart';
import '../cubit/checkout_cubit.dart';
import 'payment_webview_page.dart';
import 'payment_success_page.dart';
import 'invoice_page.dart';
import '../../../../features/cart/presentation/pages/address_picker_page.dart';
import 'package:latlong2/latlong.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/ui/toast/app_toast.dart';
import '../widgets/checkout_order_summary.dart';
import '../widgets/checkout_payment_methods.dart';

class CheckoutPageBody extends StatefulWidget {
  const CheckoutPageBody({super.key});

  @override
  State<CheckoutPageBody> createState() => _CheckoutPageBodyState();
}

class _CheckoutPageBodyState extends State<CheckoutPageBody> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();
    String firstName = '';
    String lastName = '';
    String email = '';
    String phone = '';

    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      email = user.email ?? '';
      phone = user.phone ?? '';
      final fullName = user.userMetadata?['full_name'] as String? ?? '';
      final names = fullName.split(' ');
      if (names.isNotEmpty && names[0].isNotEmpty) firstName = names[0];
      if (names.length > 1) lastName = names.sublist(1).join(' ');
    }

    final cartState = context.read<CartCubit>().state;

    _firstNameController = TextEditingController(text: firstName);
    _lastNameController = TextEditingController(text: lastName);
    _emailController = TextEditingController(text: email);
    _phoneController = TextEditingController(text: phone);
    _addressController = TextEditingController(text: cartState.shippingAddress);
    if (cartState.latitude != null && cartState.longitude != null) {
      _selectedLocation = LatLng(cartState.latitude!, cartState.longitude!);
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckoutCubit, CheckoutState>(
      listener: (context, state) {
        if (state is PaymentProcessing) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PaymentWebViewPage(
                paymentKey: state.paymentKey,
                onSuccess: () =>
                    context.read<CheckoutCubit>().onPaymentSuccess(),
                onFailure: (msg) {
                  AppToast.error(context, message: msg);
                  Navigator.pop(context);
                },
              ),
            ),
          );
        } else if (state is PaymentFailure) {
          AppToast.error(context, message: state.message);
        } else if (state is OrderConfirmed) {
          AppToast.success(context, message: 'invoice.order_confirmed'.tr());
          context.read<CartCubit>().clearCart();
          context.go(AppRouter.cartOrders);
        }
      },
      builder: (context, state) {
        final checkoutCubit = context.read<CheckoutCubit>();

        if (state is PaymentSuccess) {
          return PaymentSuccessPage(
            order: state.order,
            onViewDetails: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: checkoutCubit,
                    child: InvoicePage(
                      order: state.order,
                      onConfirm: () => checkoutCubit.confirmOrder(),
                    ),
                  ),
                ),
              );
            },
          );
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text('checkout.title'.tr()),
            backgroundColor: Colors.white,
            foregroundColor: AppColors.textPrimary,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: BlocBuilder<CartCubit, CartState>(
            builder: (context, cartState) {
              return SingleChildScrollView(
                padding: EdgeInsets.all(20.r),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CheckoutOrderSummary(cartState: cartState),
                      AppSpacing.h24,
                      Text(
                        'checkout.customer_shipping_info'.tr(),
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AppSpacing.h16,
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              controller: _firstNameController,
                              hintText: 'checkout.first_name'.tr(),
                              validator: (v) =>
                                  v!.isEmpty ? 'checkout.required'.tr() : null,
                            ),
                          ),
                          AppSpacing.w12,
                          Expanded(
                            child: AppTextField(
                              controller: _lastNameController,
                              hintText: 'checkout.last_name'.tr(),
                              validator: (v) =>
                                  v!.isEmpty ? 'checkout.required'.tr() : null,
                            ),
                          ),
                        ],
                      ),
                      AppSpacing.h12,
                      AppTextField(
                        controller: _emailController,
                        hintText: 'checkout.email'.tr(),
                        validator: (v) =>
                            v!.isEmpty ? 'checkout.required'.tr() : null,
                      ),
                      AppSpacing.h12,
                      AppTextField(
                        controller: _phoneController,
                        hintText: 'checkout.phone'.tr(),
                        validator: (v) =>
                            v!.isEmpty ? 'checkout.required'.tr() : null,
                      ),
                      AppSpacing.h12,
                      AppTextField(
                        controller: _addressController,
                        hintText: 'checkout.shipping_address'.tr(),
                        validator: (v) =>
                            v!.isEmpty ? 'checkout.required'.tr() : null,
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.location_on,
                            color: AppColors.primary,
                          ),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AddressPickerPage(),
                              ),
                            );

                            if (result != null &&
                                result is Map<String, dynamic>) {
                              final loc = result['location'] as LatLng;
                              final addr = result['address'] as String;

                              setState(() {
                                _addressController.text = addr;
                                _selectedLocation = loc;
                              });

                              // ignore: use_build_context_synchronously
                              context.read<CartCubit>().updateAddress(
                                lat: loc.latitude,
                                lng: loc.longitude,
                                address: addr,
                              );
                            }
                          },
                        ),
                      ),
                      AppSpacing.h24,
                      CheckoutPaymentMethods(cartState: cartState),
                      AppSpacing.h32,

                      Builder(
                        builder: (context) {
                          final isCod =
                              cartState.selectedPaymentMethod.toLowerCase() ==
                                  'cash' ||
                              cartState.selectedPaymentMethod.toLowerCase() ==
                                  'cod';
                          return AppButton(
                            text: isCod
                                ? 'checkout.place_order_cash'.tr(
                                    namedArgs: {
                                      'total': cartState.total.toStringAsFixed(
                                        2,
                                      ),
                                    },
                                  )
                                : 'checkout.pay_mastercard'.tr(
                                    namedArgs: {
                                      'total': cartState.total.toStringAsFixed(
                                        2,
                                      ),
                                    },
                                  ),
                            isLoading: state is CheckoutLoading,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                final items = cartState.items
                                    .where((item) => item.isSelected)
                                    .map(
                                      (item) => OrderItemEntity(
                                        productId: item.product.id,
                                        name: item.product.name,
                                        quantity: item.quantity,
                                        price: item.product.price,
                                      ),
                                    )
                                    .toList();

                                final user =
                                    Supabase.instance.client.auth.currentUser;
                                final userId = user?.id ?? 'anonymous';

                                checkoutCubit.startCheckout(
                                  userId: userId,
                                  items: items,
                                  totalAmount: cartState.total,
                                  firstName: _firstNameController.text,
                                  lastName: _lastNameController.text,
                                  email: _emailController.text,
                                  phone: _phoneController.text,
                                  paymentMethod:
                                      cartState.selectedPaymentMethod,
                                  shippingAddress: _addressController.text,
                                  latitude: _selectedLocation?.latitude,
                                  longitude: _selectedLocation?.longitude,
                                );
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
