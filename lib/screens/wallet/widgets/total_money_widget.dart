import 'package:findovio_business/provider/salon_provider/get_salon_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../models/appointment_model.dart';

class TotalMoneyWidget extends StatelessWidget {
  final bool chartType;
  const TotalMoneyWidget({super.key, required this.chartType});

  @override
  Widget build(BuildContext context) {
    return Consumer<GetSalonProvider>(
      builder: (context, dataProvider, _) {
        // Sprawdź, czy dane zostały wczytane
        if (dataProvider.appointments != null) {
          var endDate = DateTime.now();
          var startDate = chartType
              ? endDate.subtract(const Duration(days: 90))
              : endDate.subtract(const Duration(days: 7));
          var totalAmount = 0.0;
          var totalCanceledAmount = 0.0;
          if (dataProvider.appointments != null) {
            var tempAppointmentsListForCalculation = getAppointmentsInDateRange(
                dataProvider.appointments ?? [], startDate, endDate);

            for (var appointment in tempAppointmentsListForCalculation) {
              totalAmount += double.parse(appointment.totalAmount.toString());
              if (appointment.status == "X") {
                totalCanceledAmount +=
                    double.parse(appointment.totalAmount.toString());
              }
            }
          } else {
            return const Text('0');
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: 140,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: MediaQuery.sizeOf(context).width / 2 - 16,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      const BoxShadow(
                        color: Color.fromARGB(88, 0, 0, 0),
                        offset: Offset(0, 3),
                        blurRadius: 1,
                      )
                    ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Zarobiłeś',
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 22,
                            color: Color.fromARGB(255, 0, 0, 0))),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '€${totalAmount.toString()}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 32,
                              color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                        Text(
                          '€${(totalAmount * 0.36).floor().toString()} Podatku',
                          style: const TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 16,
                              color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                height: 140,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: MediaQuery.sizeOf(context).width / 2 - 16,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Anulowane',
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 22,
                            color: Color.fromARGB(255, 255, 255, 255))),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '€${totalCanceledAmount.toString()}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 32,
                              color: Color.fromARGB(255, 255, 255, 255)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
          // return Text(totalAmount.toString());
        } else {
          // Jeśli dane nie zostały jeszcze pobrane, pobierz je
          // Wyświetl informację o wczytywaniu danych
          return const CircularProgressIndicator();
        }
      },
    );
  }

  List<AppointmentModel> getAppointmentsInDateRange(
      List<AppointmentModel> appointments,
      DateTime startDate,
      DateTime endDate) {
    return appointments.where((appointment) {
      // Parsuj datę rezerwacji
      DateTime appointmentDate = parseDate(appointment.dateOfBooking!);
      // Sprawdź, czy data rezerwacji mieści się w zakresie dat
      return appointmentDate.isAfter(startDate) &&
          appointmentDate.isBefore(endDate);
    }).toList();
  }

  DateTime parseDate(String dateString) {
    return DateFormat('yyyy-MM-dd').parse(dateString);
  }
}
