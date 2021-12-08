import 'package:flutter/material.dart';

// A dialog that stays up while a Future is running, and returns the result of the Future when done, or its error
class LoadingDialog extends AlertDialog {
  final Future future;
  final String message;

  const LoadingDialog({
    required this.future,
    required this.message,
    Key? key,
  }) : super(key: key);

  @override
  Widget? get content => FutureBuilder(
        future: (future),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Navigator.pop(context, snapshot.data!);
          } else if (snapshot.hasError) {
            Navigator.pop(context, snapshot.error);
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  message + "...",
                  maxLines: 2,
                ),
              ),
            ],
          );
        },
      );

  @override
  EdgeInsets get insetPadding => const EdgeInsets.all(24);
}
