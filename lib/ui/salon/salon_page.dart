import '../../widget/icon_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../routes.dart';
import '../../widget/error_item.dart';
import '../../widget/loading_item.dart';
import 'controller/salon_controller.dart';

class SalonPage extends StatelessWidget {
  final String salonId;

  const SalonPage(this.salonId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SalonController(
        context,
        salonId,
      ),
      builder: (context, _) {
        return buildLayout(context);
      },
    );
  }

  Widget buildLayout(
    BuildContext context,
  ) {
    final controller = context.watch<SalonController>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          splashRadius: 24,
        ),
        actions: [
          IconPopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                child: Text('Send Feedback'),
                value: 1,
              ),
            ],
            onSelected: (value) {
              if (value == 1) {
                Navigator.of(context).pushNamed(Routes.salonFeedbackRoute(salonId));
              }
            },
          ),
        ],
        title: controller.salon == null ? null : Text(controller.salon!.name),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: selectView(context, controller),
      ),
    );
  }

  Widget selectView(
    BuildContext context,
    SalonController controller,
  ) {
    if (controller.error != null) {
      return ErrorItem(
        error: controller.error!,
        onRetry: controller.getSalonData(),
      );
    } else if (controller.salon == null) {
      return const LoadingItem();
    } else {
      final salon = controller.salon!;

      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (salon.image != null)
            SizedBox.square(
              dimension: 320,
              child: Image.network(
                salon.image!,
                errorBuilder: (context, error, stack) => const DecoratedBox(
                  decoration: BoxDecoration(color: Colors.red),
                ),
              ),
            ),
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: const Icon(Icons.date_range_sharp),
                onPressed: controller.selectDate,
                splashRadius: 24,
              ),
              hintText: 'Select Date',
              labelText: 'Select Date',
            ),
            readOnly: true,
            onTap: controller.selectDate,
            controller: controller.selectedDateTextController,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: const Icon(Icons.access_alarm),
                onPressed: controller.selectTime,
                splashRadius: 24,
              ),
              hintText: 'Select Time',
              labelText: 'Select Time',
            ),
            readOnly: true,
            onTap: controller.selectTime,
            controller: controller.selectedTimeTextController,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: controller.dateSelected ? controller.createBooking : null,
            child: const Text('Confirm Booking'),
          )
        ],
      );
    }
  }
}
