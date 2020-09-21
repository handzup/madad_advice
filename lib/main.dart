import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:madad_advice/blocs/articel_bloc.dart';
import 'package:madad_advice/blocs/bookmark_bloc.dart';
import 'package:madad_advice/blocs/category_bloc.dart';
import 'package:madad_advice/blocs/comments_bloc.dart';
import 'package:madad_advice/blocs/download_bloc.dart';
import 'package:madad_advice/blocs/drawer_menu_bloc.dart';
import 'package:madad_advice/blocs/internet_bloc.dart';
import 'package:madad_advice/blocs/news_data_bloc.dart';
import 'package:madad_advice/blocs/notification_bloc.dart';
import 'package:madad_advice/blocs/popular_bloc.dart';
import 'package:madad_advice/blocs/question_bloc.dart';
import 'package:madad_advice/blocs/recent_bloc.dart';
import 'package:madad_advice/blocs/recommanded_bloc.dart';
import 'package:madad_advice/blocs/search_bloc.dart';
import 'package:madad_advice/blocs/section_bloc.dart';
import 'package:madad_advice/blocs/sign_in_bloc.dart';
import 'package:madad_advice/blocs/sing_up_bloc.dart';
import 'package:madad_advice/blocs/user_bloc.dart';
import 'package:madad_advice/blocs/viewed_articles_bloc.dart';
import 'package:madad_advice/models/langs.dart';
import 'package:madad_advice/models/pinned_file.dart';
import 'package:madad_advice/models/recived_notification.dart';
import 'package:madad_advice/models/section.dart';
import 'package:madad_advice/models/category.dart';
import 'package:madad_advice/models/sphere.dart';
import 'package:madad_advice/models/sphere_articel.dart';
import 'package:madad_advice/pages/welcome_page.dart';
import 'package:madad_advice/utils/locator.dart';
import 'package:madad_advice/widgets/preload.dart';
import 'blocs/soc_links_bloc.dart';
import 'httpcsv.dart' as CsvAssetLoader;
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';

const section = 'section';
const category = 'category';

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
  Hive.registerAdapter(MyCategoryAdapter());
  Hive.registerAdapter(SphereModelAdapter());
  Hive.registerAdapter(SphereArticleAdapter());
  Hive.registerAdapter(PinnedFileAdapter());
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
