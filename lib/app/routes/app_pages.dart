import 'package:get/get.dart';

import '../modules/auth/auth_binding.dart';
import '../modules/auth/login/login_view.dart';
import '../modules/auth/register/register_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/loan_capture/bindings/loan_capture_binding.dart';
import '../modules/loan_capture/views/loan_capture_camera_view.dart';
import '../modules/loan_capture/views/loan_capture_view.dart';
import '../modules/onboarding/onboarding_binding.dart';
import '../modules/onboarding/onboarding_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = <GetPage<dynamic>>[
    GetPage(
      name: AppRoutes.initial,
      page: () => OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => RegisterView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.loanCapture,
      page: () => const LoanCaptureView(),
      binding: LoanCaptureBinding(),
      fullscreenDialog: true,
      transition: Transition.cupertino,
    ),
    GetPage(
      name: AppRoutes.loanCaptureCamera,
      page: () => const LoanCaptureCameraView(),
      transition: Transition.fadeIn,
    ),
  ];
}
