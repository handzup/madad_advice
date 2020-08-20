import 'package:flutter/material.dart';
import 'package:madad_advice/pages/more_news.dart';
import 'package:madad_advice/styles.dart';
import 'package:madad_advice/utils/next_screen.dart';
import 'package:madad_advice/widgets/loading_shimmer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:madad_advice/generated/locale_keys.g.dart';

class Recent extends StatelessWidget {
  const Recent({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(child: Expanded(child: LoadingWidget2())),
      ],
    );
  }
}
