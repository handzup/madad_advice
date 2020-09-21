import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:madad_advice/blocs/articel_bloc.dart';
import 'package:madad_advice/models/config.dart';
import 'package:madad_advice/models/sphere.dart';
import 'package:madad_advice/pages/details.dart';
import 'package:madad_advice/utils/empty.dart';
import 'package:madad_advice/utils/next_screen.dart';
import 'package:madad_advice/widgets/service_error_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:madad_advice/generated/locale_keys.g.dart';
import '../styles.dart';

class CategoryItemPage extends StatefulWidget {
  final String category;
  final String queryPath;
  final Color color;
  CategoryItemPage(
      {Key key, @required this.category, this.color, this.queryPath})
      : super(key: key);

  @override
  _CategoryItemPageState createState() =>
      _CategoryItemPageState(category, color, queryPath);
}

class _CategoryItemPageState extends State<CategoryItemPage> {
  final String category;
  final String queryPath;
  final Color color;
  final String url = Config().url;
  _CategoryItemPageState(this.category, this.color, this.queryPath);
  DateFormat format = DateFormat('dd.MM.yyyy');
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 0)).then((_) async {
      final articleBlock = Provider.of<ArticleBloc>(context);
      await articleBlock.getSectionData(
          code: queryPath, force: articleBlock.first);
      if (articleBlock.sectionData.error) {
        articleBlock.sectionData.errorMessage == 'internet'
            ? _scaffoldKey.currentState.showSnackBar(snackBar(_handleRefresh))
            : _scaffoldKey.currentState.showSnackBar(serviceError());
      }
    });
    super.initState();
  }

  Future<Null> _handleRefresh() async {
    final articleBlock = Provider.of<ArticleBloc>(context);
    await articleBlock.getSectionData(code: queryPath, force: true);
    if (articleBlock.sectionData.error) {
      articleBlock.sectionData.errorMessage == 'internet'
          ? _scaffoldKey.currentState.showSnackBar(snackBar(_handleRefresh))
          : _scaffoldKey.currentState.showSnackBar(serviceError());
    }
    return null;
  }

  Future<bool> clear() async {
    Provider.of<ArticleBloc>(context, listen: false).clearData();
    Navigator.pop(context);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: clear,
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(
              category,
              overflow: TextOverflow.fade,
            ),
          ),
          body: LiquidPullToRefresh(
              showChildOpacityTransition: false,
              height: 50,
              color: ThemeColors.primaryColor.withOpacity(0.8),
              animSpeedFactor: 2,
              borderWidth: 1,
              springAnimationDurationInMilliseconds: 100,
              onRefresh: _handleRefresh,
              child: Consumer<ArticleBloc>(
                builder: (context, data, child) {
                  if (data.sectionData.data.elements.isEmpty) return child;
                  return buildList(data.sectionData.data);
                },
                child: EmptyPage(
                  icon: Icons.hourglass_empty,
                  message: LocaleKeys.emptyPage.tr(),
                  animate: true,
                ),
              ))),
    );
  }

  Widget buildList(SphereModel data) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Padding(
                padding: const EdgeInsets.all(3.0),
                child: InkWell(
                  child: Container(
                      height: 150,
                      padding: EdgeInsets.all(15),
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
                          data.elements[index].preview_picture != null
                              ? Flexible(
                                  flex: 2,
                                  child: Container(
                                    height: 140,
                                    width: 140,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                              color: Colors.grey[200],
                                              blurRadius: 1,
                                              offset: Offset(1, 1))
                                        ],
                                        image: DecorationImage(
                                            image: CachedNetworkImageProvider(
                                                '${url + data.elements[index].preview_picture}'),
                                            fit: BoxFit.cover)),
                                  ),
                                )
                              : SizedBox.shrink(),
                          Flexible(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    data.elements[index].title,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[800],
                                        fontWeight: FontWeight.w500),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Spacer(),
                                  Container(
                                    child: Text(
                                      data.elements[index].preview_text != null
                                          ? data.elements[index].preview_text
                                              .replaceAll(
                                                  RegExp(
                                                      '(&[A-Za-z]+?;)|(<.+?>)|([\w-]+)'),
                                                  '')
                                          : '',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.black54),
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Spacer(),
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.access_time,
                                        color: Colors.grey,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        data.elements[index].datetime != null
                                            ? format.format(format.parse(data
                                                .elements[index].datetime
                                                .toString()))
                                            : '',
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 13),
                                      ),
                                      Spacer(),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      )),
                  onTap: () {
                    nextScreen(
                        context,
                        DetailsPage(
                          data: data.elements[index],
                          category: data.title,
                          date: data.elements[index].datetime != null
                              ? format.format(format.parse(
                                  data.elements[index].datetime.toString()))
                              : '',
                          description: data.elements[index].detail_text,
                          imageUrl: data.elements[index].preview_picture,
                          norma: data.elements[index].normativnye_akty,
                          title: data.elements[index].title,
                          files: data.elements[index].prikreplennye_fayly,
                        ));
                  },
                ),
              );
            },
            childCount: data.elements.length,
          ),
        )
      ],
    );
  }
}
