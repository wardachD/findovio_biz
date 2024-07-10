import 'package:findovio_business/screens/main_menu/main_screen_placeholder/container_placeholder.dart';
import 'package:flutter/material.dart';

class PlaceholderDashboardTitleWidget extends StatelessWidget {
  const PlaceholderDashboardTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 223, 222, 222),
              blurRadius: 12,
              offset: Offset(0, 12),
            )
          ]),
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8),
      margin: EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: const ContainerPlaceholder(height: 45, width: 45),
                ),
                const SizedBox(width: 12),
                const ContainerPlaceholder(height: 20, width: 80),
                const SizedBox(width: 12),
                IconButton(onPressed: () {}, icon: Icon(Icons.logout_outlined)),
              ],
            ),
          ),
          SizedBox(
            height: 12,
          )
        ],
      ),
    );
  }
}
