import 'package:ecommerce_app/core/di/init_dependencies.dart';
import 'package:ecommerce_app/core/widgets/double_back_to_exit_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/onboarding_cubit.dart';
import '../widgets/onboarding_page_body.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OnboardingCubit>(
      create: (context) => serviceLocator<OnboardingCubit>(),
      child: const DoubleBackToExitWrapper(
        child: Scaffold(
          body: OnboardingPageBody(),
        ),
      ),
    );
  }
}
