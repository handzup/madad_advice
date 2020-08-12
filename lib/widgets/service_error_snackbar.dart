import 'package:flutter/material.dart';

Widget serviceError() {
  return SnackBar(
    backgroundColor: Colors.red,
    content: Text('Сервис временно недоступен!'),
    duration: Duration(seconds: 5),
  );
}
