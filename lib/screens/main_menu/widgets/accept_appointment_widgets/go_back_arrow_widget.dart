import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GoBackArrowWiget extends StatelessWidget {
  final String text;
  final Function()? onPressed;

  const GoBackArrowWiget({super.key, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        icon: const Icon(Icons.arrow_back),
        label: Text(
          text,
          style: const TextStyle(fontSize: 18),
        ),
        onPressed: onPressed ?? () => Get.back(),
      ),
    );
  }
}
