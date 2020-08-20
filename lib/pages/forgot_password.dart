//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:madad_advice/blocs/internet_bloc.dart';
import 'package:madad_advice/blocs/sing_up_bloc.dart';
import 'package:madad_advice/generated/locale_keys.g.dart';
import 'package:madad_advice/models/icons_data.dart';
import 'package:madad_advice/pages/sign_in.dart';
import 'package:madad_advice/styles.dart';
import 'package:madad_advice/utils/next_screen.dart';
import 'package:madad_advice/utils/snacbar.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class ForgotPasswordPage extends StatefulWidget {
  ForgotPasswordPage({Key key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  PageController _controller = PageController(initialPage: 0, keepPage: false);
  var label = LocaleKeys.phoneNumber.tr();
  bool offsecureText = true;
  Icon lockIcon = LockIcon().lock;
  var formKeyPhoneValidate = GlobalKey<FormState>();
  var formKeyValidateCode = GlobalKey<FormState>();
  var formKeyRegister = GlobalKey<FormState>();
  String _pass;

  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var phoneNumberCtrl = TextEditingController();
  String phoneNumber;
  String prefix = '+';
  String phoneNumberMasked;
  bool signUpStarted = false;
  bool signUpCompleted = false;
  bool phoneExists = false;
  bool hasError = false;
  String _smsCode;
  String _validationCode;
  var onTapRecognizer;
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

  @override
  void initState() {
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        _controller.previousPage(
            duration: Duration(milliseconds: 300), curve: Curves.easeIn);
      };
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: PageView(
        onPageChanged: (int index) {
          setState(() {
            signUpStarted = false;
            signUpCompleted = false;
            hasError = false;
            phoneExists = false;
          });
        },
        controller: _controller,
        physics: NeverScrollableScrollPhysics(),
        children: [
          signUpPhoneValidateUI(),
          enterVerificationCodeUI(),
          signUpUI()
        ],
      ),
    );
  }

  Widget enterVerificationCodeUI() {
    return Form(
      key: formKeyValidateCode,
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
                    _controller.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn);
                  }),
            ),
            Text(
              LocaleKeys.enterVerificationCode.tr(),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
            Divider(
              color: ThemeColors.dividerColor,
              thickness: 1,
            ),
            RichText(
              softWrap: true,
              textAlign: TextAlign.center,
              text: TextSpan(
                text: LocaleKeys.verifyCodeWasSend.tr(),
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[700],
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: '  $phoneNumberMasked',
                      style: TextStyle(
                        letterSpacing: 2,
                        color: ThemeColors.primaryColor,
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
            ),
            SizedBox(
              height: 60,
            ),
            PinCodeTextField(
              length: 6,
              obsecureText: false,
              textInputType: TextInputType.phone,
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                inactiveColor: ThemeColors.primaryColor,
                inactiveFillColor: Colors.transparent,
                activeColor: ThemeColors.primaryColor,
                selectedFillColor: Colors.transparent,
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 50,
                fieldWidth: 40,
                activeFillColor: Colors.white,
              ),
              animationDuration: Duration(milliseconds: 300),
              validator: (v) {
                if (v.length != 6) {
                  return LocaleKeys.enterVerificationCode.tr();
                } else {
                  if (hasError) {
                    return LocaleKeys.incorrectCode.tr();
                  }
                }
                return null;
              },
              enableActiveFill: true,
              //errorAnimationController: errorController,
              // controller: textEditingController,
              onCompleted: (v) {
                print("Completed");
              },
              onChanged: (value) {
                setState(() {
                  _validationCode = value;
                  hasError = false;
                });
              },
              beforeTextPaste: (text) {
                print("Allowing to paste $text");
                //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                //but you can show anything you want here, like your pop up saying wrong paste format or etc
                return true;
              },
            ),
            SizedBox(
              height: 10,
            ),
            RichText(
              textAlign: TextAlign.justify,
              text: TextSpan(
                  text: LocaleKeys.didnreciveCode.tr(),
                  style: TextStyle(color: Colors.black54, fontSize: 13),
                  children: [
                    TextSpan(
                        text: LocaleKeys.retry.tr(),
                        recognizer: onTapRecognizer,
                        style: TextStyle(
                            color: ThemeColors.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 13))
                  ]),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 45,
              width: double.infinity,
              child: RaisedButton(
                  color: ThemeColors.primaryColor,
                  child: signUpStarted == false
                      ? Text(
                          LocaleKeys.next.tr(), // LocaleKeys.signUp.tr(),
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        )
                      : signUpCompleted == false
                          ? CircularProgressIndicator()
                          : Text(LocaleKeys.succesReg.tr(),
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white)),
                  onPressed: () {
                    handleEnterValidCode();
                    // handleSignUpwithEmailPassword();
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget signUpPhoneValidateUI() {
    return Form(
      key: formKeyPhoneValidate,
      child: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30, bottom: 0),
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.all(0),
                      icon: Icon(Icons.keyboard_backspace),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
              ],
            ),
            Text(LocaleKeys.resPassword.tr(),
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700)),
            Text(LocaleKeys.followsteps.tr(),
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey)),
            SizedBox(
              height: 50,
            ),
            TextFormField(
              autofocus: false,
              decoration: InputDecoration(
                  prefix: Text(
                    prefix,
                    style: TextStyle(color: Colors.black),
                  ),
                  alignLabelWithHint: true,
                  hintText: '1234566789',
                  //prefixIcon: Icon(Icons.email),
                  labelText: label),
              controller: phoneNumberCtrl,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                PhoneInputFormatter(
                    onCountrySelected: (PhoneCountryData countryData) {
                  setState(() {
                    label = countryData != null ? countryData.country : '';
                  });
                })
              ],
              autocorrect: false,
              validator: (String value) {
                if (value.isEmpty) {
                  return LocaleKeys.phoneNumCantBe.tr();
                } else {
                  if (value.length >= 8) {
                    if (phoneExists) {
                      return LocaleKeys.noSuchNumber.tr();
                    }
                  } else {
                    return LocaleKeys.enterCorrectPhNum.tr();
                  }
                }

                return null;
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
                  phoneExists = false;
                  phoneNumberMasked = value;
                  phoneNumber = value
                      .replaceFirst('+', '')
                      .replaceAll('(', '')
                      .replaceAll(')', '')
                      .replaceAll(' ', '');
                });
              },
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              height: 45,
              width: double.infinity,
              child: RaisedButton(
                  color: ThemeColors.primaryColor,
                  child: signUpStarted == false
                      ? Text(
                          LocaleKeys.next.tr(), // LocaleKeys.signUp.tr(),
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        )
                      : signUpCompleted == false
                          ? CircularProgressIndicator()
                          : Text(
                              LocaleKeys.succesReg.tr(),
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                  onPressed: () {
                    handleEnterPhone();

                    // handleSignUpwithEmailPassword();
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget signUpUI() {
    return Form(
      key: formKeyRegister,
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
                    _controller.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn);
                  }),
            ),
            Text(
              LocaleKeys.createNewPass.tr(),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
            Divider(
              color: ThemeColors.dividerColor,
              thickness: 1,
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              obscureText: offsecureText,

              decoration: InputDecoration(
                suffixIcon: IconButton(
                    icon: lockIcon,
                    onPressed: () {
                      lockPressed();
                    }),

                labelText: LocaleKeys.enterPassword.tr(),
                hintText: LocaleKeys.enterPassword.tr(),
                //prefixIcon: Icon(Icons.vpn_key),
              ),
              //controller: passCtrl,
              validator: (String value) {
                if (value.isNotEmpty) {
                  if (value.length >= 8) {
                    return null;
                  }
                  return LocaleKeys.minPasslength.tr();
                }
                return LocaleKeys.passwordCantBe.tr();
              },
              onChanged: (String value) {
                setState(() {
                  _pass = value;
                });
              },
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              height: 45,
              width: double.infinity,
              child: RaisedButton(
                  color: ThemeColors.primaryColor,
                  child: signUpStarted == false
                      ? Text(
                          LocaleKeys.restorePass.tr(),
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        )
                      : signUpCompleted == false
                          ? CircularProgressIndicator()
                          : Icon(Icons.check),
                  onPressed: () {
                    handleRegister();
                  }),
            ),
          ],
        ),
      ),
    );
  }

  handleRegister() async {
    final ib = Provider.of<InternetBloc>(context);
    final signUp = Provider.of<SignUpBloc>(context);

    await ib.checkInternet();
    if (formKeyRegister.currentState.validate()) {
      formKeyRegister.currentState.save();
      FocusScope.of(context).requestFocus(FocusNode());
      if (ib.hasInternet == false) {
        openSnacbar(_scaffoldKey, LocaleKeys.noInternet.tr());
      } else {
        setState(() {
          signUpStarted = true;
        });
        if (await signUp.recoverPass(
          pass: _pass,
        )) {
          setState(() {
            signUpCompleted = true;
          });
          Future.delayed(Duration(milliseconds: 1000))
              .then((value) => nextScreenReplace(context, SignInPage()));
        } else {
          openSnacbar(_scaffoldKey, LocaleKeys.errDuringRecoverPass.tr());
        }
      }
    }
  }

  handleEnterPhone() async {
    final ib = Provider.of<InternetBloc>(context);
    final signUp = Provider.of<SignUpBloc>(context);

    await ib.checkInternet();
    if (formKeyPhoneValidate.currentState.validate()) {
      formKeyPhoneValidate.currentState.save();
      FocusScope.of(context).requestFocus(FocusNode());

      if (ib.hasInternet == false) {
        openSnacbar(_scaffoldKey, LocaleKeys.noInternet.tr());
      } else {
        setState(() {
          signUpStarted = true;
        });
        if (!await signUp.checkPhone(phoneNumber)) {
          var code = await signUp.sendVerificationCode(phoneNumber);
          setState(() {
            signUpCompleted = true;
            _smsCode = code;
          });
          await _controller.nextPage(
              duration: Duration(milliseconds: 300), curve: Curves.easeIn);
        } else {
          setState(() {
            phoneExists = true;
            signUpStarted = false;
          });
          formKeyPhoneValidate.currentState.validate();
        }
      }
    }
  }

  handleEnterValidCode() async {
    final ib = Provider.of<InternetBloc>(context);
    final signUp = Provider.of<SignUpBloc>(context);

    await ib.checkInternet();
    if (formKeyValidateCode.currentState.validate()) {
      formKeyValidateCode.currentState.save();
      FocusScope.of(context).requestFocus(FocusNode());
      if (ib.hasInternet == false) {
        openSnacbar(_scaffoldKey, LocaleKeys.noInternet.tr());
      } else {
        if (await signUp.checkVarificationCode(_validationCode, _smsCode)) {
          await _controller.nextPage(
              duration: Duration(milliseconds: 300), curve: Curves.easeIn);
        } else {
          setState(() {
            hasError = true;
          });
          formKeyValidateCode.currentState.validate();
        }
      }
    }
  }
}
