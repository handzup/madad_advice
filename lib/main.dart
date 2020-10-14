import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'blocs/articel_bloc.dart';
import 'blocs/bookmark_bloc.dart';
import 'blocs/category_bloc.dart';
import 'blocs/comments_bloc.dart';
import 'blocs/download_bloc.dart';
import 'blocs/drawer_menu_bloc.dart';
import 'blocs/internet_bloc.dart';
import 'blocs/news_data_bloc.dart';
import 'blocs/notification_bloc.dart';
import 'blocs/popular_bloc.dart';
import 'blocs/question_bloc.dart';
import 'blocs/recent_bloc.dart';
import 'blocs/recommanded_bloc.dart';
import 'blocs/search_bloc.dart';
import 'blocs/section_bloc.dart';
import 'blocs/sign_in_bloc.dart';
import 'blocs/sing_up_bloc.dart';
import 'blocs/soc_links_bloc.dart';
import 'blocs/user_bloc.dart';
import 'blocs/viewed_articles_bloc.dart';
import 'httpcsv.dart' as CsvAssetLoader;
import 'models/category.dart';
import 'models/langs.dart';
import 'models/menu.dart';
import 'models/pinned_file.dart';
import 'models/recived_notification.dart';
import 'models/section.dart';
import 'models/sphere.dart';
import 'models/sphere_articel.dart';
import 'models/sphere_article_short.dart';
import 'models/subsection.dart';
import 'models/subsection_2.dart';
import 'pages/welcome_page.dart';
import 'utils/locator.dart';
import 'widgets/preload.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

NotificationAppLaunchDetails notificationAppLaunchDetails;
void main() async {
  setupLocator();
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  await Hive.initFlutter();
  Hive.registerAdapter(SectionAdapter());
  Hive.registerAdapter(MenuAdapter());
  Hive.registerAdapter(SubsectionAdapter());
  Hive.registerAdapter(Subsection2Adapter());
  Hive.registerAdapter(MyCategoryAdapter());
  Hive.registerAdapter(SphereModelAdapter());
  Hive.registerAdapter(SphereArticleAdapter());
  Hive.registerAdapter(PinnedFileAdapter());
  Hive.registerAdapter(SphereArticleShortAdapter());
  WidgetsFlutterBinding.ensureInitialized();

  runApp(EasyLocalization(
    child: MyApp(),
    supportedLocales: [
      Locale('en', 'US'),
      Locale('ru', 'RU'),
      Locale('uz', 'UZ'),
      // Locale('uz-UZ', "uz-Uz"),
    ],
    // path: 'https://raw.githubusercontent.com/handzup/madad_advice/master/resources/langs/langscopy.csv',
    path: 'https://b-advice.uz/inc/langs.csv',
    fallbackLocale: Locale('uz', "UZ"),
    startLocale: Locale('uz', "UZ"),
    assetLoader: CsvAssetLoader.CsvAssetLoader(),
    preloaderWidget: PreloadPage(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(context.supportedLocales.toString());

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SignInBloc>(
          create: (context) => SignInBloc(),
        ),
        ChangeNotifierProvider<UserBloc>(
          create: (context) => UserBloc(),
        ),
        ChangeNotifierProvider<NewsDataBloc>(
          create: (context) => NewsDataBloc(),
        ),
        ChangeNotifierProvider<PopularDataBloc>(
          create: (context) => PopularDataBloc(),
        ),
        ChangeNotifierProvider<RecentDataBloc>(
          create: (context) => RecentDataBloc(),
        ),
        ChangeNotifierProvider<RecommandedDataBloc>(
          create: (context) => RecommandedDataBloc(),
        ),
        ChangeNotifierProvider<UserBloc>(
          create: (context) => UserBloc(),
        ),
        ChangeNotifierProvider<BookmarkBloc>(
          create: (context) => BookmarkBloc(),
        ),
        ChangeNotifierProvider<CommentsBloc>(
          create: (context) => CommentsBloc(),
        ),
        ChangeNotifierProvider<NotificationBloc>(
          create: (context) => NotificationBloc(),
        ),
        ChangeNotifierProvider<InternetBloc>(
          create: (context) => InternetBloc(),
        ),
        ChangeNotifierProvider<CategoryBloc>(
          create: (context) => CategoryBloc(),
        ),
        ChangeNotifierProvider<DrawerMenuBloc>(
          create: (context) => DrawerMenuBloc(),
        ),
        ChangeNotifierProvider<SectionBloc>(
          create: (context) => SectionBloc(),
        ),
        ChangeNotifierProvider<ArticleBloc>(
          create: (context) => ArticleBloc(),
        ),
        ChangeNotifierProvider<DownloadBloc>(
          create: (context) => DownloadBloc(),
        ),
        ChangeNotifierProvider<SearchBloc>(
          create: (context) => SearchBloc(),
        ),
        ChangeNotifierProvider<SignUpBloc>(
          create: (context) => SignUpBloc(),
        ),
        ChangeNotifierProvider<ViewedArticlesBloc>(
          create: (context) => ViewedArticlesBloc(),
        ),
        ChangeNotifierProvider<QuestionBloc>(
          create: (context) => QuestionBloc(),
        ),
        ChangeNotifierProvider<CosLinksBloc>(
          create: (context) => CosLinksBloc(),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: ThemeData(
            primarySwatch: Colors.blueGrey,
            accentColor: Colors.white,
            fontFamily: 'Open Sans',
            appBarTheme: AppBarTheme(
                color: Colors.white,
                brightness:
                    Platform.isAndroid ? Brightness.light : Brightness.light,
                iconTheme: IconThemeData(color: Colors.black87),
                textTheme: TextTheme(
                    headline6: TextStyle(
                  fontFamily: 'Open Sans',
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[900],
                ))),
          ),
          home: MyHomePage()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String imageUrl;
  String uName;
  var lang = locator<Langs>();
  @override
  void initState() {
    SharedPreferences.getInstance().then((sp) {
      final name = sp.getString('name');
      final uimageUrl = sp.getString('image url');

      setState(() {
        imageUrl = uimageUrl;
        uName = name;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    lang.setLang(context.locale.languageCode);

    //final SignInBloc sb = Provider.of<SignInBloc>(context);
    // return sb.isSignedIn == false ? WelcomePage() : HomePage();
    return WelcomePage(
      name: uName,
      url: imageUrl,
    );
  }
}
