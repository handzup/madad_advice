import 'package:flutter/material.dart';

import '../styles.dart';

class PreloadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Align(
        alignment: Alignment(0, 0),
        child: Container(
            child: Directionality(
          textDirection: TextDirection.ltr,
          child: RichText(
            text: TextSpan(
              text: 'Welcome to ',
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[700]),
              children: <TextSpan>[
                TextSpan(
                    text: 'Advice for business',
                    style: TextStyle(
                        color: ThemeColors.primaryColor,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
