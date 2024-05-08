import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_frontend/api_client.dart';
import 'package:flutter_frontend/api_endpoints.dart';
import 'package:flutter_frontend/models/car_mate_user.dart';
import 'package:flutter_frontend/notification_service.dart';
import 'package:flutter_frontend/screens/dashboard_pages/components/user_avatar.dart';
import 'package:flutter_frontend/screens/forms/account/change_password.dart';
import 'package:flutter_frontend/screens/forms/account/change_username.dart';
import 'package:flutter_frontend/screens/forms/form_modal.dart';
import 'package:flutter_frontend/screens/forms/upload_photo_form.dart';
import 'package:http/http.dart' as http;

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late CarMateUser _user;

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

  void addPhoto() {
    fetchUser().then((user) {
      setState(() {
        _user = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    final screenWidth = MediaQuery.of(context).size.width;

    return FutureBuilder(
      future: fetchUser(),
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

        _user = snapshot.data as CarMateUser;
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: screenWidth > 768
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: double.infinity),
                child: Wrap(
                  alignment: screenWidth > 768
                      ? WrapAlignment.spaceEvenly
                      : WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 500),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors
                                    .white, // Set background color (optional)
                                borderRadius: BorderRadius.circular(
                                    20.0), // Add rounded corners (optional)
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey
                                        .withOpacity(0.5), // Shadow color
                                    spreadRadius:
                                        2.0, // Adjusts shadow spread (optional)
                                    blurRadius:
                                        4.0, // Adjusts shadow blur (optional)
                                    offset: const Offset(2.0,
                                        2.0), // Sets shadow offset (optional)
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(64.0),
                              child: Column(
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        FormModal(context).showModal(
                                            UploadPhotoForm(
                                                '${ApiEndpoints.accountEndpoint}/profile-photo',
                                                addPhoto));
                                      },
                                      child: UserAvatar(_user)),
                                  const SizedBox(height: 32),
                                  Column(children: [
                                    Text(_user.username,
                                        style: TextStyle(
                                            fontSize: 32.0,
                                            fontWeight: FontWeight.bold,
                                            color: primary)),
                                    Text(_user.email,
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            color: primary)),
                                  ]),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ConstrainedBox(
                        constraints:
                            const BoxConstraints(maxWidth: 600, maxHeight: 400),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  FormModal(context).showModal(
                                      ChangeUsernameForm(
                                          () => {setState(() {})}));
                                },
                                child: const Text("Change username"),
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  FormModal(context).showModal(
                                      ChangePasswordForm(
                                          () => {setState(() {})}));
                                },
                                child: const Text("Change Password"),
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {},
                                child: const Text("Resend Verification Email"),
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {},
                                child: const Text("Enable 2FA"),
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {},
                                child: const Text("Delete Account"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
