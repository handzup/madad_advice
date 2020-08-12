//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:flutter_html/style.dart';
import 'package:madad_advice/blocs/viewed_articles_bloc.dart';
import 'package:madad_advice/models/config.dart';
import 'package:madad_advice/models/pinned_file.dart';
import 'package:madad_advice/models/scope.dart';
import 'package:madad_advice/models/sphere_articel.dart';
import 'package:madad_advice/pages/comments.dart';
import 'package:madad_advice/styles.dart';
import 'package:madad_advice/utils/next_screen.dart';
import 'package:madad_advice/widgets/downloader.dart';
import 'package:madad_advice/widgets/tag.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:madad_advice/generated/locale_keys.g.dart';

class DetailsPage extends StatefulWidget {
  final String category;
  final String date;
  final String description;
  final String imageUrl;
  final List<PinnedFile> files;
  final norma;
  final SphereArticle data;

  final String title;

  DetailsPage(
      {Key key,
      this.category,
      this.date,
      this.description,
      this.imageUrl,
      this.title,
      this.files,
      this.norma,
      this.data})
      : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState(
      category, date, description, imageUrl, title, files, norma, data);
}

class _DetailsPageState extends State<DetailsPage> {
  final String category;
  final norma;
  final String date;
  final String description;
  final String imageUrl;
  final List<PinnedFile> files;
  final String title;
  final SphereArticle data;
  var filesDirectory;
  bool showHtml = false;
  _DetailsPageState(this.category, this.date, this.description, this.imageUrl,
      this.title, this.files, this.norma, this.data);

  double rightPaddingValue = 50;
  List<Scope> scopes = [];
  @override
  void initState() {
    if (description.length > 10000) {
      showDelayed();
    } else {
      if (mounted) {
        setState(() {
          showHtml = true;
        });
      }
    }
    if (data.scopes != null) {
      data.scopes.forEach((key, value) => scopes.add(Scope(key, value)));
      scopes.sort((a, b) => a.name.length.compareTo(b.name.length));
    }
    //scopes.sort((a, b) => a.name.length.compareTo(b.name.length));
    Future.delayed(Duration(milliseconds: 100)).then((value) {
      if (mounted) {
        setState(() {
          rightPaddingValue = 10;
        });
      }
    });
    Future.delayed(Duration(milliseconds: 100)).then((value) async {
      var viewedBloc = Provider.of<ViewedArticlesBloc>(context, listen: false);
      if (!await viewedBloc.isExists(data.id))
        await viewedBloc.writeArticle(data.id, data);
    });
    super.initState();
  }

  Future<void> getPath() async {
    filesDirectory = await getApplicationDocumentsDirectory();
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  showDelayed() {
    Future.delayed(Duration(milliseconds: 600)).then((_) {
      if (mounted) {
        setState(() {
          showHtml = true;
        });
      }
    });
  }

  Future<bool> removeWidget() async {
    if (mounted) {
      if (description.length > 10000) {
        setState(() {
          showHtml = false;
        });
      }

      Navigator.pop(context);
    }
    return false;
  }

  renderhtml(article) {
    return Flexible(
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
        child: Html(
          data: article ?? '',
          //Optional parameters:
          style: {
            "html": Style(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//              color: Colors.white,
            ),
            "h1": Style(
              textAlign: TextAlign.center,
            ),
            "table": Style(
              backgroundColor: Color.fromARGB(0x50, 0xee, 0xee, 0xee),
            ),
            "tr": Style(
              border: Border(bottom: BorderSide(color: Colors.grey)),
            ),
            "th": Style(
              padding: EdgeInsets.all(6),
              backgroundColor: Colors.grey,
            ),
            "td": Style(
              padding: EdgeInsets.all(6),
            ),
            "var": Style(fontFamily: 'serif'),
          },
          customRender: {
            "flutter": (RenderContext context, Widget child, attributes, _) {
              return FlutterLogo(
                style: (attributes['horizontal'] != null)
                    ? FlutterLogoStyle.horizontal
                    : FlutterLogoStyle.markOnly,
                textColor: context.style.color,
                size: context.style.fontSize.size * 5,
              );
            },
          },
          onLinkTap: (url) {
            _launchURL(url);
          },
          onImageTap: (src) {
            print(src);
          },
          onImageError: (exception, stackTrace) {
            print(exception);
          },
        ),
      ),
    );
  }

