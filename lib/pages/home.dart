import 'dart:io';
import 'dart:ui';

import 'package:connectivity/connectivity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';
import 'package:provider/provider.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:rxdart/subjects.dart';

import '../blocs/drawer_menu_bloc.dart';
import '../blocs/recent_bloc.dart';
import '../blocs/section_bloc.dart';
import '../blocs/sign_in_bloc.dart';
import '../blocs/user_bloc.dart';
import '../generated/locale_keys.g.dart';
import '../models/recived_notification.dart';
import '../models/section.dart';
import '../styles.dart';
import '../utils/next_screen.dart';
import '../widgets/drawer.dart';
import '../widgets/main_page_block.dart';
import '../widgets/no_internet_connection.dart';
import '../widgets/reacent_home.dart';
import 'q&a_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  RateMyApp _rateMyApp = RateMyApp(
    preferencesPrefix: 'rateMyApp_',
    minDays: 5,
    minLaunches: 5,
    remindDays: 2,
    remindLaunches: 2,
  );
  var subscription;
  int currentIndex = 0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  NotificationAppLaunchDetails notificationAppLaunchDetails;
  final BehaviorSubject<ReceivedNotification>
      didReceiveLocalNotificationSubject =
      BehaviorSubject<ReceivedNotification>();
  final BehaviorSubject<String> selectNotificationSubject =
      BehaviorSubject<String>();

  Widget snackBar({bool serviceError = false}) {
    return SnackBar(
      duration: Duration(minutes: 1),
      content: Container(
        alignment: Alignment.centerLeft,
        height: 60,
        child: Text(
          LocaleKeys.noInternet.tr(),
          style: TextStyle(
            fontSize: 17,
          ),
        ),
      ),
      action: SnackBarAction(
        label: serviceError ? 'Servcie Error' : LocaleKeys.tryAgain.tr(),
        textColor: Colors.blueAccent,
        onPressed: () {
          _handleRefresh();
        },
      ),
    );
  }

  Future<void> _showNotification({message}) async {
    var bigTextStyleInformation = BigTextStyleInformation(
        '${message['notification']['body']}',
        htmlFormatBigText: true,
        contentTitle: '  <b>${message['notification']['title']}</b> ',
        htmlFormatContentTitle: true,
        htmlFormatSummaryText: true);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max,
        priority: Priority.High,
        ticker: 'ticker',
        largeIcon: DrawableResourceAndroidBitmap('@drawable/ic_launcher'),
        color: Color(0xFF233f60),
        styleInformation: bigTextStyleInformation);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0,
        message['notification']['title'],
        message['notification']['body'],
        platformChannelSpecifics,
        payload: 'dasdas');
  }

  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      // Handle data message
      print('data 222');
    }

    if (message.containsKey('notification')) {
      print('noti 222');
      // Handle notification message
    }
    print('data default');
    // Or do other work.
  }

  internetlisener() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        _scaffoldKey.currentState.showSnackBar(snackBar());
      } else {
        _scaffoldKey.currentState.hideCurrentSnackBar();
        _handleRefresh();
      }
    });
  }

  final _firebaseMessaging = FirebaseMessaging();
  @override
  void initState() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_stat');
    internetlisener();
    var initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        onDidReceiveLocalNotification:
            (int id, String title, String body, String payload) async {
          didReceiveLocalNotificationSubject.add(ReceivedNotification(
              id: id, title: title, body: body, payload: payload));
        });
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      selectNotificationSubject.add(payload);
    });
    Future.delayed(Duration(milliseconds: 0)).then((_) {
      Provider.of<UserBloc>(context, listen: false).getUserData();
      Provider.of<SignInBloc>(context, listen: false).checkSignIn();
      _requestIOSPermissions();
      _configureSelectNotificationSubject();
    });
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
        await _showNotification(message: message);
      },
      onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
        nextScreen(context, QandAPage());
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
        nextScreen(context, QandAPage());
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: false));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print('Settings registered: $settings');
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      print('Push Messaging token: $token');
    });
    Future.delayed(Duration(seconds: 1)).then((_) {
      _rateMyApp.init().then((_) async {
        if (_rateMyApp.shouldOpenDialog) {
          _rateMyApp.launchNativeReviewDialog();
        }
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    subscription.cancel();
    super.dispose();
  }

  void _requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      nextScreen(context, QandAPage());
    });
  }

  final List categoryColors = [ThemeColors.primaryColor.withOpacity(.1)];
  ScrollController _scrollController;
  TabController _tabController;

  Future<Null> _handleRefresh() async {
    //final cb = Provider.of<CategoryBloc>(context);
    await Provider.of<DrawerMenuBloc>(context, listen: false).getMenuData();
    await Provider.of<SectionBloc>(context, listen: false)
        .getSectionData(force: true);
    await Provider.of<RecentDataBloc>(context).getRecentData(force: true);
    // await cb.getCategoryData(force: true);
    // if (cb.sphereData.error) {
    //   _scaffoldKey.currentState.showSnackBar(serviceError());
    // }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          drawer: DrawerMenu(),
          key: _scaffoldKey,
          body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  bottom: TabBar(
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: ThemeColors.primaryColor,
                      unselectedLabelColor: Color(0xff5f6368), //niceish grey
                      isScrollable: false,
                      indicator: MD2Indicator(
                          //it begins here
                          indicatorHeight: 5,
                          indicatorColor: ThemeColors.primaryColor,
                          indicatorSize: MD2IndicatorSize
                              .full //3 different modes tiny-normal-full
                          ),
                      tabs: <Widget>[
                        Tab(
                          child: Text(
                            LocaleKeys.spheresList.tr(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Tab(
                          child: Text(
                            LocaleKeys.recentArticels.tr(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ]),
                  automaticallyImplyLeading: false,
                  centerTitle: false,
                  titleSpacing: 0,
                  pinned: true,
                  floating: true,
                  forceElevated: innerBoxIsScrolled,
                  leading: IconButton(
                    icon: Icon(
                      AntDesign.menu_fold,
                      color: Colors.black87,
                    ),
                    onPressed: () {
                      _scaffoldKey.currentState.openDrawer();
                    },
                  ),
                  title: Container(
                    child: Row(
                      children: <Widget>[
                        Image(width: 30, image: AssetImage('assets/logo.png')),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text(
                              LocaleKeys.appTitle.tr(),
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18,
                                  decorationThickness: 0,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black),
                            ),
                            Text(
                              LocaleKeys.appSubtitle.tr(),
                              style: TextStyle(
                                  fontFamily: 'Open Sans',
                                  fontSize: 12,
                                  height: 0.40,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ];
            },
            body: LiquidPullToRefresh(
                showChildOpacityTransition: false,
                height: 50,
                color: ThemeColors.primaryColor.withOpacity(0.8),
                animSpeedFactor: 2,
                borderWidth: 1,
                springAnimationDurationInMilliseconds: 100,
                onRefresh: _handleRefresh,
                child: TabBarView(
                  children: <Widget>[
                    Consumer<SectionBloc>(
                      builder: (context, data, child) {
                        if (data.sectionData.data.isEmpty) return child;
                        return buildCategoryList(data.sectionData.data);
                      },
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: NoInternetConnection(),
                          ),
                        ],
                      ),
                    ),
                    ReacentHome()
                  ],
                )),
            controller: _scrollController,
          )),
    );
  }

  Widget buildCategoryList(List<Section> data) {
    return Container(
      child:
          CustomScrollView(physics: ClampingScrollPhysics(), slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              // return Sphere(
              //   categoryColor: Color(0xfffdfdfd).withOpacity(0.9),
              //   data: data,
              //   index: index,
              // );
              return MainPageBlock(data: data[index]);
            },
            childCount: data.length,

            ///sda
          ),
        ),
      ]),
    );
  }
}
