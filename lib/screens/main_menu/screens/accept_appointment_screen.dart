import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:findovio_business/models/appointment_model.dart';
import 'package:findovio_business/provider/salon_provider/get_salon_provider.dart';

import '../widgets/accept_appointment_widgets/accept_appointment_widget.dart';
import '../widgets/accept_appointment_widgets/go_back_arrow_widget.dart';

class AcceptAppointmentScreen extends StatefulWidget {
  const AcceptAppointmentScreen({super.key});

  @override
  _AcceptAppointmentScreenState createState() =>
      _AcceptAppointmentScreenState();
}

class _AcceptAppointmentScreenState extends State<AcceptAppointmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const GoBackArrowWiget(
              text: 'Potwierdź wizyty',
            ),
            Expanded(
              child: Consumer<GetSalonProvider>(
                builder: (context, salonProvider, _) {
                  if (salonProvider.appointments == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (salonProvider.appointments!.isEmpty) {
                    return const Center(
                      child: Text('Brak umówionych spotkań.'),
                    );
                  } else {
                    // Filtrujemy tylko spotkania o statusie "P"
                    final now = DateTime.now();
                    final fifteenMinutesBeforeNow =
                        now.subtract(const Duration(minutes: 15));

                    final pendingAppointments = salonProvider.appointments!
                        .where((appointment) =>
                            appointment.status == "P" &&
                            DateTime.parse(appointment.dateOfBooking!)
                                .isAfter(fifteenMinutesBeforeNow))
                        .toList();

// Grupowanie spotkań po dniach
                    Map<DateTime, List<AppointmentModel>> groupedAppointments =
                        {};
                    for (var appointment in pendingAppointments) {
                      DateTime date =
                          DateTime.parse(appointment.dateOfBooking!);
                      groupedAppointments
                          .putIfAbsent(date, () => [])
                          .add(appointment);
                    }

// Sortowanie dat
                    List<DateTime> sortedDates = groupedAppointments.keys
                        .toList()
                      ..sort((a, b) => a.compareTo(b));

                    // Tworzenie listy widgetów dla każdej daty
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: sortedDates.length,
                      itemBuilder: (context, index) {
                        DateTime date = sortedDates[index];
                        List<AppointmentModel> appointmentsOnDate =
                            groupedAppointments[date]!;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          key: const Key('Appointment_Listview'),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                title: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color.fromARGB(34, 0, 0, 0),
                                          offset: Offset(0, 4),
                                          blurRadius: 6,
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      'Wizyty na ${_formatDate(date)}',
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Column(
                                  children: appointmentsOnDate
                                      .map((appointment) =>
                                          AcceptAppointmentWidget(
                                            appointment: appointment,
                                          ))
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    if (date.isToday) {
      return 'Dzisiaj';
    } else if (date.isTomorrow) {
      return 'Jutro';
    } else if (date.isAfter(DateTime.now()) &&
        date.difference(DateTime.now()).inDays <= 2) {
      return 'Pojutrze';
    } else {
      return '${date.day}.${date.month}.${date.year}';
    }
  }
}

extension DateTimeExtension on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }
}
