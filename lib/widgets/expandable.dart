import 'package:flutter/material.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/menu.dart';
import '../pages/category_item_page.dart';
import '../pages/details_from_search.dart';
import '../pages/profile.dart';
import '../pages/q&a_page.dart';
import '../pages/viewed_articles.dart';
import '../utils/fa_icon.dart';
import '../utils/next_screen.dart';

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

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void pageNavigator(String path) {
    switch (path.replaceAll(RegExp('/'), '')) {
      case 'settings':
        nextScreen(context, ProfilePage());
        break;
      case 'history':
        nextScreen(context, ViewedArticles());  
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

  void openLink(String url) {
    _launchURL(url);
  }

  void openArticle(Menu data) {
    nextScreen(
        context,
        DetailsFromSearchPage(
          code: data.path,
          title: data.title,
        ));
  }

  void openSection(Menu data) {
    nextScreen(
        context,
        CategoryItemPage(
          category: data.title,
          queryPath: data.path,
        ));
  }

  void directionNavigator(Menu data) {
    switch (data.type.replaceAll(RegExp('/'), '')) {
      case 'static':
        pageNavigator(data.path);
        break;
      case 'link':
        openLink(data.path);
        break;
      case 'section':
        openSection(data);
        break;
      case 'article':
        openArticle(data);
        break;
      default:
        nextScreen(context, ProfilePage());
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
            trailing: data.submenu.isNotEmpty
                ? Icon(
                    !isExpanded ? Icons.arrow_drop_down : Icons.arrow_drop_up)
                : SizedBox.shrink(),
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
                directionNavigator(data);
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
      physics: NeverScrollableScrollPhysics(),
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
              directionNavigator(data[index]);
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
