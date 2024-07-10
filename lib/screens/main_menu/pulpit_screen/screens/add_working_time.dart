import 'package:findovio_business/models/get_salon_model.dart';
import 'package:findovio_business/provider/salon_provider/get_salon_builder_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../../models/get_salon_schedule.dart';
import '../../../../provider/salon_provider/get_salon_provider.dart';
import '../../widgets/loading_popup.dart';
import '../widgets/go_back_arrow.dart';

class DayInfo {
  final String day;
  final int dayNumber;
  bool switchValue;
  TimeOfDay startTime;
  TimeOfDay endTime;

  DayInfo(
      this.day, this.dayNumber, this.switchValue, this.startTime, this.endTime);
}

class AddWorkingTimeScreen extends StatefulWidget {
  const AddWorkingTimeScreen({super.key});

  @override
  State<AddWorkingTimeScreen> createState() => _AddWorkingTimeScreenState();
}

class _AddWorkingTimeScreenState extends State<AddWorkingTimeScreen> {
  List<Services> selectedServices = [];
  bool collapseTitle = false;
  bool isDisabled = false;
  bool switchValueIcon = true;
  GetSalonProvider getSalonProvider = GetSalonProvider();

  final List<DayInfo> days = [
    DayInfo('Poniedziałek', 0, false, const TimeOfDay(hour: 0, minute: 0),
        const TimeOfDay(hour: 0, minute: 0)),
    DayInfo('Wtorek', 1, false, const TimeOfDay(hour: 0, minute: 0),
        const TimeOfDay(hour: 0, minute: 0)),
    DayInfo('Środa', 2, false, const TimeOfDay(hour: 0, minute: 0),
        const TimeOfDay(hour: 0, minute: 0)),
    DayInfo('Czwartek', 3, false, const TimeOfDay(hour: 0, minute: 0),
        const TimeOfDay(hour: 0, minute: 0)),
    DayInfo('Piątek', 4, false, const TimeOfDay(hour: 0, minute: 0),
        const TimeOfDay(hour: 0, minute: 0)),
    DayInfo('Sobota', 5, false, const TimeOfDay(hour: 0, minute: 0),
        const TimeOfDay(hour: 0, minute: 0)),
    DayInfo('Niedziela', 6, false, const TimeOfDay(hour: 0, minute: 0),
        const TimeOfDay(hour: 0, minute: 0)),
  ];

  void updateDays() {
    if (getSalonProvider.schedules == null) {
      return; // If schedules list is null or empty, no need to update days
    }

    // Iterate through the schedules
    for (GetSalonSchedule schedule in getSalonProvider.schedules!) {
      // Get the day number from the schedule
      int dayNumber = schedule.dayOfWeek!;

      // Find the corresponding DayInfo object
      DayInfo? dayInfo = days.firstWhere((day) => day.dayNumber == dayNumber);

      // If a corresponding DayInfo object is found and its switchValue is false,
      // update it to true
      if (!dayInfo.switchValue) {
        dayInfo.switchValue = true;

        // Parse start time and end time strings to TimeOfDay objects
        TimeOfDay startTime = _parseTimeOfDay(schedule.timeFrom!);
        TimeOfDay endTime = _parseTimeOfDay(schedule.timeTo!);

        dayInfo.startTime = startTime;
        dayInfo.endTime = endTime;
      }
    }
  }

