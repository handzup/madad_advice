import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:madad_advice/blocs/recommanded_bloc.dart';
import 'package:madad_advice/pages/details.dart';
import 'package:madad_advice/utils/next_screen.dart';
import 'package:madad_advice/widgets/loading_shimmer.dart';
import 'package:provider/provider.dart';

class Recommanded extends StatelessWidget {
  const Recommanded({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RecommandedDataBloc rb = Provider.of<RecommandedDataBloc>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 15, top: 15, bottom: 8),
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
              Text('Recommended',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600)),

            ],
          )
        ),
        Container(
          height: 900,
          child: rb.data.length == 0
          ? LoadingWidget1()
          : _buildList(rb.data) 
        ),
      ],
    );
  }


  Widget _buildList(d){
    return ListView.separated(
            padding: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 20),

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
                    height: 210,
                    
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
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              flex: 5,
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    d[index]['title'],
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.grey[800], fontWeight: FontWeight.w500),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  
                                    Text(
                                      d[index]['description'],
                                      style: TextStyle(
                                          fontSize: 13, color: Colors.black54),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  
                                ],
                              ),
                            ),
                            Flexible(
                              flex: 3,
                              child: Hero(
                                tag: 'recommanded$index',
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                            color: Colors.grey[200],
                                            blurRadius: 1,
                                            offset: Offset(1, 1))
                                      ],
                                      image: DecorationImage(
                                          image:
                                              CachedNetworkImageProvider(d[index]['image url']),
                                          fit: BoxFit.cover)),
                                ),
                              ),
                            )
                          ],
                        ),
                        Spacer(),
                        Row(
                              children: <Widget>[
                                Icon(
                                  Icons.access_time,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  d[index]['date'],
                                  style: TextStyle(color: Colors.grey[600],
                                  fontSize: 13
                                  ),
                                  
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
                                      color: Colors.black38, fontSize: 13)),
                              ],
                            )
                      ],
                    )),

                    onTap: (){
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