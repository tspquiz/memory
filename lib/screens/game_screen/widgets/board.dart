import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:memory/models/card_state.dart';
import 'package:memory/screens/game_screen/widgets/memory_card.dart';
import 'package:memory/screens/game_screen/widgets/memory_card_back_content.dart';
import 'package:memory/screens/game_screen/widgets/memory_card_front_content.dart';
import 'package:memory/screens/game_screen/widgets/memory_card_side.dart';

/// This widget renders the game board which will display a MemoryCard for
/// each CardState in the data array.
class Board extends StatelessWidget {
  final List<CardState> data;
  final Function(int index) onReveal;
  const Board({required this.data, required this.onReveal, super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final nColumns = max(2, sqrt(data.length).ceil());
      final nRows = (data.length / nColumns).ceil();
      final cellSize = min(
        min(constraints.maxWidth / nColumns,
            MemoryCardSide.size + (nColumns + 1) * 10),
        min(constraints.maxHeight / nRows, MemoryCardSide.size + (nRows + 1) * 10),
      );
      final leftRightPadding =
          (constraints.maxWidth - (cellSize * nColumns)) / 2;
      final topBottomPadding = (constraints.maxHeight - (cellSize * nRows)) / 2;

      return GridView.count(
        crossAxisCount: nColumns,
        addAutomaticKeepAlives: true,
        padding: EdgeInsets.only(
          left: leftRightPadding,
          right: leftRightPadding,
          top: topBottomPadding,
          bottom: topBottomPadding,
        ),
        children: [
          ...data
              .mapIndexed((int index, CardState cardState) =>
                  _buildMemoryCard(context, index, cardState))
              .toList(),
        ],
      );
    });
  }

  Widget _buildMemoryCard(
    BuildContext context,
    int index,
    CardState cardState,
  ) {
    bool allCompleted = data.where((card) => !card.completed).isEmpty;
    return Padding(
      key: Key('$index grid-cell'),
      padding: const EdgeInsets.all(1),
      child: Center(
        child: AnimatedOpacity(
          opacity: cardState.hidden ? 0.0 : 1.0,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeIn,
          child: AnimatedScale(
            scale: cardState.hidden ? 0.0 : (cardState.completed && !allCompleted ? 0.9 : 1.0),
            curve: Curves.easeIn,
            duration: const Duration(milliseconds: 400),
            child: Semantics(
              label: 'Kort ${index + 1}',
              // The MemoryCard is responsible for the flipping
              child: MemoryCard(
                showFrontSide: cardState.showFrontSide,
                front: MemoryCardSide(
                  backgroundColor: cardState.completed
                      ? Colors.green.shade300
                      : Colors.grey.shade400,
                  content: MemoryCardFrontContent(
                    sign: cardState.sign,
                    completed: cardState.completed,
                    key: Key('${cardState.sign.id} memory-card-front-content'),
                  ),
                ),
                back: MemoryCardSide(
                  backgroundColor: Colors.lightBlue,
                  content: const MemoryCardBackContent(),
                  onTap: () {
                    onReveal(index);
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
