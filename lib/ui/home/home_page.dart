import 'package:flutter/material.dart';

import '../../main.dart';
import '../../routes.dart';
import '../popular/popular_salons_page.dart';

class HomePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Popular Salons'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
            tooltip: 'Search',
            splashRadius: 24,
          )
        ],
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          splashRadius: 24,
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Sign Out'),
              onTap: () {
                Navigator.pop(context);

                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Sign Out'),
                    content: const Text('Are you sure you want to sign out?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: const Text('Yes'),
                      ),
                    ],
                  ),
                ).then((value) async {
                  if (value != null) {
                    await auth.signOut();
                    await preferences.remove('salon');

                    Navigator.popUntil(context, (_) => false);
                    Navigator.pushNamed(context, Routes.AUTH);
                  }
                });
              },
            )
          ],
        ),
      ),
      body: const PopularSalonsPage(),
    );
  }
}