  int selectedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: removeWidget,
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              title,
              overflow: TextOverflow.fade,
            ),
          ),
          body: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                            height: 28,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.black12),
                            child: AnimatedPadding(
                              duration: Duration(milliseconds: 1000),
                              padding: EdgeInsets.only(
                                  left: 10,
                                  right: rightPaddingValue,
                                  top: 5,
                                  bottom: 5),
                              child: Text(
                                category,
                                style: TextStyle(fontSize: 13),
                                overflow: TextOverflow.clip,
                              ),
                            )),
                        Spacer(),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.access_time, size: 18, color: Colors.grey),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          date,
                          style: TextStyle(color: Colors.black38, fontSize: 12),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      title,
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
                    ),
                    Divider(
                      color: ThemeColors.dividerColor,
                      endIndent: 200,
                      thickness: 2,
                    ),
                    SizedBox(
                      height: 8,
                    ),
//                     Flexible(
//                       child: MediaQuery(
//                         data:
//                             MediaQuery.of(context).copyWith(textScaleFactor: 1),
//                         child: Html(
//                           data: description ?? '',
//                           //Optional parameters:
//                           style: {
//                             'html': Style(
//                               backgroundColor:
//                                   Theme.of(context).scaffoldBackgroundColor,
// //              color: Colors.white,
//                             ),
//                             'h1': Style(
//                               textAlign: TextAlign.center,
//                             ),
//                             'table': Style(
//                               backgroundColor:
//                                   Color.fromARGB(0x50, 0xee, 0xee, 0xee),
//                             ),
//                             'tr': Style(
//                               border: Border(
//                                   bottom: BorderSide(color: Colors.grey)),
//                             ),
//                             'th': Style(
//                               padding: EdgeInsets.all(6),
//                               backgroundColor: Colors.grey,
//                             ),
//                             'td': Style(
//                               padding: EdgeInsets.all(6),
//                             ),
//                             'var': Style(fontFamily: 'serif'),
//                           },
//                           customRender: {
//                             'flutter': (RenderContext context, Widget child,
//                                 attributes, _) {
//                               return FlutterLogo(
//                                 style: (attributes['horizontal'] != null)
//                                     ? FlutterLogoStyle.horizontal
//                                     : FlutterLogoStyle.markOnly,
//                                 textColor: context.style.color,
//                                 size: context.style.fontSize.size * 5,
//                               );
//                             },
//                           },
//                           onLinkTap: (url) {
//                             _launchURL(url);
//                           },
//                           onImageTap: (src) {
//                             print(src);
//                           },
//                           onImageError: (exception, stackTrace) {
//                             print(exception);
//                           },
//                         ),
//                       ),
//                     ),

                    !showHtml
                        ? Container(
                            alignment: Alignment.center,
                            child: JumpingText(
                              '°°°',
                              style: TextStyle(fontSize: 30),
                            ),
                          )
                        : renderhtml(description),
                    norma != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(LocaleKeys.norma.tr()),
                              Divider(
                                color: ThemeColors.dividerColor,
                                endIndent: 200,
                                thickness: 2,
                              ),
                              MediaQuery(
                                data: MediaQuery.of(context)
                                    .copyWith(textScaleFactor: 1),
                                child: Html(
                                  data: norma
                                      .replaceAll('&lt;', '<')
                                      .replaceAll('&gt;', '>')
                                      .replaceAll('&quot;', '\''),
                                  //Optional parameters:
                                  style: {
                                    'html': Style(
                                      backgroundColor: Theme.of(context)
                                          .scaffoldBackgroundColor,
//              color: Colors.white,
                                    ),
                                    'h1': Style(
                                      textAlign: TextAlign.center,
                                    ),
                                    'table': Style(
                                      backgroundColor: Color.fromARGB(
                                          0x50, 0xee, 0xee, 0xee),
                                    ),
                                    'tr': Style(
                                      border: Border(
                                          bottom:
                                              BorderSide(color: Colors.grey)),
                                    ),
                                    'th': Style(
                                      padding: EdgeInsets.all(6),
                                      backgroundColor: Colors.grey,
                                    ),
                                    'td': Style(
                                      padding: EdgeInsets.all(6),
                                    ),
                                    'var': Style(fontFamily: 'serif'),
                                  },
                                  customRender: {
                                    'flutter': (RenderContext context,
                                        Widget child, attributes, _) {
                                      return FlutterLogo(
                                        style:
                                            (attributes['horizontal'] != null)
                                                ? FlutterLogoStyle.horizontal
                                                : FlutterLogoStyle.markOnly,
                                        textColor: context.style.color,
                                        size: context.style.fontSize.size * 5,
                                      );
                                    },
                                  },
                                  onLinkTap: (url) {
                                    _launchURL(url);
                                  },
                                  onImageTap: (src) {
                                    print(src);
                                  },
                                  onImageError: (exception, stackTrace) {
                                    print(exception);
                                  },
                                ),
                              )
                            ],
                          )
                        : SizedBox.shrink(),
                    SizedBox(
                      height: 20,
                    ),
                    files != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(LocaleKeys.pinnedFiles.tr()),
                              Divider(
                                color: ThemeColors.dividerColor,
                                endIndent: 200,
                                thickness: 2,
                              ),
                              SingleChildScrollView(
                                  physics: NeverScrollableScrollPhysics(),
                                  child: _buildDownloadFiles(files))
                            ],
                          )
                        : SizedBox.shrink(),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(LocaleKeys.helpful.tr()),
                          Stack(alignment: Alignment.center, children: [
                            selectedIndex != -1
                                ? Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      LocaleKeys.ty.tr(),
                                      softWrap: true,
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      ChoiceChip(
                                        label: Row(children: [
                                          Icon(Icons.check),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(LocaleKeys.yes.tr())
                                        ]),
                                        selected: selectedIndex == 0,
                                        onSelected: (v) {
                                          setState(() {
                                            selectedIndex = v ? 0 : -1;
                                          });
                                        },
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      ChoiceChip(
                                          label: Row(children: [
                                            Icon(Icons.clear),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(LocaleKeys.no.tr()),
                                          ]),
                                          selected: selectedIndex == 1,
                                          onSelected: (v) {
                                            setState(() {
                                              selectedIndex = v ? 1 : -1;
                                            });
                                          }),
                                    ],
                                  ),
                          ]),
                        ]),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(LocaleKeys.tags.tr()),
                        Divider(
                          color: ThemeColors.dividerColor,
                          endIndent: 200,
                          thickness: 2,
                        ),
                        Wrap(
                          alignment: WrapAlignment.start,
                          direction: Axis.horizontal,
                          verticalDirection: VerticalDirection.down,
                          children: List.generate(scopes.length, (index) {
                            return Tag(
                              tagRoute: scopes[index].url,
                              tagName: scopes[index].name,
                            );
                          }),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton.icon(
                          color: ThemeColors.primaryColor.withOpacity(0.5),
                          icon: Icon(Icons.comment,
                              color: Colors.black87, size: 20),
                          label: Text(
                              '${LocaleKeys.comments.tr()} ${data.forum_message_cnt}',
                              style: TextStyle(color: Colors.black87)),
                          onPressed: () {
                            nextScreen(
                                context,
                                CommentsPage(
                                    code: data.code,
                                    topicId: data.forum_topic_id));
                          },
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              // Others(
              //   timestamp: timestamp,
              // )
            ],
          ))),
    );
  }

  // Widget _buildLoves(loves) {
  //   return Text(
  //     '${loves.toString()} People like this',
  //     style: TextStyle(color: Colors.black38, fontSize: 13),
  //   );
  // }
  String _getFileName(String string) {
    int index = string.lastIndexOf('/');
    if (index == -1) return string;
    return string.substring(index + 1, string.length);
  }

  String _getFileType(String string) {
    int index = string.lastIndexOf('.');
    if (index == -1) return string;
    return string.substring(index + 1, string.length);
  }

  Widget _buildDownloadFiles(files) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return Downloader(
              fileName: _getFileName(files[index].path),
              fileUrl: '${Config().url + files[index].path}',
              filesDirectory: filesDirectory,
              filetype: _getFileType(files[index].path),
              size: files[index].size);
        },
        itemCount: files.length);
  }

  // Widget _buildBookmarkIcon(uid) {
  //   return StreamBuilder(
  //     stream: Firestore.instance.collection('users').document(uid).snapshots(),
  //     builder: (context, snap) {
  //       if (!snap.hasData) return BookmarkIcon().normal;
  //       List d = snap.data['bookmarked items'];

  //       if (d.contains(timestamp)) {
  //         return BookmarkIcon().bold;
  //       } else {
  //         return BookmarkIcon().normal;
  //       }
  //     },
  //   );
  // }

}
