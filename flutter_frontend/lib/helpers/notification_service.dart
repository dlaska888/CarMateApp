import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum MessageType {
  error,
  ok,
  info,
}

class NotificationService {
  static void showNotification(String message,
      {MessageType type = MessageType.ok}) {
    Color bgColor;

    switch (type) {
      case MessageType.ok:
        bgColor = Colors.green;
        break;
      case MessageType.info:
        bgColor = Colors.blue;
        break;
      case MessageType.error:
        bgColor = Colors.red;
        break;
      default:
        bgColor = Colors.green;
        break;
    }

    String bgColorHex = '#${bgColor.value.toRadixString(16).substring(2, 8)}';

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      webPosition: "right",
      backgroundColor: bgColor,
      webBgColor: bgColorHex,
      textColor: Colors.white,
      fontSize: 16.0,
      timeInSecForIosWeb: 3,
    );
  }
}
