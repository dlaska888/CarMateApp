import 'dart:developer';

import 'package:datepicker_dropdown/datepicker_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/helpers/api_service.dart';
import 'package:flutter_frontend/models/maintenance.dart';
import 'package:flutter_frontend/screens/dashboard_pages/expenses_components/month_cost_chart.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ExpensesPage extends StatefulWidget {
  final String selectedCarId;
  const ExpensesPage(this.selectedCarId, {super.key});

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  final ApiService _apiService = ApiService();
  DateTime _selectedDate = DateTime.now();
  bool _isMonthSelected = false;
  late SelectionBehavior _selectionBehavior;

  late Future<List<Maintenance>> _futureMaintenances;

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

  void refreshData() {
    setState(() {
      _futureMaintenances = _apiService.fetchMaintenancesByDates(
          widget.selectedCarId,
          DateTime(_selectedDate.year),
          DateTime(_selectedDate.year + 1).subtract(const Duration(days: 1)));
    });
  }

  @override
  void initState() {
    super.initState();
    _selectionBehavior = SelectionBehavior(enable: true);
    refreshData();
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
            child: Builder(
              builder: (context) {
                if (_isMonthSelected) {
                  return MonthCostChart(
                    maintenanceList
                        .where((maintenance) =>
                            maintenance.dueDate!.month == _selectedDate.month)
                        .toList(),
                    _selectedDate,
                    onBack: () => setState(() {
                      _isMonthSelected = false;
                    }),
                  );
                }

                return Column(
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
                            refreshData();
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
                            onSelectionChanged: (selectionArgs) {
                              setState(() {
                                _isMonthSelected = true;
                                _selectedDate = DateTime(_selectedDate.year,
                                    selectionArgs.pointIndex + 1);
                              });
                            },
                            series: <ColumnSeries<MapEntry<DateTime, double>,
                                DateTime>>[
                          ColumnSeries<MapEntry<DateTime, double>, DateTime>(
                            dataSource: monthlyCostMap.entries.toList(),
                            xValueMapper: (monthCost, _) => monthCost.key,
                            yValueMapper: (monthCost, _) => monthCost.value,
                            selectionBehavior: _selectionBehavior,
                            width: 0.5,
                            // Enable data label
                            dataLabelSettings: const DataLabelSettings(
                                isVisible: true,
                                textStyle: TextStyle(fontSize: 16)),
                            dataLabelMapper: (monthCost, _) =>
                                monthCost.value != 0
                                    ? '\$${monthCost.value.toStringAsFixed(2)}'
                                    : null,
                          )
                        ])),
                  ],
                );
              },
            ));
      },
    );
  }
}
