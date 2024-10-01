import 'package:flutter/material.dart';

class EmptyListIndicator extends StatefulWidget {
  const EmptyListIndicator({Key? key, this.text, this.subtext}) : super(key: key);

  final String? text;
  final String? subtext;
  @override
  State<EmptyListIndicator> createState() => _EmptyListIndicatorState();
}

class _EmptyListIndicatorState extends State<EmptyListIndicator> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.text ?? "Such Emptyness...",
            style: const TextStyle(color: Colors.grey, fontSize: 18, fontStyle: FontStyle.italic),
          ),
          if (widget.subtext != null)
            Text(
              widget.subtext!,
              style: TextStyle(color: Colors.grey.shade700, fontSize: 16, fontStyle: FontStyle.italic),
            ),
        ],
      ),
    );
  }
}
