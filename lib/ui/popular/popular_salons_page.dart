import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widget/error_item.dart';
import '../../widget/loading_item.dart';
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

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: selectView(context, controller),
    );
  }

  Widget selectView(
    BuildContext context,
    PopularSalonsController controller,
  ) {
    if (controller.error != null) {
      return ErrorItem(
        error: controller.error!,
        onRetry: controller.getPopularSalons(),
      );
    } else if (controller.salons == null) {
      return const LoadingItem();
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
