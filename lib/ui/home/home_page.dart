import 'dart:convert';

import 'package:barber_salon/ui/salon_bookings/salon_bookings_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    final user = jsonDecode(preferences.getString('user')!);

    final userIsOwner = user['salon'] != null;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(!userIsOwner ? 'Popular Salons' : 'Appointments'),
        actions: [
          if (!userIsOwner)
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(Routes.SALONS);
              },
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
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Welcome',
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 4),
                  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: firestore.collection('users').doc(auth.currentUser!.uid).snapshots(),
                    builder: (context, snapshot) {
                      final data = snapshot.data;

                      if (data != null) {
                        final user = data.data()!;

                        return Text(
                          '${user['first_name']} ${user['last_name']}',
                          style: const TextStyle(fontSize: 20),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  )
                ],
              ),
            ),
            ListTile(
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);

                Navigator.of(context).pushNamed(Routes.PROFILE);
              },
            ),
            if (!userIsOwner)
              ListTile(
                title: const Text('Appointments'),
                onTap: () {
                  Navigator.pop(context);

                  Navigator.of(context).pushNamed(Routes.BOOKINGS);
                },
              ),
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
            ),
          ],
        ),
      ),
      body: userIsOwner ? const SalonBookingsPage() : const PopularSalonsPage(),
    );
  }
}
