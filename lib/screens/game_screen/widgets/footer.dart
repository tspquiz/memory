import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  final int level;
  final int nCompletedPairs;
  final int ofTotalPairs;
  const Footer({
    required this.level,
    required this.nCompletedPairs,
    required this.ofTotalPairs,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.lightBlue.shade200,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            spreadRadius: 5,
            blurRadius: 10,
            offset: Offset.zero,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        right: false,
        left: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Nivå $level '),
            const SizedBox(width: 20),
            Text('Samlade par: $nCompletedPairs av $ofTotalPairs'),
          ],
        ),
      ),
    );
  }
}
