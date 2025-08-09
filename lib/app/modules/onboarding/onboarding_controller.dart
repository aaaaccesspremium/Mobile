import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sofomcloud_mobile/app/modules/onboarding/onboarding_provider.dart';
import '../../routes/app_routes.dart';
import 'package:uuid/uuid.dart';

class OnboardingController extends GetxController {
  final OnboardingProvider onboardingProvider = Get.find<OnboardingProvider>();
  final currentIndex = 0.obs;
  final box = GetStorage();
  final onboardingSlides = <Map<String, dynamic>>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    try {
      final slides = await onboardingProvider.messages();
      if (slides != null && slides.isNotEmpty) {
        onboardingSlides.assignAll(slides);
      } else {
        finishOnboarding();
      }
    } catch (e) {
      Get.snackbar('Error', 'No se pudieron cargar los mensajes');
      finishOnboarding();
    }
  }

  void nextSlide() {
    if (currentIndex.value < onboardingSlides.length - 1) {
      currentIndex.value++;
    } else {
      finishOnboarding();
    }
  }

  void finishOnboarding() {
    box.write('onboardingCompleted', true);
    if (validateRegister()) {
      Get.offNamed(AppRoutes.login);
    } else {
      Get.offNamed(AppRoutes.register);
    }
  }

  bool validateRegister() {
    final storage = GetStorage();
    final uuid = Uuid();

    String? storedUUID = storage.read('app_uuid');
    if (storedUUID != null) {
      onboardingProvider.validateUuid(storedUUID);
      return true;
    }

    String newUUID = uuid.v4();
    storage.write('app_uuid', newUUID);

    return false;
  }
}
