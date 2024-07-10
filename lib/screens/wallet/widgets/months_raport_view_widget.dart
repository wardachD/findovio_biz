import 'package:findovio_business/provider/buttons_state/wallet_buttons_months_provider.dart';
import 'package:findovio_business/provider/salon_provider/get_salon_provider.dart';
import 'package:findovio_business/screens/wallet/screens/wallet_details_screen.dart';
import 'package:findovio_business/screens/wallet/widgets/line_chart.dart';
import 'package:findovio_business/screens/wallet/widgets/total_cost_percentage_widget.dart';
import 'package:findovio_business/screens/wallet/widgets/wallet_information_widget.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class MonthsRaportViewWidget extends StatelessWidget {
  const MonthsRaportViewWidget({super.key});

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
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletButtonsMonthsProvider>(
      builder: (context, dataProvider, _) {
        if (dataProvider.selectedMonth == null) {
          return Center(
              child: SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.55,
            width: MediaQuery.sizeOf(context).width * 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/financialraport.png', // Tutaj ustaw URL swojego obrazka
                            width: 160,
                            height: 160,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            textAlign: TextAlign.center,
                            'Czekamy na \npierwsze dane 🎈👀',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Nie mamy jeszcze danych do wyświetlenia. Po pierwszej wizycie Twój widok portfela będzie zaktualizowany automatycznie.',
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ));
        }

        return Consumer<GetSalonProvider>(builder: (context, salonProvider, _) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WalletInformationWidget(
                        width: MediaQuery.of(context).size.width,
                        height: 72,
                        icon: MdiIcons.cashCheck,
                        title: 'PRZYCHÓD',
                        contentWidget: TotalCostPercentageWidget(
                          selectedMonth: dataProvider.selectedMonth!,
                          salonProvider: salonProvider,
                        ),
                        onDetailsPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WalletDetailsScreen(
                                  selectedMonth: monthToNumber(
                                      dataProvider.selectedMonth ?? ''),
                                  appointments:
                                      salonProvider.appointments ?? []),
                            ),
                          );
                        },
                        detailsButtonText: 'szczegóły',
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          WalletInformationWidget(
                            width: MediaQuery.of(context).size.width / 2 - 18,
                            height: 72,
                            icon: MdiIcons.calendar,
                            title: 'WIZYT',
                            contentWidget: NumberWithPreviousMonthComparison(
                              number: salonProvider
                                  .getVisitsWithStatusForMonth(
                                      monthToNumber(
                                          dataProvider.selectedMonth ?? ''),
                                      'C')
                                  .toString(),
                              previousMonthNumber: salonProvider
                                  .getVisitsWithStatusForMonth(
                                      monthToNumber(
                                              dataProvider.selectedMonth ??
                                                  '') -
                                          1,
                                      'C')
                                  .toString(),
                            ),
                            onDetailsPressed: () {
                              // tutaj przejście na inny ekran
                            },
                          ),
                          WalletInformationWidget(
                            width: MediaQuery.of(context).size.width / 2 - 18,
                            height: 72,
                            icon: MdiIcons.humanGreeting,
                            title: 'UNIK. KLIENCI',
                            contentWidget: NumberWithPreviousMonthComparison(
                              number: salonProvider
                                  .getUniqueClientCountUpToMonth(monthToNumber(
                                      dataProvider.selectedMonth ?? ''))
                                  .toString(),
                              previousMonthNumber: salonProvider
                                  .getUniqueClientCountUpToMonth(monthToNumber(
                                          dataProvider.selectedMonth ?? '') -
                                      1)
                                  .toString()
                                  .toString(),
                            ),
                            onDetailsPressed: () {
                              // tutaj przejście na inny ekran
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          WalletInformationWidget(
                            width: MediaQuery.of(context).size.width / 2 - 18,
                            height: 72,
                            icon: MdiIcons.calendarRemove,
                            title: 'ANULOWANE',
                            contentWidget: NumberWithPreviousMonthComparison(
                              reverse: true,
                              number: salonProvider
                                  .getVisitsWithStatusForMonth(
                                      monthToNumber(
                                          dataProvider.selectedMonth ?? ''),
                                      'X')
                                  .toString(),
                              previousMonthNumber: salonProvider
                                  .getVisitsWithStatusForMonth(
                                      monthToNumber(
                                              dataProvider.selectedMonth ??
                                                  '') -
                                          1,
                                      'X')
                                  .toString(),
                            ),
                            onDetailsPressed: () {
                              // tutaj przejście na inny ekran
                            },
                          ),
                          WalletInformationWidget(
                            width: MediaQuery.of(context).size.width / 2 - 18,
                            height: 72,
                            icon: MdiIcons.heart,
                            title: 'ULUBIONE',
                            contentWidget: const Text('wkrótce'),
                            onDetailsPressed: () {
                              // tutaj przejście na inny ekran
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 243, 243, 243),
                            borderRadius: BorderRadius.circular(12)),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: 320,
                            maxHeight: constraints.maxHeight,
                          ),
                          child: LineChartWidget(
                            appointments: salonProvider
                                .getAppointmentsForMonthNumber(monthToNumber(
                                    dataProvider.selectedMonth ?? '')),
                            chartType: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
      },
    );
  }
}

class NumberWithPreviousMonthComparison extends StatelessWidget {
  final String number;
  final String previousMonthNumber;
  final bool reverse;

  NumberWithPreviousMonthComparison({
    Key? key,
    required this.number,
    required this.previousMonthNumber,
    this.reverse = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double currentNumber = double.parse(number);
    double prevNumber = double.parse(previousMonthNumber);

    double percentageDifference = 0;
    if (prevNumber != 0) {
      percentageDifference = ((currentNumber - prevNumber) / prevNumber) * 100;
    }

    Color textColor;
    String sign;
    String formattedDifference;

    if (reverse) {
      if (percentageDifference > 0) {
        textColor = Colors.red;
        sign = '+';
        percentageDifference = percentageDifference.abs();
      } else if (percentageDifference < 0) {
        textColor = Colors.green;
        sign = '';
      } else {
        textColor = Colors.black;
        sign = '';
      }
    } else {
      if (percentageDifference > 0) {
        textColor = Colors.green;
        sign = '+';
      } else if (percentageDifference < 0) {
        textColor = Colors.red;
        sign = '-';
        percentageDifference = percentageDifference.abs();
      } else {
        textColor = Colors.black;
        sign = '';
      }
    }

    formattedDifference = percentageDifference == 0
        ? ''
        : '$sign${percentageDifference.toStringAsFixed(0)}%';

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          number,
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 5),
        Text(
          formattedDifference,
          style: TextStyle(color: textColor, fontSize: 12),
        ),
      ],
    );
  }
}
