import 'package:flutter/material.dart';
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
        height: 100,
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
              Container(
                alignment: Alignment.center,
                  height: 60,
                  width: 60,
                  child: FaIcons(  
                   data[index].icon.toString()  ,
                   color: Colors.blue.withOpacity(.4),
                   
                    size: 30  ,
                  )
                  ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                flex: 5,
                child: Text(
                  data[index].title,
                  softWrap: true,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
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
              queryPath:data[index].path,
              color: Colors.white,
            ));
      },
    );
  }
}
