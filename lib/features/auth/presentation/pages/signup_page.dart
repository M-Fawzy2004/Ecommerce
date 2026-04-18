import 'package:ecommerce_app/core/di/init_dependencies.dart';
import 'package:ecommerce_app/core/widgets/double_back_to_exit_wrapper.dart';
import 'package:ecommerce_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'signup_page_body.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (_) => serviceLocator<AuthCubit>(),
      child: DoubleBackToExitWrapper(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: const SignupPageBody(),
            ),
          ),
        ),
      ),
    );
  }
}
