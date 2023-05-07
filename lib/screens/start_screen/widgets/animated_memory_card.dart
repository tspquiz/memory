
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:memory/screens/game_screen/widgets/memory_card.dart';

class AnimatedMemoryCard extends StatefulWidget {
  final Widget front;
  final Widget back;

  const AnimatedMemoryCard({required this.front, required this.back, super.key});

  @override
  State<AnimatedMemoryCard> createState() => _AnimatedMemoryCardState();
}

class _AnimatedMemoryCardState extends State<AnimatedMemoryCard> {
  bool _showFrontSide = true;
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 10), flip);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void flip(Timer invoker) {
    setState(() {
      _showFrontSide = !_showFrontSide;
    }); 
  }

  @override
  Widget build(BuildContext context) {
    return MemoryCard(
      showFrontSide: _showFrontSide,
      front: widget.front,
      back: widget.back,
    );
  }
}