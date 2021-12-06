import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/src/provider.dart';

import '../../../model/booking.dart';
import '../controller/bookings_controller.dart';

class BookingItem extends StatelessWidget {
  final Booking booking;

  const BookingItem(this.booking, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final salon = booking.salon!;
    final bookingsController = context.read<BookingsController>();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          children: [
            Row(
              children: [
                SizedBox.square(
                  dimension: 108,
                  child: Image.network(
                    salon.image ?? '',
                    errorBuilder: (context, error, stack) => const DecoratedBox(
                      decoration: BoxDecoration(color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        salon.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${salon.address}, ${salon.city}',
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
              ],
            ),
            if (booking.date.isAfter(DateTime.now().add(const Duration(hours: 1))) && booking.status != 'Cancelled')
              SizedBox(
                height: 48,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          bookingsController.cancelBooking(booking);
                        },
                        child: Text('CANCEL'),
                      )
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
