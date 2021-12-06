import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/src/provider.dart';

import '../../../model/booking.dart';
import '../controller/salon_bookings_controller.dart';

class SalonBookingItem extends StatelessWidget {
  final Booking booking;

  const SalonBookingItem(this.booking, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = booking.user!;
    final bookingsController = context.read<SalonBookingsController>();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${user.first_name} ${user.last_name}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    user.phone,
                  ),
                  Text(
                    DateFormat('EEEE, dd MMM yyyy').format(booking.date),
                  ),
                  Text(
                    DateFormat('hh:mm aa').format(booking.date),
                  ),
                  Text(
                    booking.status,
                  ),
                ],
              ),
            ),
            if (booking.status != 'Cancelled' && booking.status != 'Confirmed')
              SizedBox(
                height: 48,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (booking.date.isAfter(DateTime.now().add(const Duration(hours: 1))) &&
                          booking.status != 'Cancelled')
                        TextButton(
                          onPressed: () {
                            bookingsController.cancelBooking(booking);
                          },
                          child: Text('CANCEL'),
                        ),
                      if (booking.date.isAfter(DateTime.now().add(const Duration(hours: 1))) &&
                          booking.status != 'Confirmed')
                        TextButton(
                          onPressed: () {
                            bookingsController.confirmBooking(booking);
                          },
                          child: Text('CONFIRM'),
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
