import 'package:flutter/material.dart';
import 'package:flutter_frontend/models/car.dart';
import 'package:flutter_frontend/screens/dashboard_pages/home_components/car_field_card.dart';
import 'package:intl/intl.dart';

class CarCard extends StatelessWidget {
  final Car car;
  const CarCard(this.car, {super.key});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    return Flexible(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          children: [
            Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Set background color (optional)
                  borderRadius: BorderRadius.circular(
                      10.0), // Add rounded corners (optional)
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Shadow color
                      spreadRadius: 2.0, // Adjusts shadow spread (optional)
                      blurRadius: 4.0, // Adjusts shadow blur (optional)
                      offset: const Offset(
                          2.0, 2.0), // Sets shadow offset (optional)
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
                        children: [
                          Icon(
                            Icons.directions_car,
                            color: primary,
                            size: 40.0,
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            car.name,
                            style: const TextStyle(
                                fontSize: 24.0, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.fade,
                            softWrap: false,
                          ),
                          if (car.brand != null && car.model != null)
                            Text(
                              '${car.brand} ${car.model}',
                              overflow: TextOverflow.fade,
                              softWrap: false,
                            ),
                        ],
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 16.0),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          textStyle: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {},
                        child: const Text("Add Photo"),
                      )
                    ],
                  ),
                )),
            Container(
              decoration: BoxDecoration(
                color: Colors.white, // Set background color (optional)
                borderRadius: BorderRadius.circular(
                    20.0), // Add rounded corners (optional)
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.asset(
                  "images/car2.jpg",
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (car.displacement != null)
                  CarFieldCard("Engine displacement",
                      car.displacement!.toStringAsFixed(1), Icons.electric_car),
                if (car.mileage != null)
                  CarFieldCard(
                      "Milage", car.mileage.toString(), Icons.add_road),
                if (car.productionDate != null)
                  CarFieldCard(
                      "Production date",
                      DateFormat('yyyy-MM-dd').format(car.productionDate!),
                      Icons.access_time_filled),
                if (car.purchaseDate != null)
                  CarFieldCard(
                      "Purchase date",
                      DateFormat('yyyy-MM-dd').format(car.purchaseDate!),
                      Icons.shopping_cart),
              ],
            )
          ],
        ),
      ),
    );
  }
}
