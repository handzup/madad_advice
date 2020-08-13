import 'dart:io';
import 'dart:ui';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:madad_advice/blocs/category_bloc.dart';
import 'package:madad_advice/blocs/drawer_menu_bloc.dart';
import 'package:madad_advice/blocs/internet_bloc.dart';
import 'package:madad_advice/blocs/section_bloc.dart';
import 'package:madad_advice/blocs/sign_in_bloc.dart';
import 'package:madad_advice/blocs/user_bloc.dart';
import 'package:madad_advice/models/category.dart';
import 'package:madad_advice/models/recived_notification.dart';
import 'package:madad_advice/pages/q&a_page.dart';
import 'package:madad_advice/styles.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:madad_advice/utils/api_response.dart';
import 'package:madad_advice/utils/api_service.dart';
import 'package:madad_advice/utils/locator.dart';
import 'package:madad_advice/utils/next_screen.dart';
import 'package:madad_advice/widgets/drawer.dart';
import 'package:madad_advice/widgets/loading_shimmer.dart';
import 'package:madad_advice/widgets/reacent_home.dart';
import 'package:madad_advice/widgets/recent_news.dart';
import 'package:madad_advice/widgets/service_error_snackbar.dart';
import 'package:madad_advice/widgets/sphere.dart';
import 'package:madad_advice/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  APIResponse<List<MyCategory>> _apiResponse;
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
          checkInternet();
        },
      ),
    );
  }

  void checkInternet() async {
    final ib = Provider.of<InternetBloc>(context);

    await ib.checkInternet();
    ib.hasInternet == false
        ? _scaffoldKey.currentState.showSnackBar(snackBar())
        : _handleRefresh();
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
      final dynamic data = message['data'];
      print('data 222');
    }

    if (message.containsKey('notification')) {
      print('noti 222');
      // Handle notification message
      final dynamic notification = message['notification'];
    }
    print('data default');
    // Or do other work.
  }

  final _firebaseMessaging = FirebaseMessaging();
  @override
  void initState() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_stat');

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
      final ub = Provider.of<UserBloc>(context);
      final sp = Provider.of<SignInBloc>(context);

      sp.checkSignIn();
      ub.getUserData();
      _requestIOSPermissions();
      _configureSelectNotificationSubject();
      checkInternet();
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
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print('Settings registered: $settings');
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      print('Push Messaging token: $token');
    });

    super.initState();
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
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
      await nextScreen(context, QandAPage());
    });
  }

  final List categoryColors = [ThemeColors.primaryColor.withOpacity(.1)];

  Future<Null> _handleRefresh() async {
    final ib = Provider.of<InternetBloc>(context, listen: false);
    await ib.checkInternet();
    ib.hasInternet == false
        ? _scaffoldKey.currentState.showSnackBar(snackBar())
        : null;
    final cb = Provider.of<CategoryBloc>(context);
    final drawer = Provider.of<DrawerMenuBloc>(context);
    final sections = Provider.of<SectionBloc>(context);
    await drawer.getMenuData();
    await cb.getCategoryData(force: true);
    await sections.getSectionData(force: true);
    if (cb.sphereData.error) {
      _scaffoldKey.currentState.showSnackBar(serviceError());
    }
    return null;
  }

  bool isShow(APIResponse<List<MyCategory>> response) {
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
    final cb = Provider.of<CategoryBloc>(context);
    setState(() {
      _apiResponse = cb.sphereData;
    });

    return Scaffold(
        drawer: DrawerMenu(),
        key: _scaffoldKey,
        appBar: AppBar(
          titleSpacing: 0.0,
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
                RichText(
                  text: TextSpan(
                    text: 'Advice for Business',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                    children: <TextSpan>[],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: LiquidPullToRefresh(
            showChildOpacityTransition: false,
            height: 50,
            color: ThemeColors.primaryColor.withOpacity(0.8),
            animSpeedFactor: 2,
            borderWidth: 1,
            springAnimationDurationInMilliseconds: 100,
            onRefresh: _handleRefresh,
            child: isShow(_apiResponse)
                ? Container(
                    child: ListView(
                      children: <Widget>[
                        Container(
                          child: LoadingSphereWidget(),
                          width: double.infinity,
                          height: 500,
                        ),
                        Recent(),
                      ],
                    ),
                  )
                : Container(
                    child: CustomScrollView(slivers: <Widget>[
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            if (index == 0) {
                              return Container(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      height: 30,
                                      width: 4,
                                      decoration: BoxDecoration(
                                          color: ThemeColors.primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                            LocaleKeys.spheresList
                                                .tr(), //title Сферы
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w600))
                                        .tr(),
                                    Spacer(),
                                  ],
                                ),
                              );
                            }
                            return Sphere(
                              categoryColor: Color(0xfffdfdfd).withOpacity(0.9),
                              data: _apiResponse.data,
                              index: index - 1,
                            );
                          },
                          childCount: _apiResponse.data.length + 1,
                        ),
                      ),
                      ReacentHome()
                    ]),
                  )));
  }
}
