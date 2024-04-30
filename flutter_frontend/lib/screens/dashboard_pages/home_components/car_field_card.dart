import 'package:flutter/material.dart';

class CarFieldCard extends StatelessWidget {
  final String _field;
  final String _value;
  final IconData _icon;
  const CarFieldCard(this._field, this._value, this._icon, {super.key});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    return Container(
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius:
              BorderRadius.circular(10.0), 
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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _field,
                    style:
                        const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  Text(_value)
                ],
              ),
              const SizedBox(
                width: 48,
              ),
              Column(
                children: [
                  Icon(
                    _icon,
                    color: primary,
                    size: 40.0,
                  )
                ],
              )
            ],
          ),
        ));
  }
}
