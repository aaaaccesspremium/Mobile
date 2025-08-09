import 'package:get/get.dart';
import 'package:sofomcloud_mobile/app/modules/onboarding/onboarding_provider.dart';
import 'onboarding_controller.dart';

class OnboardingBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingProvider>(() => OnboardingProvider());
    Get.lazyPut(() => OnboardingController());
  }
}
