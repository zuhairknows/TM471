class Salon {
  final String uuid;
  final String name;
  final String address;
  final String city;
  final String? image;

  Salon({
    required this.uuid,
    required this.name,
    required this.address,
    required this.city,
    this.image,
  });
}
