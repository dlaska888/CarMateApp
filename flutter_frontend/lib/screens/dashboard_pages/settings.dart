import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    final screenWidth = MediaQuery.of(context).size.width;

    return Expanded(
      child: SingleChildScrollView(
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
                              color:
                                  Colors.white, // Set background color (optional)
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
                                  offset: const Offset(
                                      2.0, 2.0), // Sets shadow offset (optional)
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(64.0),
                            child: Column(
                              children: [
                                const CircleAvatar(
                                  radius: 150,
                                  backgroundImage: AssetImage("images/car1.jpg"),
                                ),
                                const SizedBox(height: 32),
                                Column(children: [
                                  Text("Your name",
                                      style: TextStyle(
                                          fontSize: 32.0,
                                          fontWeight: FontWeight.bold,
                                          color: primary)),
                                  Text("email@gmail.com",
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color: primary)),
                                ]),
                              ],
                            ),
                            // ... other Container properties (width, height, child)
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
                              onPressed: () {},
                              child: const Text("Change username"),
                            ),
                            
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {},
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
                              onPressed: (){},
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
      ),
    );
  }
}
