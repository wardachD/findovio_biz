import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final Color? buttonColor;
  final Decoration? decoration;
  final BorderRadius? borderRadius;
  final String? text;
  final Color? textColor;
  final bool? isNext;
  final bool? isBack;

  const CustomButton({
    Key? key,
    this.onTap,
    this.width,
    this.height,
    this.buttonColor,
    this.decoration,
    this.borderRadius,
    this.text,
    this.textColor,
    this.isNext,
    this.isBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap ?? () {},
        child: Container(
          alignment: Alignment.center,
          width: width ?? MediaQuery.of(context).size.width,
          height: height ?? MediaQuery.of(context).size.height * 0.05,
          decoration: isBack == true
              ? BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                  ),
                  borderRadius: borderRadius ?? BorderRadius.circular(12),
                  color: buttonColor,
                )
              : isNext == true
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.orange,
                    )
                  : decoration ??
                      BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius: borderRadius ?? BorderRadius.circular(12),
                        color: buttonColor,
                      ),
          child: Text(
            text ?? (isNext != null ? 'Dalej' : 'Cofnij'),
            style: TextStyle(
              color: textColor ??
                  (isNext == true
                      ? Colors.white
                      : Color.fromARGB(255, 43, 43, 43)),
            ),
          ),
        ),
      ),
    );
  }
}
