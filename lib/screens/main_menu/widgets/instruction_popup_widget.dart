import 'package:flutter/material.dart';
import 'package:linear_progress_bar/ui/dots_indicator.dart';

class InstructionPopupWidget extends StatefulWidget {
  const InstructionPopupWidget({super.key});

  @override
  _InstructionPopupWidgetState createState() => _InstructionPopupWidgetState();
}

class _InstructionPopupWidgetState extends State<InstructionPopupWidget> {
  int _currentPageIndex = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'Widok Kalendarza',
      'description':
          'Strzałki pozwalają Ci na zmianę miesiąca. Możesz maksymalnie cofnąć się o jeden miesiąc i przejść o jeden miesiąc do przodu. Archiwum jest dostępne w zakładce Profil.',
      'imagePath': 'assets/images/instr1.jpg',
    },
    {
      'title': 'Ikony dni',
      'description':
          'Podświetlony dzień to ten który aktualnie jest zaznaczony. Kropki informują o ilości wizyt w danym dniu.',
      'imagePath': 'assets/images/instr2.png',
    },
  ];

  void _togglePage() {
    setState(() {
      if (_currentPageIndex == 0) {
        _currentPageIndex = 1;
      } else {
        Navigator.of(context).pop(); // Zamknij alert dialog
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.white,
      title: Text(_pages[_currentPageIndex]['title']),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            _pages[_currentPageIndex]['imagePath'],
          ),
          SizedBox(height: 16),
          Text(_pages[_currentPageIndex]['description']),
          SizedBox(
            height: 12,
          ),
          DotsIndicator(
            dotsCount: 2,
            position: double.parse(_currentPageIndex.toString()),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: _togglePage,
          child: Text(_currentPageIndex == 0 ? 'Pokaż Drugi Ekran' : 'Zamknij'),
        ),
      ],
    );
  }
}
