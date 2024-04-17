import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: screenWidth > 768
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            decoration: BoxDecoration(
                              color: Colors
                                  .white, // Set background color (optional)
                              borderRadius: BorderRadius.circular(
                                  10.0), // Add rounded corners (optional)
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
                            margin: const EdgeInsets.all(8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Icon(
                                        Icons.directions_car,
                                        color: primary,
                                        size: 40.0,
                                      )
                                    ],
                                  ),
                                  const Text(
                                    "Maintenance",
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24.0, vertical: 16.0),
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                      textStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onPressed: () {},
                                    child: const Text("Add"),
                                  )
                                ],
                              ),
                            )),
                        Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
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
                            margin: const EdgeInsets.all(8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Tires",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(DateFormat.yMMMd()
                                          .format(DateTime.now()))
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
                              color: Colors
                                  .white, // Set background color (optional)
                              borderRadius: BorderRadius.circular(
                                  10.0), // Add rounded corners (optional)
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
                            margin: const EdgeInsets.all(8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Engine Oil",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
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
                              color: Colors
                                  .white, // Set background color (optional)
                              borderRadius: BorderRadius.circular(
                                  10.0), // Add rounded corners (optional)
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
                            margin: const EdgeInsets.all(8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Breaking discs",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(DateFormat.yMMMd()
                                          .format(DateTime.now()))
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
                      ]),
                ),
              ),
              if (screenWidth > 1000) const SizedBox(width: 50),
              if (screenWidth > 768)
                Flexible(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Column(
                      children: [
                        Container(
                            decoration: BoxDecoration(
                              color: Colors
                                  .white, // Set background color (optional)
                              borderRadius: BorderRadius.circular(
                                  10.0), // Add rounded corners (optional)
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
                            margin: const EdgeInsets.all(8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Icon(
                                        Icons.directions_car,
                                        color: primary,
                                        size: 40.0,
                                      )
                                    ],
                                  ),
                                  const Text(
                                    "Hyundai i30",
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24.0, vertical: 16.0),
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                      textStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onPressed: () {},
                                    child: const Text("Add Photo"),
                                  )
                                ],
                              ),
                            )
                            // ... other Container properties (width, height, child)
                            ),
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
                            margin: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              "images/car1.jpg",
                              width: 500,
                            )
                            // ... other Container properties (width, height, child)
                            ),
                        Wrap(
                          alignment: WrapAlignment.spaceEvenly,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                  color: Colors
                                      .white, // Set background color (optional)
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Add rounded corners (optional)
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
                                margin: const EdgeInsets.all(8.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Mileage",
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text("56 000km")
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 48,
                                      ),
                                      Column(
                                        children: [
                                          Icon(
                                            Icons.add_road,
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
                                  color: Colors
                                      .white, // Set background color (optional)
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Add rounded corners (optional)
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
                                margin: const EdgeInsets.all(8.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Engine",
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text("1.6 90hp")
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 48,
                                      ),
                                      Column(
                                        children: [
                                          Icon(
                                            Icons.directions_car,
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
                                  color: Colors
                                      .white, // Set background color (optional)
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Add rounded corners (optional)
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
                                margin: const EdgeInsets.all(8.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Production Date",
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text("2012")
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 48,
                                      ),
                                      Column(
                                        children: [
                                          Icon(
                                            Icons.access_time_filled,
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
                        )
                      ],
                    ),
                  ),
                )
            ],
          )
        ],
      ),
    );
  }
}
