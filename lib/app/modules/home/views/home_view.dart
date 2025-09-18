import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../widgets/home_main_content.dart';
import '../widgets/home_make_payment_content.dart';
import '../widgets/home_payments_content.dart';
import '../widgets/home_profile_content.dart';
import '../widgets/home_request_loan_content.dart';
import '../widgets/home_transfer_content.dart';
import '../widgets/home_header.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          switch (controller.currentIndex.value) {
            case 0:
              return Column(
                children: [
                  HomeHeader(
                    userName: 'Jazmín',
                    subtitle: 'Bienvenida de nuevo',
                    avatarUrl: 'https://i.pravatar.cc/150?img=11',
                    onNotificationTap: () {},
                  ),
                  Expanded(
                    child: HomeMainContent(controller: controller),
                  ),
                ],
              );
            case 1:
              return HomePaymentsContent(controller: controller);
            case 2:
              return HomeTransferContent(controller: controller);
            case 3:
              return HomeProfileContent(controller: controller);
            case 10:
              return HomeMakePaymentContent(controller: controller);
            case 11:
              return HomeRequestLoanContent(controller: controller);
            default:
              return HomeMainContent(controller: controller);
          }
        }),
      ),
      bottomNavigationBar: Obx(
        () => NavigationBar(
          selectedIndex: controller.currentIndex.value > 3
              ? 0
              : controller.currentIndex.value,
          onDestinationSelected: controller.changeTab,
          destinations: const [
            NavigationDestination(
              icon: FaIcon(FontAwesomeIcons.house),
              label: 'Inicio',
            ),
            NavigationDestination(
              icon: FaIcon(FontAwesomeIcons.receipt),
              label: 'Pagos',
            ),
            NavigationDestination(
              icon: FaIcon(FontAwesomeIcons.moneyBillTransfer),
              label: 'Transferir',
            ),
            NavigationDestination(
              icon: FaIcon(FontAwesomeIcons.idCard),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }
}
