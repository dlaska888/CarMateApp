import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_frontend/models/car.dart';

class CarCard extends StatelessWidget {
  final Car _car;

  const CarCard(Car car, {super.key}) : _car = car;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _car.name ?? '',
                        style: const TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      Text(_car.model ?? ''),
                      Text(_car.brand ?? ''),
                      Text(_car.displacement != null ? _car.displacement.toString() : ''),
                      Text(_car.productionDate?.toString() ?? ''),
                      Text(_car.mileage != null ? _car.mileage.toString() : ''),
                      Text(_car.purchaseDate?.toString() ?? ''),
                      Text(_car.plate ?? ''),
                      Text(_car.vin ?? ''),
                    ],
                  ),
                  const SizedBox(width: 64.0),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Expanded(
                      child: Column(
                        children: [
                          Image.asset(
                            "images/car1.jpg",
                            fit: BoxFit.fill,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
