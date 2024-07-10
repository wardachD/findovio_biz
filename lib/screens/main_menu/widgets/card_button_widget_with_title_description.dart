import 'package:flutter/material.dart';

class CardButtonWidgetWithTitleDescription extends StatelessWidget {
  final IconData? iconData;
  final String? title;
  final String? description;
  final String? buttonText;
  final Color? buttonColor;
  final double? fontSize;
  final bool? deleteBorder;
  final VoidCallback onPressed;
  final BoxBorder? border;
  final Color? fontColor;
  final bool isDisabled;
  final bool? isReadyCardIndicator;
  final BoxShadow boxShadow;

  const CardButtonWidgetWithTitleDescription({
    super.key, // Klucz widgetu
    this.iconData,
    this.title,
    this.description,
    this.buttonText,
    this.buttonColor,
    this.deleteBorder,
    this.boxShadow = const BoxShadow(color: Colors.transparent),
    this.fontSize,
    required this.onPressed,
    this.border,
    this.fontColor,
    required this.isDisabled,
    this.isReadyCardIndicator =
        false, // Domyślna wartość dla isReadyCardIndicator
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.9,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: isDisabled ? Colors.grey[200] : Colors.white,
        border: isDisabled ? null : border,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [boxShadow],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) const SizedBox(height: 10),
          if (isReadyCardIndicator == true)
            Container(
              height: 30,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.green, // Kolor zielony
                borderRadius: BorderRadius.circular(10), // Zaokrąglenie rogów
              ),
              padding: const EdgeInsets.all(6),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.check_circle_rounded, // Ikona plusa w kółku zębatym
                    color: Colors.white, // Kolor biały dla ikony
                    size: 18,
                  ),
                  Text(
                    'Gotowe',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          if (title != null)
            Text(
              title ?? '',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: fontSize ?? 26,
                color:
                    isDisabled ? const Color.fromARGB(255, 95, 95, 95) : null,
              ),
            ),
          if (description != null) const SizedBox(height: 10),
          if (description != null)
            Text(
              description ?? '',
              textAlign: TextAlign.left,
              style: TextStyle(
                color:
                    isDisabled ? const Color.fromARGB(255, 95, 95, 95) : null,
              ),
            ),
          const SizedBox(height: 20),
          OutlinedButton(
            style: ButtonStyle(
              backgroundColor: isDisabled
                  ? MaterialStateProperty.all<Color>(Colors.grey)
                  : buttonColor != null
                      ? MaterialStateProperty.all<Color>(buttonColor!)
                      : null,
              side: deleteBorder != null
                  ? MaterialStateProperty.all(const BorderSide(
                      color: Colors.transparent,
                    ))
                  : null,
            ),
            onPressed: onPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (iconData != null) Icon(iconData),
                Text(
                  buttonText ?? '',
                  style: TextStyle(
                    color: fontColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
