import 'package:findovio_business/screens/intro/register/screens/widgets/custom_back_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/appointment_model.dart';

class WalletDetailsScreen extends StatefulWidget {
  final List<AppointmentModel> appointments;
  final int selectedMonth;

  const WalletDetailsScreen({
    super.key,
    required this.appointments,
    required this.selectedMonth,
  });

  @override
  State<WalletDetailsScreen> createState() => _WalletDetailsScreenState();
}

class _WalletDetailsScreenState extends State<WalletDetailsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _sortOrder = 'cenie_rosnąco';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String numberToMonth = widget.selectedMonth < 10
        ? '0${widget.selectedMonth}'
        : widget.selectedMonth.toString();
    DateTime parsedSelectedMonth = DateTime.parse('2024-$numberToMonth-01');

    List<AppointmentModel> filteredAppointments =
        widget.appointments.where((appointment) {
      if (appointment.dateOfBooking == null) return false;
      DateTime appointmentDate =
          DateFormat('yyyy-MM-dd').parse(appointment.dateOfBooking!);
      bool matchesMonth = appointmentDate.year == parsedSelectedMonth.year &&
          appointmentDate.month == parsedSelectedMonth.month;

      bool matchesSearchQuery = _searchQuery.isEmpty ||
          (appointment.customerObject?.firebaseName != null &&
              appointment.customerObject!.firebaseName
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase())) ||
          (appointment.services != null &&
              appointment.services!.any((service) => service.title!
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase())));

      return matchesMonth && matchesSearchQuery;
    }).toList();

    // Sorting the filtered appointments
    if (_sortOrder == 'cenie_rosnąco') {
      filteredAppointments.sort((a, b) => (double.parse(a.totalAmount!))
          .compareTo((double.parse(b.totalAmount!))));
    } else if (_sortOrder == 'cenie_malejąco') {
      filteredAppointments.sort((a, b) => (double.parse(b.totalAmount!))
          .compareTo((double.parse(a.totalAmount!))));
    } else if (_sortOrder == 'ilości_usług_rosnąco') {
      filteredAppointments.sort((a, b) =>
          (a.services?.length ?? 0).compareTo(b.services?.length ?? 0));
    } else if (_sortOrder == 'ilości_usług_malejąco') {
      filteredAppointments.sort((a, b) =>
          (b.services?.length ?? 0).compareTo(a.services?.length ?? 0));
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
                padding: const EdgeInsets.only(left: 12, top: 12),
                width: MediaQuery.sizeOf(context).width,
                child: Row(
                  children: [
                    const CustomBackButton(),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      "Przeglądaj wizyty: ${DateFormat.MMMM('pl_PL').format(parsedSelectedMonth)}",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ],
                )),
            const Divider(
              color: Color.fromARGB(255, 243, 243, 243),
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: 'Szukaj klienta lub usługę',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: DropdownButton<String>(
                value: _sortOrder,
                icon: const Icon(Icons.sort_outlined),
                onChanged: (String? newValue) {
                  setState(() {
                    _sortOrder = newValue!;
                  });
                },
                items: <String>[
                  'cenie_rosnąco',
                  'cenie_malejąco',
                  'ilości_usług_rosnąco',
                  'ilości_usług_malejąco'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text('Sortuj po: ${value.replaceAll('_', ' ')}'),
                  );
                }).toList(),
              ),
            ),
            Expanded(
              child: filteredAppointments.isEmpty
                  ? const Center(child: Text('No appointments for this month.'))
                  : ListView.builder(
                      itemCount: filteredAppointments.length,
                      itemBuilder: (context, index) {
                        AppointmentModel appointment =
                            filteredAppointments[index];
                        String servicesToPolish =
                            appointment.services != null &&
                                    appointment.services!.isNotEmpty
                                ? appointment.services!.length == 1
                                    ? 'usługa'
                                    : 'usługi'
                                : 'Brak usług';
                        List<Widget> servicesList = appointment.services!
                            .where((service) =>
                                _searchQuery.isEmpty ||
                                service.title!
                                    .toLowerCase()
                                    .contains(_searchQuery.toLowerCase()))
                            .map((service) => ListTile(
                                  title: Text(service.title ?? ''),
                                ))
                            .toList();

                        return ExpansionTile(
                          leading: const Icon(Icons.expand_more),
                          title: Text(
                              appointment.customerObject?.firebaseName ??
                                  'Nieznany klient'),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                appointment.dateOfBooking != null
                                    ? appointment.dateOfBooking!.substring(5)
                                    : 'Brak nazwy',
                                style: const TextStyle(fontSize: 12),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 2),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: appointment.status == 'C'
                                        ? Colors.green
                                        : appointment.status == 'X'
                                            ? Colors.red
                                            : Colors.black),
                                child: Text(
                                  appointment.status == 'C'
                                      ? 'Potwierdzona'
                                      : appointment.status == 'X'
                                          ? 'Anulowana'
                                          : 'Zakończona',
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.white),
                                ),
                              )
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '€ ${appointment.totalAmount ?? 'Brak ceny'}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                  '${appointment.services?.length ?? 0} $servicesToPolish')
                            ],
                          ),
                          children: servicesList,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
