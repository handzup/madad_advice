import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:madad_advice/models/config.dart';
import 'package:share/share.dart';

import '../styles.dart';

class HelpPage extends StatefulWidget {
  final String tag;
  final String category;
  final String date;
  final String description;
  final String imageUrl;
  final int loves;
  final String timestamp;
  final String title;

  HelpPage(
      {Key key,
      @required this.tag,
      this.category,
      this.date,
      this.description,
      this.imageUrl,
      this.loves,
      this.timestamp,
      this.title})
      : super(key: key);

  @override
  _HelpPageState createState() => _HelpPageState(
      this.tag,
      this.category,
      this.date,
      this.description,
      this.imageUrl,
      this.loves,
      this.timestamp,
      this.title);
}

class _HelpPageState extends State<HelpPage> {
  final String tag;
  final String category;

  final String date;
  final String description;
  final String imageUrl;
  final int loves;
  final String timestamp;
  final String title;

  _HelpPageState(this.tag, this.category, this.date, this.description,
      this.imageUrl, this.loves, this.timestamp, this.title);

  double rightPaddingValue = 140;

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 100)).then((value) {
      setState(() {
        rightPaddingValue = 10;
      });
    });
    super.initState();
  }

  void _handleShare(title) {
    Share.share(title,
        subject:
            'Check out this app to explore more. App link: https://play.google.com/store/apps/details?id=${Config().androidPacakageName}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            //pinned: true,

            expandedHeight: 0,
            elevation: 1.0,
            forceElevated: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.print,
                  size: 22,
                  color: Colors.black,
                ),
                onPressed: () {
                  _handleShare(title);
                },
              ),
              IconButton(
                icon: Icon(
                  FontAwesome.file_pdf_o,
                  size: 22,
                  color: Colors.black,
                ),
                onPressed: () {
                  _handleShare(title);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.favorite_border,
                  size: 22,
                  color: Colors.black,
                ),
                onPressed: () {
                  _handleShare(title);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.share,
                  size: 22,
                  color: Colors.black,
                ),
                onPressed: () {
                  _handleShare(title);
                },
              ),
              SizedBox(
                width: 5,
              )
            ],
          ),
          SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 15, left: 15, right: 15, top: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          title,
                          style: TextStyle(
                              fontSize: 19, fontWeight: FontWeight.w600),
                        ),
                        Row(
                          children: <Widget>[
                            Icon(Icons.access_time,
                                size: 18, color: Colors.grey),
                            SizedBox(
                              width: 3,
                            ),
                            Text(
                              date,
                              style: TextStyle(
                                  color: Colors.black38, fontSize: 12),
                            ),
                          ],
                        ),
                        Divider(
                          color: ThemeColors.dividerColor,
                          endIndent: 200,
                          thickness: 2,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
