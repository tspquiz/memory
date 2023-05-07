import 'package:flutter/material.dart';

class ViewSettings extends ChangeNotifier {
  bool _showVideo;

  ViewSettings({required showVideo}): _showVideo = showVideo;

  set showVideo(bool value) {
    _showVideo = value;
    notifyListeners();
  }

  bool get showVideo => _showVideo;
}