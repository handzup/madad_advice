import 'package:flutter/material.dart';
import 'package:madad_advice/pages/category_item_page.dart';
import 'package:madad_advice/utils/next_screen.dart';

import '../styles.dart';

class SectionBlock extends StatelessWidget {
  const SectionBlock({
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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment: Alignment.center,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
 

                  Flexible(
                    child: Text(
                      data[index].title,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
