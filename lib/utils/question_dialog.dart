import 'package:flutter/material.dart';

/// Adds .askQuestion() to BuildContext
extension Question on BuildContext {
  /// Shows a dialog with a question.
  ///
  /// Returns the button text of the given answer or null if user dismissed
  /// question without answering.
  Future<String?> askQuestion({
    required Widget title,
    Widget? body,
    required List<String> answers,
  }) async {
    return showDialog<String>(
      context: this,
      builder: (context) => AlertDialog(
        title: title,
        content: body,
        actions: answers
            .map((a) => TextButton(
                  onPressed: () => Navigator.of(context).pop(a),
                  child: Text(a.toUpperCase()),
                ))
            .toList(),
      ),
    );
  }
}
