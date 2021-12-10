import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// date format
import 'package:intl/intl.dart';

import '../../../main.dart';
import '../../../model/booking.dart';
import '../../../model/salon.dart';
import '../../../utils/extensions.dart';
import '../../../utils/utils.dart';
import '../../../widget/loading_dialog.dart';

class SalonController with ChangeNotifier {
  CancelableOperation? _request;

  final String salonId;
  Salon? salon;

  final BuildContext _context;

  ScaffoldMessengerState get _scaffoldMessenger => ScaffoldMessenger.of(_context);

  Exception? error;

  TextEditingController selectedDateTextController = TextEditingController();
  DateTime? selectedDate;

  TextEditingController selectedTimeTextController = TextEditingController();
  DateTime? selectedTime;

  bool get dateSelected => selectedDate != null && selectedTime != null;

  SalonController(
    this._context,
    this.salonId,
  ) {
    getSalonData();
  }

  getSalonData() {
    _request = CancelableOperation.fromFuture(_getSalonData());
  }

  _getSalonData() async {
    try {
      if (error != null) {
        error = null;
        notifyListeners();
      }

      final response = await firestore.collection('salons').doc(salonId).get();

      final map = response.data()!;

      salon = Salon(
        uuid: salonId,
        name: map['name'] as String,
        city: map['city'] as String,
        address: map['address'] as String,
        image: map['image'] as String?,
      );
    } on Exception catch (e) {
      error = e;
    }

    notifyListeners();
  }

  selectDate() {
    showDatePicker(
      context: _context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    ).then((value) {
      // If the user selects a date, grab the date and format it for the user to see it
      // Also clear the selected time to inform the user that they need to select a new time
      if (value != null) {
        selectedDate = value;

        selectedDateTextController.text = DateFormat('EEE, dd MMM yyyy').format(value);

        selectedTime = null;

        selectedTimeTextController.text = '';

        notifyListeners();
      }
    });
  }

  selectTime() {
    showTimePicker(
      context: _context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      // If the user selects a time, we first check if this time is in the past, as there is no way to disable selecting past times
      // If the time is valid, we clear the minutes from the selection, as we are only interested in the hour
      // Then we format the time for showing to the user
      if (value != null) {
        final currentSelection = value.toDateTime();

        if (selectedDate!.day == DateTime.now().day &&
            selectedDate!.month == DateTime.now().month &&
            currentSelection.hour <= DateTime.now().hour + 2) {
          _scaffoldMessenger.showMessageSnackBar('Selected time must be 2 hours before');
        } else {
          selectedTime = value.toDateTime();
          selectedTime = selectedTime!.subtract(Duration(minutes: value.minute));

          selectedTimeTextController.text = DateFormat('hh:mm aa').format(selectedTime!);

          notifyListeners();
        }
      }
    });
  }

  createBooking() {
    showDialog(
      context: _context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: LoadingDialog(
          future: _createBooking(),
          message: 'Creating Booking...',
        ),
      ),
    ).then((value) {
      if (value is Exception) {
        _scaffoldMessenger.showMessageSnackBar(value.message);
      } else if (value == true) {
        _scaffoldMessenger.showMessageSnackBar('Booking Created!');
      } else {
        _scaffoldMessenger.showMessageSnackBar('Selected date and time are already booked');
      }
    });
  }

  _createBooking() async {
    final bookingTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
    );

    // When creating a booking, we first check if there exist any bookings that are at the exact same time
    // But we also check if this booking is not cancelled (by customer or salon)
    final salonBookings = await firestore
        .collection('bookings')
        .where(
          'salon',
          isEqualTo: firestore.collection('salons').doc(salonId),
        )
        .where(
          'date',
          isEqualTo: bookingTime,
        )
        .get();

    final bookings = salonBookings.docs.map((e) {
      final map = e.data();

      return Booking(
        id: e.id,
        date: (map['date'] as Timestamp).toDate(),
        status: map['status'] as String,
      );
    }).where((element) => element.status != 'Cancelled').toList();

    if (bookings.isEmpty) {
      final booking = await firestore.collection('bookings').doc().set({
        'salon': firestore.collection('salons').doc(salonId),
        'date': bookingTime,
        'user': firestore.collection('users').doc(auth.currentUser!.uid),
        'status': 'Pending',
      });

      // Send a notification to all the Users associated with the Salon
      _sendNotification(
        bookingTime: bookingTime,
      );

      return true;
    } else {
      return false;
    }
  }

  _sendNotification({
    required DateTime bookingTime,
  }) async {
    final tokens = <String>[];

    final users = await firestore
        .collection('users')
        .where(
          'salon',
          isEqualTo: firestore.collection('salons').doc(salonId),
        )
        .get();

    for (var element in users.docs) {
      if (element.data()['token'] != null) {
        tokens.add(element.data()['token']);
      }
    }

    final bookingTimeText = DateFormat('EEE, dd MMM yyyy hh:mm aa').format(bookingTime);

    if (tokens.isNotEmpty) {
      sendNotifications(
        ids: tokens,
        title: 'New Booking',
        text: 'A new booking has been made on $bookingTimeText',
      );
    }
  }

  @override
  void dispose() {
    super.dispose();

    _request?.cancel();
  }
}
