import 'package:flutter/material.dart';
import 'package:flutter_frontend/helpers/datime_helper.dart';
import 'package:iso8601_duration/iso8601_duration.dart';

class IntervalPicker {
  static Future<String?> showDateIntervalPicker(
      {required BuildContext context}) async {
    return showDialog<String>(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('Select interval'),
          content: IntervalPickerDialog(controller: controller),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, "clear");
              },
              child: const Text('Clear'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, controller.text);
              },
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }
}

class IntervalPickerDialog extends StatefulWidget {
  final TextEditingController? controller;
  const IntervalPickerDialog({this.controller, super.key});

  @override
  State<IntervalPickerDialog> createState() => _IntervalPickerDialogState();
}

class _IntervalPickerDialogState extends State<IntervalPickerDialog> {
  int _selectedInterval = 1;
  String _selectedPeriod = 'month';

  final Map<String, int> _intervals = {
    'day': 30,
    'week': 4,
    'month': 12,
    'year': 10,
  };

  void _onChanged() {
    ISODuration? duration;

    switch (_selectedPeriod) {
      case 'day':
        duration = ISODuration(day: _selectedInterval);
        break;
      case 'week':
        duration = ISODuration(day: _selectedInterval * 7);
        break;
      case 'month':
        duration = ISODuration(month: _selectedInterval);
        break;
      case 'year':
        duration = ISODuration(year: _selectedInterval);
        break;
    }

    final result = DateTimeHelper.convertToISO8601(duration!);
    widget.controller?.text = result;
  }

  @override
  void initState() {
    super.initState();
    _onChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownButton<int>(
            value: _selectedInterval,
            onChanged: (value) => {
                  setState(() {
                    _selectedInterval = value!;
                    _onChanged();
                  })
                },
            items: List.generate(_intervals[_selectedPeriod]!, (index) {
              return DropdownMenuItem<int>(
                value: index + 1,
                child: Text('${index + 1}'),
              );
            })),
        const SizedBox(width: 10),
        DropdownButton<String>(
          value: _selectedPeriod,
          onChanged: (value) {
            setState(() {
              _selectedInterval = 1;
              _selectedPeriod =
                  _intervals.keys.firstWhere((key) => key == value!);
              _onChanged();
            });
          },
          items: _intervals.keys.map((period) {
            return DropdownMenuItem<String>(
              value: period,
              child: Text('$period${_selectedInterval == 1 ? '' : 's'}'),
            );
          }).toList(),
        ),
      ],
    );
  }
}
