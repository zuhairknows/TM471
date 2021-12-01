import 'package:flutter/material.dart';
import '../utils/utils.dart';

class ErrorItem extends StatelessWidget {
  final VoidCallback onRetry;
  final Exception error;

  const ErrorItem({
    required this.error,
    required this.onRetry,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              error.message,
              style: const TextStyle(
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          OutlinedButton(
            onPressed: onRetry,
            child: const Text(
              "Retry",
            ),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
      ),
    );
  }
}
