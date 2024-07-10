import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../salon_provider/get_salon_provider.dart';

class WalletButtonsMonthsProvider with ChangeNotifier {
  String? _selectedMonth;

  String? get selectedMonth => _selectedMonth;

  String? lastMonth(BuildContext context) {
    final _salonModelProvider =
        Provider.of<GetSalonProvider>(context, listen: false);
    return _salonModelProvider.getMonthsWithAppointments.last;
  }

  void selectMonth(String month) {
    _selectedMonth = month;
    notifyListeners();
  }

  void selectMonthSilent(String month) {
    _selectedMonth = month;
  }
}
