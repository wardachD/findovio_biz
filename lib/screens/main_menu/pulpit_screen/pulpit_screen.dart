import 'package:findovio_business/provider/salon_provider/get_salon_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/dashboard_create_screen.dart';

class PulpitScreen extends StatefulWidget {
  const PulpitScreen({super.key});

  @override
  State<PulpitScreen> createState() => _PulpitScreenState();
}

class _PulpitScreenState extends State<PulpitScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GetSalonProvider>(
      builder: (context, salonModelProvider, child) {
        if (salonModelProvider.salon == null) {
          // Pobierz dane salonu z serwera przy inicjowaniu ekranu
          salonModelProvider.fetchSalon(true);
          return const CircularProgressIndicator(); // Lub inny widget ładowania
        } else {
          // Wyświetl dane salonu
          final salonModel = salonModelProvider.salon!;
          return DashboardCreateScreen(salonModel: salonModel);
        }
      },
    );
  }
}
