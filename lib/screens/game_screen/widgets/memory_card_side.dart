import 'package:flutter/material.dart';

class MemoryCardSide extends StatelessWidget {
  /// The content to show on this card side
  final Widget content;

  /// Background color of card side
  final Color backgroundColor;

  /// Event handler for when the card side is tapped.
  final void Function()? onTap;

  // Width and height of a memory card side
  static const size = 100.0;

  const MemoryCardSide({
    required this.content,
    required this.backgroundColor,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      // For accessibility, I use an elevated button here which will provide
      // keyboard navigation support. To disable the elevation shadow, I set
      // elevation to 0.
      child: ElevatedButton(
        onPressed: onTap,
        clipBehavior: Clip.antiAlias,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.all(0)),
          elevation: MaterialStateProperty.all<double?>(0),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
          ),
        ),
        child: content,
      ),
    );
  }
}
