import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:madad_advice/blocs/drawer_menu_bloc.dart';
import 'package:madad_advice/blocs/internet_bloc.dart';
import 'package:madad_advice/blocs/sign_in_bloc.dart';
import 'package:madad_advice/blocs/user_bloc.dart';
import 'package:madad_advice/models/config.dart';
import 'package:madad_advice/models/menu.dart';
import 'package:madad_advice/pages/category_page.dart';
import 'package:madad_advice/pages/help_page.dart';
import 'package:madad_advice/pages/profile.dart';
import 'package:madad_advice/pages/q&a_page.dart';
import 'package:madad_advice/pages/sections_page.dart';
import 'package:madad_advice/pages/sign_in.dart';
import 'package:madad_advice/pages/viewed_articles.dart';
import 'package:madad_advice/pages/welcome_page.dart';
import 'package:madad_advice/utils/fa_icon.dart';
import 'package:madad_advice/utils/next_screen.dart';
import 'package:madad_advice/widgets/search_bar.dart';
import 'package:provider/provider.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:madad_advice/generated/locale_keys.g.dart';
import '../styles.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({Key key}) : super(key: key);

  @override
  _DrawerMenuState createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  List<Menu> _apiResponse;

  bool checkUrl(url) {
    return url != null ? url.contains('http') : false;
  }

  @override
  initState() {
    Future.delayed(Duration(milliseconds: 0)).then((_) {
      checkInternet();
      setData();
    });

    super.initState();
  }

  void checkInternet() async {
    final ib = Provider.of<InternetBloc>(context);

    await ib.checkInternet;
    ib.hasInternet ? setData() : null;
  }

  void setData() {
    final cb = Provider.of<DrawerMenuBloc>(context);
    setState(() {
      _apiResponse = cb.menuData;
    });
  }

  Widget singOut() {
    return ClipOval(
      child: Material(
        color: Colors.white,
        child: InkWell(
          splashColor: Colors.grey,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(pi),
              child: Icon(
                MaterialCommunityIcons.logout_variant,
              ),
            ),
          ),
          onTap: () => handleLogout(),
        ),
      ),
    );
  }

  Widget singIn(BuildContext context) {
    return ClipOval(
      child: Material(
        color: Colors.white,
        child: InkWell(
          splashColor: Colors.grey,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(0),
              child: Icon(MaterialCommunityIcons.login_variant),
            ),
          ),
          onTap: () => nextScreen(
              context,
              SignInPage(
                firstSingIn: false,
              )),
        ),
      ),
    );
  }

  handleLogout() async {
    final sb = Provider.of<SignInBloc>(context);

    await showDialog(
        context: context,
        builder: (BuildContext context) {
          final isIos = Theme.of(context).platform == TargetPlatform.iOS;
          if (isIos) {
            return CupertinoAlertDialog(
              title: Text(
                '${LocaleKeys.signOut.tr()}?',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              content: Text(
                LocaleKeys.rlySignOut.tr(),
                style: TextStyle(fontSize: 12),
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text(LocaleKeys.yes.tr()),
                  onPressed: () async {
                    await sb.setLogIut();
                    nextScreenCloseOthers(context, WelcomePage());
                  },
                ),
                CupertinoDialogAction(
                  child: Text(LocaleKeys.no.tr()),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          } else {
            return AlertDialog(
              title: Text(
                '${LocaleKeys.signOut.tr()}?',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              content: Text(
                LocaleKeys.rlySignOut.tr(),
                style: TextStyle(fontSize: 12),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(LocaleKeys.yes.tr()),
                  onPressed: () async {
                    await sb.setLogIut();
                    nextScreenCloseOthers(context, WelcomePage());
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
          }
        });
  }

  void exitFromApp() async {
    await MoveToBackground.moveTaskToBack();
  }

  void pageNavigator(String page) {
    switch (page.replaceAll(RegExp('/'), '')) {
      case 'sfery':
        nextScreen(context, CategoryPage());
        break;
      case 'settings':
        nextScreen(context, ProfilePage());
        break;
      case 'sections':
        nextScreen(context, SectionPage());
        break;
      case 'history':
        nextScreen(context, ViewedArticles()); //WebViewExample()
        break;
      case 'question':
        nextScreen(context, QandAPage());
        break;
      case 'exit':
        exitFromApp();
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    final isIos = Theme.of(context).platform == TargetPlatform.iOS;
    final cb = Provider.of<DrawerMenuBloc>(context);

    setState(() {
      _apiResponse = cb.menuData;
    });
    _apiResponse != null
        ? _apiResponse.sort((a, b) => a.sort.compareTo(b.sort))
        : null;
    final ub = Provider.of<UserBloc>(context);
    final sp = Provider.of<SignInBloc>(context);

    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () => nextScreen(context, ProfilePage()),
            child: Container(
                color: ThemeColors.primaryColor,
                height: MediaQuery.of(context).size.height * 0.24,
                child: Column(
                  children: <Widget>[
                    Spacer(
                      flex: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20, bottom: 0, left: 15, right: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Flexible(
                            flex: 1,
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: ThemeColors.primaryColor,
                              backgroundImage: (checkUrl(ub.imageUrl)
                                  ? CachedNetworkImageProvider(
                                      ub.imageUrl,
                                    )
                                  : (File(ub.imageUrl).existsSync()
                                      ? FileImage(File(ub.imageUrl))
                                      : AssetImage(Config().splashIcon))),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            flex: 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  ub.userName,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  ub.email,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Spacer(
                      flex: 3,
                    ),
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Spacer(),
                          InkWell(
                            borderRadius: BorderRadius.circular(26),
                            child: Container(
                                width: 45,
                                height: 45,
                                child: Icon(
                                  FontAwesome.facebook,
                                  size: 20,
                                  color: Colors.white,
                                )),
                            onTap: () {},
                          ),
                          Spacer(),
                          InkWell(
                            borderRadius: BorderRadius.circular(26),
                            child: Container(
                                width: 45,
                                height: 45,
                                child: Icon(
                                  FontAwesome.instagram,
                                  size: 20,
                                  color: Colors.white,
                                )),
                            onTap: () {},
                          ),
                          Spacer(),
                          InkWell(
                            borderRadius: BorderRadius.circular(26),
                            child: Container(
                                width: 45,
                                height: 45,
                                child: Icon(
                                  FontAwesome.twitter,
                                  size: 20,
                                  color: Colors.white,
                                )),
                            onTap: () {},
                          ),
                          Spacer(),
                          InkWell(
                            borderRadius: BorderRadius.circular(26),
                            child: Container(
                                width: 45,
                                height: 45,
                                child: Icon(
                                  FontAwesome.youtube_play,
                                  size: 20,
                                  color: Colors.white,
                                )),
                            onTap: () => print("youtube_play"),
                          ),
                          Spacer(),
                          InkWell(
                              borderRadius: BorderRadius.circular(26),
                              child: Container(
                                  width: 45,
                                  height: 45,
                                  child: Icon(
                                    FontAwesome.telegram,
                                    size: 20,
                                    color: Colors.white,
                                  )),
                              onTap: () => print("telegram")),
                          Spacer(),
                        ],
                      ),
                    ),
                    Spacer(
                      flex: 1,
                    ),
                  ],
                )),
          ),
          SearchBar(),
          Flexible(
            child: _apiResponse == null
                ? Container()
                : ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(0),
                    itemCount: _apiResponse.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (!isIos || _apiResponse[index].path != 'exit')
                        return ListTile(
                          title: Text(
                            _apiResponse[index].title,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: Colors.grey[700]),
                          ),
                          leading: CircleAvatar(
                              backgroundColor: Colors.white12,
                              child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.white,
                                    border:
                                        Border.all(color: Colors.grey[100])),
                                child: FaIcons(
                                  _apiResponse[index].icon.toString(),
                                  color: Colors.blue.withOpacity(.4),
                                  size: 20,
                                ),
                              )),
                          onTap: () {
                            Navigator.pop(context);
                            pageNavigator(_apiResponse[index].path);
                          },
                        );
                    },
                  ),
          ),
          Container(
              color: Colors.grey[200],
              padding: EdgeInsets.all(5),
              height: MediaQuery.of(context).size.height * 0.11,
              child: Column(
                children: <Widget>[
                  Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Spacer(),
                      sp.isSignedIn ? singOut() : singIn(context),
                      Spacer(),
                      ClipOval(
                        child: Material(
                          color: Colors.white,
                          child: InkWell(
                              splashColor: Colors.grey,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Icon(FontAwesome.question_circle),
                              ),
                              onTap: () => nextScreen(
                                  context,
                                  HelpPage(
                                    tag: 'Help',
                                    category: "Helper",
                                    date: 'today',
                                    description:
                                        'Some description here for ur reading',
                                    imageUrl:
                                        'https://img.pngio.com/avatar-business-face-people-icon-people-icon-png-512_512.png',
                                    loves: 24,
                                    timestamp: '4:44',
                                    title: 'Lorem impus',
                                  ))),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                  Spacer(),
                ],
              )),
        ],
      ),
    );
  }
}
