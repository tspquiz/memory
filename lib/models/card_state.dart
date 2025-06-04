import 'package:memory/models/sign.dart';

/// Holds the state of a memory card
class CardState {
  final Sign sign;
  bool showFrontSide;
  bool completed;
  bool hidden;

  CardState({required this.sign})
    : showFrontSide = false,
      completed = false,
      hidden = false;
}
