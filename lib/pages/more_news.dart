import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:madad_advice/blocs/recent_bloc.dart';
import 'package:madad_advice/generated/locale_keys.g.dart';
import 'package:madad_advice/models/config.dart';
import 'package:madad_advice/models/sphere.dart';
import 'package:madad_advice/pages/details.dart';
import 'package:madad_advice/utils/empty.dart';
import 'package:madad_advice/utils/next_screen.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../styles.dart';

class MoreNewsPage extends StatefulWidget {
  final String title;
  MoreNewsPage({Key key, @required this.title}) : super(key: key);

  @override
  _MoreNewsPageState createState() => _MoreNewsPageState(this.title);
}

class _MoreNewsPageState extends State<MoreNewsPage> {
  String title;
  _MoreNewsPageState(this.title);
  final String url = Config().url;
  SphereModel _apiResponse;
  DateFormat format = DateFormat("dd.MM.yyyy");
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 0)).then((_) async {
      //  final PopularDataBloc pb = Provider.of<PopularDataBloc>(context);
      final RecentDataBloc rb = Provider.of<RecentDataBloc>(context);
      await rb.getRecentData();
      // rb.getData();
      setState(() {
        _apiResponse = rb.recentData;
      });
    });
    super.initState();
  }

  bool isShow() {
    if (_apiResponse != null) {
      if (_apiResponse.elements.length > 0) {
        return true;
      }
      return false;
    }
    return false;
  }

  Future<Null> _handleRefresh() async {
    // await new Future.delayed(new Duration(milliseconds: 1300));
    final RecentDataBloc recentDataBloc = Provider.of<RecentDataBloc>(context);
    await recentDataBloc.getRecentData(force: true);

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: Text(title),
          backgroundColor: Colors.white,
        ),
        body: LiquidPullToRefresh(
            showChildOpacityTransition: false,
            height: 50,
            color: ThemeColors.primaryColor.withOpacity(0.8),
            animSpeedFactor: 2,
            borderWidth: 1,
            springAnimationDurationInMilliseconds: 100,
            onRefresh: _handleRefresh,
            child: isShow()
                ? CustomScrollView(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        _apiResponse.elements[index]
                                                    .preview_picture !=
                                                null
                                            ? Flexible(
                                                flex: 2,
                                                child: Container(
                                                  height: 140,
                                                  width: 140,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      boxShadow: <BoxShadow>[
                                                        BoxShadow(
                                                            color: Colors
                                                                .grey[200],
                                                            blurRadius: 1,
                                                            offset:
                                                                Offset(1, 1))
                                                      ],
                                                      image: DecorationImage(
                                                          image: CachedNetworkImageProvider(
                                                              '${url + _apiResponse.elements[index].preview_picture}'),
                                                          fit: BoxFit.cover)),
                                                ),
                                              )
                                            : SizedBox.shrink(),
                                        Flexible(
                                          flex: 4,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 15),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  _apiResponse
                                                      .elements[index].title,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey[800],
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Spacer(),
                                                Container(
                                                  child: Text(
                                                    _apiResponse.elements[index]
                                                        .preview_text
                                                        .replaceAll(
                                                            RegExp(
                                                                '(&[A-Za-z]+?;)|(<.+?>)|([\w-]+)'),
                                                            ''),
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.black54),
                                                    maxLines: 4,
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                                      format.format(format
                                                          .parse(_apiResponse
                                                              .elements[index]
                                                              .datetime
                                                              .toString())),
                                                      style: TextStyle(
                                                          color:
                                                              Colors.grey[600],
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
                                        data: _apiResponse.elements[index],
                                        category:
                                            LocaleKeys.recentArticels.tr(),
                                        date: format.format(format.parse(
                                            _apiResponse
                                                .elements[index].datetime
                                                .toString())),
                                        description: _apiResponse
                                            .elements[index].detail_text,
                                        imageUrl: _apiResponse
                                            .elements[index].preview_picture,
                                        norma: _apiResponse
                                            .elements[index].normativnye_akty,
                                        title:
                                            _apiResponse.elements[index].title,
                                        files: _apiResponse.elements[index]
                                            .prikreplennye_fayly,
                                      ));
                                },
                              ),
                            );
                          },
                          childCount: _apiResponse.elements.length,
                        ),
                      )
                    ],
                  )
                : EmptyPage(
                    icon: Icons.hourglass_empty,
                    message: LocaleKeys.emptyPage.tr(),
                    animate: true,
                  )));
  }
}
