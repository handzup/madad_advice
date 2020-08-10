import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:madad_advice/blocs/comments_bloc.dart';
import 'package:madad_advice/blocs/internet_bloc.dart';
import 'package:madad_advice/blocs/sign_in_bloc.dart';
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
 
  final String timestamp;
  const CommentsPage(
      {Key key,   @required this.timestamp})
      : super(key: key);

  @override
  _CommentsPageState createState() =>
      _CommentsPageState( timestamp);
}

class _CommentsPageState extends State<CommentsPage> {
  
  String timestamp;
  _CommentsPageState(  this.timestamp);

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
        // await cb.saveNewComment(timestamp, comment);
        textFieldCtrl.clear();
        FocusScope.of(context).requestFocus(new FocusNode());
      }
    }
  }

  void handleDelete(uid, timestamp2) async {
    final   ib = Provider.of<InternetBloc>(context);
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
                    final   sp =
                        await SharedPreferences.getInstance();
                    var _uid = sp.getString('uid');
                    if (uid != _uid) {
                      openToast(context, 'You can not delete others comment');
                    } else {
                      // await cb.deleteComment(timestamp, uid, timestamp2);
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
            future: cb.getData(timestamp),
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
                        nextScreen(context, SignInPage());
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

  Widget _buildList(snap) {
    List d = snap;
    d.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
    return ListView.builder(
      padding: EdgeInsets.all(15),
      itemCount: d.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          child: Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Row(
                children: <Widget>[
                  Container(
                    alignment: Alignment.bottomLeft,
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.grey[200],
                      backgroundImage:
                          CachedNetworkImageProvider(d[index]['image url']),
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
                                d[index]['name'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[900],
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                d[index]['comment'],
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
                            d[index]['date'],
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
              )),
          onLongPress: () {
            handleDelete(d[index]['uid'], d[index]['timestamp']);
          },
        );
      },
    );
  }
}
