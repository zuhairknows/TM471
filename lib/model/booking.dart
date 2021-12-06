import 'salon.dart';
import 'user.dart';

class Booking {
  final String id;
  final DateTime date;
  final String status;
  final Salon? salon;
  final User? user;

  Booking({
    required this.id,
    required this.date,
    required this.status,
    this.salon,
    this.user,
  });
}
