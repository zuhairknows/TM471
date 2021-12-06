import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widget/error_item.dart';
import '../../widget/loading_item.dart';
import '../popular/widget/salon_item.dart';
import '../register/controller/register_controller.dart';
import 'controller/salons_list_controller.dart';

class SalonsListPage extends StatelessWidget {
  const SalonsListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SalonsListController(),
      builder: (context, _) {
        return buildLayout(context);
      },
    );
  }

  Widget buildLayout(
    BuildContext context,
  ) {
    final controller = context.watch<SalonsListController>();

    return Scaffold(
      appBar: AppBar(
        titleSpacing: controller.searchOpened ? 0 : null,
        actions: [
          if (!controller.searchOpened && controller.salons != null)
            IconButton(
              onPressed: () {
                controller.startSearch();
              },
              tooltip: 'Search',
              icon: const Icon(Icons.search),
              splashRadius: 24,
            ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          splashRadius: 24,
        ),
        title: !controller.searchOpened
            ? const Text('Salons')
            : TextField(
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary.withAlpha(0x66),
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                  ),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      controller.stopSearch();
                    },
                    iconSize: 24,
                    splashRadius: 24,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
                textAlignVertical: TextAlignVertical.center,
                maxLines: 1,
                onChanged: (searchText) {
                  controller.applySearch(searchText, controller.selectedCity);
                },
                textCapitalization: TextCapitalization.words,
                focusNode: controller.focusNode,
                controller: controller.textController,
                autocorrect: false,
              ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: selectView(context, controller),
      ),
    );
  }

  Widget selectView(
    BuildContext context,
    SalonsListController controller,
  ) {
    if (controller.error != null) {
      return ErrorItem(
        error: controller.error!,
        onRetry: controller.getAllSalons(),
      );
    } else if (controller.salons == null) {
      return const LoadingItem();
    } else {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'City',
                isDense: true,
              ),
              isDense: true,
              onChanged: (text) {
                controller.applySearch(controller.searchTerm, text);
              },
              items: [
                const DropdownMenuItem(child: Text('All'), value: null),
                ...addressValues.map((e) {
                  return DropdownMenuItem(child: Text(e), value: e);
                }).toList()
              ],
            ),
          ),
          Expanded(
            child: controller.salons!.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text(
                        'No Results found',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : GridView.builder(
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
                  ),
          )
        ],
      );
    }
  }
}
