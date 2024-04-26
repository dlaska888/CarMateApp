import 'package:flutter/material.dart';
import 'package:flutter_frontend/api_client.dart';
import 'package:flutter_frontend/api_endpoints.dart';
import 'package:flutter_frontend/models/car.dart';
import 'package:flutter_frontend/models/paged_results.dart';
import 'package:flutter_frontend/notification_service.dart';
import 'package:flutter_frontend/screens/dashboard_pages/cars_components/car_card.dart';
import 'package:flutter_frontend/screens/forms/add_car.dart';
import 'package:flutter_frontend/screens/forms/form_button.dart';

class MyCarsPage extends StatefulWidget {
  const MyCarsPage({super.key});

  @override
  State<MyCarsPage> createState() => _MyCarsPageState();
}

class _MyCarsPageState extends State<MyCarsPage> {
  late Future<PagedResults<Car>> futureCars;

  @override
  void initState() {
    super.initState();
    futureCars = fetchCars();
  }

  Future<PagedResults<Car>> fetchCars() async {
    return ApiClient.sendRequest(ApiEndpoints.carsEndpoint,
            authorizedRequest: true)
        .then((data) async {
      return PagedResults<Car>.fromJson(data);
    }).catchError((error) {
      NotificationService.showNotification("$error", type: MessageType.error);
      throw error;
    });
  }

  void refreshCars() {
    setState(() {
      futureCars = fetchCars();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FormButton(AddCarForm(refreshCars)),
      body: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: FutureBuilder<PagedResults<Car>>(
                future: futureCars,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Wrap(
                      alignment: MediaQuery.of(context).size.width < 768
                          ? WrapAlignment.start
                          : WrapAlignment.center,
                      children: snapshot.data!.data.map((car) {
                        return CarCard(car);
                      }).toList(),
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  // By default, show a loading spinner.
                  return const CircularProgressIndicator();
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
