import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyCarsPage extends StatelessWidget {
  const MyCarsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Wrap(
          alignment: MediaQuery.of(context).size.width < 768
              ? WrapAlignment.start
              : WrapAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2.0,
                          blurRadius: 4.0,
                          offset: const Offset(2.0, 2.0),
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
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text("Hyundai i30 2012"),
                              Text("1.6 Gas 90hp"),
                              Text("56 000km"),
                              Text("Bought 12.06.2014")
                            ],
                          ),
                          const SizedBox(width: 64.0),
                          Expanded(
                            child: Column(
                              children: [
                                Image.asset(
                                  "images/car1.jpg",
                                  fit: BoxFit.fill,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2.0,
                          blurRadius: 4.0,
                          offset: const Offset(2.0, 2.0),
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
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text("Hyundai i30 2012"),
                              Text("1.6 Gas 90hp"),
                              Text("56 000km"),
                              Text("Bought 12.06.2014")
                            ],
                          ),
                          const SizedBox(width: 64.0),
                          Expanded(
                            child: Column(
                              children: [
                                Image.asset(
                                  "images/car1.jpg",
                                  fit: BoxFit.fill,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2.0,
                          blurRadius: 4.0,
                          offset: const Offset(2.0, 2.0),
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
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text("Hyundai i30 2012"),
                              Text("1.6 Gas 90hp"),
                              Text("56 000km"),
                              Text("Bought 12.06.2014")
                            ],
                          ),
                          const SizedBox(width: 64.0),
                          Expanded(
                            child: Column(
                              children: [
                                Image.asset(
                                  "images/car1.jpg",
                                  fit: BoxFit.fill,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
