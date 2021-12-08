import 'package:async/async.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../model/salon.dart';

class PopularSalonsController with ChangeNotifier {
  CancelableOperation? _request;

  List<Salon>? salons;

  Exception? error;

  PopularSalonsController() {
    getPopularSalons();
  }

  getPopularSalons() {
    _request = CancelableOperation.fromFuture(_getPopularSalons());
  }

  _getPopularSalons() async {
    try {
      // Reset the error before launching a new request, to show the Loading state
      if (error != null) {
        error = null;
        notifyListeners();
      }

      final response = await firestore
          .collection('salons')
          .where('popular', isEqualTo: true)
          .get();

      salons = response.docs.map(
        (e) {
          final map = e.data();

          return Salon(
            uuid: e.id,
            name: map['name'] as String,
            city: map['city'] as String,
            address: map['address'] as String,
            image: map['image'] as String?,
          );
        },
      ).toList();
    } on Exception catch (e) {
      error = e;
    }

    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();

    _request?.cancel();
  }
}
