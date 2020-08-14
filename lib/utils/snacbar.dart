import 'package:flutter/material.dart';

void openSnacbar(_scaffoldKey, snacMessage ) {
  _scaffoldKey.currentState.showSnackBar(SnackBar(
    content: Container(
      alignment: Alignment.centerLeft,
      height: 60,
      child: Text(
        snacMessage,
        style: TextStyle(
          fontSize: 14,
        ),
      ),
    ),
    action: SnackBarAction(
      label: 'OK',
      textColor: Colors.blueAccent,
      onPressed: () {},
    ),
  ));
}

void openSnacbarQ(_scaffoldKey, snacMessage, {bool alert = false}) {
  _scaffoldKey.currentState.showSnackBar(SnackBar(
    backgroundColor: alert ? Colors.redAccent : Colors.black,

    content: Container(
      alignment: Alignment.centerLeft,
      height: 30,
      child: Text(
        snacMessage,
        style: TextStyle(
          fontSize: 14,
        ),
      ),
    ),
    action: SnackBarAction(
      label: 'OK',
      textColor: Colors.blueAccent,
      onPressed: () {},
    ),
  ));
}
