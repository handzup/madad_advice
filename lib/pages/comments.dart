import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:madad_advice/blocs/comments_bloc.dart';
import 'package:madad_advice/blocs/internet_bloc.dart';
import 'package:madad_advice/blocs/sign_in_bloc.dart';
import 'package:madad_advice/blocs/user_bloc.dart';
import 'package:madad_advice/models/comment.dart';
import 'package:madad_advice/models/config.dart';
import 'package:madad_advice/pages/sign_in.dart';
import 'package:madad_advice/styles.dart';
import 'package:madad_advice/utils/empty.dart';
import 'package:madad_advice/utils/next_screen.dart';
import 'package:madad_advice/utils/snacbar.dart';
import 'package:madad_advice/utils/toast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:madad_advice/generated/locale_keys.g.dart';

class CommentsPage extends StatefulWidget {
  final String code;
  const CommentsPage({Key key, @required this.code}) : super(key: key);

  @override
  _CommentsPageState createState() => _CommentsPageState(code);
}

class _CommentsPageState extends State<CommentsPage> {
  String code;
  _CommentsPageState(this.code);
  final String url = Config().url;

  var formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var textFieldCtrl = TextEditingController();
  String comment;

  void handleSubmit() async {
    final InternetBloc ib = Provider.of<InternetBloc>(context);
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      await ib.checkInternet;
      if (ib.hasInternet == false) {
        openSnacbar(scaffoldKey, 'No internet available');
      } else {
        // await cb.saveNewComment(code, comment);
        textFieldCtrl.clear();
        FocusScope.of(context).requestFocus(new FocusNode());
      }
    }
  }

  void handleDelete(uid, code2) async {
    final ib = Provider.of<InternetBloc>(context);
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Delete?',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            content: Text('Want to delete this comment?'),
            actions: <Widget>[
              FlatButton(
                child: Text('Yes'),
                onPressed: () async {
                  Navigator.pop(context);
                  await ib.checkInternet;
                  if (ib.hasInternet == false) {
                    openToast(context, 'No internet connection');
                  } else {
                    final sp = await SharedPreferences.getInstance();
                    var _uid = sp.getString('uid');
                    if (uid != _uid) {
                      openToast(context, 'You can not delete others comment');
                    } else {
                      // await cb.deleteComment(code, uid, code2);
                      openToast(context, 'Deleted Successfully');
                    }
                  }
                },
              ),
              FlatButton(
                child: Text(LocaleKeys.no.tr()),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final CommentsBloc cb = Provider.of<CommentsBloc>(context);
    final SignInBloc sb = Provider.of<SignInBloc>(context);
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
          Expanded(
              child: FutureBuilder(
            future: cb.getData(code),
            builder: (context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return EmptyPage(
                      icon: Icons.signal_wifi_off,
                      message: 'No internet connection');
                case ConnectionState.waiting:
                  return Center(
                      child: CircularProgressIndicator(
                    backgroundColor: Colors.deepPurpleAccent,
                  ));
                default:
                  if (snapshot.hasError)
                    return EmptyPage(icon: Icons.error, message: 'Error');
                  if (snapshot.data.isEmpty)
                    return EmptyPage(icon: Icons.message, message: '');
                  else
                    return _buildList(snapshot.data);
              }
            },
          )),
          Divider(
            height: 1,
            color: Colors.black26,
          ),
          SafeArea(
              child: sb.isSignedIn
                  ? Container(
                      height: 65,
                      padding: EdgeInsets.only(
                          top: 8, bottom: 10, right: 20, left: 20),
                      width: double.infinity,
                      color: Colors.white,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(25)),
                        child: Form(
                          key: formKey,
                          child: TextFormField(
                            decoration: InputDecoration(
                                errorStyle: TextStyle(fontSize: 0),
                                contentPadding: EdgeInsets.only(
                                    left: 15, top: 10, right: 5),
                                border: InputBorder.none,
                                hintText: LocaleKeys.writeComment.tr(),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    Icons.send,
                                    color: Colors.grey[700],
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    handleSubmit();
                                  },
                                )),
                            controller: textFieldCtrl,
                            onSaved: (String value) {
                              setState(() {
                                this.comment = value;
                              });
                            },
                            validator: (value) {
                              if (value.length == 0) return 'nullllll';
                              return null;
                            },
                          ),
                        ),
                      ),
                    )
                  : InkWell(
                      onTap: () {
                        nextScreen(context, SignInPage(firstSingIn: false));
                      },
                      splashColor: Colors.red,
                      highlightColor: Colors.green,
                      child: Container(
                        height: 65,
                        padding: EdgeInsets.only(
                            top: 8, bottom: 10, right: 20, left: 20),
                        width: double.infinity,
                        color: Colors.white,
                        alignment: Alignment.center,
                        child: Text(
                          LocaleKeys.signIn.tr(),
                          style: TextStyle(
                              color: ThemeColors.primaryColor,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ))
        ],
      ),
    );
  }

  Widget _buildList(List<Comment> d) {
    final user = Provider.of<UserBloc>(context);
    return ListView.builder(
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
                        d[index].postDate,
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
                        Html(data: d[index].postMessage.replaceAll('[QUOTE]', '<b><i>').replaceAll('[/QUOTE]','</b></i> <br><br>'))
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
                      d[index].postDate,
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
    );
  }
}
