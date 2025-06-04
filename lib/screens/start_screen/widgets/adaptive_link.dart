import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

/// Builds a Link() on web, but otherwise launches
/// uri with launchUri on other platforms.
class AdaptiveLink extends StatelessWidget {
  final Uri uri;
  final LinkWidgetBuilder builder;
  const AdaptiveLink({required this.uri, required this.builder, super.key});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Link(uri: uri, builder: builder);
    }
    return builder(context, openLink);
  }

  Future<void> openLink() async {
    launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
