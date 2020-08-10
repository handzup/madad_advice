import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../styles.dart';

class FeaturedLoadingWidget extends StatelessWidget {
  const FeaturedLoadingWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.black87,
        highlightColor: Colors.white54,
        child: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 15),
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            Positioned(
              left: 30,
              top: 30,
              height: 30,
              width: 100,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(25)),
              ),
            ),
            Positioned(
                right: 5,
                top: 30,
                height: 30,
                width: 100,
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.black26,
                )),
            Positioned(
                bottom: 0,
                width: MediaQuery.of(context).size.width,
                height: 130,
                child: Container(
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 5,
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(25)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 5,
                        width: 250,
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(25)),
                      ),
                    ],
                  ),
                ))
          ],
        ));
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(bottom: 30),
      itemCount: 5,
      itemBuilder: (BuildContext context, int index) {
        return Shimmer.fromColors(
            baseColor: Colors.black87,
            highlightColor: Colors.white54,
            child: Stack(
              children: <Widget>[
                Container(
                  margin:
                      EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 0),
                  height: 340,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12))),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15, right: 15),
                        height: 5,
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(25)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 5,
                        margin: EdgeInsets.only(left: 15, right: 15),
                        width: 250,
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(25)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30, right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.black26,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  right: 30,
                  top: 30,
                  height: 30,
                  width: 100,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(25)),
                  ),
                ),
              ],
            ));
      },
    );
  }
}

class LoadingWidget1 extends StatelessWidget {
  const LoadingWidget1({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: 4,
      itemBuilder: (BuildContext context, int index) {
        return Shimmer.fromColors(
          baseColor: Colors.black87,
          highlightColor: Colors.white54,
          child: Container(
              margin: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 0),
              height: 180,
              padding: EdgeInsets.all(15),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Flexible(
                        flex: 6,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                height: 5,
                                decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(25)),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 5,
                                width: 250,
                                decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(25)),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                height: 30,
                                width: 100,
                                decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(25)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              )),
        );
      },
    );
  }
}

class LoadingWidget2 extends StatelessWidget {
  const LoadingWidget2({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (BuildContext context, int index) {

        return Shimmer.fromColors(
          baseColor: Colors.black87,
          highlightColor: Colors.white54,
          child: Container(
              margin: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 0),
              height: 165,
              padding: EdgeInsets.all(15),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    flex: 2,
                    child: Container(
                      height: 140,
                      width: 140,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.black12),
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
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 5,
                            decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(25)),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 5,
                            width: 120,
                            decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(25)),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 30,
                            width: 100,
                            decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(25)),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )),
        );
      },
    );
  }
}

class LoadingSphereWidget extends StatelessWidget {
  const LoadingSphereWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(bottom: 30),
      itemCount: 5,
      itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
          return Container(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  height: 30,
                                  width: 4,
                                  decoration: BoxDecoration(
                                      color: ThemeColors.primaryColor,
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('Список сфер',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w600)),
                                Spacer(),
                              ],
                            ),
                          );
        }
        return Shimmer.fromColors(
            baseColor: Colors.black87,
            highlightColor: Colors.white54,
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(5),
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          height: 60,
                          width: 60,
                          child: Icon(
                            Icons.category,
                            size: 30,
                            color: Colors.black54,
                          )),
                      SizedBox(
                        width: 5,
                      ),
                      Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 10,
                          margin: EdgeInsets.only(left: 15, right: 15),
                          width: 200,
                          decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(25)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 10,
                          margin: EdgeInsets.only(left: 15, right: 15),
                          width: 200,
                          decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(25)),
                        ),
                      ],
                        ),
                    ],
                  ),
                ),
              ],
            ));
      },
    );
  }
}
