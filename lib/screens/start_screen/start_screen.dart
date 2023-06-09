import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:memory/screens/start_screen/widgets/adaptive_link.dart';
import 'package:memory/utils/gradients.dart';
import 'package:url_launcher/link.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: menuBackgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Spacer(),
              Material(
                clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadius.circular(20),
                elevation: 0,
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: SvgPicture.asset('assets/icon.svg'),
                ),
              ),
              const SizedBox(height: 8),
              Text('TSP Memory', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 30),
              _buildStartGameButton(context, Colors.blue.shade700),
              const Spacer(),
              _buildTspQuizAttribution(context),
              _buildLexiconAttribution(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStartGameButton(BuildContext context, Color color) {
    return ElevatedButton.icon(
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(color),
        shape: MaterialStatePropertyAll(
            ContinuousRectangleBorder(borderRadius: BorderRadius.circular(20))),
      ),
      onPressed: () {
        context.go('/game');
      },
      icon: const Icon(Icons.play_arrow),
      label: const Text('Starta spel'),
    );
  }

  /// Using _buildXYZ is actually an anti-pattern in Flutter.
  /// Better performance is obtained if you create separate
  /// stateless widgets, like with AttributionLink widget below.
  Widget _buildLexiconAttribution(BuildContext context) {
    return const AttributionLink(
      text: 'Videofilmer från Svenskt teckenspråkslexikon CC-BY-SA-NC',
      url: 'https://teckensprakslexikon.su.se/',
    );
  }

  Widget _buildTspQuizAttribution(BuildContext context) {
    return const AttributionLink(
      text: 'Använder TSP Quiz API',
      url: 'https://tspquiz.se/',
    );
  }
}

class AttributionLink extends StatelessWidget {
  final String text;
  final String url;
  const AttributionLink({required this.text, required this.url, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AdaptiveLink(
        builder: (context, followLink) => TextButton(
          style: const ButtonStyle(
            visualDensity: VisualDensity.compact,
            textStyle: MaterialStatePropertyAll<TextStyle>(TextStyle(
              fontSize: 10,
            )),
            foregroundColor: MaterialStatePropertyAll<Color>(Colors.black),
          ),
          child: Text(text),
          onPressed: () => followLink!(),
        ),
        uri: Uri.parse(url),
      ),
    );
  }
}
