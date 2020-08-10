import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:madad_advice/blocs/popular_bloc.dart';
import 'package:madad_advice/pages/details.dart';
import 'package:madad_advice/pages/more_news.dart';
import 'package:madad_advice/utils/next_screen.dart';
import 'package:madad_advice/widgets/loading_shimmer.dart';

import 'package:provider/provider.dart';

class Popular extends StatelessWidget {
  const Popular({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PopularDataBloc pb = Provider.of<PopularDataBloc>(context);
    
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
                  color: Colors.deepPurpleAccent,
                  borderRadius: BorderRadius.circular(10)
                ),
              ),
              SizedBox(width: 5,),
              Text('Popular News',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600)),

              Spacer(),

              IconButton(
                icon: Icon(Icons.navigate_next),
                onPressed: (){
                  nextScreen(context, MoreNewsPage(title: 'Popular',));
                },
              )
            ],
          )
        ),
        Container(
          height: 780,
          child: pb.popularData.length == 0 
          ? LoadingWidget1()
          : _buildList(pb.popularData) 
        ),
      ],
    );
  }


  Widget _buildList (d){
    return ListView.separated(
            padding: EdgeInsets.only(top: 10, left: 15, right: 15),
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
                    
                    height: 180,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                      d[index]['title'],
                                      style: TextStyle(fontSize: 14,color: Colors.grey[800], fontWeight: FontWeight.w500),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 10, right: 10, top: 4, bottom: 4),
                                    height: 25,
                                    
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: Colors.blueGrey[600]),
                                    child: Text(
                                      d[index]['category'], style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              flex: 3,
                              child: Hero(
                                  tag: 'popular$index',
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
                                          image: CachedNetworkImageProvider(d[index]['image url']),
                                          fit: BoxFit.cover)),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
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