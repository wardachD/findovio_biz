import 'package:findovio_business/screens/main_menu/widgets/license_snackbar_widget.dart';
import 'package:findovio_business/screens/schedule/widgets/calendar_list_element.dart';
import 'package:findovio_business/screens/main_menu/widgets/instruction_popup_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import '../../models/appointment_model.dart';
import '../../provider/salon_provider/get_salon_provider.dart';

class CalendarViewScreen extends StatefulWidget {
  bool isFullScreen = false;
  CalendarViewScreen({super.key, required this.isFullScreen});

  @override
  State<CalendarViewScreen> createState() => _CalendarViewScreenState();
}

class _CalendarViewScreenState extends State<CalendarViewScreen> {
  DateTime _focusedDay = DateTime.now();
  bool _isHeaderVisible = true;
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _getInitialSelectedDay();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection ==
            ScrollDirection.forward &&
        _scrollController.position.extentBefore < 10) {
      // Scroll w górę, przywróć poprzedni format kalendarza
      setState(() {
        _isHeaderVisible = true;
        _calendarFormat = CalendarFormat.month;
      });
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      // Scroll w dół, zmień format kalendarza na tydzień
      setState(() {
        _isHeaderVisible = false;
        _calendarFormat = CalendarFormat.week;
      });
    }
  }

  AppointmentModel? getFirstAppointmentAfterToday(
      List<AppointmentModel> appointments) {
    final now = DateTime.now();

    // Sortujemy spotkania względem daty i czasu
    appointments.sort((a, b) {
      final dateA = DateTime.parse(a.dateOfBooking!);
      final dateB = DateTime.parse(b.dateOfBooking!);
      return dateA.compareTo(dateB);
    });

    // Szukamy pierwszego spotkania po dzisiejszej dacie
    for (var appointment in appointments) {
      final appointmentDate = DateTime.parse(appointment.dateOfBooking!);
      if (appointmentDate.isAfter(now)) {
        return appointment;
      }
    }

    // Jeśli nie znaleziono żadnego spotkania po dzisiejszej dacie, zwracamy null
    return null;
  }

  void _getInitialSelectedDay() {
    final salonProvider = Provider.of<GetSalonProvider>(context, listen: false);
    showSnackbar(salonProvider.license.remainingDays.toString());

    AppointmentModel? firstAppointmentFromToday =
        getFirstAppointmentAfterToday(salonProvider.appointments ?? []);
    if (firstAppointmentFromToday != []) {
      if (firstAppointmentFromToday != null) {
        if (firstAppointmentFromToday.dateOfBooking != null) {
          setState(() {
            _selectedDay =
                DateTime.parse(firstAppointmentFromToday.dateOfBooking!);
          });
        } else {
          // Obsługa gdy dateOfBooking jest null
          setState(() {
            _selectedDay = DateTime.now();
          });
        }
      } else {
        // Obsługa gdy nie znaleziono żadnego spotkania po dzisiejszej dacie
        setState(() {
          _selectedDay = DateTime.now();
        });
      }
    } else {
      setState(() {
        _selectedDay = DateTime.now();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AnimatedContainer(
                height: _isHeaderVisible ? 48 : 0,
                duration: const Duration(milliseconds: 300),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Kalendarz',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const InstructionPopupWidget();
                              },
                            );
                          },
                          icon: const Icon(Icons.help_outline),
                        ),
                      ],
                    ),
                  ),
                )),
            Container(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.only(bottom: 12),
                decoration:
                    const BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 187, 187, 187),
                    offset: Offset(0, 2),
                    blurRadius: 6,
                  )
                ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Consumer<GetSalonProvider>(
                      builder: (context, salonProvider, _) {
                        return TableCalendar(
                          locale: 'pl_PL',
                          availableCalendarFormats: const {
                            CalendarFormat.month: 'Miesiąc',
                            CalendarFormat.twoWeeks: '2 tygodnie',
                            CalendarFormat.week: 'Tydzień'
                          },
                          focusedDay: _focusedDay,
                          firstDay:
                              DateTime.now().subtract(const Duration(days: 14)),
                          lastDay: DateTime.now().add(const Duration(days: 60)),
                          selectedDayPredicate: (day) =>
                              isSameDay(_selectedDay, day),
                          onDaySelected: _onDaySelected,
                          calendarFormat: _calendarFormat,
                          onFormatChanged: _onFromatChanged,
                          eventLoader: _getEventsForDay,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            if (_selectedDay != null)
              Consumer<GetSalonProvider>(
                builder: (context, salonProvider, _) {
                  return Expanded(
                    child:
                        _getAppointmentsInfoForDay(salonProvider.appointments),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  List<dynamic> _getEventsForDay(DateTime day) {
    // Pobieramy listę wydarzeń dla danej daty z dostawcy
    final salonProvider = Provider.of<GetSalonProvider>(context, listen: false);
    List<AppointmentModel>? appointments = salonProvider.appointments;

    // Pobieramy wydarzenia dla danej daty z listy terminów
    return appointments
            ?.where((appointment) =>
                _isSameDay(DateTime.parse(appointment.dateOfBooking!), day))
            .toList() ??
        [];
  }

  bool _isSameDay(DateTime day1, DateTime day2) {
    return day1.year == day2.year &&
        day1.month == day2.month &&
        day1.day == day2.day;
  }

  _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  _onFromatChanged(CalendarFormat format) {
    setState(() => _calendarFormat = format);
  }

  Widget _getAppointmentsInfoForDay(List<AppointmentModel>? appointments) {
    if (appointments == null) return const SizedBox();

    // Filtrujemy wizyty dla wybranego dnia
    List<AppointmentModel> appointmentsForDay = appointments
        .where((appointment) => _isSameDay(
            DateTime.parse(appointment.dateOfBooking!), _selectedDay!))
        .toList();

    // Sortujemy wizyty od najwcześniejszej do najpóźniejszej
    appointmentsForDay.sort((a, b) =>
        DateTime.parse('${a.dateOfBooking} ${a.timeslots!.first.timeFrom}')
            .compareTo(DateTime.parse(
                '${b.dateOfBooking} ${b.timeslots!.first.timeFrom}')));

    // Tworzymy widgety z informacjami o wizytach
    if (appointmentsForDay.isEmpty) {
      return Center(
          child: SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.8,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flex(
              direction: Axis.vertical,
            ),
            Column(
              children: [
                Icon(Icons.hourglass_empty_rounded),
                SizedBox(height: 8),
                Text('Brak wizyt...',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(
                  height: 8,
                ),
                Text(
                    textAlign: TextAlign.center,
                    'Udostępniaj aplikację wśród klientów by zwiększyć ilość wizyt i sprawdź opcje reklamy w ustawieniach aplikacji!'),
              ],
            ),
            Flex(
              direction: Axis.vertical,
            ),
          ],
        ),
      ));
    }
    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: appointmentsForDay.length,
      itemBuilder: (context, index) {
        final appointment = appointmentsForDay[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 18.0),
          child: CalendarListElement(appointments: appointment),
        );
      },
    );
  }
}
