import 'package:flutter/material.dart';

class HandSelector extends StatelessWidget {
  final void Function(int) onSelected;

  const HandSelector({required this.onSelected, super.key});

  // Map numbers to word-based image filenames
  static const List<String> _numberImages = [
    'one.png',
    'two.png',
    'three.png',
    'four.png',
    'five.png',
    'six.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (i) {
            final number = i + 1;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: InkWell(
                  onTap: () => onSelected(number),
                  child: Image.asset(
                    'graphics/${_numberImages[i]}',
                    width: 60,
                    height: 60,
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (i) {
            final number = i + 4;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: InkWell(
                  onTap: () => onSelected(number),
                  child: Image.asset(
                    'graphics/${_numberImages[i + 3]}',
                    width: 60,
                    height: 60,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
