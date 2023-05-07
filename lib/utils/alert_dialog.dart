import 'package:flutter/material.dart';

/// Adds .showAlert() to BuildContext
extension Alert on BuildContext {
  /// Shows an alert dialog
  Future<void> showAlert({
    required Widget title,
    Widget? content,
    String okButtonCaption = 'OK',
  }) async {
    return showDialog(
      context: this,
      builder: (context) => AlertDialog(
        title: title,
        content: content,
        actions: [
          TextButton(
            child: Text(okButtonCaption),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }
}
