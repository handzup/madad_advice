import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:madad_advice/blocs/category_bloc.dart';
import 'package:madad_advice/models/category.dart';
import 'package:madad_advice/widgets/sphere.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:madad_advice/generated/locale_keys.g.dart';
import '../styles.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key key}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  double paddingValue = 10;
  List<MyCategory> _apiResponse;

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 0)).then((f) {
      setData();
      setState(() {
        paddingValue = 0;
      });
    });
    super.initState();
  }
Future<Null> _handleRefresh() async {
  //await new Future.delayed(new Duration(milliseconds: 1300));
final CategoryBloc cb = Provider.of<CategoryBloc>(context);
  cb.getCategoryData(force: true);
 

  return null;
}
  final List categoryColors = [
    Colors.orange[100],
    Colors.blueGrey[100],
    Colors.teal[100],
    Colors.grey[100],
    Colors.amber[100],
    Colors.indigo[100]
  ];
  var randomColorIndex = 0;

  Color nextRandomColor() {
    if (randomColorIndex >= _apiResponse.length - 1) {
      randomColorIndex = 0;
    }
    return categoryColors[randomColorIndex++ % (categoryColors.length)];
  }

  void setData() async {
    final CategoryBloc cb = Provider.of<CategoryBloc>(context);

    setState(() {
      _apiResponse = cb.sphereData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.spheres.tr()),
      ),
      body: LiquidPullToRefresh(
            showChildOpacityTransition: false,
            height: 50,
            color: ThemeColors.primaryColor.withOpacity(0.8),
            animSpeedFactor: 2,
            borderWidth: 1,
            springAnimationDurationInMilliseconds: 100,
            onRefresh: _handleRefresh,
            child:  _apiResponse != null
          ? ListView.builder(
              itemCount: _apiResponse.length,
              itemBuilder: (BuildContext context, int index) {
                return Sphere(
                  categoryColor: nextRandomColor(),
                  data: _apiResponse,
                  index: index,
                );
              })
          : Container(),
    ));

  
  }
}
