import 'package:findovio_business/provider/buttons_state/wallet_buttons_months_provider.dart';
import 'package:findovio_business/provider/salon_provider/get_salon_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class HorizontalScrollableListWidget extends StatefulWidget {
  const HorizontalScrollableListWidget({super.key});

  @override
  State<HorizontalScrollableListWidget> createState() =>
      _HorizontalScrollableListWidgetState();
}

class _HorizontalScrollableListWidgetState
    extends State<HorizontalScrollableListWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GetSalonProvider>(
      builder: (context, dataProvider, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 12),
          child: Row(
            children: [
              SizedBox(
                height: 42,
                width: MediaQuery.of(context).size.width - 12,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: dataProvider.getMonthsWithAppointments.length,
                  itemBuilder: (context, index) {
                    String month =
                        dataProvider.getMonthsWithAppointments[index];
                    print(month);
                    return Consumer<WalletButtonsMonthsProvider>(
                      builder: (context, selectedMonthProvider, _) {
                        bool isSelected =
                            (selectedMonthProvider.selectedMonth == month) ||
                                (selectedMonthProvider.selectedMonth == null &&
                                    index + 1 ==
                                        dataProvider
                                            .getMonthsWithAppointments.length);
                        if (isSelected) {
                          WidgetsBinding.instance
                              .addPostFrameCallback((timeStamp) {
                            selectedMonthProvider.selectMonth(month);
                          });
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(8.0),
                            child: InkWell(
                              onTap: () {
                                selectedMonthProvider.selectMonth(month);
                              },
                              borderRadius: BorderRadius.circular(8.0),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.black
                                        : const Color.fromARGB(
                                            255, 236, 236, 236),
                                    borderRadius: BorderRadius.circular(6)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 4),
                                child: Center(
                                  child: Text(
                                    month.capitalizeFirst!,
                                    style: TextStyle(
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.w400,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
