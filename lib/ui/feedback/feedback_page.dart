import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controller/feedback_controller.dart';

class FeedbackPage extends StatelessWidget {
  final String salonId;

  const FeedbackPage(this.salonId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FeedbackController(
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
    final controller = context.watch<FeedbackController>();

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
        title: const Text('Send Feedback'),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: selectView(context, controller),
      ),
    );
  }

  Widget selectView(
    BuildContext context,
    FeedbackController controller,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'You can send us a feedback about the salon',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Feedback',
            alignLabelWithHint: true,
          ),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.newline,
          onChanged: (text) {
            controller.feedbackText = text;
          },
          minLines: 10,
          maxLines: 10,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: controller.sendFeedback,
          child: Text('Send Feedback'.toUpperCase()),
        ),
      ],
    );
  }
}
