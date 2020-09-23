import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:madad_advice/blocs/section_bloc.dart';
import 'package:madad_advice/models/config.dart';
import 'package:madad_advice/models/section.dart';
import 'package:madad_advice/models/subsection.dart';
import 'package:madad_advice/pages/category_item_page.dart';
import 'package:madad_advice/utils/fa_icon.dart';
import 'package:madad_advice/utils/next_screen.dart';
import 'package:provider/provider.dart';

import '../styles.dart';

class MainPageBlock extends StatefulWidget {
  final Section data;

  const MainPageBlock({Key key, this.data}) : super(key: key);
  @override
  _MainPageBlockState createState() => _MainPageBlockState(this.data);
}

class _MainPageBlockState extends State<MainPageBlock> {
  final Section data;
  bool hover = true;
  final restUrl = Config().url;
  _MainPageBlockState(this.data);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nextScreen(
            context,
            CategoryItemPage(
              category: data.title,
              queryPath: data.path,
              color: Colors.white,
            ));
      },
      // onTapDown: (value) {
      //   setState(() {
      //     print('onTapDown');
      //     hover = false;
      //   });
      // },
      // onTapUp: (value) {
      //   setState(() {
      //     print('onTapUp');
      //     hover = true;
      //   });
      // },
      // onTapCancel: () {
      //   setState(() {
      //     print('onTapCancel');
      //     hover = true;
      //   });
      // },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 100),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(data.title,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w900,
                    )),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      flex: 5,
                      child: _sectionBuilder(data.subsections),
                    ),
                    Flexible(
                      
                        flex: 2,
                        child: Container(
                            alignment: Alignment.center,
                            child:  
                            //SvgPicture.asset('assets/calendar_start_icon.svg',color: Colors.white,)
                            SvgPicture.network(
                              
                              data.pic != null
                                  ? restUrl + data.pic
                                  : 'https://b-advice.uz/upload/uf/565/calendar_start_icon.svg',height: 100,
                            )
                            //  FaIcons(
                            //   data.icon,
                            //   size: 80,
                            // ),
                            ))
                  ],
                ),
                Text(
                  data.desc,
                  style: TextStyle(fontStyle: FontStyle.italic),
                )
              ],
            ),
          ),
          decoration: BoxDecoration(
              boxShadow: [
                hover
                    ? BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      )
                    : BoxShadow(
                        color: ThemeColors.primaryColor.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
              ],
              color: Colors.white,
              border: Border(
                  top: BorderSide(width: 5, color: ThemeColors.primaryColor))),
        ),
      ),
    );
  }

  Widget _sectionBuilder(List<Subsection> list) {
    list.sort((a, b) => a.sort.compareTo(b.sort));
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(top: 10, bottom: 10),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            nextScreen(
                context,
                CategoryItemPage(
                  category: list[index].title,
                  queryPath: list[index].path,
                  color: Colors.white,
                ));
          },
          child: Row(
            children: <Widget>[
              Icon(
                FlutterIcons.angle_right_faw5s,
                color: Colors.grey[600],
              ),
              Expanded(
                child: Text(
                  list[index].title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 13.0,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        );
      },
      itemCount: list.length,
    );
  }
}
