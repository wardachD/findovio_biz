import 'package:findovio_business/screens/main_menu/create_salon_screen/create_salon_screen.dart';
import 'package:findovio_business/screens/main_menu/pulpit_screen/pulpit_screen.dart';
import 'package:findovio_business/screens/main_menu/screens/pulpit_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ErrorScreen extends StatelessWidget {
  final String pageName;
  const ErrorScreen({super.key, required this.pageName});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      switch (pageName) {
        case 'salon_not_created':
          Get.off(
              () => const Scaffold(body: SafeArea(child: CreateSalonScreen())));
        case 'salon_not_finished':
          Get.off(() => const Scaffold(
              body: SafeArea(
                  child: SingleChildScrollView(child: PulpitScreen()))));
        default:
          Get.off(() => const Scaffold(
              body: SafeArea(child: PulpitUser(isSalonListEmpty: true))));
      }
    });
    return const SizedBox();
  }
}
