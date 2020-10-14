import 'package:flutter/material.dart';

import 'loading_shimmer.dart';

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
