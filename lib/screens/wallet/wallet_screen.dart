import 'package:findovio_business/screens/wallet/widgets/months_raport_view_widget.dart';
import 'package:flutter/material.dart';
import 'widgets/horizontal_button_list_widget.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 12,
            ),
            Column(
              children: [
                Container(
                    padding: const EdgeInsets.only(left: 12),
                    width: MediaQuery.sizeOf(context).width,
                    child: const Text(
                      'Podsumowanie',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    )),
                const Divider(
                  color: Color.fromARGB(255, 228, 228, 228),
                  height: 24,
                ),
                const HorizontalScrollableListWidget(),
                const MonthsRaportViewWidget(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
