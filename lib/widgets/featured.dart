import 'package:cached_network_image/cached_network_image.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../blocs/news_data_bloc.dart';
import '../pages/details.dart';
import '../utils/next_screen.dart';
import 'loading_shimmer.dart';

class Featured extends StatefulWidget {
  Featured({Key key}) : super(key: key);

  @override
  _FeaturedState createState() => _FeaturedState();
}

class _FeaturedState extends State<Featured> {

  int dotIndex = 0;

  @override
  Widget build(BuildContext context) {
    final NewsDataBloc nb = Provider.of<NewsDataBloc>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 15, top: 15, right: 15),
          child: Row(
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
              Text(
                'Featured',
                style: TextStyle(
                    color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        Container(
          height: 250,
          width: double.infinity,
          child: nb.data.length == 0
              ?  FeaturedLoadingWidget()
              : _buildPage(nb.data)
        ),
        _indicator()
      ],
    );
  }


  Widget _indicator (){
    return Container(
            alignment: Alignment.center,
            child: DotsIndicator(
              
              dotsCount: 5,
              position: dotIndex.toDouble(),
              decorator: DotsDecorator(
                color: Colors.black26,
                activeColor: Colors.black,
                spacing: EdgeInsets.only(left: 6),
                size: const Size.square(7.0),
                activeSize: const Size(25.0, 5.0),
                activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
              ),
            ));
  }


  Widget _buildPage (d){
    return PageView.builder(
                  itemCount: 5,
                  scrollDirection: Axis.horizontal,
                  controller: PageController(initialPage: 0),
                  onPageChanged: (index) {
                    setState(() {
                      dotIndex = index;
                      print(dotIndex);
                    });
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                       child: Stack(
                        children: <Widget>[
                           Hero(
                              tag: 'featured$index',
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: 15, left: 15, right: 15, bottom: 10),
                                height: 220,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: Colors.black12,
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: CachedNetworkImageProvider(
                                            d[index]['image url'])),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          color: Colors.grey[300],
                                          blurRadius: 10,
                                          offset: Offset(3, 3))
                                    ]),
                              ),
                            ),
                           
                          Positioned(
                            left: 30,
                            top: 30,
                            right: 15,
                            child: Row(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10, top: 6, bottom: 6),
                                  height: 30,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: Colors.deepPurpleAccent.withOpacity(0.7)),
                                  child: Text(
                                    d[index]['category'],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10, top: 6, bottom: 6),
                                  height: 30,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: Colors.black45),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(Icons.favorite, size: 20, color: Colors.white,),
                                      SizedBox(width: 2,),
                                      Text(d[index]['loves'].toString(), style: TextStyle(
                                        color: Colors.white
                                      ),)
                                    ],
                                  )
                                ),
                                
                                SizedBox(
                                  width: 10,
                                )
                              ],
                            ),
                          ),
                          Positioned(
                              bottom: 0,
                              width: MediaQuery.of(context).size.width,
                              height: 130,
                              child: Container(
                                padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                                margin: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    color: Colors.black26,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(12),
                                        bottomRight: Radius.circular(12))),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                        d[index]['title'],
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                        children: <Widget>[
                                          Icon(Icons.timer,
                                              size: 16, color: Colors.white),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(d[index]['date'],
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12))
                                        ],
                                      
                                    )
                                  ],
                                ),
                              ))
                        ],
                      ),
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
