import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:madad_advice/blocs/viewed_articles_bloc.dart';
import 'package:madad_advice/generated/locale_keys.g.dart';
import 'package:madad_advice/models/config.dart';
import 'package:madad_advice/pages/details.dart';
import 'package:madad_advice/utils/empty.dart';
import 'package:madad_advice/utils/next_screen.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

final String url = Config().url;
final String uri = Config().uri;
var format = DateFormat('dd.MM.yyyy');

class ViewedArticles extends StatefulWidget {
  @override
  _ViewedArticlesState createState() => _ViewedArticlesState();
}

class _ViewedArticlesState extends State<ViewedArticles> {
  @override
  void initState() {
    Future.delayed(Duration(microseconds: 0)).then((_) {
      var viewedBloc = Provider.of<ViewedArticlesBloc>(context, listen: false);
      viewedBloc.getAllFiles();
    });
    super.initState();
  }

  bool isShow(articles) {
    if (articles != null) {
      if (articles.isNotEmpty) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    var pb = Provider.of<ViewedArticlesBloc>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            LocaleKeys.viewedArticels.tr(),
            overflow: TextOverflow.fade,
          ),
        ),
        body: isShow(pb.allArticles)
            ? suggestionUI(context)
            : EmptyPage(
                icon: Icons.hourglass_empty,
                message: LocaleKeys.emptyPage.tr(),
                animate: true,
              ));
  }

  Widget suggestionUI(context) {
    var pb = Provider.of<ViewedArticlesBloc>(context);
    return ListView.separated(
      padding: EdgeInsets.all(8),
      itemCount: pb.allArticles.length,
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
                      height: 150,
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
                          pb.allArticles[index].preview_picture != null
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
                                                '${url + pb.allArticles[index].preview_picture}'),
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
                                    pb.allArticles[index].title,
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
                                      pb.allArticles[index].preview_text != null
                                          ? pb.allArticles[index].preview_text
                                              .replaceAll(
                                                  RegExp(
                                                      '(&[A-Za-z]+?;)|(<.+?>)|([\w-]+)'),
                                                  '')
                                          : '',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.black54),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Spacer(),
                                  pb.allArticles[index].datetime != null
                                      ? Row(
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
                                              format.format(format.parse(pb
                                                  .allArticles[index].datetime
                                                  .toString())),
                                              style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 13),
                                            ),
                                            Spacer(),
                                          ],
                                        )
                                      : SizedBox.shrink()
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
                          data: pb.allArticles[index],
                          category: pb.allArticles[index].title,
                          date: pb.allArticles[index].datetime != null
                              ? format.format(format.parse(
                                  pb.allArticles[index].datetime.toString()))
                              : '',
                          description: pb.allArticles[index].detail_text,
                          imageUrl: pb.allArticles[index].preview_picture,
                          norma: pb.allArticles[index].normativnye_akty,
                          title: pb.allArticles[index].title,
                          files: pb.allArticles[index].prikreplennye_fayly,
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
}
