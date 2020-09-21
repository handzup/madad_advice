import 'package:flutter/material.dart';
import 'package:madad_advice/models/menu.dart';
import 'package:madad_advice/pages/category_page.dart';
import 'package:madad_advice/pages/profile.dart';
import 'package:madad_advice/pages/q&a_page.dart';
import 'package:madad_advice/pages/sections_page.dart';
import 'package:madad_advice/pages/viewed_articles.dart';
import 'package:madad_advice/utils/fa_icon.dart';
import 'package:madad_advice/utils/next_screen.dart';
import 'package:move_to_background/move_to_background.dart';

class ExpandedList extends StatefulWidget {
  final Menu data;

  const ExpandedList({Key key, @required this.data}) : super(key: key);
  @override
  _ExpandedListState createState() => _ExpandedListState(this.data);
}

class _ExpandedListState extends State<ExpandedList> {
  final Menu data;
  bool isExpanded = false;
  _ExpandedListState(this.data);
  void exitFromApp() async {
    await MoveToBackground.moveTaskToBack();
  }

  void pageNavigator(String page) {
    switch (page.replaceAll(RegExp('/'), '')) {
      case 'sfery':
        nextScreen(context, CategoryPage());
        break;
      case 'settings':
        nextScreen(context, ProfilePage());
        break;
      case 'sections':
        nextScreen(context, SectionPage());
        break;
      case 'history':
        nextScreen(context, ViewedArticles()); //WebViewExample()
        break;
      case 'question':
        nextScreen(context, QandAPage());
        break;
      case 'exit':
        exitFromApp();
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              border: Border(
            bottom: BorderSide(width: 0.5, color: Colors.grey[400]),
            // top: BorderSide(width: 1, color: Colors.grey[300]),
          )),
          child: ListTile(
            title: Text(
              data.title,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: Colors.grey[700]),
            ),
            leading: CircleAvatar(
                backgroundColor: Colors.white12,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white,
                      border: Border.all(color: Colors.grey[100])),
                  child: FaIcons(
                    data.icon.toString(),
                    color: Colors.blue.withOpacity(.4),
                    size: 20,
                  ),
                )),
            onTap: () {
              if (data.submenu.isNotEmpty) {
                setState(() {
                  isExpanded = !isExpanded;
                });
              } else {
                Navigator.pop(context);
                pageNavigator(data.path);
              }
            },
          ),
        ),
        ExpandableContainer(
          expandedHeight: data.submenu.length * 50.0 + 10,
          expanded: isExpanded,
          child: listTile(data.submenu),
        ),
      ],
    );
  }

  Widget listTile(List<Menu> data) {
    return ListView.builder(
      physics: AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(0),
      itemCount: data.length,
      itemExtent: 50,
      // ignore: missing_return
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: ListTile(
            contentPadding: EdgeInsets.all(0.0),
            title: Text(
              data[index].title,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: Colors.grey[700]),
            ),
            leading: CircleAvatar(
                backgroundColor: Colors.white12,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white,
                      border: Border.all(color: Colors.grey[100])),
                  child: FaIcons(
                    data[index].icon.toString(),
                    color: Colors.blue.withOpacity(.4),
                    size: 20,
                  ),
                )),
            onTap: () {
              Navigator.pop(context);
              pageNavigator(data[index].path);
            },
          ),
        );
      },
    );
  }
}

class ExpandableContainer extends StatelessWidget {
  final bool expanded;
  final double collapsedHeight;
  final double expandedHeight;
  final Widget child;

  ExpandableContainer({
    @required this.child,
    this.collapsedHeight = 0.0,
    this.expandedHeight = 100.0,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: screenWidth,
      height: expanded ? expandedHeight : collapsedHeight,
      child: Container(
        child: child,
      ),
    );
  }
}
