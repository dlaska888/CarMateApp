import 'package:flutter/material.dart';

class FormModal {
  final BuildContext _context;
  const FormModal(BuildContext context) : _context = context;

  void showModal(Widget form) {
    final screenWidth = MediaQuery.of(_context).size.width;
    screenWidth < 768
        ? showModalBottomSheet(
            context: _context,
            isScrollControlled: true,
            builder: (context) {
              return form;
            })
        : showDialog(
            context: _context,
            barrierDismissible: false,
            builder: (context) {
              return Dialog(
                child: form,
              );
            });
  }
}
