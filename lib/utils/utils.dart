import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

extension ExceptionType on Exception {
  String get message {
    if (kDebugMode) {
      return toString();
    } else {
      if (this is TimeoutException || this is SocketException) {
        return 'Network connectivity is limited or unavailable';
      } else {
        return 'Unknown error, try again';
      }
    }
  }
}

extension TimeOfDayExtension on TimeOfDay {
  DateTime toDateTime() {
    return DateTime(0, 0, 0, hour, minute);
  }
}

sendNotifications({
  required List<String> ids,
  required String title,
  required String text,
}) async {
  final response = await http.post(
    Uri.https('fcm.googleapis.com', 'fcm/send'),
    body: jsonEncode({
      'registration_ids': ids,
      'notification': {
        'title': title,
        'body': text,
      }
    }),
    headers: {
      'Content-Type': "application/json",
      'Authorization':
          'key=AAAAIYF2ESs:APA91bHjYVP5hZFE2UsOtOt8u2I2ejvoTEfMKtrZk9VaW6-jAn4Hup_qh6g8dAuSPgaQi-UQN48_SGde-irTtailrKE3_LDjyWd-vLyLuExqi53BbrqSrutWX17sNdEpGzG3NIZe1Pu2',
    },
  );

  if (kDebugMode) print(response);
}
