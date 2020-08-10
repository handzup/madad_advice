
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
        Padding(
          padding: const EdgeInsets.only(left: 15, top: 10, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 30,
                width: 4,
                
                decoration: BoxDecoration(
                  color: ThemeColors.primaryColor,
                  borderRadius: BorderRadius.circular(10)
                ),
              ),
              SizedBox(width: 5,),
              Text(LocaleKeys.recentArticels.tr(),
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600)),

              Spacer(),

              IconButton(
                icon: Icon(Icons.navigate_next),
                onPressed: (){
                  nextScreen(context, MoreNewsPage(title: LocaleKeys.recent.tr(),));
                },
              )
            ],
          )
        ),
        Container(
          height: 730,
          child:  
            LoadingWidget2()
          
        ),
      ],
    );
  }


 }