import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:madad_advice/blocs/section_bloc.dart';
import 'package:madad_advice/models/section.dart';
import 'package:madad_advice/widgets/section_sections.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:madad_advice/generated/locale_keys.g.dart';
import '../styles.dart';

class SectionPage extends StatefulWidget {
  const SectionPage({Key key}) : super(key: key);

  @override
  _SectionPageState createState() => _SectionPageState();
}

class _SectionPageState extends State<SectionPage> {
  double paddingValue = 10;
  List<Section> _apiResponse;

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

  Future<Null> _handleRefresh() async {
     final sb = Provider.of<SectionBloc>(context);
    await sb.getSectionData(force: true);

    return null;
  }

  void setData() async {
    final   sb = Provider.of<SectionBloc>(context);

    setState(() {
      _apiResponse = sb.sectionData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.sections.tr()),
        ),
        body: LiquidPullToRefresh(
          showChildOpacityTransition: false,
          height: 50,
          color: ThemeColors.primaryColor.withOpacity(0.8),
          animSpeedFactor: 2,
          borderWidth: 1,
          springAnimationDurationInMilliseconds: 100,
          onRefresh: _handleRefresh,
          child: _apiResponse != null
              ? GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  childAspectRatio: 1,
                  children: List.generate(_apiResponse.length, (index) {
                    return SectionBlock(
                      categoryColor: nextRandomColor(),
                      data: _apiResponse,
                      index: index,
                    );
                  }),
                )
              : ListView(),
        ));
  }
}
