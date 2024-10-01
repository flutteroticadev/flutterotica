import 'package:flutter/material.dart';

class LitBadge extends StatelessWidget {
  const LitBadge({
    super.key,
    required this.text,
    required this.color,
  });

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: color.computeLuminance() > 0.4 ? Colors.black : Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
