import 'package:async/async.dart';
import '../../../model/salon.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';

class PopularSalonsController with ChangeNotifier {
  CancelableOperation? _request;

  List<Salon>? salons;

  PopularSalonsController() {
    _request = CancelableOperation.fromFuture(getPopularSalons());
  }

  getPopularSalons() async {
    try {
      final response = await firestore.collection('salons').where('popular', isEqualTo: true).get();

      salons = response.docs
          .map(
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
          )
          .toList();

      notifyListeners();
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    super.dispose();

    _request?.cancel();
  }
}
