import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import "../../widget/error_item.dart";
import '../../widget/loading_item.dart';
import 'controller/bookings_controller.dart';
import 'widget/booking_item.dart';

class BookingsPage extends StatelessWidget {
  const BookingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BookingsController(context),
      builder: (context, _) {
        return buildLayout(context);
      },
    );
  }

  Widget buildLayout(
    BuildContext context,
  ) {
    final controller = context.watch<BookingsController>();

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
          title: const Text('Appointments'),
      ),
      // Animated Switcher is used to show an animation when changing between view states of the page
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: selectView(context, controller),
      ),
    );
  }

  // selectView returns a state of the view depending on the controller.
  // Error view if there is an error
  // Loading view if the data is being loaded
  // Data view if the data is ready
  Widget selectView(
    BuildContext context,
    BookingsController controller,
  ) {
    final selectedPeriod = controller.selectedPeriod;

    if (controller.error != null) {
      return ErrorItem(
        error: controller.error!,
        onRetry: controller.getBookings(),
      );
    } else if (controller.bookings == null) {
      return const LoadingItem();
    } else {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: selectedPeriod == 0
                      ? ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButtonTheme.of(context).style!.copyWith(
                                elevation: MaterialStateProperty.all(0),
                              ),
                          child: const Text('PAST'),
                        )
                      : OutlinedButton(
                          onPressed: () {
                            controller.selectedPeriod = 0;
                          },
                          style: ElevatedButtonTheme.of(context).style!.copyWith(
                                elevation: MaterialStateProperty.all(0),
                              ),
                          child: const Text('PAST'),
                        ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: selectedPeriod == 1
                      ? ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButtonTheme.of(context).style!.copyWith(
                                elevation: MaterialStateProperty.all(0),
                              ),
                          child: const Text('FUTURE'),
                        )
                      : OutlinedButton(
                          onPressed: () {
                            controller.selectedPeriod = 1;
                          },
                          style: ElevatedButtonTheme.of(context).style!.copyWith(
                                elevation: MaterialStateProperty.all(0),
                              ),
                          child: const Text('FUTURE'),
                        ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              key: ValueKey(selectedPeriod),
              itemCount: selectedPeriod == 1 ? controller.futureBookings!.length : controller.pastBookings!.length,
              itemBuilder: (context, index) {
                // Either show Future bookings or Past bookings depending on the selection
                final bookings =
                    selectedPeriod == 1 ? controller.futureBookings![index] : controller.pastBookings![index];

                return BookingItem(
                  booking,
                  key: ValueKey(booking.id),
                );
              },
            ),
          )
        ],
      );
    }
  }
}
