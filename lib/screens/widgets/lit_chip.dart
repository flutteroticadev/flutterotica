import 'package:flutter/material.dart';
import 'package:flutterotica/env/colors.dart';

class LitChip extends StatelessWidget {
  const LitChip({
    super.key,
    required this.text,
    this.textFontSize = 16,
    required this.label,
    this.labelFontSize = 16,
    this.textBackgroundColor = kRed,
    this.labelBackgroundColor = Colors.transparent,
  });

  final String text;
  final double? textFontSize;
  final String label;
  final double? labelFontSize;
  final Color? textBackgroundColor;
  final Color? labelBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
          decoration: BoxDecoration(
            color: labelBackgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(5),
              bottomLeft: Radius.circular(5),
            ),
            border: Border.all(
              color: textBackgroundColor!,
            ),
          ),
          child: Text(
            label.toUpperCase(),
            style: TextStyle(
              color: labelBackgroundColor!.computeLuminance() > 0.4 ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 0.5, horizontal: 4),
          decoration: BoxDecoration(
            color: textBackgroundColor,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(5),
              bottomRight: Radius.circular(5),
            ),
          ),
          child: Text(
            text.toUpperCase(),
            style: TextStyle(
              color: textBackgroundColor!.computeLuminance() > 0.4 ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: textFontSize,
            ),
          ),
        ),
      ],
    );
  }
}
