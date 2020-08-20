import 'package:flutter/material.dart';
import 'package:madad_advice/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

Widget snackBar( Function handleRefresh,{bool serviceError = false,}) {
  return SnackBar(
    duration: Duration(minutes: 1),
    content: Container(
      alignment: Alignment.centerLeft,
      height: 60,
      child: Text(
        LocaleKeys.noInternet.tr(),
        style: TextStyle(
          fontSize: 17,
        ),
      ),
    ),
    action: SnackBarAction(
      label: serviceError ? 'Servcie Error' : LocaleKeys.tryAgain.tr(),
      textColor: Colors.blueAccent,
      onPressed: () {
        handleRefresh();
      },
    ),
  );
}

Widget serviceError() {
  return SnackBar(
    backgroundColor: Colors.red,
    content: Text(LocaleKeys.serviceUnavailable.tr()),
    duration: Duration(seconds: 5),
  );
}
