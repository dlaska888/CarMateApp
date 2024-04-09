import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_frontend/catemateapp_theme.dart';
import 'package:intl/intl.dart';

class MyCarsPage extends StatelessWidget {
  const MyCarsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MediaQuery.of(context).size.width < 768
          ? MainAxisAlignment.start
          : MainAxisAlignment.center,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // Set background color (optional)
                borderRadius: BorderRadius.circular(
                    10.0), // Add rounded corners (optional)
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Shadow color
                    spreadRadius: 2.0, // Adjusts shadow spread (optional)
                    blurRadius: 4.0, // Adjusts shadow blur (optional)
                    offset:
                        const Offset(2.0, 2.0), // Sets shadow offset (optional)
                  ),
                ],
              ),
              margin: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "My car name",
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        Text("Hyundai i30 2012"),
                        Text("1.6 Gas 90hp"),
                        Text("56 000km"),
                        Text("Bought 12.06.2014")
                      ],
                    ),
                    Column(
                      children: [Image.asset("images/car1.jpg", height: 100)],
                    )
                  ],
                ),
              )),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // Set background color (optional)
                borderRadius: BorderRadius.circular(
                    10.0), // Add rounded corners (optional)
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Shadow color
                    spreadRadius: 2.0, // Adjusts shadow spread (optional)
                    blurRadius: 4.0, // Adjusts shadow blur (optional)
                    offset:
                        const Offset(2.0, 2.0), // Sets shadow offset (optional)
                  ),
                ],
              ),
              margin: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "My car name",
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        Text("Hyundai i30 2012"),
                        Text("1.6 Gas 90hp"),
                        Text("56 000km"),
                        Text("Bought 12.06.2014")
                      ],
                    ),
                    Column(
                      children: [Image.asset("images/car1.jpg", height: 100)],
                    )
                  ],
                ),
              )),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // Set background color (optional)
                borderRadius: BorderRadius.circular(
                    10.0), // Add rounded corners (optional)
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Shadow color
                    spreadRadius: 2.0, // Adjusts shadow spread (optional)
                    blurRadius: 4.0, // Adjusts shadow blur (optional)
                    offset:
                        const Offset(2.0, 2.0), // Sets shadow offset (optional)
                  ),
                ],
              ),
              margin: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "My car name",
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        Text("Hyundai i30 2012"),
                        Text("1.6 Gas 90hp"),
                        Text("56 000km"),
                        Text("Bought 12.06.2014")
                      ],
                    ),
                    Column(
                      children: [Image.asset("images/car1.jpg", height: 100)],
                    )
                  ],
                ),
              )),
        ),
      ],
    );
  }
}
