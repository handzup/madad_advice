import 'package:flutter/material.dart';

import '../pages/category_item_page.dart';
import '../utils/next_screen.dart';

class Tag extends StatelessWidget {
  final tagName;
  final tagRoute;

  const Tag({Key key, this.tagName, this.tagRoute}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey[300], blurRadius: 10, offset: Offset(3, 3))
            ],
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.grey[300], width: 1)),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: InkWell(
            onTap: () {
              nextScreen(
                  context,
                  CategoryItemPage(
                    category: tagName,
                    queryPath: tagRoute,
                    color: Colors.white,
                  ));
            },
            child: Text(
              tagName,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11),
            ),
          ),
        ),
      ),
    );
  }
}
