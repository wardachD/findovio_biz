import 'dart:ui';

import 'package:findovio_business/screens/main_menu/pulpit_screen/screens/add_services_widgets/time_picker_widget.dart';
import 'package:flutter/material.dart';

class TimePickerPopup extends StatelessWidget {
  final TextEditingController controller;

  const TimePickerPopup({super.key, required this.controller});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color.fromARGB(167, 255, 255, 255),
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                  color: Color.fromARGB(255, 230, 230, 230), blurRadius: 12)
            ],
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            border:
                Border.all(color: const Color.fromARGB(255, 228, 228, 228))),
        height: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: TimePickerWidget(
                controller: controller,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
