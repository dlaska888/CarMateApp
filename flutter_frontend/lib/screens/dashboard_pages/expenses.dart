import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ExpensesPage extends StatelessWidget {
  final String selectedCarId;
  const ExpensesPage(this.selectedCarId, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SfCartesianChart(
            primaryXAxis: const CategoryAxis(),
            // Chart title
            title: const ChartTitle(text: 'Half yearly expenses'),
            // Enable legend
            series: <LineSeries<ExpensesData, String>>[
      LineSeries<ExpensesData, String>(
          dataSource: <ExpensesData>[
            ExpensesData('Jan', 350),
            ExpensesData('Feb', 300),
            ExpensesData('Mar', 600),
            ExpensesData('Apr', 400),
            ExpensesData('May', 500)
          ],
          xValueMapper: (ExpensesData sales, _) => sales.year,
          yValueMapper: (ExpensesData sales, _) => sales.sales,
          // Enable data label
          dataLabelSettings: const DataLabelSettings(isVisible: true))
    ]));
  }
}

class ExpensesData {
  ExpensesData(this.year, this.sales);
  final String year;
  final double sales;
}
