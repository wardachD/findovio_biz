import 'package:animate_gradient/animate_gradient.dart';
import 'package:flutter/material.dart';

class ContainerPlaceholder extends StatelessWidget {
  final double width;
  final double height;

  const ContainerPlaceholder({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: AnimateGradient(
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
            ]),
      ),
    );
  }
}
