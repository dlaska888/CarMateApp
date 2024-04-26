import 'package:flutter/material.dart';

class FormButton extends StatelessWidget {
  final Widget _form;

  const FormButton(Widget form, {super.key}) : _form = form;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final primary = Theme.of(context).primaryColor;

    return FloatingActionButton(
      backgroundColor: primary,
      onPressed: () {
        screenWidth < 768
            ? showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return _form;
                })
            : showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return Dialog(
                    child: _form,
                  );
                });
      },
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}
