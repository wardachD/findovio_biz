import 'package:animate_gradient/animate_gradient.dart';
import 'package:flutter/material.dart';

class AnimatedPlaceholderBoxWithContraints extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  AnimatedPlaceholderBoxWithContraints({
    super.key,
    required this.width,
    required this.height,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    AnimateGradient animateGradient = AnimateGradient(
        duration: const Duration(milliseconds: 1200),
        primaryBegin: Alignment.centerRight,
        primaryEnd: Alignment.centerRight,
        secondaryBegin: Alignment.centerLeft,
        secondaryEnd: Alignment.centerLeft,
        primaryColors: const [
          Color.fromARGB(202, 255, 255, 255),
          Color.fromARGB(159, 238, 238, 238),
        ],
        secondaryColors: const [
          Color.fromARGB(159, 238, 238, 238),
          Color.fromARGB(202, 255, 255, 255),
        ]);

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        width: width,
        height: height,
        child: animateGradient,
      ),
    );
  }
}
