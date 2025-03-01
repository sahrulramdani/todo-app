import 'package:flutter/material.dart';

SnackBar customSnackbarComp({
  required String message,
  required String severity,
}) {
  IconData icon = Icons.check_circle_outline;
  Color background = Colors.green[300]!;

  if (severity == 'error') {
    icon = Icons.cancel_outlined;
    background = Colors.red[300]!;
  }

  return SnackBar(
    content: Row(
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(width: 10),
        Expanded(
          child: Text(message, style: const TextStyle(color: Colors.white)),
        ),
      ],
    ),
    backgroundColor: background,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    margin: const EdgeInsets.fromLTRB(16, 0, 16, 60),
    duration: const Duration(seconds: 3),
  );
}
