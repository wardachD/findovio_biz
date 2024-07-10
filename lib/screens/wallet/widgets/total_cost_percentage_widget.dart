import 'package:findovio_business/provider/salon_provider/get_salon_provider.dart';
import 'package:flutter/material.dart';

// Twoje funkcje pomocnicze

int monthToNumber(String month) {
  switch (month) {
    case 'styczeń':
      return 1;
    case 'luty':
      return 2;
    case 'marzec':
      return 3;
    case 'kwiecień':
      return 4;
    case 'maj':
      return 5;
    case 'czerwiec':
      return 6;
    case 'lipiec':
      return 7;
    case 'sierpień':
      return 8;
    case 'wrzesień':
      return 9;
    case 'październik':
      return 10;
    case 'listopad':
      return 11;
    case 'grudzień':
      return 12;
    default:
      throw ArgumentError('Invalid month name: $month');
  }
}

// Widget do wyświetlania całkowitych kosztów i różnicy procentowej

class TotalCostPercentageWidget extends StatelessWidget {
  final String selectedMonth;
  final GetSalonProvider salonProvider;

  TotalCostPercentageWidget({
    required this.selectedMonth,
    required this.salonProvider,
  });

  @override
  Widget build(BuildContext context) {
    int currentMonth = monthToNumber(selectedMonth);
    double currentCost = salonProvider.getTotalCostForMonth(currentMonth);
    double previousCost = currentMonth > 1
        ? salonProvider.getTotalCostForMonth(currentMonth - 1)
        : 0.0;
    double percentageChange = 0.0;
    Color textColor = Colors.black;

    if (previousCost != 0) {
      percentageChange = ((currentCost - previousCost) / previousCost) * 100;
      if (percentageChange > 0) {
        textColor = Colors.green;
      } else if (percentageChange < 0) {
        textColor = Colors.red;
      }
    }

    return Row(
      children: [
        Text(
          currentCost.toStringAsFixed(2),
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(width: 8),
        if (previousCost != 0)
          Text(
            percentageChange == 0
                ? '+ 0%'
                : '${percentageChange > 0 ? '+ ' : ''}${percentageChange.toStringAsFixed(2)}%',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
      ],
    );
  }
}
