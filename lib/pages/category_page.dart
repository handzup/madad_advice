import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:madad_advice/blocs/category_bloc.dart';
import 'package:madad_advice/models/category.dart';
import 'package:madad_advice/utils/api_response.dart';
import 'package:madad_advice/widgets/loading_shimmer.dart';
import 'package:madad_advice/widgets/service_error_snackbar.dart';
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
  APIResponse<List<MyCategory>> _apiResponse;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 0)).then((f) {
     _handleRefresh();
    });
    super.initState();
  }

  Future<Null> _handleRefresh() async {
    final CategoryBloc cb = Provider.of<CategoryBloc>(context);
    await cb.getCategoryData(force: true);
    if (cb.sphereData.error) {
      _scaffoldKey.currentState.showSnackBar(serviceError());
    }
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

  void setData() async {
    final CategoryBloc cb = Provider.of<CategoryBloc>(context);
    setState(() {
      _apiResponse = cb.sphereData;
    });
  }

  @override
  Widget build(BuildContext context) {
    final CategoryBloc cb = Provider.of<CategoryBloc>(context);
    setState(() {
      _apiResponse = cb.sphereData;
    });
    return Scaffold(
        key: _scaffoldKey,
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
            child: _apiResponse.error
                ? Container(
                    child: ListView(
                      children: <Widget>[
                        Container(
                          child: LoadingSphereWidget(),
                          width: double.infinity,
                          height: 500,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _apiResponse.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Sphere(
                        categoryColor: Color(0xfffdfdfd).withOpacity(0.9),
                        data: _apiResponse.data,
                        index: index,
                      );
                    })));
  }
}
