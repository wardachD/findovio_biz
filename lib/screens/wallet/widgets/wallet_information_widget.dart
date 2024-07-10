import 'package:flutter/material.dart';

class WalletInformationWidget extends StatelessWidget {
  final double? width;
  final double height;
  final IconData icon;
  final String title;
  final Widget contentWidget;
  final VoidCallback? onDetailsPressed;
  final String? detailsButtonText;

  const WalletInformationWidget({
    super.key,
    this.width,
    required this.height,
    required this.icon,
    required this.title,
    required this.contentWidget,
    this.onDetailsPressed,
    this.detailsButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 12),
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: const Color.fromARGB(255, 243, 243, 243),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: const Color.fromARGB(255, 228, 228, 228),
                  ),
                  child: Icon(
                    icon,
                    size: 32,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title.toUpperCase(),
                        style: const TextStyle(
                          color: Color.fromARGB(255, 82, 82, 82),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      contentWidget,
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (onDetailsPressed != null && detailsButtonText != null)
            Material(
              borderRadius: BorderRadius.circular(6),
              color: const Color.fromARGB(255, 228, 228, 228),
              child: InkWell(
                onTap: onDetailsPressed,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  child: Row(
                    children: [
                      Text('${detailsButtonText!} '),
                      const Icon(Icons.open_in_new, size: 18),
                    ],
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
