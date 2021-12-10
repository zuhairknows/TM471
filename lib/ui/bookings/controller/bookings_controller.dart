import 'dart:async';

import 'package:barber_salon/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../main.dart';
import '../../../model/booking.dart';
import '../../../model/salon.dart';
import '../../../utils/extensions.dart';
import '../../../widget/loading_dialog.dart';

class BookingsController with ChangeNotifier {
  StreamSubscription? _streamListener;
  final BuildContext _context;

  ScaffoldMessengerState get _scaffoldMessenger => ScaffoldMessenger.of(_context);

  List<Booking>? bookings;

  List<Booking>? futureBookings;
  List<Booking>? pastBookings;

  Exception? error;

  int _selectedPeriod = 1;

  int get selectedPeriod => _selectedPeriod;

  set selectedPeriod(int value) {
    _selectedPeriod = value;

    notifyListeners();
  }

  BookingsController(this._context) {
    getBookings();
  }

  getBookings() {
    // Cancel the previous listener, if one exists
    _streamListener?.cancel();

    // Create a new listner on the bookings collection, and map the data to the bookings list when any changes occur
    _streamListener = firestore
        .collection('bookings')
        .where(
          'user',
          isEqualTo: firestore.collection('users').doc(auth.currentUser!.uid),
        )
        .snapshots()
        .listen((event) => _getBookings(event.docs));
  }
//  convert database data into objects
  _getBookings(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) async {
    try {
      if (bookings != null) {
        bookings!.clear();
      } else {
        bookings = [];
      }

      for (QueryDocumentSnapshot<Map<String, dynamic>> e in docs) {
        final map = e.data();
        final salonMap = await (map['salon'] as DocumentReference).get();

        final booking = Booking(
          id: e.id,
          date: (map['date'] as Timestamp).toDate(),
          status: map['status'] as String,
          salon: Salon(
            uuid: (map['salon'] as DocumentReference).id,
            name: salonMap['name'] as String,
            city: salonMap['city'] as String,
            address: salonMap['address'] as String,
            image: salonMap['image'] as String?,
          ),
        );

        bookings!.add(booking);
      }

      futureBookings = bookings!.where((e) => e.date.isAfter(DateTime.now())).toList();

      pastBookings = bookings!.where((e) => e.date.isBefore(DateTime.now())).toList();
    } on Exception catch (e) {
      error = e;
    }

    notifyListeners();
  }

  cancelBooking(Booking booking) {
    showDialog(
      context: _context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Appointment'),
        content: const Text('Are you sure you want to cancel this appointment?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    ).then((value) {
      if (value == true) {
        showDialog(
          context: _context,
          barrierDismissible: false,
          builder: (context) => WillPopScope(
            onWillPop: () async => false,
            child: LoadingDialog(
              future: _cancelBooking(booking),
              message: 'Cancelling Appointment...',
            ),
          ),
        ).then((value) {
          if (value is Exception) {
            _scaffoldMessenger.showMessageSnackBar(value.toString());
          } else {
            _scaffoldMessenger.showMessageSnackBar('Appointment Cancelled');
          }
        });
      }
    });
  }

  _cancelBooking(Booking booking) async {
    await firestore.collection('bookings').doc(booking.id).update({
      'status': 'Cancelled',
    });

    final tokens = <String>[];

    // Collect the users associated with this Salon, and collect the Tokens for each user to send a notification to each
    final users = await firestore
        .collection('users')
        .where(
          'salon',
          isEqualTo: firestore.collection('salons').doc(booking.salon!.uuid),
        )
        .get();

    for (var element in users.docs) {
      if (element.data()['token'] != null) {
        tokens.add(element.data()['token']);
      }
    }

    if(tokens.isNotEmpty) {
      sendNotifications(
        ids: tokens,
        title: 'New Booking',
        text: 'Appointment at ${DateFormat('EEE, dd MMM yyyy hh:mm aa').format(booking.date)} has been cancelled',
      );
    }

    return true;
  }

  @override
  void dispose() {
    super.dispose();

    _streamListener?.cancel();
  }
}
