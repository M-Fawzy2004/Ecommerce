import 'package:ecommerce_app/core/di/init_dependencies.dart';
import 'package:ecommerce_app/core/router/app_router.dart';
import 'package:ecommerce_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ecommerce_app/core/widgets/double_back_to_exit_wrapper.dart';
import 'package:flutter/material.dart';
import 'profile_page_body.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<AuthCubit>(),
      child: DoubleBackToExitWrapper(
        child: Scaffold(
          body: BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthInitial) {
                context.go(AppRouter.login);
              }
            },
            child: const SafeArea(
              child: ProfilePageBody(),
            ),
          ),
        ),
      ),
    );
  }
}
