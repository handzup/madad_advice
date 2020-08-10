

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:madad_advice/blocs/recommanded_bloc.dart';
import 'package:madad_advice/pages/details.dart';
import 'package:madad_advice/utils/next_screen.dart';
import 'package:provider/provider.dart';

class Others extends StatelessWidget {
  final String timestamp;
  const Others({Key key, @required this.timestamp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RecommandedDataBloc rb = Provider.of<RecommandedDataBloc>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 30, left: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 30,
                width: 4,
                decoration: BoxDecoration(
                  color: Colors.deepPurpleAccent,
                  borderRadius: BorderRadius.circular(10)
                ),
              ),
              SizedBox(width: 5,),
              Text('You might also like',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600)),

            ],
          )
        ),
        Container(
          height: 800,
          child: _buildList(rb.data)
        )
      ],
    );
  }




  Widget _buildList (d){

    d.skipWhile((value) => value['timestamp'] == timestamp);
    return ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            itemCount: 4,
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 10,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                child: Container(
                    height: 170,
                    margin: EdgeInsets.only(left: 15, right: 15),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.grey[300],
                              blurRadius: 10,
                              offset: Offset(3, 3))
                        ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Flexible(
                          flex: 2,
                          child: Hero(
                              tag: 'others$index',
                              child: Container(
                              height: 140,
                              width: 140,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: Colors.grey[200],
                                        blurRadius: 1,
                                        offset: Offset(1, 1))
                                  ],
                                  image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                          d[index]['image url']),
                                      fit: BoxFit.cover)),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  height: 65,
                                  child: Text(
                                    d[index]['title'],
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[800],
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10, top: 3, bottom: 3),
                                  height: 25,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: Colors.black12),
                                  child: Text(
                                    d[index]['category'],
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                                Spacer(),
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.timer,
                                      color: Colors.grey,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      d[index]['date'],
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 13),
                                    ),
                                    Spacer(),
                                    Icon(
                                      Icons.favorite,
                                      color: Colors.grey,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Text(d[index]['loves'].toString(),
                                        style: TextStyle(
                                            color: Colors.black38,
                                            fontSize: 13)),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    )),
                onTap: () {
                  nextScreen(
                      context,
                      DetailsPage(
                         category: d[index]['category'],
                        date: d[index]['date'],
                        description: d[index]['description'],
                        imageUrl: d[index]['image url'],
                        // loves: d[index]['loves'],
                        // timestamp: d[index]['timestamp'],
                        title: d[index]['title'],
                      ));
                },
              );
            },
          );
  }
}
