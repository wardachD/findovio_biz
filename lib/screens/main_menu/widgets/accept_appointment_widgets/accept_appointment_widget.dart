import 'package:findovio_business/screens/main_menu/widgets/animated_placeholder_box_with_constraints.dart';
import 'package:flutter/material.dart';
import 'package:findovio_business/models/appointment_model.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../provider/salon_provider/get_salon_provider.dart';
import '../alertdialog_loading.dart'; // Zaimportuj odpowiedni serwis

class AcceptAppointmentWidget extends StatefulWidget {
  final AppointmentModel appointment;

  const AcceptAppointmentWidget({super.key, required this.appointment});

  @override
  State<AcceptAppointmentWidget> createState() =>
      _AcceptAppointmentWidgetState();
}

class _AcceptAppointmentWidgetState extends State<AcceptAppointmentWidget> {
  bool _isLoading = false;
  bool _isButtonPressed = false;
  String _requestStatus = '';
  final String sendConfirmationButtonText = 'Potwierdź';
  final String sendRejectionButtonText = 'Odrzuć';

  @override
  Widget build(BuildContext context) {
    Provider.of<GetSalonProvider>(context, listen: false);
    final width = MediaQuery.sizeOf(context).width;
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(
        vertical: 16.0,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 235, 235, 235)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(255, 236, 236, 236),
            blurRadius: 8,
          )
        ],
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: !_isLoading
            ? Column(
                key: ValueKey<int>(DateTime.now().second),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.money),
                                const Text(' Do zapłaty: '),
                                Text(
                                  '€${widget.appointment.totalAmount ?? "Brak"}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            // Wyświetlanie godziny bookingu
                            Row(
                              children: [
                                const Icon(Icons.watch_later_outlined),
                                const Text(' Godzina: '),
                                Text(
                                  trimTimeFrom(widget
                                      .appointment.timeslots!.first.timeFrom),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: 26,
                          width: 120,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.orange)),
                          child: Text(
                            widget.appointment.status == 'P'
                                ? 'Oczekujące'
                                : 'Zakończone',
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),

                  // Wyświetlanie nazwy użytkownika (jeśli dostępna)
                  AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      key: const Key('title'),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          const Icon(Icons.man),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            key: const Key('title1'),
                            child: widget.appointment.customerObject == null
                                ? AnimatedPlaceholderBoxWithContraints(
                                    width: 110, height: 26, radius: 12)
                                : Row(
                                    children: [
                                      const Text(
                                        ' Klient: ',
                                      ),
                                      Text(
                                          widget.appointment.customerObject!
                                              .firebaseName,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                          ),
                        ],
                      )),
                  const Divider(
                    height: 20,
                    color: Color.fromARGB(66, 158, 158, 158),
                  ),
                  // Wyświetlanie usług
                  const SizedBox(height: 8.0),
                  const Text(
                    'Usługi:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4.0),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.appointment.services?.length ?? 0,
                    itemBuilder: (context, index) {
                      final service = widget.appointment.services![index];
                      return Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color.fromARGB(
                                  97, 158, 158, 158), // Kolor obramowania
                              width: 0.5, // Grubość obramowania
                            ),
                          ),
                        ),
                        child: ListTile(
                          title: Text('${index + 1}. ${service.title}'),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.money,
                                      size: 18,
                                      color: Color.fromARGB(255, 87, 87, 87)),
                                  Text(
                                      '  €${service.price!.substring(0, service.price!.length - 3)}       ',
                                      style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 87, 87, 87))),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.watch_later_outlined,
                                    size: 18,
                                  ),
                                  Text('  ${service.durationMinutes} minut',
                                      style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 87, 87, 87))),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                      height: 16.0), // Dodaj odstęp między listą a przyciskami
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _isLoading
                          ? AnimatedPlaceholderBoxWithContraints(
                              width: 110, height: 42, radius: 12)
                          : ElevatedButton(
                              onPressed: () async {
                                print('[PROCESS] Update status');
                                showDialog(
                                  barrierColor: Colors.transparent,
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return const AlertDialogLoading(
                                      icon: Icon(Icons.check),
                                      title: 'Wizyta potwierdzona!',
                                      message:
                                          'Teraz zaktualizujemy Twoje wyniki...',
                                    );
                                  },
                                );
                                if (mounted) {
                                  await _updateAppointmentStatus('C');
                                }
                                Get.back();
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.black,
                              ),
                              child: Text(sendConfirmationButtonText),
                            ),
                      _isLoading
                          ? AnimatedPlaceholderBoxWithContraints(
                              width: 110, height: 42, radius: 12)
                          : OutlinedButton(
                              onPressed: () async {
                                print('[PROCESS] Update status');
                                showDialog(
                                  barrierColor: Colors.transparent,
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return const AlertDialogLoading(
                                      icon: Icon(Icons.check),
                                      title: 'Wizyta odrzucona!',
                                      message:
                                          'Teraz zaktualizujemy Twoje wyniki...',
                                    );
                                  },
                                );
                                if (mounted) {
                                  await _updateAppointmentStatus('X');
                                }
                                Get.back();
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                side: const BorderSide(
                                  color: Color.fromARGB(
                                      255, 0, 0, 0), // Kolor obramowania
                                  width: 1.0, // Grubość obramowania
                                ),
                              ),
                              child: Text(sendRejectionButtonText,
                                  style: const TextStyle(color: Colors.black)),
                            ),
                    ],
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50,
                    width: width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AnimatedPlaceholderBoxWithContraints(
                                width: 110, height: 18, radius: 12),
                            // Wyświetlanie godziny bookingu
                            AnimatedPlaceholderBoxWithContraints(
                                width: 95, height: 14, radius: 12),
                          ],
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: 26,
                          width: 100,
                          decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.orange)),
                          child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 500),
                              child: AnimatedPlaceholderBoxWithContraints(
                                  width: 60, height: 14, radius: 12)),
                        )
                      ],
                    ),
                  ),

                  // Wyświetlanie nazwy użytkownika (jeśli dostępna)
                  AnimatedPlaceholderBoxWithContraints(
                      width: 110, height: 26, radius: 12),

                  // Wyświetlanie usług
                  const SizedBox(height: 8.0),
                  AnimatedPlaceholderBoxWithContraints(
                      width: 64, height: 14, radius: 12),
                  const SizedBox(height: 4.0),
                  AnimatedPlaceholderBoxWithContraints(
                      width: 110, height: 42, radius: 12),
                  const SizedBox(
                      height: 16.0), // Dodaj odstęp między listą a przyciskami
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AnimatedPlaceholderBoxWithContraints(
                          width: 110, height: 42, radius: 12),
                      AnimatedPlaceholderBoxWithContraints(
                          width: 110, height: 42, radius: 12)
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  String trimTimeFrom(String? input) {
    if (input == null || input.isEmpty) {
      return '';
    } else {
      if (input[0] == '0') {
        return input.substring(1, 5);
      } else {
        return input.substring(0, 5);
      }
    }
  }

  Future<void> _updateAppointmentStatus(String status) async {
    setState(() {
      _isLoading = true; // Ustaw isLoading na true, aby pokazać loader
      _isButtonPressed = true;
    });

    try {
      final salonProvider =
          Provider.of<GetSalonProvider>(context, listen: false);
      String response =
          await salonProvider.sendStatusUpdate(widget.appointment.id!, status);
      bool responseUpdateAppointments =
          await salonProvider.getAppointments(salonProvider.salon!.id!);

      // Sprawdź odpowiedź i wyświetl odpowiednią informację
      if (response == '201' && responseUpdateAppointments) {
        _showBottomBar('Status spotkania został zaktualizowany.');
        setState(() {
          _requestStatus = status == 'C'
              ? 'potwierdzona'
              : 'odrzucona'; // Ustaw isLoading na false, aby ukryć loader po zakończeniu
        });
      } else {
        _showBottomBar('Nie udało się zaktualizować statusu spotkania.');
        setState(() {
          _requestStatus =
              'błąd'; // Ustaw isLoading na false, aby ukryć loader po zakończeniu
        });
      }
    } catch (e) {
      print('Błąd podczas aktualizacji statusu spotkania: $e');
      setState(() {
        _requestStatus = e
            .toString(); // Ustaw isLoading na false, aby ukryć loader po zakończeniu
      });
      _showBottomBar('Wystąpił błąd podczas aktualizacji statusu spotkania.');
    } finally {
      setState(() {
        _isLoading =
            false; // Ustaw isLoading na false, aby ukryć loader po zakończeniu
      });
    }
  }

  void _showBottomBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
