import 'package:flutter/material.dart';
import 'package:flutter_frontend/api_client.dart';
import 'package:flutter_frontend/api_endpoints.dart';
import 'package:flutter_frontend/models/car.dart';
import 'package:flutter_frontend/notification_service.dart';
import 'package:flutter_frontend/screens/dashboard_pages/components/photo_card.dart';
import 'package:flutter_frontend/screens/dashboard_pages/components/photo_gallery.dart';
import 'package:flutter_frontend/screens/dashboard_pages/my_cars_components/car_info.dart';
import 'package:flutter_frontend/screens/forms/cars/delete_car.dart';
import 'package:flutter_frontend/screens/forms/cars/edit_car.dart';
import 'package:flutter_frontend/screens/forms/form_modal.dart';

class CarTile extends StatefulWidget {
  final Car car;
  final bool isCarSelected;
  const CarTile(this.car, {this.isCarSelected = false, super.key});

  @override
  State<CarTile> createState() => _CarTileState();
}

class _CarTileState extends State<CarTile> {
  late Car _car;
  bool isCarDeleted = false;

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

  void removeCar() {
    setState(() {
      isCarDeleted = true;
    });
  }

  void showCarInfo() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => CarInfo(_car),
    );
  }

  @override
  void initState() {
    super.initState();
    _car = widget.car;
  }

  @override
  Widget build(BuildContext context) {
    if (isCarDeleted) {
      return const SizedBox();
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              border: widget.isCarSelected
                  ? Border.all(color: Colors.green, width: 3.0)
                  : null,
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
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _car.name,
                              style: const TextStyle(
                                  fontSize: 24.0, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.fade,
                              softWrap: false,
                            ),
                            Text(
                              '${_car.brand ?? ''} ${_car.model ?? ''}',
                              overflow: TextOverflow.fade,
                              softWrap: false,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          PopupMenuButton(itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                  value: 'info',
                                  child: const Row(children: [
                                    Icon(Icons.info_outline),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text('Info')
                                  ]),
                                  onTap: () => FormModal(context)
                                      .showModal(CarInfo(_car))),
                              PopupMenuItem(
                                  value: 'edit',
                                  child: const Row(children: [
                                    Icon(Icons.edit_outlined),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text('Edit')
                                  ]),
                                  onTap: () => FormModal(context).showModal(
                                      EditCarForm(_car, refreshCar))),
                              PopupMenuItem(
                                  value: 'delete',
                                  child: const Row(children: [
                                    Icon(Icons.delete_outline),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text('Delete')
                                  ]),
                                  onTap: () => FormModal(context).showModal(
                                      DeleteCarForm(_car, removeCar)))
                            ];
                          }),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Column(
                    children: [
                      GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) =>
                                    PhotoGallery(_car, refreshCar));
                          },
                          child: PhotoCard(_car, _car.currentPhotoId ?? '',
                              width: 500, height: 300)),
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
