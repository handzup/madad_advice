
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:madad_advice/pages/details.dart';
import 'package:madad_advice/utils/next_screen.dart';

Widget categoryTabList(d, tag){
  return ListView.separated(
      padding: EdgeInsets.all(15),
      itemCount: d.length,
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: 20,
        );
      },
      itemBuilder: (BuildContext context, int index) {
        return index.isOdd
            ? InkWell(
                child: Container(
                    height: 240,
                    width: MediaQuery.of(context).size.width,
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

                                        maxLines: 4,
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
                                tag: '$tag$index',
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
                            Text(d[index]['date'], style: TextStyle(
                              color: Colors.grey,
                              fontSize: 13
                            ),),
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
              )
            : InkWell(
                child: Container(
                  height: 370,
                  width: MediaQuery.of(context).size.width,
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
                      Hero(
                        tag: '$tag$index',
                        child: Container(
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8)),
                              image: DecorationImage(
                                  image: CachedNetworkImageProvider(d[index]['image url']),
                                  fit: BoxFit.cover)),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 10, right: 10, top: 6, bottom: 6),
                                height: 30,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: Colors.deepPurpleAccent.withOpacity(0.7)),
                                child: Text(
                                 d[index]['category'], style: TextStyle(
                                   fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white
                                 ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                                d[index]['title'],
                                style: 
                                    TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[800]),

                                
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                                d[index]['description'],
                                style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black54),


                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
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
                        ),
                      )
                    ],
                  ),
                ),
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