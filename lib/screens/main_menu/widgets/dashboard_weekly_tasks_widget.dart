import 'package:findovio_business/provider/salon_provider/get_salon_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardWeeklyTasksWidget extends StatelessWidget {
  const DashboardWeeklyTasksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final salonProvider = Provider.of<GetSalonProvider>(context);
// Pobranie danych dotyczących wizyt i dni tygodnia
    final appointments = salonProvider.appointments ?? [];
    final appointmentCounts =
        salonProvider.getAppointmentCountsPerDay(appointments);
    final weekdayNames = salonProvider.getShortWeekdayNames();

    const Color chartBgColor = Color.fromARGB(255, 238, 238, 238);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(255, 245, 245, 245),
              blurRadius: 8,
            )
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Tytuł
          Container(
            width: MediaQuery.sizeOf(context).width,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            margin: const EdgeInsets.fromLTRB(6, 0, 0, 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Na ten tydzień',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.subdirectory_arrow_right,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Box z dniami tygodnia
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
                color: chartBgColor, borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                7,
                (index) => Column(
                  children: [
                    SizedBox(
                      width: (MediaQuery.sizeOf(context).width * 0.85) / 7 - 6,
                      child: Column(
                        children: [
                          Text(
                            weekdayNames[index],
                            style: TextStyle(
                                color: appointmentCounts[index] > 0
                                    ? const Color.fromARGB(255, 14, 14, 14)
                                    : Colors.grey,
                                fontSize: 14,
                                fontWeight: appointmentCounts[index] > 0
                                    ? FontWeight.w600
                                    : null),
                          ),
                          Text(
                            appointmentCounts[index].toString(),
                            style: TextStyle(
                              color: appointmentCounts[index] > 0
                                  ? const Color.fromARGB(255, 14, 14, 14)
                                  : Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Box z wykresem
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            padding: const EdgeInsets.symmetric(vertical: 12),
            width: MediaQuery.sizeOf(context).width * 0.9,
            decoration: BoxDecoration(
                color: chartBgColor, borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                7,
                (index) => AppointmentColumnWidget(
                    appointmentCount: appointmentCounts[index]),
              ),
            ),
          ),

          // Legenda
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(6)),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    const Text(
                      'Wolne',
                      style: TextStyle(),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 111, 185, 255),
                          borderRadius: BorderRadius.circular(6)),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    const Text(
                      'Zajęty',
                      style: TextStyle(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AppointmentColumnWidget extends StatelessWidget {
  final int appointmentCount;

  const AppointmentColumnWidget({super.key, required this.appointmentCount});

  @override
  Widget build(BuildContext context) {
    const Color emptyDayColor = Color.fromARGB(255, 248, 248, 248);
    const Color appointmentDayColor = Color.fromARGB(255, 111, 185, 255);

    return SizedBox(
      width: (MediaQuery.sizeOf(context).width * 0.9) / 7 - 6,
      height: MediaQuery.sizeOf(context).height * 0.15,
      child: Column(
        children: List.generate(
          appointmentCount == 0 ? 1 : appointmentCount,
          (index) {
            return Expanded(
              flex: appointmentCount == 0 ? 1 : appointmentCount,
              child: Container(
                width: 12,
                decoration: BoxDecoration(
                  color: appointmentCount == 0
                      ? emptyDayColor
                      : appointmentDayColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.symmetric(vertical: 2),
              ),
            );
          },
        ),
      ),
    );
  }
}
