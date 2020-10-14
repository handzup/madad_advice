import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../generated/locale_keys.g.dart';
import '../styles.dart';

class NotificationDetails extends StatelessWidget {
  final String title;
  final String description;
  final String date;

  const NotificationDetails(
      {Key key,
      @required this.title,
      @required this.description,
      @required this.date})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(LocaleKeys.notificationDetails.tr()),
      ),
      body: ListView(
        padding: EdgeInsets.only(
          left: 20,
          top: 50,
          right: 20,
        ),
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.access_time,
                size: 16,
                color: Colors.grey[600],
              ),
              Text(
                date,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              )
            ],
          ),
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          Divider(
            height: 20,
            color: ThemeColors.dividerColor,
            endIndent: 100,
            thickness: 3,
          ),
          SizedBox(
            height: 20,
          ),
          // Html(
          //   data: '''$description''',
          //   defaultTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, fontFamily: 'Open Sans'),

          //   onLinkTap: (url){
          //     launch(url);
          //   },
          // )
        ],
      ),
    );
  }
}
