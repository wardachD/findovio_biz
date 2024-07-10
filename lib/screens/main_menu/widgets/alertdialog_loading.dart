import 'package:flutter/material.dart';

class AlertDialogLoading extends StatelessWidget {
  final Color? barrierColor;
  final bool? barrierDismissible;
  final Color? backgroundColor;
  final Color? shadowColor;
  final Icon icon;
  final String title;
  final String message;
  final double? boxWidth;
  final double? boxHeight;
  final double? titleFontSize;
  final double? messageFontSize;
  final Widget? progressIndicator;

  const AlertDialogLoading({
    super.key,
    this.barrierColor,
    this.barrierDismissible,
    this.backgroundColor,
    this.shadowColor,
    required this.icon,
    required this.title,
    required this.message,
    this.boxWidth,
    this.boxHeight,
    this.titleFontSize,
    this.messageFontSize,
    this.progressIndicator,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: backgroundColor ?? Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 0,
      content: SizedBox(
        width: boxWidth ?? 100,
        height: boxHeight ?? 180,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon,
              SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: titleFontSize ?? 16,
                ),
              ),
              SizedBox(height: 4),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: messageFontSize ?? 14),
              ),
              SizedBox(height: 12),
              progressIndicator ?? LinearProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
