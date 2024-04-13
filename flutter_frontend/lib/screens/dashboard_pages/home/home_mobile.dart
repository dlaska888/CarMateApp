import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePageMobile extends StatelessWidget {
  const HomePageMobile({super.key});

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).primaryColor;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            decoration: BoxDecoration(
              color: Colors.white, // Set background color (optional)
              borderRadius:
                  BorderRadius.circular(10.0), // Add rounded corners (optional)
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Tires",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      Text(DateFormat.yMMMd().format(DateTime.now()))
                    ],
                  ),
                  Column(
                    children: [
                      Icon(
                        Icons.tire_repair,
                        color: primary,
                        size: 40.0,
                      )
                    ],
                  )
                ],
              ),
            )
            // ... other Container properties (width, height, child)
            ),
        Container(
            decoration: BoxDecoration(
              color: Colors.white, // Set background color (optional)
              borderRadius:
                  BorderRadius.circular(10.0), // Add rounded corners (optional)
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
                        "Engine Oil",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      Text("15 000km")
                    ],
                  ),
                  Column(
                    children: [
                      Icon(
                        Icons.engineering,
                        color: primary,
                        size: 40.0,
                      )
                    ],
                  )
                ],
              ),
            )
            // ... other Container properties (width, height, child)
            ),
        Container(
            decoration: BoxDecoration(
              color: Colors.white, // Set background color (optional)
              borderRadius:
                  BorderRadius.circular(10.0), // Add rounded corners (optional)
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Breaking discs",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      Text(DateFormat.yMMMd().format(DateTime.now()))
                    ],
                  ),
                  Column(
                    children: [
                      Icon(
                        Icons.disc_full,
                        color: primary,
                        size: 40.0,
                      )
                    ],
                  )
                ],
              ),
            )
            // ... other Container properties (width, height, child)
            ),
      ],
    );
  }
}
