import 'package:async/async.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../model/salon.dart';

class SalonsListController with ChangeNotifier {
  CancelableOperation? _request;

  List<Salon>? _allSalons;
  List<Salon>? salons;

  bool searchOpened = false;

  Exception? error;

  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController listScrollController = ScrollController();

  TextEditingController get textController => _textController;

  FocusNode get focusNode => _focusNode;

  String searchTerm = '';
  String? selectedCity;

  SalonsListController() {
    getAllSalons();
  }

  getAllSalons() {
    _request = CancelableOperation.fromFuture(_getAllSalons());
  }

  _getAllSalons() async {
    try {
      if (error != null) {
        error = null;
        notifyListeners();
      }

      final response = await firestore.collection('salons').get();

      _allSalons = response.docs.map(
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

      salons = _allSalons;
    } on Exception catch (e) {
      error = e;
    }

    notifyListeners();
  }

  void startSearch() {
    searchOpened = true;
    focusNode.requestFocus();

    notifyListeners();
  }

  void stopSearch() {
    searchOpened = false;
    focusNode.unfocus();
    textController.clear();

    salons = _allSalons;

    notifyListeners();
  }

  // applySearch simply searches the already acquired Salons
  // As we don't have a large dataset yet, we can get away with Local search instead of Server search
  void applySearch(
    String searchText,
    String? city,
  ) {
    searchTerm = searchText;
    selectedCity = city;

    salons = _allSalons!.where((element) {
      final matchAddress = city != null ? element.city == city : true;

      return matchAddress &&
          (element.name.toLowerCase().contains(searchText.toLowerCase()) ||
              element.address.toLowerCase().contains(searchText.toLowerCase()));
    }).toList();

    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();

    _request?.cancel();
  }
}
