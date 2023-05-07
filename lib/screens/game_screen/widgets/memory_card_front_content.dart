import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:memory/models/sign.dart';
import 'package:memory/models/view_settings.dart';
import 'package:memory/screens/game_screen/widgets/card_video_player.dart';
import 'package:memory/utils/alert_dialog.dart';
import 'package:provider/provider.dart';

class MemoryCardFrontContent extends StatelessWidget {
  final Sign sign;
  final bool completed;
  const MemoryCardFrontContent({
    required this.sign,
    required this.completed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<ViewSettings>(context, listen: true);

    // Show player or text at bottom of stack
    if (settings.showVideo) {
      return _buildVideoFace(context);
    } else {
      return SizedBox.expand(
        child: Center(
          child: Text(
            sign.word,
            style: const TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  Widget _buildVideoFace(BuildContext context) {
    return Semantics(
      label: sign.word,
      child: CardVideoPlayer(
        url: sign.videoUrl,
        onLoadError: () async {
          // If a video fails to load, change memory to text mode.
          final settings =
              Provider.of<ViewSettings>(context, listen: false);
          if (settings.showVideo) {
            await context.showAlert(
              title: const Text('Lyckades inte läsa in video'),
              content: const Text('Byter till text-läge'),
            );
            settings.showVideo = false;
          }
        },
        key: Key(sign.videoUrl),
      ),
    );
  }
}
