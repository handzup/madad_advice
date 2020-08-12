import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:madad_advice/blocs/drawer_menu_bloc.dart';
import 'package:madad_advice/blocs/popular_bloc.dart';
import 'package:madad_advice/blocs/recent_bloc.dart';
import 'package:madad_advice/blocs/search_bloc.dart';
import 'package:madad_advice/models/config.dart';
import 'package:madad_advice/models/menu.dart';
import 'package:madad_advice/models/search_result.dart';
import 'package:madad_advice/pages/details.dart';
import 'package:madad_advice/pages/details_from_search.dart';
import 'package:madad_advice/utils/next_screen.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:madad_advice/generated/locale_keys.g.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var formKey = GlobalKey<FormState>();
  var textFieldCtrl = TextEditingController();

  final String url = Config().url;
  final String uri = Config().uri;
  DateFormat format = DateFormat('dd.MM.yyyy');
  @override
  Widget build(BuildContext context) {
    final pb = Provider.of<RecentDataBloc>(context);
    final searchBloc = Provider.of<SearchBloc>(context);

    return Scaffold(
        appBar: AppBar(
            elevation: 1,
            title: Form(
              key: formKey,
              child: TextFormField(
                 decoration: InputDecoration(
                  focusedBorder: InputBorder.none,
                  hintText: LocaleKeys.searchActicles.tr(),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear, color: Colors.grey[800]),
                    onPressed: () {
                      WidgetsBinding.instance
                          .addPostFrameCallback((_) => textFieldCtrl.clear());
                      pb.afterSearch('');
                    },
                  ),
                ),
                controller: textFieldCtrl,
                onChanged: (String value) {
                  searchBloc.afterSearch(value);
                },
              ),
            )),
        body: searchBloc.hasData
            ? afterSearchUI(context)
            : suggestionUI(context));
  }

  bool ableToshow(SearchResult data) {
    var pb = Provider.of<DrawerMenuBloc>(context);
    var first = true;
    var second = false;
    pb.menuData.forEach((element) {
      if (element.title == data.title) {
        first = false;
      }
    });
    if (data.code != null && data.code != '') {
      if (data.preview_text != null && data.preview_text != '') {
        if (data.title != null && data.title != '') {
          second = true;
        }
      }
    }
    if (first && second) {
      return true;
    }
    return false;
  }

  Widget suggestionUI(context) {
    var pb = Provider.of<RecentDataBloc>(context);
    return ListView.separated(
      padding: EdgeInsets.all(8),
      itemCount: pb.recentData.elements.take(5).length,
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: 10,
        );
      },
      itemBuilder: (BuildContext context, int index) {
        return AnimationConfiguration.staggeredList(
          position: index,
          duration: Duration(milliseconds: 300),
          child: SlideAnimation(
            verticalOffset: 50,
            child: FadeInAnimation(
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: InkWell(
                  child: Container(
                      height: 110,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.grey[300],
                                blurRadius: 10,
                                offset: Offset(3, 3))
                          ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Flexible(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    pb.recentData.elements[index].title,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[800],
                                        fontWeight: FontWeight.w500),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Spacer(),
                                  Container(
                                    child: Text(
                                      pb.recentData.elements[index].preview_text
                                          .replaceAll(
                                              RegExp(
                                                  '(&[A-Za-z]+?;)|(<.+?>)|([\w-]+)'),
                                              ''),
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.black54),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Spacer(),
                                ],
                              ),
                            ),
                          )
                        ],
                      )),
                  onTap: () {
                    nextScreen(
                        context,
                        DetailsFromSearchPage(
                          id: pb.recentData.elements[index].id,
                          category: pb.recentData.elements[index].title,
                          code: pb.recentData.elements[index].code,
                          title: pb.recentData.elements[index].title,
                        ));
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget afterSearchUI(context) {
    final pb = Provider.of<SearchBloc>(context);
    return ListView.separated(
      padding: EdgeInsets.all(8),
      itemCount: pb.searchData.length,
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: 10,
        );
      },
      itemBuilder: (BuildContext context, int index) {
        if (ableToshow(pb.searchData[index])) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: Duration(milliseconds: 300),
            child: SlideAnimation(
              verticalOffset: 50,
              child: FadeInAnimation(
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: InkWell(
                    child: Container(
                        height: 110,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.grey[300],
                                  blurRadius: 10,
                                  offset: Offset(3, 3))
                            ]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              flex: 4,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      pb.searchData[index].title,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.w500),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Spacer(),
                                    Container(
                                      child: Text(
                                        pb.searchData[index].preview_text
                                            .replaceAll(
                                                RegExp(
                                                    '(&[A-Za-z]+?;)|(<.+?>)|([\w-]+)'),
                                                ''),
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Spacer(),
                                    // Row(
                                    //   children: <Widget>[
                                    //     Icon(
                                    //       Icons.access_time,
                                    //       color: Colors.grey,
                                    //       size: 20,
                                    //     ),
                                    //     SizedBox(
                                    //       width: 5,
                                    //     ),
                                    //     // Text(
                                    //     //   format.format(format.parse(pb
                                    //     //       .searchData[index].datetime
                                    //     //       .toString())),
                                    //     //   style: TextStyle(
                                    //     //       color: Colors.grey[600],
                                    //     //       fontSize: 13),
                                    //     // ),
                                    //     Spacer(),
                                    //   ],
                                    // )
                                  ],
                                ),
                              ),
                            )
                          ],
                        )),
                    onTap: () {
                      nextScreen(
                          context,
                          DetailsFromSearchPage(
                            id: pb.searchData[index].id,
                            category: pb.searchData[index].title,
                            code: pb.searchData[index].code,
                            title: pb.searchData[index].title,
                          ));
                    },
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
