import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:madad_advice/blocs/user_bloc.dart';
import 'package:madad_advice/pages/search_page.dart';
import 'package:madad_advice/utils/next_screen.dart';
//import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:madad_advice/generated/locale_keys.g.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final UserBloc ub = Provider.of<UserBloc>(context);

    return Container(
      padding: const EdgeInsets.all(5),
      height: 45,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkWell(
            child: Container(
              height: double.infinity,
              width: MediaQuery.of(context).size.width > 600
                  ? MediaQuery.of(context).size.width * 0.34
                  : MediaQuery.of(context).size.width * 0.70,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey[400], width: 0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  LocaleKeys.search.tr(),
                  style: TextStyle(
                      color: Colors.black45,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            onTap: () {
              nextScreen(context, SearchPage());
            },
          ),
        ],
      ),
    );
  }
}
