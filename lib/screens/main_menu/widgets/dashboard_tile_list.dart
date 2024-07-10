import 'package:findovio_business/main.dart';
import 'package:findovio_business/models/appointment_model.dart';
import 'package:findovio_business/provider/salon_provider/get_salon_provider.dart';
import 'package:findovio_business/screens/main_menu/widgets/alertdialog_loading.dart';
import 'package:findovio_business/screens/main_menu/widgets/dashboard_tile_action_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../screens/accept_appointment_screen.dart';

class DashboardTileList extends StatelessWidget {
  const DashboardTileList({
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
          child: Consumer(
            builder: (context, GetSalonProvider provider, _) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DashboardTileActionWidget(
                    width: MediaQuery.sizeOf(context).width,
                    height: 120,
                    title: 'Zarobione w tym miesiącu',
                    imagePath: 'assets/images/grads/dashboard_money_bg.webp',
                    fontDescriptionSize: 28,
                    fontColor: Colors.white,
                    description:
                        '€${provider.calculateTotalPriceForStatusF().round().toString()}',
                    onTap: () {
                      minimalExampleKey.currentState?.changeTab(2);
                    },
                    color: const Color.fromARGB(255, 255, 255, 255),
                    iconColor: Colors.black,
                    buttonColor: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DashboardTileActionWidget(
                        title: 'Najbliższe wizyty',
                        description: provider.getAppointmentsInfo(),
                        fontDescriptionSize: 14,
                        iconFile: Icons.calendar_month_outlined,
                        onTap: () {
                          showDialog(
                            barrierColor: const Color.fromARGB(82, 0, 0, 0),
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return const AlertDialogLoading(
                                icon: Icon(Icons.check),
                                title: 'Aktualizujemy kalendarz',
                                message:
                                    'Poczekaj chwilkę żeby być na bieżąco...',
                              );
                            },
                          );

                          Future.delayed(const Duration(milliseconds: 2000),
                              () {
                            Get.back();
                          }).then((value) =>
                              minimalExampleKey.currentState?.changeTab(1));
                        },
                        color: const Color.fromARGB(255, 255, 255, 255),
                        iconColor: Colors.black,
                        buttonColor: const Color.fromARGB(255, 255, 255, 255),
                      ),
                      DashboardTileActionWidget(
                        title: 'Potwierdź',
                        fontDescriptionSize: 14,
                        description: provider.getAppointmentsToAcceptInfo(),
                        iconFile: Icons.edit_calendar_outlined,
                        onTap: () {
                          if (provider.getAppointmentsToAcceptInfo() !=
                              "Brak") {
                            List<AppointmentModel> tempAppointmentData = [];
                            for (var element in provider.appointments!) {
                              if (element.status == "P") {
                                tempAppointmentData.add(element);
                              }
                            }
                            Get.to(const AcceptAppointmentScreen());
                          }
                        },
                        color: const Color.fromARGB(255, 255, 255, 255),
                        iconColor: Colors.black,
                        buttonColor: const Color.fromARGB(255, 255, 255, 255),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
