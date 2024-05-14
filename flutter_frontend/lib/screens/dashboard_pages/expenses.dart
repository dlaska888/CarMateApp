import 'dart:developer';

import 'package:datepicker_dropdown/datepicker_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/helpers/api_client.dart';
import 'package:flutter_frontend/helpers/api_endpoints.dart';
import 'package:flutter_frontend/models/maintenance.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ExpensesPage extends StatefulWidget {
  final String selectedCarId;
  const ExpensesPage(this.selectedCarId, {super.key});

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  DateTime _selectedDate = DateTime.now();
  late Future<List<Maintenance>> _futureMaintenances;

  Future<List<Maintenance>> fetchMaintenances() async {
    var startDate =
        DateFormat('yyyy-MM-dd').format(DateTime(_selectedDate.year));
    var endDate = DateFormat('yyyy-MM-dd').format(
        DateTime(_selectedDate.year + 1).subtract(const Duration(days: 1)));

    return ApiClient.sendRequest(
            '${ApiEndpoints.carsEndpoint}/${widget.selectedCarId}/maintenances/by-dates?startDate=$startDate&endDate=$endDate',
            authorizedRequest: true) 
        .then((data) {
      return List<Maintenance>.from(data.map((m) => Maintenance.fromJson(m)));
    }).catchError((error) {
      log('$error');
      return <Maintenance>[];
    });
  }

  Map<DateTime, double> getMonthlyCostMap(List<Maintenance> maintenanceList) {
    Map<DateTime, double> monthMap = {
      for (var i = 1; i <= 12; i++) DateTime(_selectedDate.year, i): 0,
    };

    for (var maintenance in maintenanceList) {
      var key = DateTime(maintenance.dueDate!.year, maintenance.dueDate!.month);
      var cost = double.parse(maintenance.cost!);
      monthMap[key] = (monthMap[key] ?? 0) + cost;
    }

    return monthMap;
  }

  @override
  void initState() {
    super.initState();
    _futureMaintenances = fetchMaintenances();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureMaintenances,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          log("Error loading home: ${snapshot.error}");
          return const Center(
            child: Text("Could not load car"),
          );
        }

        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final maintenanceList = snapshot.data!;
        final monthlyCostMap = getMonthlyCostMap(maintenanceList);

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 200),
                child: DropdownDatePicker(
                  showDay: false,
                  showMonth: false,
                  startYear: 1900,
                  endYear: 2100,
                  selectedYear: _selectedDate.year,
                  onChangedYear: (year) {
                    setState(() {
                      _selectedDate = DateTime(int.parse(year!));
                    });
                  },
                ),
              ),
              Expanded(
                  child: SfCartesianChart(
                      primaryXAxis: DateTimeAxis(
                        interval: 1,
                        minimum: DateTime(_selectedDate.year, 1, 1),
                        maximum: DateTime(_selectedDate.year, 12, 1),
                        intervalType: DateTimeIntervalType.months,
                        dateFormat: DateFormat.MMM(),
                      ),
                      title: const ChartTitle(text: 'Your expenses'),
                      series: <ColumnSeries<MapEntry<DateTime, double>,
                          DateTime>>[
                    ColumnSeries<MapEntry<DateTime, double>, DateTime>(
                      dataSource: monthlyCostMap.entries.toList(),
                      xValueMapper: (monthCost, _) => monthCost.key,
                      yValueMapper: (monthCost, _) => monthCost.value,
                      // Enable data label
                      dataLabelSettings: const DataLabelSettings(
                          isVisible: true, textStyle: TextStyle(fontSize: 16)),
                      dataLabelMapper: (monthCost, _) => monthCost.value != 0
                          ? '\$${monthCost.value.toStringAsFixed(2)}'
                          : null,
                    )
                  ])),
            ],
          ),
        );
      },
    );
  }
}
