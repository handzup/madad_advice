import 'package:cached_network_image/cached_network_image.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../blocs/drawer_menu_bloc.dart';
import '../blocs/recent_bloc.dart';
import '../blocs/section_bloc.dart';
import '../blocs/sign_in_bloc.dart';
import '../models/config.dart';
import '../styles.dart';
import '../utils/next_screen.dart';
import 'home.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({
    this.name,
    this.url,
    Key key,
  }) : super(key: key);
  final String name;
  final String url;
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with TickerProviderStateMixin {
  var aligng = Alignment(0, 0.0);
  bool show = false;
  AnimationController _controller;
  Animation _animation;
  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);

    Future.delayed(Duration(milliseconds: 0)).then((_) async {
      final sb = Provider.of<SignInBloc>(context);
      sb.checkSignIn();

      await Provider.of<DrawerMenuBloc>(context, listen: false).getMenuData();
      await Provider.of<SectionBloc>(context, listen: false)
          .getSectionData(force: true);
      await Provider.of<RecentDataBloc>(context).getRecentData(force: true);
    });
    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        aligng = Alignment(0, -0.75);
      });
      _controller.forward();
    });
    Future.delayed(const Duration(milliseconds: 2000), () {
      nextScreenReplace(context, HomePage());
    });
    super.initState();
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sb = Provider.of<SignInBloc>(context);
    ImageProvider downSide = AssetImage(Config().downSideSplashIcon);
    ImageProvider upSide = AssetImage(Config().splashIcon);
    // ImageProvider logo = AssetImage("images/logo_rienpa.png");

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: <Widget>[
            FadeTransition(
              opacity: _animation,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                alignment: aligng,
                child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            width: 120,
                            height: 120,
                            child: Image(
                              image: upSide,
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            RichText(
                              text: TextSpan(
                                text: 'Welcome to ',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[700]),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Advice for business',
                                      style: TextStyle(
                                          color: ThemeColors.primaryColor,
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment(0, 0),
              child: Container(
                  width: 100,
                  height: 100,
                  child: FlareActor('assets/loader.flr',
                      fit: BoxFit.contain, animation: 'defauld')),
            ),
            Align(
                alignment: Alignment(0, .5),
                child: Container(
                    width: 150,
                    height: 150,
                    child: Image(
                      image: downSide,
                    ))),
            // sb.isSignedIn != true
            //     ? Align(
            //         alignment: Alignment.bottomCenter,
            //         child: FlatButton(
            //           child: Text(
            //             LocaleKeys.auth.tr(),
            //             style: TextStyle(
            //                 color: ThemeColors.primaryColor, fontSize: 20),
            //           ),
            //           onPressed: () {
            //             nextScreen(context, SignUpPage());
            //           },
            //         ),
            //       )
            //     : SizedBox.shrink(),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
