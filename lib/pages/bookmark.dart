import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:madad_advice/blocs/bookmark_bloc.dart';
import 'package:madad_advice/pages/details.dart';
import 'package:madad_advice/utils/empty.dart';
import 'package:madad_advice/utils/next_screen.dart';
import 'package:provider/provider.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({Key key}) : super(key: key);

  @override
  _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {

  
  


  @override
  Widget build(BuildContext context) {
    final BookmarkBloc bb = Provider.of<BookmarkBloc>(context);
    return Scaffold(
      
      appBar: AppBar(
        title: Text('Bookmark'),
        elevation: 1,
      ),
      body: bb.data.length == 0
      ? EmptyPage(icon:Icons.bookmark_border, message:'Bookmark is empty!') 
      : _buildList(bb.data)
          );
    }


  



    Widget _buildList(d){
      return ListView.separated(
                  padding: EdgeInsets.only(top: 10, bottom: 20),
                  
                  itemCount: d.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 0,
                    );
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: Duration(milliseconds: 375),
                      child: SlideAnimation(
                        verticalOffset: 50,
                        child: FadeInAnimation(
                          child: InkWell(
                          child: Container(
                          margin: EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 5),
                          height: 170,
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Colors.grey[100],
                                    blurRadius: 10,
                                    offset: Offset(0, 3))
                              ]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Flexible(
                                flex: 2,
                                child: Hero(
                                    tag: 'bookmark$index',
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
                                            image: CachedNetworkImageProvider(d[index]['image url']),
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
                                      Text(
                                          d[index]['title'],
                                          style: TextStyle(
                                              fontSize: 15, color: Colors.grey[800], fontWeight: FontWeight.w500),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
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
                                  Icons.access_time,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 2,
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
                                ),
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
                    ),
                        ),
                      ),
                    );
                  
                  },
                );
    }

        
  }
      
  