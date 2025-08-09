import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'onboarding_controller.dart';

class OnboardingView extends StatelessWidget {
  final controller = Get.find<OnboardingController>();

  OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Obx(() {
        if (controller.onboardingSlides.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final slide = controller.onboardingSlides[controller.currentIndex.value];

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
  height: 120,
  child: slide['lottie'] != null && slide['lottie'].toString().isNotEmpty
      ? Lottie.network(
          slide['lottie'],
          fit: BoxFit.contain,
          frameRate: FrameRate.max,
          onLoaded: (composition) {
            // Opcional: puedes hacer algo al cargar
          },
          errorBuilder: (context, error, stackTrace) {
            return const Center(child: Text('Error al cargar animación'));
          },
        )
      : const SizedBox.shrink(),
),
              const SizedBox(height: 20),
              Text(
                slide['title'],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                slide['description'],
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  controller.onboardingSlides.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: controller.currentIndex.value == index
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : Theme.of(context).colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  if (controller.currentIndex.value <
                      controller.onboardingSlides.length - 1) {
                    controller.nextSlide();
                  } else {
                    controller.finishOnboarding();
                  }
                },
                child: Text(
                  controller.currentIndex.value <
                          controller.onboardingSlides.length - 1
                      ? 'Siguiente'
                      : 'Comenzar',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
