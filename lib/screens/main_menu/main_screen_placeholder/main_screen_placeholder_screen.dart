import 'package:findovio_business/screens/main_menu/main_screen_placeholder/placeholder_dashboard_tile_list_screen.dart';
import 'package:findovio_business/screens/main_menu/main_screen_placeholder/placeholder_dashboard_weekly_tasks_widget.dart';
import 'package:flutter/material.dart';
import 'placeholder_dashboard_title_widget.dart';

class MainScreenPlaceholderScreen extends StatelessWidget {
  const MainScreenPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PlaceholderDashboardTitleWidget(),
        PlaceholderDashboardTileListScreen(),
        PlaceholderDashboardWeeklyTasksWidget()
      ],
    );
  }
}
