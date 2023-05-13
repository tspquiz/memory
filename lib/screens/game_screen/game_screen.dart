import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:go_router/go_router.dart';
import 'package:memory/api/sign_api.dart';
import 'package:memory/models/card_state.dart';
import 'package:memory/screens/game_screen/widgets/board.dart';
import 'package:memory/screens/game_screen/widgets/footer.dart';
import 'package:memory/screens/game_screen/widgets/view_setting_buttons.dart';
import 'package:memory/utils/gradients.dart';
import 'package:memory/utils/question_dialog.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int _level = 1;
  List<CardState> _board = [];

  @override
  void initState() {
    super.initState();
    _newGame(_level);
  }

  Future<void> _newGame(int level) async {
    final nPairs = level + 2;
    // Clear the board so we can show a loading state.
    setState(() {
      _board.clear();
    });
    // Announce to screen reader that a loading process has started.
    SemanticsService.announce('Laddar', TextDirection.ltr);

    // Grab some random signs from the API
    final signs = await getRandomSigns(nPairs);
    if (!mounted) return;

    // Add two cards for each sign to a new board array
    List<CardState> newBoard = [];
    newBoard.addAll(signs.map((s) => CardState(sign: s)));
    newBoard.addAll(signs.map((s) => CardState(sign: s)));

    // Shuffle all cards
    newBoard.shuffle();

    // Update widget state => repaint
    setState(() {
      _board = newBoard;
      _level = level;
    });
    // Announce to screen readers that the level has loaded
    SemanticsService.announce(
        'Ny nivå har startat med $nPairs par', TextDirection.ltr);
  }

  /// Callback from when a card is tapped to reveal the front
  Future<void> onReveal(int flipIndex) async {
    if (!mounted) return;
    final flippedCount =
        _board.where((card) => card.showFrontSide && !card.completed).length;
    if (flippedCount >= 2) {
      setState(() {
        for (var card in _board) {
          if (!card.completed) {
            card.showFrontSide = false;
          }
        }
      });
    }
    final flipCard = _board[flipIndex];
    if (flipCard.showFrontSide) {
      // Do nothing if the card has already been flipped.
      return;
    }
    final otherCard = _board
        .whereIndexed((index, card) =>
            card.sign.id == flipCard.sign.id && index != flipIndex)
        .firstOrNull;
    if (otherCard == null) {
      throw Exception('Could not find pair');
    }

    // Flip card
    setState(() {
      flipCard.showFrontSide = true;
    });
    // Found pair?
    if (otherCard.showFrontSide) {
      setState(() {
        otherCard.completed = true;
        flipCard.completed = true;
      });
      // After a short delay, hide the completed pair
      if (!_isGameCompleted) {
        Future.delayed(const Duration(milliseconds: 600)).then((_) {
          if (!mounted) return;
          setState(() {
            otherCard.hidden = true;
            flipCard.hidden = true;
          });
        });
      } else {
        // Game completed => show all cards again
        for (var card in _board) {
          if (card.hidden) {
            setState(() => card.hidden = false);
            await Future.delayed(const Duration(milliseconds: 50));
            if (!mounted) return;
          }
        }
      }
    }

    // For screen readers, announce when a pair was found.
    // Tip: on iOS you can enable closed captions for VoiceOver
    var semanticMessage = '${flipCard.sign.word}. ';
    if (otherCard.showFrontSide) {
      if (_isGameCompleted) {
        semanticMessage += 'Du har slutfört nivån. ';
      } else {
        semanticMessage += 'Par hittat. ';
      }
    }
    SemanticsService.announce(semanticMessage, TextDirection.ltr);
    // Uncomment to show a snackbar with the semantic message
    //ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //  content: Text(semanticMessage),
    //));
  }

  /// Obtain number of completed pairs
  int get _nCompleted => _board.where((card) => card.completed).length;

  /// Has all pairs in the game been completed?
  bool get _isGameCompleted =>
      _board.isNotEmpty && _nCompleted == _board.length;

  // Unless loading, show a bottom status bar
  bool get _showFooter => _board.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.black,
          ),
          tooltip: 'Avbryt spel',
          onPressed: () async {
            final navigator = Navigator.of(context);
            if (_isGameCompleted || await _askAbortGame()) {
              try {
                if (!mounted) return;
                navigator.pop();
              } catch (e) {
                if (!mounted) return;
                context.go('/');
              }
            }
          },
        ),
        backgroundColor: Colors.lightBlue.shade200,
        elevation: 0,
        title: const Text('Memory', style: TextStyle(color: Colors.black)),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 5.0),
            child: ViewSettingButtons(),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: gameBackgroundGradient,
        ),
        child: SafeArea(
          bottom: !_showFooter,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _board.isNotEmpty
                  // Loaded => show game board
                  ? Expanded(
                      child: Board(
                        data: _board,
                        onReveal: onReveal,
                      ),
                    )
                  // Loading state:
                  : Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: 20),
                            Text('Väljer ut tecken...',
                                style: Theme.of(context).textTheme.titleSmall),
                          ],
                        ),
                      ),
                    ),
              if (_showFooter)
                Footer(
                  level: _level,
                  nCompletedPairs: (_nCompleted / 2).floor(),
                  ofTotalPairs: (_board.length / 2).floor(),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: _isGameCompleted
          ? FloatingActionButton(
              backgroundColor: Colors.blue,
              tooltip: 'Nästa nivå',
              shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: const Icon(Icons.skip_next),
              onPressed: () {
                _newGame(_level + (_isGameCompleted ? 1 : 0));
              },
            )
          : null,
    );
  }

  /// Show a dialog asking user to confirm if they want to abort
  /// the game
  Future<bool> _askAbortGame() async {
    final answer = await context.askQuestion(
      title: const Text('Vill du avbryta spelet?'),
      answers: ['Ja', 'Nej'],
    );
    return answer == 'Ja';
  }
}
