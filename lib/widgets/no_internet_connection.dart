import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

import '../blocs/section_bloc.dart';
import '../generated/locale_keys.g.dart';
import '../utils/fa_icon.dart';

class NoInternetConnection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        shrinkWrap: true,
        children: [
          Container(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FaIcons('fad fa-wifi'),
              SizedBox(
                height: 10,
              ),
              Text(LocaleKeys.noInternet.tr()),
              SizedBox(
                height: 10,
              ),
              InkWell(
                splashColor: Colors.blueAccent,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                onTap: () => Provider.of<SectionBloc>(context).getSectionData(),
                child: Icon(
                  EvilIcons.refresh,
                  color: Colors.blueAccent,
                  size: 50,
                ),
              )
            ],
          ))
        ],
      ),
    );
  }
}
