import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroPage extends StatefulWidget {
  IntroPage({Key key}) : super(key: key);

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {

  
  void afterIntroComplete (){
    
    Navigator.pop(context);
  }



  final List<PageViewModel> pages = [


    PageViewModel(
      titleWidget: Column(
        children: <Widget>[
          Text('Explore Latest News', style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w600
          ),),
          SizedBox(height: 8,),
          Container(
            height: 3,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(10)
            ),
          )
        ],
      ),
      
      body: "Explore lattest news and events happening in the world in minutes...",
      image: Center(
        child: Image(
          image: AssetImage('assets/news1.png')
        )
      ),

      decoration: const PageDecoration(
        pageColor: Colors.white,
        bodyTextStyle: TextStyle(color: Colors.black54, fontSize: 16,),
        descriptionPadding: EdgeInsets.only(left: 30, right: 30),
        imagePadding: EdgeInsets.all(30)
      ),
    ),


    
    

    PageViewModel(
      titleWidget: Column(
        children: <Widget>[
          Text('Get Notified First', style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w600
          ),),
          SizedBox(height: 8,),
          Container(
            height: 3,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(10)
            ),
          )
        ],
      ),
      
      body:
          "Subscribe and get notified to all of our articles & share with your friends...",
      image: Center(
        child: Image(
          image: AssetImage('assets/news6.png')
        ),
      ),


      decoration: const PageDecoration(
        pageColor: Colors.white,
        bodyTextStyle: TextStyle(color: Colors.black54, fontSize: 16),
        descriptionPadding: EdgeInsets.only(left: 30, right: 30),
        imagePadding: EdgeInsets.all(30)
      ),
    ),

    PageViewModel(
      titleWidget: Column(
        children: <Widget>[
          Text('Save Articles', style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w600
          ),),
          SizedBox(height: 8,),
          Container(
            height: 3,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(10)
            ),
          )
        ],
      ),
      
      body:
          "Bookmark, like & comment on your favourite articles and share on social media...",
      image: Center(
        child: Image(
          image: AssetImage('assets/news7.png')
        )
      ),

      decoration: const PageDecoration(
        pageColor: Colors.white,
        bodyTextStyle: TextStyle(color: Colors.black54, fontSize: 16),
        descriptionPadding: EdgeInsets.only(left: 30, right: 30),
        imagePadding: EdgeInsets.all(30)
      ),
    ),


    
  ];

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: pages,
      onDone: () {
         afterIntroComplete();
      },
      onSkip: () {
        //afterIntroComplete();
      },
      showSkipButton: true,
      skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey)),
      next: const Icon(Icons.navigate_next),
      done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),

      dotsDecorator: DotsDecorator(
          size: const Size.square(7.0),
          activeSize: const Size(20.0, 5.0),
          color: Colors.black26,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0))),
    );
  }
}
