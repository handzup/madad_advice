import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:madad_advice/blocs/recent_bloc.dart';
import 'package:madad_advice/models/config.dart';
import 'package:madad_advice/models/sphere.dart';
import 'package:madad_advice/pages/details.dart';
import 'package:madad_advice/pages/more_news.dart';
import 'package:madad_advice/utils/next_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:madad_advice/generated/locale_keys.g.dart';
import 'package:provider/provider.dart';
import '../styles.dart';

class ReacentHome extends StatefulWidget {
  ReacentHome({
    Key key,
  }) : super(key: key);

  @override
  _ReacentHomeState createState() => _ReacentHomeState();
}

class _ReacentHomeState extends State<ReacentHome> {
  SphereModel _apiResponse;

  final String url = Config().url;

  DateFormat format = DateFormat("dd.MM.yyyy");
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 0)).then((_) async {
      //  final PopularDataBloc pb = Provider.of<PopularDataBloc>(context);
      final RecentDataBloc rb = Provider.of<RecentDataBloc>(context);
      await rb.getRecentData();
      // rb.getData();
      if (mounted) {
        setState(() {
          _apiResponse = rb.recentData;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          if (index == 0)
            return Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 30,
                    width: 4,
                    decoration: BoxDecoration(
                        color: ThemeColors.primaryColor,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(LocaleKeys.recentArticels.tr(),
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                          fontWeight: FontWeight.w600)),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.navigate_next),
                    onPressed: () {
                      nextScreen(
                          context,
                          MoreNewsPage(
                            title: LocaleKeys.recent.tr(),
                          ));
                    },
                  )
                ],
              ),
            );
          return _apiResponse != null
              ? Padding(
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
                            _apiResponse.elements[index].preview_picture != null
                                ? Flexible(
                                    flex: 2,
                                    child: Container(
                                      height: 140,
                                      width: 140,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                                color: Colors.grey[200],
                                                blurRadius: 1,
                                                offset: Offset(1, 1))
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
                                padding: const EdgeInsets.only(left: 15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      _apiResponse.elements[index].title,
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
                                        _apiResponse
                                            .elements[index].preview_text
                                            .replaceAll(
                                                RegExp(
                                                    '(&[A-Za-z]+?;)|(<.+?>)|([\w-]+)'),
                                                ''),
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54),
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
                                          format.format(format.parse(
                                              _apiResponse
                                                  .elements[index].datetime
                                                  .toString())),
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
                            data: _apiResponse.elements[index],
                            category: LocaleKeys.recentArticels.tr(),
                            date: format.format(format.parse(_apiResponse
                                .elements[index].datetime
                                .toString())),
                            description:
                                _apiResponse.elements[index].detail_text,
                            imageUrl:
                                _apiResponse.elements[index].preview_picture,
                            norma:
                                _apiResponse.elements[index].normativnye_akty,
                            title: _apiResponse.elements[index].title,
                            files: _apiResponse
                                .elements[index].prikreplennye_fayly,
                          ));
                    },
                  ),
                )
              : SizedBox.shrink();
        },
        childCount: 5,
      ),
    );
  }
}
