import 'package:flutter/material.dart';

import '../../../model/salon.dart';

class SalonItem extends StatelessWidget {
  final Salon salon;
  final Function(Salon) onTap;

  const SalonItem(
    this.salon, {
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        onTap(salon);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox.square(
            dimension: 120,
            child: Image.network(
              salon.image ?? '',
              errorBuilder: (context, error, stack) => const DecoratedBox(
                decoration: BoxDecoration(color: Colors.red),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            salon.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 4),
          Text(
            '${salon.address}, ${salon.city}',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface.withAlpha(0x66),
            ),
          ),
        ],
      ),
    );
  }
}
