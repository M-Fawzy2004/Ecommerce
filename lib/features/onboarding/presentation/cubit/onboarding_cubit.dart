import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/onboarding_model.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(OnboardingInitial());

  final List<OnboardingModel> onboardingPages = [
    const OnboardingModel(
      image: 'assets/lottie/onborading_1.json',
      title: 'onboarding.title1',
      description: 'onboarding.desc1',
    ),
    const OnboardingModel(
      image: 'assets/lottie/onborading_3.json',
      title: 'onboarding.title2',
      description: 'onboarding.desc2',
    ),
    const OnboardingModel(
      image: 'assets/lottie/onborading_2.json',
      title: 'onboarding.title3',
      description: 'onboarding.desc3',
    ),
  ];

  int currentIndex = 0;

  void updateIndex(int index) {
    currentIndex = index;
    emit(OnboardingPageChanged(index));
  }
}
