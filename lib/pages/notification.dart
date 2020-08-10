import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:madad_advice/blocs/notification_bloc.dart';
import 'package:madad_advice/models/config.dart';
import 'package:madad_advice/pages/details.dart';
import 'package:madad_advice/pages/notification_details.dart';
import 'package:madad_advice/utils/next_screen.dart';
import 'package:madad_advice/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';



class NotificationPage extends StatefulWidget {
  NotificationPage({Key key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  


  @override
  Widget build(BuildContext context) {
    final NotificationBloc nb = Provider.of<NotificationBloc>(context);

    return Scaffold(
        
        appBar: AppBar(
          centerTitle: false,
          title: Text(LocaleKeys.notifications.tr()),
          elevation: 1,
          actions: <Widget>[
            IconButton(
              icon: Icon(AntDesign.reload1, size: 22,),
              onPressed: (){
                
               // nb.getData();

                
                
              },
            )
          ],

          
        ),
        body: nb.ndata.length == 0 
        ? Center(child: CircularProgressIndicator(),)
        : _buildList(nb.ndata)
        
        
        );
  }

  

  Widget _buildList(snap) {
    List d = snap;
    d.sort((a,b) => b['timestamp'].compareTo(a['timestamp']));

    return ListView.builder(
      padding: EdgeInsets.only(top: 10, bottom: 20),
      itemCount: d.length,
      itemBuilder: (context, index) {
        return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: Duration(milliseconds: 300),
                      child: SlideAnimation(
                        verticalOffset: 50,
                        child: FadeInAnimation(
                          child: d[index]['category'] == null
        
        ? Container(
          margin: EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 5),
          padding: EdgeInsets.fromLTRB(5, 10, 10, 10),
          decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.grey[100],
                      blurRadius: 10,
                      offset: Offset(0, 3))
                ],
              ),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(Config().splashIcon)),
            title: Text(d[index]['title'], style:TextStyle(fontSize: 14, fontWeight: FontWeight.w600),),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  d[index]['description'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style:TextStyle(fontSize: 14, fontWeight: FontWeight.w400),),
                SizedBox(height: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.access_time, size: 16, color:Colors.grey),
                    Text(d[index]['date'], style:TextStyle(fontSize: 13, fontWeight: FontWeight.w400),),
                  ],
                )
              ],
            ),
            isThreeLine: true,
            onTap: (){
              Navigator.push(context, CupertinoPageRoute(
                builder: (context) => NotificationDetails(
                title: d[index]['title'], 
                description: d[index]['description'], 
                date: d[index]['date']
                )));
            },
            
          ),
          
          )
        
        : InkWell(
          child: Container(
              margin: EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 5),
              height: 150,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.grey[100],
                      blurRadius: 10,
                      offset: Offset(0, 3))
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    flex: 2,
                    child: Hero(
                      tag: 'notification$index',
                      child: Container(
                        height: 110,
                        width: 110,
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
                          Text(
                              d[index]['title'],
                              style:TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              
                            ),
                          
                          Spacer(),
                          Container(
                            padding: EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
                            height: 25,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.black12),
                            child: Text(d[index]['category'],style: TextStyle(fontSize: 12),),
                          ),
                          Spacer(),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.access_time,
                                color: Colors.grey,
                                size: 18,
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text(d[index]['date'],
                                  style: TextStyle(
                                      color: Colors.black38, fontSize: 12)),
                              Spacer(),
                              Icon(
                                Icons.favorite,
                                color: Colors.grey,
                                size: 18,
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text(d[index]['loves'].toString(),
                                  style: TextStyle(
                                      color: Colors.black38, fontSize: 12)),
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
        ),
                        ),
                      ),
                    );
        
        
        
        
        
      },
    );
  }
}

