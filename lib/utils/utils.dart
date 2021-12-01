import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

extension ExceptionType on Exception {
  String get message {
    if(kDebugMode) {
      return toString();
    } else {
      if(this is TimeoutException || this is SocketException) {
        return 'Network connectivity is limited or unavailable';
      } else {
        return 'Unknown error, try again';
      }
    }
  }
}
