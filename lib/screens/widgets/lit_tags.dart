import 'package:flutter/material.dart';
import 'package:lit_reader/env/colors.dart';
import 'package:lit_reader/models/tag.dart';

class LitTags extends StatelessWidget {
  const LitTags({
    super.key,
    required this.tag,
    this.height,
    this.onTap,
  });

  final Tag tag;
  final double? height;

  final Function()? onTap;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(right: 5),
        child: onTap != null
            ? GestureDetector(
                onTap: onTap,
                child: Text(
                  '#${tag.tag}',
                  style: TextStyle(
                    height: height ?? 1.6,
                    color: kRed,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : Text(
                '#${tag.tag}',
                style: TextStyle(
                  height: height ?? 1.6,
                  color: kRed,
                  fontWeight: FontWeight.bold,
                ),
              ),
      );
}
