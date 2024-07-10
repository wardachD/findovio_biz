import 'package:flutter/material.dart';
import 'package:findovio_business/models/appointment_model.dart';

class CalendarListElement extends StatefulWidget {
  final AppointmentModel appointments;

  const CalendarListElement({super.key, required this.appointments});

  @override
  _CalendarListElementState createState() => _CalendarListElementState();
}

class _CalendarListElementState extends State<CalendarListElement> {
  bool _isExpanded = false;
  final Color _dividerColor = const Color.fromARGB(255, 231, 231, 231);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color.fromARGB(255, 255, 255, 255),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(255, 224, 224, 224),
              blurRadius: 6,
              offset: Offset(0, 3),
            )
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.watch_later_outlined),
                            Text(
                              ' ${trimTimeFrom(widget.appointments.timeslots!.first.timeFrom)} - ${trimTimeFrom(widget.appointments.timeslots!.last.timeTo)}',
                            ),
                          ],
                        ),
                        Text(
                          ' ${widget.appointments.customerObject!.firebaseName}',
                        ),
                        Icon(
                          _isExpanded ? Icons.expand_less : Icons.expand_more,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(height: 18, color: _dividerColor),
          Text(
              'Lista zarezerwowanych usług (${widget.appointments.services!.length}):'),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: widget.appointments.services!.length > 1
                ? AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: _isExpanded
                        ? SizedBox(
                            width: MediaQuery.sizeOf(context).width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              key: const Key('1'),
                              children: () {
                                List<Widget> widgets = [];
                                int index = 0;
                                for (var service
                                    in widget.appointments.services!) {
                                  widgets.add(
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                          .width,
                                                  child: Text(
                                                    '${index + 1}. ${service.title}',
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Row(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          color: Colors.black),
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 6,
                                                          vertical: 4),
                                                      child: Text(
                                                          '€${service.price}',
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white)),
                                                    ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 6),
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 6,
                                                          vertical: 4),
                                                      child: Row(
                                                        children: [
                                                          const Icon(
                                                              Icons
                                                                  .watch_later_outlined,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      102,
                                                                      102,
                                                                      102),
                                                              size: 16),
                                                          Text(
                                                              ' ${service.durationMinutes} minut',
                                                              style: const TextStyle(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          102,
                                                                          102,
                                                                          102))),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                  index++;
                                }
                                return widgets;
                              }(),
                            ),
                          )
                        : SizedBox(
                            width: MediaQuery.sizeOf(context).width,
                            child: Padding(
                              key: const Key('2'),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                  '${widget.appointments.services!.first.title} + ${widget.appointments.services!.length - 1} więcej'),
                            ),
                          ),
                  )
                : Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.sizeOf(context).width,
                                    child: Text(
                                      '1. ${widget.appointments.services!.first.title}',
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.watch_later_outlined,
                                          color: Color.fromARGB(
                                              255, 102, 102, 102),
                                          size: 16),
                                      Text(
                                          ' ${widget.appointments.services!.first.durationMinutes} minut',
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 102, 102, 102))),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
          ),
          Row(
            children: [
              const Icon(Icons.money),
              Text('Do zapłaty: €${widget.appointments.totalAmount}'),
            ],
          ),
          if (_isExpanded)
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Divider(height: 18, color: _dividerColor),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () async {},
                      style: ElevatedButton.styleFrom(
                        surfaceTintColor: Colors.white,
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                      ),
                      child: const Text('Kontakt z klientem'),
                    ),
                    ElevatedButton(
                      onPressed: () async {},
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                      ),
                      child: const Text('Anuluj wizytę'),
                    ),
                  ],
                ),
              ],
            ),
        ],
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
}
