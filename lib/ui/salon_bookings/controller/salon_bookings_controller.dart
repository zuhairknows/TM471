import 'dart:async';
import 'dart:convert';

import 'package:barber_salon/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../main.dart';
import '../../../model/booking.dart';
import '../../../model/user.dart';
import '../../../utils/extensions.dart';
import '../../../widget/loading_dialog.dart';

class SalonBookingsController with ChangeNotifier {
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

  SalonBookingsController(this._context) {
    getBookings();
  }

  getBookings() {
    _streamListener?.cancel();

    final user = jsonDecode(preferences.getString('user')!);

    _streamListener = firestore
        .collection('bookings')
        .where(
          'salon',
          isEqualTo: firestore.collection('salons').doc(user['salon']),
        )
        .snapshots()
        .listen((event) => _getBookings(event.docs));
  }

  _getBookings(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) async {
    try {
      if (bookings != null) {
        bookings!.clear();
      } else {
        bookings = [];
      }

      for (QueryDocumentSnapshot<Map<String, dynamic>> e in docs) {
        final map = e.data();
        final userMap = await (map['user'] as DocumentReference).get();

        final booking = Booking(
          id: e.id,
          date: (map['date'] as Timestamp).toDate(),
          status: map['status'] as String,
          user: User(
            uuid: (map['user'] as DocumentReference).id,
            first_name: userMap['first_name'] as String,
            last_name: userMap['last_name'] as String,
            phone: userMap['phone'] as String,
            city: userMap['city'] as String,
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
    final user = booking.user!;

    showDialog(
      context: _context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Appointment'),
        content: Text.rich(
          TextSpan(children: [
            const TextSpan(text: 'Are you sure you want to cancel this appointment with '),
            TextSpan(
              style: const TextStyle(fontWeight: FontWeight.bold),
              text: '${user.first_name} ${user.last_name}',
            ),
            const TextSpan(text: ' at '),
            TextSpan(
              style: const TextStyle(fontWeight: FontWeight.bold),
              text: DateFormat('EEE, dd MMM yyyy hh:mm aa').format(booking.date),
            ),
          ]),
        ),
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

  confirmBooking(Booking booking) {
    final user = booking.user!;

    showDialog(
      context: _context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Appointment'),
        content: Text.rich(
          TextSpan(children: [
            const TextSpan(text: 'Are you sure you want to confirm this appointment with '),
            TextSpan(
              style: const TextStyle(fontWeight: FontWeight.bold),
              text: '${user.first_name} ${user.last_name}',
            ),
            const TextSpan(text: ' at '),
            TextSpan(
              style: const TextStyle(fontWeight: FontWeight.bold),
              text: DateFormat('EEE, dd MMM yyyy hh:mm aa').format(booking.date),
            ),
          ]),
        ),
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
              future: _confirmBooking(booking),
              message: 'Confirming Appointment...',
            ),
          ),
        ).then((value) {
          if (value is Exception) {
            _scaffoldMessenger.showMessageSnackBar(value.toString());
          } else {
            _scaffoldMessenger.showMessageSnackBar('Appointment Confirmed');
          }
        });
      }
    });
  }

  _cancelBooking(Booking booking) async {
    await firestore.collection('bookings').doc(booking.id).update({
      'status': 'Cancelled',
    });

    final user = await firestore.collection('users').doc(booking.user!.uuid).get();
    final userData = user.data()!;

    if (userData['token'] != null) {
      await sendNotifications(
        ids: [userData['token']],
        title: 'Appointment cancelled',
        text: 'Appointment at ${DateFormat('EEE, dd MMM yyyy hh:mm aa').format(booking.date)} has been cancelled',
      );
    }

    return true;
  }

  _confirmBooking(Booking booking) async {
    await firestore.collection('bookings').doc(booking.id).update({
      'status': 'Confirmed',
    });

    final user = await firestore.collection('users').doc(booking.user!.uuid).get();
    final userData = user.data()!;

    if (userData['token'] != null) {
      await sendNotifications(
        ids: [userData['token']],
        title: 'Appointment confirmed',
        text: 'Appointment at ${DateFormat('EEE, dd MMM yyyy hh:mm aa').format(booking.date)} has been confirmed',
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
