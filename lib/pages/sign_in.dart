import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:madad_advice/blocs/internet_bloc.dart';
import 'package:madad_advice/blocs/sign_in_bloc.dart';
import 'package:madad_advice/models/icons_data.dart';
import 'package:madad_advice/pages/forgot_password.dart';
import 'package:madad_advice/pages/sign_up.dart';
import 'package:madad_advice/styles.dart';
import 'package:madad_advice/utils/api_response.dart';
import 'package:madad_advice/utils/next_screen.dart';
import 'package:madad_advice/utils/snacbar.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:madad_advice/generated/locale_keys.g.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key key, this.firstSingIn = true}) : super(key: key);
  final firstSingIn;
  @override
  _SignInPageState createState() => _SignInPageState(firstSingIn);
}

class _SignInPageState extends State<SignInPage> {
  _SignInPageState(this.firstSingIn);
  bool offsecureText = true;
  bool firstSingIn;
  bool hasError = false;
  bool phoneHas = false;
  String prefix = '+';
  Icon lockIcon = LockIcon().lock;
  var phoneCtrl = TextEditingController();
  var passCtrl = TextEditingController();

  var formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool signInStart = false;
  bool signInComplete = false;
  String phone;
  String pass;

  void lockPressed() {
    if (offsecureText == true) {
      setState(() {
        offsecureText = false;
        lockIcon = LockIcon().open;
      });
    } else {
      setState(() {
        offsecureText = true;
        lockIcon = LockIcon().lock;
      });
    }
  }

  Future<APIResponse<bool>> checkPhone() async {
    final sb = Provider.of<SignInBloc>(context);
    return await sb.checkPhone(phone: phone);
  }

  // ignore: always_declare_return_types
  handleSignInwithemailPassword() async {
    final ib = Provider.of<InternetBloc>(context);
    final sb = Provider.of<SignInBloc>(context);
    await ib.checkInternet();
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      FocusScope.of(context).requestFocus(FocusNode());

      await ib.checkInternet();
      if (ib.hasInternet == false) {
        openSnacbar(_scaffoldKey, LocaleKeys.noInternet.tr());
      } else {
        setState(() {
          signInStart = true;
        });
        await sb
            .signInwithEmailPassword(phoneNumber: phone, password: pass)
            .then((_) async {
          if (sb.hasError == false) {
            await sb
                .saveDataToSP()
                .then((value) => sb.setSignIn().then((value) {
                      setState(() {
                        signInComplete = true;
                      });
                      firstSingIn
                          ? sb.handleAfterSignup(context)
                          : sb.handleBack(context);
                    }));
          } else {
            var check = await checkPhone();
            setState(() {
              signInStart = false;
              hasError = true;
              phoneHas = !check.data;
            });
            formKey.currentState.validate();
            // openSnacbar(_scaffoldKey, sb.errorCode);
          }
        });
      }
    }
  }

  var label = LocaleKeys.phoneNumber.tr();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey, backgroundColor: Colors.white, body: signInUI());
  }

  Widget signInUI() {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30, bottom: 0),
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.centerLeft,
              width: double.infinity,
              child: IconButton(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(0),
                  icon: Icon(Icons.keyboard_backspace),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
            Text(LocaleKeys.signIn.tr(),
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
            SizedBox(
              height: 80,
            ),
            TextFormField(
              decoration: InputDecoration(
                  prefix: Text(
                    prefix,
                    style: TextStyle(color: Colors.black),
                  ),
                  hintText: '1234566789',
                  //prefixIcon: Icon(Icons.email),
                  labelText: label),
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                PhoneInputFormatter(
                    onCountrySelected: (PhoneCountryData countryData) {
                  setState(() {
                    label = countryData != null ? countryData.country : '';
                  });
                }),
              ],
              autocorrect: false,
              validator: (String value) {
                if (value.isNotEmpty) {
                  if (phoneHas) return 'Не правильный номер';
                  return null;
                }
                ;
                return LocaleKeys.emailcant.tr();
              },
              onChanged: (String value) {
                if (value.length >= 3) {
                  setState(() {
                    prefix = '';
                  });
                }
                if (value.isEmpty) {
                  setState(() {
                    prefix = '+';
                  });
                }
                setState(() {
                  hasError = false;
                  phoneHas = false;
                  phone = value
                      .replaceFirst('+', '')
                      .replaceAll('(', '')
                      .replaceAll(')', '')
                      .replaceAll(' ', '');
                });
              },
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              obscureText: offsecureText,
              controller: passCtrl,
              decoration: InputDecoration(
                labelText: LocaleKeys.password.tr(),
                hintText: LocaleKeys.enterPassword.tr(),
                suffixIcon: IconButton(
                    icon: lockIcon,
                    onPressed: () {
                      lockPressed();
                    }),
              ),
              validator: (String value) {
                if (value.isNotEmpty) {
                  if (hasError) return 'Не правильный пароль';
                  return null;
                }
                ;
                return LocaleKeys.passwordCantBe.tr();
              },
              onChanged: (String value) {
                setState(() {
                  hasError = false;
                  phoneHas = false;
                  pass = value;
                });
              },
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              alignment: Alignment.centerRight,
              child: FlatButton(
                child: Text(
                  LocaleKeys.forgotPassword.tr(),
                  style: TextStyle(color: Colors.blueAccent),
                ),
                onPressed: () {
                  //nextScreen(context, ForgotPasswordPage());
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => ForgotPasswordPage()));
                },
              ),
            ),
            Container(
              height: 45,
              child: RaisedButton(
                  color: ThemeColors.primaryColor,
                  child: signInStart == false
                      ? Text(
                          LocaleKeys.signIn.tr(),
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        )
                      : signInComplete == false
                          ? CircularProgressIndicator()
                          : Text(LocaleKeys.successfulLogin.tr(),
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white)),
                  onPressed: () {
                    handleSignInwithemailPassword();
                  }),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(LocaleKeys.haveNotAcc.tr()),
                FlatButton(
                  child: Text(LocaleKeys.signUp.tr(),
                      style: TextStyle(color: Colors.blueAccent)),
                  onPressed: () {
                    nextScreenReplace(context, SignUpPage());
                  },
                )
              ],
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
