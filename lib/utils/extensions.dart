import 'package:flutter/material.dart';

// An extension to avoid calling a long method whenever we need to show a SnackBar message
extension ScaffoldSnackBar on ScaffoldMessengerState {
  showMessageSnackBar(
    String message,
  ) {
    showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
