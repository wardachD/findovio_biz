import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';

class DashboardCalendarWidget extends StatelessWidget {
  const DashboardCalendarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 420,
      width: 420,
      child: CalendarControllerProvider(
        controller: EventController(),
        child: WeekView(),
      ),
    );
  }
}
