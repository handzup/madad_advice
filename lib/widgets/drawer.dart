import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';

import '../blocs/drawer_menu_bloc.dart';
import '../blocs/internet_bloc.dart';
import '../blocs/sign_in_bloc.dart';
import '../blocs/soc_links_bloc.dart';
import '../blocs/user_bloc.dart';
import '../generated/locale_keys.g.dart';
import '../models/config.dart';
import '../models/menu.dart';
import '../pages/language.dart';
import '../pages/profile.dart';
import '../pages/sign_in.dart';
import '../pages/welcome_page.dart';
import '../styles.dart';
import '../utils/api_response.dart';
import '../utils/next_screen.dart';
import 'expandable.dart';
import 'search_bar.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({Key key}) : super(key: key);

  @override
  _DrawerMenuState createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  APIResponse<List<Menu>> _apiResponse;

  bool checkUrl(url) {
    return url != null ? url.contains('http') : false;
  }

  bool isExpanded = false;
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

    await ib.checkInternet();
    // ignore: unnecessary_statements
    ib.hasInternet ? setData() : null;
  }

  void setData() {
    final cb = Provider.of<DrawerMenuBloc>(context);
    setState(() {
      _apiResponse = cb.menuData;
    });
  }

  Widget singOut() {
    return FlatButton(
      onPressed: () => handleLogout(),
      child: Material(
        color: Colors.white,
        child: InkWell(
          splashColor: Colors.grey,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: <Widget>[
                Text(
                  LocaleKeys.signOut.tr(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                SizedBox(
                  width: 10,
                ),
                Icon(
                  FontAwesomeIcons.duotoneSignIn,
                  color: Colors.grey,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget singIn(BuildContext context) {
    return FlatButton(
      onPressed: () => nextScreen(
          context,
          SignInPage(
            firstSingIn: false,
          )),
      child: Material(
        color: Colors.white,
        child: InkWell(
          splashColor: Colors.grey,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: <Widget>[
                Text(
                  LocaleKeys.signIn.tr(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                SizedBox(
                  width: 10,
                ),
                Icon(
                  FontAwesomeIcons.duotoneSignIn,
                  color: Colors.grey,
                )
              ],
            ),
          ),
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

  bool isShow(APIResponse<List<Menu>> response) {
    if (response == null) {
      return true;
    } else {
      if (response.error) {
        return true;
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cb = Provider.of<DrawerMenuBloc>(context);

    setState(() {
      _apiResponse = cb.menuData;
    });
    _apiResponse != null
        ? _apiResponse.data.sort((a, b) => a.sort.compareTo(b.sort))
        // ignore: unnecessary_statements
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
                    _socMedia(context),
                    Spacer(
                      flex: 1,
                    ),
                  ],
                )),
          ),
          SearchBar(),
          Flexible(
              child: isShow(_apiResponse) ? Container() : buildList(context)),
          HorizontalLangView(),
          Container(
              color: Colors.grey[200],
              padding: EdgeInsets.all(5),
              height: MediaQuery.of(context).size.height * 0.11,
              child: Column(
                children: <Widget>[
                  Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Entypo.info_with_circle),
                        onPressed: () => _showDisclaimer(context),
                      ),
                      sp.isSignedIn ? singOut() : singIn(context),
                    ],
                  ),
                  Spacer(),
                ],
              )),
        ],
      ),
    );
  }

  Widget buildList(context) {
    final isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return ListView.builder(
      
      physics: AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(0),
      itemCount: _apiResponse.data.length,
      // ignore: missing_return
      itemBuilder: (BuildContext context, int index) {
        if (!isIos || _apiResponse.data[index].path != 'exit')
          return ExpandedList(
            data: _apiResponse.data[index],
          );
      },
    );
  }
}

_showDisclaimer(context) {
  var alertStyle = AlertStyle(
    animationType: AnimationType.grow,
    isCloseButton: true,
    alertPadding: EdgeInsets.only(left: 20, right: 20),
    isOverlayTapDismiss: true,
    titleStyle: TextStyle(color: Colors.red, fontSize: 16),
    descStyle: TextStyle(fontSize: 12),
  );
  Alert(
    style: alertStyle,
    context: context,
    title: "Disclaimer",
    desc:
        """This application is made possible by the support of the American People through the U.S. Agency for International Development (USAID). The contents are the sole responsibility of Tetra Tech DPK and do not necessarily reflect the views of USAID or the United States Government. 

Данное приложение стал возможным благодаря помощи американского народа, оказанной через Агентство США по международному развитию (USAID). Tetra Tech DPK (Тетра Тек ДПК) несет ответственность за содержание публикации, которое не обязательно отражает позицию USAID или Правительства США.

Мазкур дастур АҚШ Халқаро Тараққиёт Агентлиги (USAID) орқали кўрсатилган Америка халқининг ёрдами асосида яратилган. Маҳсулот мазмуни бўйича масъулият Tetra Tech DPK га юклатилади ва USAID ёки АҚШ ҳукумати расмий нуқтаи назарини акс эттириши шарт эмас.""",
  ).show();
}

Widget _socMedia(context) {
  final media = Provider.of<CosLinksBloc>(context);

  return Container(
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
          onTap: () {
            _launchURL(media.media.facebook);
          },
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
          onTap: () {
            _launchURL(media.media.instagram);
          },
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
          onTap: () {
            _launchURL(media.media.twitter);
          },
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
          onTap: () => _launchURL(media.media.youtubel),
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
            onTap: () => _launchURL(media.media.telegram)),
        Spacer(),
      ],
    ),
  );
}

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
