import 'package:flutter/material.dart';
import 'package:flutter_frontend/helpers/api_client.dart';
import 'package:flutter_frontend/helpers/api_endpoints.dart';
import 'package:flutter_frontend/models/car.dart';
import 'package:flutter_frontend/helpers/notification_service.dart';
import 'package:flutter_frontend/screens/dashboard_pages/components/photo_card.dart';
import 'package:flutter_frontend/screens/dashboard_pages/components/photo_gallery.dart';
import 'package:flutter_frontend/screens/dashboard_pages/home_components/car_field_card.dart';
import 'package:intl/intl.dart';

class CarCard extends StatefulWidget {
  final Car car;
  const CarCard(this.car, {super.key});

  @override
  State<CarCard> createState() => _CarCardState();
}

class _CarCardState extends State<CarCard> {
  late Car _car;

  Future<Car> fetchCar() async {
    return ApiClient.sendRequest('${ApiEndpoints.carsEndpoint}/${_car.id}',
            authorizedRequest: true)
        .then((data) {
      return Car.fromJson(data);
    }).catchError((error) {
      NotificationService.showNotification("$error", type: MessageType.error);
      throw error;
    });
  }

  void refreshCar() {
    fetchCar().then((car) {
      setState(() {
        _car = car;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _car = widget.car;
  }

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
                            _car.name,
                            style: const TextStyle(
                                fontSize: 24.0, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.fade,
                            softWrap: false,
                          ),
                          if (_car.brand != null && _car.model != null)
                            Text(
                              '${_car.brand} ${_car.model}',
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
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) =>
                                  PhotoGallery(_car, refreshCar));
                        },
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
              child: GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => PhotoGallery(_car, refreshCar));
                  },
                  child: PhotoCard(_car, _car.currentPhotoId ?? '',
                      width: 500, height: 300)),
            ),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (_car.displacement != null)
                  CarFieldCard(
                      "Engine displacement",
                      _car.displacement!.toStringAsFixed(1),
                      Icons.electric_car),
                if (_car.mileage != null)
                  CarFieldCard(
                      "Milage", _car.mileage.toString(), Icons.add_road),
                if (_car.productionDate != null)
                  CarFieldCard(
                      "Production date",
                      DateFormat('yyyy-MM-dd').format(_car.productionDate!),
                      Icons.access_time_filled),
                if (_car.purchaseDate != null)
                  CarFieldCard(
                      "Purchase date",
                      DateFormat('yyyy-MM-dd').format(_car.purchaseDate!),
                      Icons.shopping_cart),
              ],
            )
          ],
        ),
      ),
    );
  }
}
