import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:madad_advice/blocs/recent_bloc.dart';
import 'package:madad_advice/models/config.dart';
import 'package:madad_advice/pages/details.dart';
import 'package:madad_advice/utils/next_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:madad_advice/generated/locale_keys.g.dart';
import 'package:madad_advice/widgets/recent_news.dart';
import 'package:provider/provider.dart';

class ReacentHome extends StatefulWidget {
  ReacentHome({
    Key key,
  }) : super(key: key);

  @override
  _ReacentHomeState createState() => _ReacentHomeState();
}

class _ReacentHomeState extends State<ReacentHome> {
  final String url = Config().url;

  DateFormat format = DateFormat("dd.MM.yyyy");
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 0)).then((_) async {
      await Provider.of<RecentDataBloc>(context).getRecentData(force: true);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RecentDataBloc>(
      builder: (context, data, child) {
        if (data.recentData.data.elements.isEmpty) return child;
        return ListView.builder(
          padding: const EdgeInsets.all(0),
          itemBuilder: (BuildContext context, int index) {
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
                        data.recentData.data.elements[index].preview_picture !=
                                null
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
                                              '${url + data.recentData.data.elements[index].preview_picture}'),
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
                                  data.recentData.data.elements[index].title,
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
                                    data.recentData.data.elements[index]
                                        .preview_text
                                        .replaceAll(
                                            RegExp(
                                                '(&[A-Za-z]+?;)|(<.+?>)|([\w-]+)'),
                                            ''),
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
                                      format.format(format.parse(data.recentData
                                          .data.elements[index].datetime
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
                        data: data.recentData.data.elements[index],
                        category: LocaleKeys.recentArticels.tr(),
                        date: format.format(format.parse(data
                            .recentData.data.elements[index].datetime
                            .toString())),
                        description:
                            data.recentData.data.elements[index].detail_text,
                        imageUrl: data
                            .recentData.data.elements[index].preview_picture,
                        norma: data
                            .recentData.data.elements[index].normativnye_akty,
                        title: data.recentData.data.elements[index].title,
                        files: data.recentData.data.elements[index]
                            .prikreplennye_fayly,
                      ));
                },
              ),
            );
          },
          itemCount: data.recentData.data.elements.length,
        );
      },
      child: Recent(),
    );

    //   return SliverList(
    //     delegate: SliverChildBuilderDelegate(
    //       (BuildContext context, int index) {
    //         return _apiResponse != null
    //             ? Padding(
    //                 padding: const EdgeInsets.all(3.0),
    //                 child: InkWell(
    //                   child: Container(
    //                       height: 150,
    //                       padding: EdgeInsets.all(15),
    //                       decoration: BoxDecoration(
    //                           color: Colors.white,
    //                           borderRadius: BorderRadius.circular(12),
    //                           boxShadow: <BoxShadow>[
    //                             BoxShadow(
    //                                 color: Colors.grey[300],
    //                                 blurRadius: 10,
    //                                 offset: Offset(3, 3))
    //                           ]),
    //                       child: Row(
    //                         mainAxisAlignment: MainAxisAlignment.start,
    //                         crossAxisAlignment: CrossAxisAlignment.start,
    //                         children: <Widget>[
    //                           data.recentData.data.elements[index].preview_picture != null
    //                               ? Flexible(
    //                                   flex: 2,
    //                                   child: Container(
    //                                     height: 140,
    //                                     width: 140,
    //                                     decoration: BoxDecoration(
    //                                         borderRadius:
    //                                             BorderRadius.circular(12),
    //                                         boxShadow: <BoxShadow>[
    //                                           BoxShadow(
    //                                               color: Colors.grey[200],
    //                                               blurRadius: 1,
    //                                               offset: Offset(1, 1))
    //                                         ],
    //                                         image: DecorationImage(
    //                                             image: CachedNetworkImageProvider(
    //                                                 '${url + data.recentData.data.elements[index].preview_picture}'),
    //                                             fit: BoxFit.cover)),
    //                                   ),
    //                                 )
    //                               : SizedBox.shrink(),
    //                           Flexible(
    //                             flex: 4,
    //                             child: Padding(
    //                               padding: const EdgeInsets.only(left: 15),
    //                               child: Column(
    //                                 mainAxisAlignment: MainAxisAlignment.start,
    //                                 crossAxisAlignment: CrossAxisAlignment.start,
    //                                 children: <Widget>[
    //                                   Text(
    //                                     data.recentData.data.elements[index].title,
    //                                     style: TextStyle(
    //                                         fontSize: 14,
    //                                         color: Colors.grey[800],
    //                                         fontWeight: FontWeight.w500),
    //                                     maxLines: 3,
    //                                     overflow: TextOverflow.ellipsis,
    //                                   ),
    //                                   Spacer(),
    //                                   Container(
    //                                     child: Text(
    //                                       _apiResponse
    //                                           .elements[index].preview_text
    //                                           .replaceAll(
    //                                               RegExp(
    //                                                   '(&[A-Za-z]+?;)|(<.+?>)|([\w-]+)'),
    //                                               ''),
    //                                       style: TextStyle(
    //                                           fontSize: 12,
    //                                           color: Colors.black54),
    //                                       maxLines: 4,
    //                                       overflow: TextOverflow.ellipsis,
    //                                     ),
    //                                   ),
    //                                   Spacer(),
    //                                   Row(
    //                                     children: <Widget>[
    //                                       Icon(
    //                                         Icons.access_time,
    //                                         color: Colors.grey,
    //                                         size: 20,
    //                                       ),
    //                                       SizedBox(
    //                                         width: 5,
    //                                       ),
    //                                       Text(
    //                                         format.format(format.parse(
    //                                             _apiResponse
    //                                                 .elements[index].datetime
    //                                                 .toString())),
    //                                         style: TextStyle(
    //                                             color: Colors.grey[600],
    //                                             fontSize: 13),
    //                                       ),
    //                                       Spacer(),
    //                                     ],
    //                                   )
    //                                 ],
    //                               ),
    //                             ),
    //                           )
    //                         ],
    //                       )),
    //                   onTap: () {
    //                     nextScreen(
    //                         context,
    //                         DetailsPage(
    //                           data: data.recentData.data.elements[index],
    //                           category: LocaleKeys.recentArticels.tr(),
    //                           date: format.format(format.parse(_apiResponse
    //                               .elements[index].datetime
    //                               .toString())),
    //                           description:
    //                               data.recentData.data.elements[index].detail_text,
    //                           imageUrl:
    //                               data.recentData.data.elements[index].preview_picture,
    //                           norma:
    //                               data.recentData.data.elements[index].normativnye_akty,
    //                           title: data.recentData.data.elements[index].title,
    //                           files: _apiResponse
    //                               .elements[index].prikreplennye_fayly,
    //                         ));
    //                   },
    //                 ),
    //               )
    //             : SizedBox.shrink();
    //       },
    //       childCount: 5,
    //     ),
    //   );
  }
}
