import 'package:flutter/material.dart';
import 'package:flutter_ddd_firebase/domain/notes/note_failure.dart';

class CriticalFailureDisplay extends StatelessWidget {
  final NoteFailure failure;

  const CriticalFailureDisplay({super.key, required this.failure});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          failure.maybeMap(
            insufficientPermission: (value) => "Insufficient permissions",
            orElse: () => "Unexpected error.\nPlease contact support.",
          ),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24),
        ),
      ],
    );
  }
}
