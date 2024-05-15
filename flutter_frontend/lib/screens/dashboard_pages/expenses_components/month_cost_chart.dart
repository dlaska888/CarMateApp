import 'package:flutter/material.dart';
import 'package:flutter_frontend/models/maintenance.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MonthCostChart extends StatefulWidget {
  final List<Maintenance> maintenanceList;
  final DateTime selectedDate;
  final Function onBack;
  const MonthCostChart(this.maintenanceList, this.selectedDate, {required this.onBack, super.key});

  @override
  State<MonthCostChart> createState() => _MonthCostChartState();
}

class _MonthCostChartState extends State<MonthCostChart> {
  Map<DateTime, double> getDailyMonthMap(List<Maintenance> maintenanceList) {
    Map<DateTime, double> dayMap = {
      for (var i = 1; i <= 31; i++)
        DateTime(widget.selectedDate.year, widget.selectedDate.month, i): 0,
    };

    for (var maintenance in maintenanceList) {
      var key = maintenance.dueDate!;
      var cost = double.parse(maintenance.cost!);
      dayMap[key] = (dayMap[key] ?? 0) + cost;
    }

    return dayMap;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(onPressed: () => widget.onBack(), icon: const Icon(Icons.arrow_back)),
        Expanded(
            child: SfCartesianChart(
                primaryXAxis: DateTimeAxis(
                  interval: 1,
                  minimum: DateTime(
                      widget.selectedDate.year, widget.selectedDate.month, 1),
                  maximum: DateTime(
                      widget.selectedDate.year, widget.selectedDate.month, 31),
                  intervalType: DateTimeIntervalType.auto,
                  dateFormat: DateFormat.d(),
                ),
                title: ChartTitle(
                    text:
                        'Your expenses for ${DateFormat.MMMM().format(widget.selectedDate)} ${widget.selectedDate.year}'),
                series: <ColumnSeries<MapEntry<DateTime, double>, DateTime>>[
              ColumnSeries<MapEntry<DateTime, double>, DateTime>(
                dataSource:
                    getDailyMonthMap(widget.maintenanceList).entries.toList(),
                xValueMapper: (dailyCost, _) => dailyCost.key,
                yValueMapper: (dailyCost, _) => dailyCost.value,
                width: 1.0,
                // Enable data label
                dataLabelSettings: const DataLabelSettings(
                    isVisible: true, textStyle: TextStyle(fontSize: 16)),
                dataLabelMapper: (dailyCost, _) => dailyCost.value != 0
                    ? '\$${dailyCost.value.toStringAsFixed(2)}'
                    : null,
              )
            ])),
      ],
    );
  }
}
