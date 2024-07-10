import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';

class TimePickerWidget extends StatefulWidget {
  final TextEditingController controller;

  const TimePickerWidget({super.key, required this.controller});

  @override
  State<TimePickerWidget> createState() =>
      _TimePickerWidgetState(controller: controller);
}

class _TimePickerWidgetState extends State<TimePickerWidget> {
  int _currentHorizontalIntValue = 10;
  TextEditingController controller;

  _TimePickerWidgetState({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        NumberPicker(
          value: _currentHorizontalIntValue,
          minValue: 5,
          maxValue: 180,
          step: 5,
          itemHeight: 100,
          axis: Axis.horizontal,
          onChanged: (value) =>
              setState(() => _currentHorizontalIntValue = value),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color.fromARGB(255, 0, 0, 0)),
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                'Wybrany czas to: ${getTimeInHoursFromMinute(_currentHorizontalIntValue)}'),
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: OutlinedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 20, 20, 20)),
                side: MaterialStateProperty.all<BorderSide>(BorderSide.none)),
            onPressed: () {
              controller.text = _currentHorizontalIntValue.toString();
              Get.back();
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Zapisz',
                    style: TextStyle(
                      color: Colors.white,
                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

String getTimeInHoursFromMinute(int time) {
  if (time >= 5 && time <= 55) {
    return '$time minut';
  } else if (time >= 60) {
    int hours = time ~/ 60;
    int minutes = time % 60;
    if (minutes == 0) {
      return '$hours Godzina';
    } else {
      return '$hours Godzina $minutes Minut';
    }
  } else {
    return 'Nieprawidłowy czas';
  }
}
