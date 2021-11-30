import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controller/popular_salons_controller.dart';
import 'widget/salon_item.dart';

class PopularSalonsPage extends StatelessWidget {
  const PopularSalonsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PopularSalonsController(),
      builder: (context, _) {
        return buildLayout(context);
      },
    );
  }

  Widget buildLayout(
    BuildContext context,
  ) {
    final controller = context.watch<PopularSalonsController>();

    if (controller.salons == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: controller.salons!.length,
        itemBuilder: (context, index) => SalonItem(
          controller.salons![index],
          onTap: (salon) {},
        ),
      );
    }
  }
}
