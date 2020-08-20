//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:madad_advice/generated/locale_keys.g.dart';
import 'package:madad_advice/styles.dart';
class ForgotPasswordPage extends StatefulWidget {
  ForgotPasswordPage({Key key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

  var formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var emailCtrl = TextEditingController();
  String email;



  void handleSubmit (){
    if(formKey.currentState.validate()){
      formKey.currentState.save();
    //  resetPassword(email);
    }
  }



  // Future<void> resetPassword(String email) async {
  //   final FirebaseAuth auth = FirebaseAuth.instance; 

  //   try{
  //     await auth.sendPasswordResetEmail(email: email);
  //     openDialog(context, 'Reset Password', 'An email has been sent to $email. \n\nGo to that link & reset your password.');

  //   } catch(error){
  //     openSnacbar(scaffoldKey, error.code);
      
  //   }
  // }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        
        
        body: Form(
            key: formKey,
            child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, bottom: 0),
            child: ListView(
              children: <Widget>[
                
                SizedBox(height: 20,),
                Container(
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  child: IconButton(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.all(0),
                    icon: Icon(Icons.keyboard_backspace), 
                    onPressed: (){
                      Navigator.pop(context);
                      
                    }),
                ),
                Text(LocaleKeys.resPassword.tr(), style: TextStyle(
                  fontSize: 25, fontWeight: FontWeight.w700
                )),
                Text(LocaleKeys.followsteps.tr(), style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey
                )),
                SizedBox(
                  height: 50,
                ),
                
                TextFormField(
                  decoration: InputDecoration(
                    hintText: '+123456789',
                    labelText: LocaleKeys.phoneNumber.tr()
                    //suffixIcon: IconButton(icon: Icon(Icons.email), onPressed: (){}),
                    
                  
                    
                  ),
                  controller: emailCtrl,
                  keyboardType: TextInputType.phone,
                  validator: (String value){
                    if (value.length < 10 )return LocaleKeys.enterCorrectPhNum.tr();
                    return null;
                  },
                  onChanged: (String value){
                    setState(() {
                      email = value;
                    });
                  },
                ),
                SizedBox(height: 80,),
                Container(
                  height: 45,
                  width: double.infinity,
                  child: RaisedButton(
                    color: ThemeColors.primaryColor,
                    child: Text(LocaleKeys.submit.tr(), style: TextStyle(
                      fontSize: 16, color: Colors.white
                    ),),
                    onPressed: (){
                      handleSubmit();
                  }),
                ),
                SizedBox(height: 50,),
                
               
                
              ],
            ),
          ),
        ),
      
    );
  }
}