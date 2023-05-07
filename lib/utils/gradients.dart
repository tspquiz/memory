import 'package:flutter/material.dart';

final menuBackgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.lerp(Colors.white, Colors.lightBlue.shade100, 0.2)!,
      Color.lerp(Colors.white, Colors.lightBlue.shade100, 0.7)!,
    ]);

final gameBackgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Colors.white,
      Color.lerp(Colors.white, Colors.lightBlue.shade100, 0.5)!,
    ]);
