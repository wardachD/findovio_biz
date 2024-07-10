import 'package:findovio_business/screens/main_menu/main_screen_placeholder/placeholder_dashboard_tile_action_widget.dart';
import 'package:flutter/material.dart';

class PlaceholderDashboardTileListScreen extends StatelessWidget {
  const PlaceholderDashboardTileListScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          width: MediaQuery.sizeOf(context).width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              PlaceholderDashboardTileActionWidget(
                width: MediaQuery.sizeOf(context).width,
                height: 120,
                title: 'Zarobione w tym miesiącu',
                imagePath: 'assets/images/grads/dashboard_money_bg.webp',
                fontDescriptionSize: 28,
                fontColor: Colors.white,
                description: '',
                onTap: () {},
                color: const Color.fromARGB(255, 12, 12, 12),
                buttonColor: const Color.fromARGB(255, 255, 255, 255),
                iconColor: const Color.fromARGB(255, 12, 12, 12),
              ),
              const SizedBox(height: 12),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PlaceholderDashboardTileActionWidget(
                    title: 'Najbliższe wizyty',
                    description: '',
                    iconFile: Icons.calendar_month_outlined,
                    color: Color.fromARGB(255, 255, 255, 255),
                    buttonColor: Color.fromARGB(255, 202, 202, 202),
                  ),
                  PlaceholderDashboardTileActionWidget(
                    title: 'Potwierdź',
                    description: '',
                    iconFile: Icons.edit_calendar_outlined,
                    color: Color.fromARGB(255, 255, 255, 255),
                    buttonColor: Color.fromARGB(255, 202, 202, 202),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
