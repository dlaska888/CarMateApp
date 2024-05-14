import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_frontend/helpers/api_client.dart';
import 'package:flutter_frontend/helpers/api_endpoints.dart';
import 'package:flutter_frontend/models/car_mate_user.dart';
import 'package:flutter_frontend/helpers/notification_service.dart';
import 'package:flutter_frontend/screens/dashboard_pages/components/user_avatar.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

class DashboardDrawer extends StatefulWidget {
  final Function(int) setSelectedPage;

  const DashboardDrawer(this.setSelectedPage, {super.key});

  @override
  State<DashboardDrawer> createState() => _DashboardDrawerState();
}

class _DashboardDrawerState extends State<DashboardDrawer> {
  late Future<CarMateUser> _futureUser;

  Future<CarMateUser> fetchUser() {
    return ApiClient.sendRequest("${ApiEndpoints.accountEndpoint}/me",
            methodFun: http.get, authorizedRequest: true)
        .then((response) {
      return CarMateUser.fromJson(response);
    }).catchError((error) {
      NotificationService.showNotification("$error", type: MessageType.error);
      throw error;
    });
  }

  @override
  initState() {
    super.initState();
    _futureUser = fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    return FutureBuilder(
      future: _futureUser,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          log("Error loading settings: ${snapshot.error}");
          return const Center(
            child: Text("Could not load user"),
          );
        }

        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final user = snapshot.data as CarMateUser;

        return Drawer(
            backgroundColor: primary,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () => Scaffold.of(context).closeDrawer(),
                          icon: const Icon(
                            Icons.menu_rounded,
                            color: Colors.white,
                          )),
                      IconButton(
                          onPressed: () => Scaffold.of(context).closeDrawer(),
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                          )),
                    ],
                  ),
                  Column(
                    children: [
                      UserAvatar(user),
                      const SizedBox(height: 32),
                      Column(children: [
                        Text(user.username,
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(fontSize: 16.0)),
                        Text(user.email,
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(fontSize: 16.0)),
                      ]),
                      const SizedBox(height: 32),
                      Column(
                        children: [
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              widget.setSelectedPage(3);
                              Scaffold.of(context).closeDrawer();
                            },
                            label: const Text("Settings"),
                            icon: const Icon(Icons.settings),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () => context.go('/login'),
                            label: const Text("Log out"),
                            icon: const Icon(Icons.logout),
                          )
                        ],
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.directions_car,
                          color: Colors.white,
                          size: 48.0,
                        ),
                        Text("CarMate",
                            style:
                                TextStyle(color: Colors.white, fontSize: 24.0))
                      ],
                    ),
                  )
                ],
              ),
            ));
      },
    );
  }
}
