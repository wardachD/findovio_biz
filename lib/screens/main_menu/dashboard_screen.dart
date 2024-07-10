import 'package:findovio_business/screens/main_menu/widgets/dashboard_title_widget.dart';
import 'package:flutter/material.dart';
import 'widgets/dashboard_tile_list.dart';
import 'widgets/dashboard_weekly_tasks_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DashboardTitleWidget(),
        DashboardTileList(),
        DashboardWeeklyTasksWidget()
      ],
    );
  }
}
