import 'package:flutter/material.dart';

class DashboardTileActionWidget extends StatelessWidget {
  final String? title;
  final String? description;
  final VoidCallback? onTap;
  final Color? color;
  final Color? buttonColor;
  final bool? highlight;
  final Color? borderColor;
  final double? width;
  final double? height;
  final double? fontTitleSize;
  final Color? fontColor;
  final double? fontDescriptionSize;
  final Color? iconColor;
  final String? imagePath;
  final IconData? iconFile;

  const DashboardTileActionWidget({
    super.key,
    this.title,
    this.description,
    this.onTap,
    this.color,
    this.buttonColor,
    this.highlight = false,
    this.borderColor,
    this.width,
    this.height,
    this.fontTitleSize,
    this.fontColor,
    this.fontDescriptionSize,
    this.iconColor,
    this.imagePath,
    this.iconFile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? MediaQuery.of(context).size.width * 0.5 - 18,
      height: height ?? 140,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: borderColor ?? Colors.transparent,
            width: borderColor != null ? 1 : 0),
        boxShadow: [
          highlight != null && highlight == true
              ? const BoxShadow(
                  color: Color.fromARGB(255, 255, 172, 64), blurRadius: 5)
              : const BoxShadow(
                  color: Color.fromARGB(255, 245, 245, 245),
                  blurRadius: 8,
                )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              if (imagePath != null)
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: imagePath != null
                        ? Image.asset(
                            imagePath!,
                            fit: BoxFit.fill,
                          )
                        : Container(color: Colors.black),
                  ),
                ),
              Positioned(
                bottom: 12,
                right: 12,
                child: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                      color: buttonColor,
                      borderRadius: BorderRadius.circular(60),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(255, 255, 255, 255),
                          blurRadius: 8,
                        )
                      ]),
                  child: Center(
                    child: Icon(
                      iconFile ?? Icons.subdirectory_arrow_right,
                      color: iconColor ?? Colors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title ?? '',
                      style: TextStyle(
                        fontSize: fontTitleSize ?? 18,
                        fontWeight: FontWeight.bold,
                        color:
                            fontColor ?? const Color.fromARGB(255, 43, 43, 43),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description ?? '',
                      style: TextStyle(
                        fontSize: fontDescriptionSize ?? 22,
                        color:
                            fontColor ?? const Color.fromARGB(255, 73, 73, 73),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
