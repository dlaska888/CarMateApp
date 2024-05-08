import 'package:flutter/material.dart';
import 'package:flutter_frontend/api_client.dart';
import 'package:flutter_frontend/api_endpoints.dart';
import 'package:flutter_frontend/models/car.dart';
import 'package:flutter_frontend/notification_service.dart';
import 'package:flutter_frontend/screens/dashboard_pages/components/photo_card.dart';
import 'package:flutter_frontend/screens/forms/cars/photos/delete_car_photo.dart';
import 'package:flutter_frontend/screens/forms/form_modal.dart';
import 'package:flutter_frontend/screens/forms/upload_photo_form.dart';
import 'package:http/http.dart' as http;

class PhotoGallery extends StatefulWidget {
  final Car car;
  final Function refreshCar;
  const PhotoGallery(this.car, this.refreshCar, {super.key});

  @override
  State<PhotoGallery> createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends State<PhotoGallery> {
  late Car _car;
  late String _selectedPhotoId;

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

  void setCarCurrentPhoto(String photoId) {
    ApiClient.sendRequest(
            '${ApiEndpoints.carsEndpoint}/${widget.car.id}/currentPhoto',
            methodFun: http.post,
            body: {"photoId": photoId},
            authorizedRequest: true)
        .then((_) {
      widget.refreshCar();
      setState(() {
        _car.currentPhotoId = photoId;
      });
    }).catchError((error) {
      NotificationService.showNotification("$error", type: MessageType.error);
    });
  }

  void addPhoto() {
    fetchCar().then((car) {
      widget.refreshCar();
      setState(() {
        _car = car;
        _selectedPhotoId = _car.photosIds.last;
      });
    });
  }

  void deletePhoto() {
    fetchCar().then((car) {
      widget.refreshCar();
      setState(() {
        _car = car;
        _selectedPhotoId = _car.currentPhotoId ?? '';
      });
    });
  }

  @override
  initState() {
    super.initState();
    _car = widget.car;
    _selectedPhotoId = _car.currentPhotoId ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final mainPhotoWidth = screenWidth > 1100.0 ? 1000.0 : screenWidth * 0.9;
    final mainPhotoHeight = screenHeight > 800.0 ? 650.0 : screenHeight * 0.7;

    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      SizedBox(
        width: mainPhotoWidth + 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 10,
            ),
            IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.cancel_outlined,
                    color: Colors.white, size: 40.0)),
          ],
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Stack(
                children: [
                  PhotoCard(_car, _selectedPhotoId,
                      width: mainPhotoWidth, height: mainPhotoHeight),
                  if (_selectedPhotoId.isNotEmpty)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: ElevatedButton(
                        onPressed: () {
                          FormModal(context).showModal(DeleteCarPhotoForm(
                              _car, _selectedPhotoId, deletePhoto));
                        },
                        style: ElevatedButtonTheme.of(context).style!.copyWith(
                            textStyle: MaterialStateProperty.all(
                                const TextStyle(fontSize: 16))),
                        child: const Text('Delete'),
                      ),
                    ),
                  if (_car.currentPhotoId == _selectedPhotoId)
                    Positioned(
                        top: 10,
                        right: 10,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButtonTheme.of(context)
                              .style!
                              .copyWith(
                                  foregroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.green),
                                  textStyle: MaterialStateProperty.all(
                                      const TextStyle(fontSize: 16))),
                          child: const Text('Current photo'),
                        ))
                  else if (_selectedPhotoId.isNotEmpty)
                    Positioned(
                        top: 10,
                        right: 10,
                        child: ElevatedButton(
                          onPressed: () => setCarCurrentPhoto(_selectedPhotoId),
                          style: ElevatedButtonTheme.of(context)
                              .style!
                              .copyWith(
                                  textStyle: MaterialStateProperty.all(
                                      const TextStyle(fontSize: 16))),
                          child: const Text('Set as current photo'),
                        )),
                ],
              ),
            ),
          )
        ],
      ),
      const SizedBox(
        height: 20,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: screenWidth),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: SizedBox(
                          width: mainPhotoWidth * 0.2,
                          height: mainPhotoHeight * 0.2,
                          child: IconButton(
                            icon: const Icon(
                              Icons.add_rounded,
                              color: Colors.white,
                              size: 40.0,
                            ),
                            onPressed: () {
                              FormModal(context).showModal(UploadPhotoForm(
                                  '${ApiEndpoints.carsEndpoint}/${_car.id}/photos',
                                  addPhoto));
                            },
                          )),
                    ),
                  ),
                  Row(
                      children: _car.photosIds
                          .map(
                            (pId) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedPhotoId = pId;
                                });
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: PhotoCard(
                                    _car,
                                    pId,
                                    width: mainPhotoWidth * 0.2,
                                    height: mainPhotoHeight * 0.2,
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList()),
                ]),
              ),
            ),
          )
        ],
      ),
    ]);
  }
}
