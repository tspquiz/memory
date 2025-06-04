import 'dart:math';

import 'package:flutter/material.dart';

/// This widget represent a memory card that can flip and show either
/// a front widget or a back widget.
class MemoryCard extends StatefulWidget {
  /// Should the frontside be shown? If false, the backside is shown.
  final bool showFrontSide;

  /// Front side of the card
  final Widget front;

  /// Back side of the card
  final Widget back;
  const MemoryCard({
    required this.showFrontSide,
    required this.front,
    required this.back,
    super.key,
  });

  @override
  State<MemoryCard> createState() => _MemoryCardState();
}

class _MemoryCardState extends State<MemoryCard> {
  final _flipXAxis = true;
  late bool _showFrontSide = false;

  @override
  void didUpdateWidget(covariant MemoryCard oldWidget) {
    setState(() {
      _showFrontSide = widget.showFrontSide;
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return _buildFlipAnimation();
  }

  Widget _buildFlipAnimation() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: __transitionBuilder,
      layoutBuilder: (widget, list) =>
          Stack(children: [if (widget != null) widget, ...list]),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeIn.flipped,
      child: Container(
        key: ValueKey(_showFrontSide),
        child: _showFrontSide ? widget.front : widget.back,
      ),
    );
  }

  Widget __transitionBuilder(Widget widget, Animation<double> animation) {
    final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);
    return AnimatedBuilder(
      animation: rotateAnim,
      child: widget,
      builder: (context, widget) {
        final isUnder = (ValueKey(_showFrontSide) != widget?.key);
        var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
        tilt *= isUnder ? -1.0 : 1.0;
        final value = isUnder
            ? min(rotateAnim.value, pi / 2)
            : rotateAnim.value;
        return Transform(
          transform: _flipXAxis
              ? (Matrix4.rotationY(value)..setEntry(3, 0, tilt))
              : (Matrix4.rotationX(value)..setEntry(3, 1, tilt)),
          alignment: Alignment.center,
          child: widget,
        );
      },
    );
  }
}
