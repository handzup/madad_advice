import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:madad_advice/pages/category_item_page.dart';
import 'package:madad_advice/utils/fa_icon.dart';
import 'package:madad_advice/utils/next_screen.dart';

import '../styles.dart';

class Sphere extends StatelessWidget {
  const Sphere({
    Key key,
    @required this.categoryColor,
    @required this.data,
    @required this.index,
  }) : super(key: key);

  final Color categoryColor;
  final List data;
  final int index;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(5),
        child: Material(
          color: categoryColor,
          elevation: 1,
          shadowColor: ThemeColors.primaryColor,
          borderRadius: BorderRadius.circular(15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              // Container(
              //     alignment: Alignment.center,
              //     height: 60,
              //     width: 60,
              //     child: FaIcons(
              //       data[index].icon.toString(),
              //       color: Colors.blue.withOpacity(.4),
              //       size: 30,
              //     )),
              Icon(
                FlutterIcons.angle_right_faw5s,
                color: Colors.grey[600],
              ),

              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    data[index].title,
                    softWrap: true,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
      onTap: () {
        nextScreen(
            context,
            CategoryItemPage(
              category: data[index].title,
              queryPath: data[index].code,
              color: Colors.white,
            ));
      },
    );
  }
}
