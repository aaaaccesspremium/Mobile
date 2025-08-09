import 'package:get/get.dart';
import '../modules/auth/auth_binding.dart';
import '../modules/auth/login/login_view.dart';
import '../modules/auth/register/register_view.dart';
import '../modules/onboarding/onboarding_binding.dart';
import '../modules/onboarding/onboarding_view.dart';
import '../modules/home/home_binding.dart';
import '../modules/home/home_view.dart';
import '../modules/loan_request/start_page.dart';
import '../modules/loan_request/capture_card_page.dart';
import '../modules/loan_request/capture_ine_front_page.dart';
import '../modules/loan_request/capture_ine_back_page.dart';
import '../modules/loan_request/capture_doc_page.dart';
import '../modules/loan_request/sign_page.dart';
import '../modules/loan_request/review_page.dart';
import '../routes/app_routes.dart';

class AppPages {
  static final routes = [
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
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.loanRequestStart,
      page: () => const LoanRequestStartPage(),
    ),
    GetPage(
      name: AppRoutes.loanCaptureCard,
      page: () => const CaptureCardPage(),
    ),
    GetPage(
      name: AppRoutes.loanCaptureIneFront,
      page: () => const CaptureIneFrontPage(),
    ),
    GetPage(
      name: AppRoutes.loanCaptureIneBack,
      page: () => const CaptureIneBackPage(),
    ),
    GetPage(
      name: AppRoutes.loanCaptureDoc,
      page: () => const CaptureDocPage(),
    ),
    GetPage(
      name: AppRoutes.loanSign,
      page: () => const SignPage(),
    ),
    GetPage(
      name: AppRoutes.loanReview,
      page: () => const ReviewPage(),
    ),
  ];
}
