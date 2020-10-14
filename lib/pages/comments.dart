import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../blocs/comments_bloc.dart';
import '../blocs/internet_bloc.dart';
import '../blocs/user_bloc.dart';
import '../generated/locale_keys.g.dart';
import '../models/comment.dart';
import '../models/config.dart';
import '../styles.dart';
import '../utils/api_response.dart';
import '../utils/empty.dart';
import '../utils/snacbar.dart';

class CommentsPage extends StatefulWidget {
  final String code;
  final String topicId;
  const CommentsPage({Key key, @required this.code, this.topicId})
      : super(key: key);

  @override
  _CommentsPageState createState() => _CommentsPageState(code, topicId);
}

class _CommentsPageState extends State<CommentsPage> {
  String code;
  String topicId;
  _CommentsPageState(this.code, this.topicId);
  final String url = Config().url;
  final _focusNode = FocusNode();
  var formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var textFieldCtrl = TextEditingController();
  double angleVal = pi * 2;
  String comment = '';
  APIResponse<List<Comment>> data;
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 0)).then((value) async {
      final cb = Provider.of<CommentsBloc>(context);
      if (topicId.isEmpty) {
        cb.setTopicId(null);
      } else {
        cb.setTopicId(topicId);
      }
      await cb.getCommens(code);
    });
    _focusNode.addListener(() {
      setState(() {
        angleVal = _focusNode.hasFocus ? pi * 1.5 : pi * 2;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void handleSubmit() async {
    final ib = Provider.of<InternetBloc>(context);
    final comb = Provider.of<CommentsBloc>(context);
    final ub = Provider.of<UserBloc>(context);
    final sp = await SharedPreferences.getInstance();

    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      await ib.checkInternet();
      if (ib.hasInternet == false) {
        openSnacbar(scaffoldKey, 'No internet available');
      } else {
        if (!await comb.sendComment(
            message: comment,
            authorName: ub.isGuest ? 'Guest' : ub.userName,
            authorId: ub.isGuest ? null : ub.uid,
            photo: sp.getString('image url'),
            code: code)) {
          scaffoldKey.currentState.showSnackBar(SnackBar(
            backgroundColor: Colors.black,
            content: Text(LocaleKeys.messageNotSent.tr()),
            duration: Duration(milliseconds: 300),
          ));
        }
        textFieldCtrl.clear();
      }
    }
  }

  // void handleDelete(uid, code2) async {
  //   final ib = Provider.of<InternetBloc>(context);
  //   await showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text(
  //             'Delete?',
  //             style: TextStyle(fontWeight: FontWeight.w600),
  //           ),
  //           content: Text('Want to delete this comment?'),
  //           actions: <Widget>[
  //             FlatButton(
  //               child: Text('Yes'),
  //               onPressed: () async {
  //                 Navigator.pop(context);
  //                 await ib.checkInternet();
  //                 if (ib.hasInternet == false) {
  //                   openToast(context, 'No internet connection');
  //                 } else {
  //                   final sp = await SharedPreferences.getInstance();
  //                   var _uid = sp.getString('uid');
  //                   if (uid != _uid) {
  //                     openToast(context, 'You can not delete others comment');
  //                   } else {
  //                     // await cb.deleteComment(code, uid, code2);
  //                     openToast(context, 'Deleted Successfully');
  //                   }
  //                 }
  //               },
  //             ),
  //             FlatButton(
  //               child: Text(LocaleKeys.no.tr()),
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               },
  //             )
  //           ],
  //         );
  //       });
  // }

  Widget dnkShow(APIResponse<List<Comment>> data, String lastCode) {
    if (lastCode != code) data = null;
    if (data == null) {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: ThemeColors.primaryColor,
        ),
      );
    } else {
      if (data.error) {
        return EmptyPage(icon: Icons.error, message: data.errorMessage);
      } else if (data.data.isEmpty) {
        return EmptyPage(icon: Icons.message, message: '');
      }
    }
    return _buildList(data.data);
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  void _onRefresh() async {
    final cb = Provider.of<CommentsBloc>(context);
    cb.getCommens(code);
    // if failed,usce refreshFailed()
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final CommentsBloc cb = Provider.of<CommentsBloc>(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          LocaleKeys.comments.tr(),
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        elevation: 1,
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: dnkShow(cb.data, cb.lastCode)),
          Divider(
            height: 1,
            color: Colors.black26,
          ),
          SafeArea(
              child: Container(
            height: 65,
            padding: EdgeInsets.only(top: 10, bottom: 10, right: 20, left: 20),
            width: double.infinity,
            color: Colors.white,
            child: Form(
              key: formKey,
              child: TextFormField(
                focusNode: _focusNode,
                decoration: InputDecoration(
                    errorStyle: TextStyle(fontSize: 0),
                    contentPadding:
                        EdgeInsets.only(left: 15, top: 10, right: 5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    hintText: LocaleKeys.writeComment.tr(),
                    suffixIcon: comment.length > 0
                        ? IconButton(
                            icon: Icon(
                              Icons.send,
                              color: Colors.grey[700],
                              size: 20,
                            ),
                            onPressed: () {
                              handleSubmit();
                            },
                          )
                        : SizedBox.shrink()),
                controller: textFieldCtrl,
                onChanged: (value) {
                  setState(() {
                    this.comment = value;
                  });
                },
                onSaved: (String value) {
                  setState(() {
                    this.comment = value;
                  });
                },
              ),
            ),
          ))
        ],
      ),
    );
  }

  Widget _buildList(List<Comment> d) {
    final user = Provider.of<UserBloc>(context);
    final cm = Provider.of<CommentsBloc>(context);
    cm.setTopicId(d[0].topicId);
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: false,
      controller: _refreshController,
      onRefresh: _onRefresh,
      child: ListView.builder(
        reverse: true,
        padding: EdgeInsets.all(15),
        itemCount: d.length,
        itemBuilder: (BuildContext context, int index) {
          if (d[index].authorId == user.uid) {
            return Container(
                child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                            left: 10, top: 10, right: 10, bottom: 3),
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              d[index].authorName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[900],
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              d[index]
                                  .postMessage
                                  .replaceAll('\n', '')
                                  .replaceAll(RegExp('[QUOTE].*[/QUOTE]'), '')
                                  .replaceAll(('\[\]'), ''),
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          d[index].postDate.substring(0, 16),
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w300,
                              color: Colors.grey),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10),
                  alignment: Alignment.bottomCenter,
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: CachedNetworkImageProvider(
                        d[index].photo != null
                            ? '${url + d[index].photo}'
                            : Config().uri),
                  ),
                ),
              ],
            ));
          }
          return Container(
              child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(top: 10),
                alignment: Alignment.bottomCenter,
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: CachedNetworkImageProvider(
                      d[index].photo != null
                          ? '${url + d[index].photo}'
                          : Config().uri),
                ),
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                          left: 10, top: 10, right: 10, bottom: 3),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            d[index].authorName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[900],
                                fontWeight: FontWeight.w600),
                          ),
                          Html(
                              data: d[index]
                                  .postMessage
                                  .replaceAll('[QUOTE]', '<b><i>')
                                  .replaceAll('[/QUOTE]', '</b></i> <br><br>'))
                          // Text(
                          //   d[index]
                          //       .postMessage
                          //       .replaceAll('\n', '')
                          //       .replaceAll(RegExp('[QUOTE].*[/QUOTE]'), '')
                          //       .replaceAll(('\[\]'), ''),
                          //   style: TextStyle(
                          //       fontSize: 14,
                          //       color: Colors.grey[700],
                          //       fontWeight: FontWeight.w400),
                          // ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        d[index].postDate.substring(0, 16),
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w300,
                            color: Colors.grey),
                      ),
                    )
                  ],
                ),
              )
            ],
          ));
        },
      ),
    );
  }
}