  TimeOfDay _parseTimeOfDay(String timeString) {
    List<String> parts = timeString.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  @override
  void initState() {
    super.initState();
    getSalonProvider = Provider.of<GetSalonProvider>(context, listen: false);
    updateDays();
  }

  void mainSetState() {
    setState(() {});
  }

  String _formatTimeOfDay(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final dateTime = DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    return DateFormat('HH:mm').format(dateTime);
  }

  int getTotalServicesCount(List<Services> services) {
    return services.length;
  }

  int getServicesWithNullCategoryCount(List<Services> services) {
    return services.where((service) => service.category == null).length;
  }

  bool isAtLeastOneDaySelected() {
    var counterSwitch = 0;
    var counterStart = 0;
    var counterEnd = 0;

    for (var element in days) {
      if (element.switchValue) {
        counterSwitch++;
        if (element.startTime != const TimeOfDay(hour: 0, minute: 0)) {
          counterStart++;
        }
        if (element.endTime != const TimeOfDay(hour: 0, minute: 0)) {
          counterEnd++;
        }
      }
    }

    return counterSwitch > 0 &&
        counterSwitch == counterStart &&
        counterSwitch == counterEnd;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const GoBackArrow(),
              // Nagłówek, który będzie zajmował 15% wysokości ekranu
              const SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ustaw czas pracy',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Wybierz dni i godziny w które pracujesz. Użytkownicy będą mogli bookować wizyty tylko w tych terminach. Kalendarz Tworzony jest na kolejne 2 miesiące.',
                      style: TextStyle(color: Color.fromARGB(255, 87, 87, 87)),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),

              // Reszta dostępnego miejsca zajęte przez Expanded

              Expanded(
                child: SingleChildScrollView(
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: days.length,
                    itemBuilder: (BuildContext context, int index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: days[index].switchValue ? 120 : 55,
                        padding: const EdgeInsets.all(6),
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: days[index].switchValue
                              ? const Color.fromARGB(255, 235, 235, 235)
                              : const Color.fromARGB(255, 248, 248, 248),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: SizedBox(
                          width: MediaQuery.sizeOf(context).width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            CupertinoSwitch(
                                              value: days[index].switchValue,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  days[index].switchValue =
                                                      value ?? false;
                                                  isDisabled =
                                                      isAtLeastOneDaySelected();
                                                });
                                              },
                                            ),
                                            const SizedBox(
                                                width:
                                                    8), // Add spacing between switch and text
                                            Text(days[index].day),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 40,
                                      child: GestureDetector(
                                        child: const Icon(Icons.edit),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height:
                                    days[index].switchValue == true ? 69 : 0,
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 400),
                                  child: days[index].switchValue == true
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            const Divider(
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                GestureDetector(
                                                  onTap: () async {
                                                    final TimeOfDay? picked =
                                                        await showTimePicker(
                                                            helpText:
                                                                'Początek pracy',
                                                            cancelText:
                                                                'Anuluj',
                                                            hourLabelText:
                                                                'Godzina',
                                                            minuteLabelText:
                                                                'Minuta',
                                                            errorInvalidText:
                                                                'Wprowadziłeś złą godzinę',
                                                            initialEntryMode:
                                                                TimePickerEntryMode
                                                                    .inputOnly,
                                                            context: context,
                                                            initialTime:
                                                                const TimeOfDay(
                                                                    hour: 7,
                                                                    minute: 0));
                                                    if (picked != null) {
                                                      // Tutaj możesz obsłużyć wybrany czas
                                                      setState(() {
                                                        days[index].startTime =
                                                            picked;
                                                        isDisabled =
                                                            isAtLeastOneDaySelected();
                                                      });
                                                    }
                                                  },
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.34,
                                                    height: 42,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                          color: days[index]
                                                                      .startTime ==
                                                                  const TimeOfDay(
                                                                      hour: 0,
                                                                      minute: 0)
                                                              ? const Color
                                                                  .fromARGB(255,
                                                                  128, 128, 128)
                                                              : Colors.white),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: Center(
                                                      child: Text(days[index]
                                                                  .startTime !=
                                                              const TimeOfDay(
                                                                  hour: 0,
                                                                  minute: 0)
                                                          ? days[index]
                                                              .startTime
                                                              .format(context)
                                                          : 'Początek'),
                                                    ),
                                                  ),
                                                ),
                                                const Text('Do'),
                                                GestureDetector(
                                                  onTap: () async {
                                                    final TimeOfDay? picked =
                                                        await showTimePicker(
                                                            helpText:
                                                                'Koniec pracy',
                                                            cancelText:
                                                                'Anuluj',
                                                            hourLabelText:
                                                                'Godzina',
                                                            minuteLabelText:
                                                                'Minuta',
                                                            errorInvalidText:
                                                                'Wprowadziłeś złą godzinę',
                                                            initialEntryMode:
                                                                TimePickerEntryMode
                                                                    .inputOnly,
                                                            context: context,
                                                            initialTime:
                                                                const TimeOfDay(
                                                                    hour: 14,
                                                                    minute: 0));
                                                    if (picked != null) {
                                                      // Tutaj możesz obsłużyć wybrany czas
                                                      setState(() {
                                                        days[index].endTime =
                                                            picked;
                                                        isDisabled =
                                                            isAtLeastOneDaySelected();
                                                      });
                                                    }
                                                  },
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.34,
                                                    height: 42,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                8),
                                                        border: Border.all(
                                                            color: days[index]
                                                                        .endTime ==
                                                                    const TimeOfDay(
                                                                        hour: 0,
                                                                        minute:
                                                                            0)
                                                                ? const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    128,
                                                                    128,
                                                                    128)
                                                                : Colors
                                                                    .white)),
                                                    child: Center(
                                                      child: Text(days[index]
                                                                  .endTime !=
                                                              const TimeOfDay(
                                                                  hour: 0,
                                                                  minute: 0)
                                                          ? days[index]
                                                              .endTime
                                                              .format(context)
                                                          : 'Koniec'),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : const SizedBox(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Consumer<GetSalonBuilderProvider>(
                builder: (context, servicesProvider, _) {
                  return OutlinedButton(
                    style: ButtonStyle(
                        backgroundColor: !isDisabled
                            ? MaterialStateProperty.all<Color>(
                                const Color.fromARGB(255, 185, 185, 185))
                            : MaterialStateProperty.all<Color>(
                                const Color.fromARGB(255, 20, 20, 20)),
                        side: MaterialStateProperty.all<BorderSide>(
                            BorderSide.none)),
                    onPressed: () async {
                      if (isDisabled) {
                        showDialog(
                          barrierColor: Colors.transparent,
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return const LoadingPopup();
                          },
                        );
                        final List<GetSalonSchedule> salonSchedules = days
                            .where((day) => day.switchValue)
                            .map((day) => GetSalonSchedule(
                                dayOfWeek: day.dayNumber,
                                timeFrom: _formatTimeOfDay(day.startTime),
                                timeTo: _formatTimeOfDay(day.endTime),
                                salonId: getSalonProvider.salon?.id!))
                            .toList();
                        var res = await getSalonProvider
                            .createSchedule(salonSchedules);
                        print(res);
                        var salonModelProvider = Provider.of<GetSalonProvider>(
                            context,
                            listen: false);
                        salonModelProvider.getVerificationStatus(context);
                        Get.back();
                      }
                      Get.back();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(!isDisabled ? 'Uzupełnij dni' : ' Zapisz',
                            style: const TextStyle(
                              color: Colors.white,
                            )),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
