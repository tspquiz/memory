import 'package:flutter/material.dart';
import 'package:memory/models/view_settings.dart';
import 'package:provider/provider.dart';

class ViewSettingButtons extends StatelessWidget {
  const ViewSettingButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<ViewSettings>(context, listen: true);
    return ToggleButtons(
      constraints: const BoxConstraints(
        minHeight: 40.0,
        minWidth: 60.0,
      ),
      isSelected: [
        settings.showVideo,
        !settings.showVideo,
      ],
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      fillColor: Colors.blue.shade900,
      selectedColor: Colors.white,
      borderColor: Colors.blue.shade900,
      selectedBorderColor: Colors.blue.shade900,
      children: const [
        Text('Video'),
        Text('Text'),
      ],
      onPressed: (index) {
        final settings = Provider.of<ViewSettings>(context, listen: false);
        settings.showVideo = index == 0;
      },
    );
  }
}
