import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/appointment_model.dart';

class _LineChart extends StatelessWidget {
  const _LineChart(
      {required this.chartWeekMonthFullType, required this.appointments});

  final List<AppointmentModel> appointments;
  final bool chartWeekMonthFullType;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      chartWeekMonthFullType ? monthViewData : monthViewData,
      duration: const Duration(milliseconds: 250),
    );
  }

  int getWeekNumber(DateTime date) {
    // Oblicz dzień tygodnia dla danej daty (0 - poniedziałek, 6 - niedziela)
    int weekday = date.weekday;

    // Jeśli dzień tygodnia to niedziela (7), ustaw go na 0 (poniedziałek)
    if (weekday == 7) {
      weekday = 0;
    }

    // Oblicz numer tygodnia na podstawie liczby dni, które minęły od początku roku
    int weekNumber =
        ((date.difference(DateTime(date.year, 1, 1)).inDays) / 7).ceil();

    // Jeśli numer tygodnia wynosi 0, oznacza to, że jesteśmy w ostatnim tygodniu poprzedniego roku
    if (weekNumber == 0) {
      weekNumber = getWeekNumber(DateTime(date.year - 1, 12, 31));
    }

    return weekNumber;
  }

  List<FlSpot> get flSpots => calculateFlSpots(appointments);

  List<FlSpot> get flSpotsWeekCanceled => calculateFlSpots(appointments);

  int get minXmonths => DateTime.now().subtract(const Duration(days: 60)).month;

  List<FlSpot> calculateFlSpots(List<AppointmentModel> appointments) {
    // Stwórz mapę, która będzie przechowywać sumę pieniędzy dla każdego dnia danego miesiąca
    Map<int, double> dailyTotal = {};

    // Oblicz sumę pieniędzy dla każdego dnia w wybranym miesiącu
    for (var appointment in appointments) {
      DateTime appointmentDate = parseDate(appointment.dateOfBooking!);
      // Sprawdź, czy appointment znajduje się w wybranym miesiącu i ma status 'C'
      if (appointment.status == 'C' || appointment.status == 'F') {
        int day = appointmentDate.day;
        dailyTotal[day] =
            (dailyTotal[day] ?? 0.0) + (appointment.totalCost ?? 0.0);
      }
    }

    // Utwórz punkty FlSpot dla każdego dnia miesiąca, dodając sumy z poprzednich dni
    List<FlSpot> calculatedFlSpots = [];
    double cumulativeTotal = 0.0;
    calculatedFlSpots.add(FlSpot(1, 0));

    // Zakładamy, że miesiąc ma maksymalnie 31 dni
    for (int day = 1; day <= 31; day++) {
      cumulativeTotal += dailyTotal[day] ?? 0.0;

      if (calculatedFlSpots.isEmpty ||
          calculatedFlSpots.last.y != cumulativeTotal) {
        calculatedFlSpots.add(FlSpot(day.toDouble(), cumulativeTotal));
      } else {
        // Jeśli wartość jest taka sama jak poprzednia, zaktualizuj ostatni punkt
        calculatedFlSpots.last = FlSpot(day.toDouble(), cumulativeTotal);
      }
    }

    return calculatedFlSpots;
  }

  double calculateTotalMoneyForDateRange(List<AppointmentModel> appointments,
      DateTime startDate, DateTime endDate) {
    double totalMoney = 0.0;
    for (var appointment in appointments) {
      DateTime appointmentDate = parseDate(appointment.dateOfBooking!);
      if (appointmentDate.isAfter(startDate) &&
          appointmentDate.isBefore(endDate) &&
          appointment.status == 'C') {
        totalMoney += appointment.totalCost ?? 0.0;
      }
    }
    return totalMoney;
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

  LineChartData get monthViewData => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: titlesData2,
        borderData: borderData,
        lineBarsData: monthChartDataList,
        minX: 1,
        minY: 0,
      );

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (touchedSpot) =>
              const Color.fromARGB(255, 255, 255, 255),
        ),
      );

  FlTitlesData get titlesData2 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(sideTitles: leftTitles()),
      );

  List<LineChartBarData> get monthChartDataList => [monthChartBarData];

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text = value.toInt().toString();

    return Text(
      text,
      style: style,
    );
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        reservedSize: 42,
      );

  SideTitles get bottomTitles => const SideTitles(
      reservedSize: 38,
      showTitles: true,
      interval: 5,
      getTitlesWidget: bottomTitleWidgetsMonths);

  FlGridData get gridData => const FlGridData(
        drawHorizontalLine: true,
        drawVerticalLine: false,
        checkToShowHorizontalLine: showAllGrids,
      );

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: const Border(
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
          bottom: BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get monthChartBarData => LineChartBarData(
      preventCurveOverShooting: true,
      isCurved: true,
      curveSmoothness: 0.2,
      gradient: const LinearGradient(
        colors: [
          Color.fromARGB(255, 86, 126, 255),
          Color.fromARGB(255, 0, 238, 255),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      barWidth: 6,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(
        show: false,
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 193, 253, 169),
            Color.fromARGB(0, 255, 255, 255),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomRight,
        ),
      ),
      spots: flSpots);
}

Widget bottomTitleWidgetsMonths(double value, TitleMeta meta) {
  const style = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );
  var tvalue = '';
  if (value == 1) tvalue = '1';
  if (value == 5) tvalue = '5';
  if (value == 10) tvalue = '10';
  if (value == 15) tvalue = '15';
  if (value == 20) tvalue = '20';
  if (value == 25) tvalue = '25';
  if (value == 30) tvalue = '30';

  Widget text = Text(tvalue, style: style);

  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: text,
  );
}

class LineChartWidget extends StatefulWidget {
  final bool chartType;
  final List<AppointmentModel> appointments;
  const LineChartWidget(
      {super.key, required this.chartType, required this.appointments});

  @override
  State<LineChartWidget> createState() => LineChartWidgetState();
}

class LineChartWidgetState extends State<LineChartWidget> {
  //true - 3month, false - month

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.23,
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(
                height: 12,
              ),
              const SizedBox(
                height: 37,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, left: 6),
                  child: _LineChart(
                      appointments: widget.appointments,
                      chartWeekMonthFullType: widget.chartType),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
