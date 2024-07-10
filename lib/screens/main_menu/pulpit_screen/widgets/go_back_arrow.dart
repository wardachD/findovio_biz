import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GoBackArrow extends StatelessWidget {
  const GoBackArrow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topLeft,
        height: 40,
        child: Material(
            child: InkWell(
          child: const Icon(Icons.arrow_back_ios_new),
          onTap: () => Get.back(),
        )));
  }
}
