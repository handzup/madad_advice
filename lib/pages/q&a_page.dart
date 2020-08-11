import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:madad_advice/blocs/question_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:madad_advice/blocs/sign_in_bloc.dart';
import 'package:madad_advice/pages/sign_in.dart';
import 'package:madad_advice/styles.dart';
import 'package:madad_advice/utils/next_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:madad_advice/generated/locale_keys.g.dart';
import 'package:madad_advice/widgets/file_picker.dart';
import 'package:provider/provider.dart';

class QandAPage extends StatefulWidget {
  QandAPage({Key key}) : super(key: key);

  @override
  _QandAPageState createState() => _QandAPageState();
}

class _QandAPageState extends State<QandAPage> {
  @override
  void initState() {
    super.initState();
    handleScroll();
  }

  ScrollController _scrollController =
      ScrollController(); // set controller on scrolling
  bool _show = true;

  @override
  void dispose() {
    _scrollController.removeListener(() {});
    super.dispose();
  }

  void showFloationButton() {
    setState(() {
      _show = true;
    });
  }

  void hideFloationButton() {
    setState(() {
      _show = false;
    });
  }

  void handleScroll() async {
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        hideFloationButton();
      }
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        showFloationButton();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<QuestionBloc>(context);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(LocaleKeys.answersOnQuestions.tr()),
          elevation: 1,
          actions: <Widget>[
            bloc.inProgress
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CupertinoActivityIndicator(
                      animating: true,
                      radius: 12,
                    ),
                  )
                : SizedBox.shrink()
          ],
        ),
        floatingActionButton: Visibility(
          visible: _show,
          child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              color: ThemeColors.primaryColor.withOpacity(0.8),
              onPressed: () => showBarModalBottomSheet(
                    expand: false,
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context, scrollController) =>
                        ModalFit(scrollController: scrollController),
                  ),
              child: Text(LocaleKeys.askAQuestion.tr(),
                  style: TextStyle(
                    color: Colors.white,
                  ))),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: _buildList('ds'));
  }

  Widget _buildList(snap) {
    return CustomScrollView(
      controller: _scrollController,
      physics: ClampingScrollPhysics(),
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return QandACard(
              answerText: 'daasd',
              answeredTime: DateTime.now(),
              whoAnswered: 'Ким Кардашян',
              question: 'Как ты отрастила такую жепу?!',
            );
          }, childCount: 10),
        )
      ],
    );
  }
}

class QandACard extends StatelessWidget {
  const QandACard({
    Key key,
    this.question,
    this.whoAnswered,
    this.answerText,
    this.answeredTime,
    this.answered = false,
  }) : super(key: key);
  final String question;
  final String whoAnswered;
  final String answerText;
  final DateTime answeredTime;
  final bool answered;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 5.0, right: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[Text('Статус'), Text('Ожидание ответа')],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.grey[300],
                      blurRadius: 10,
                      offset: Offset(3, 3))
                ]),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ExpandablePanel(
                      theme: ExpandableThemeData(
                        animationDuration: const Duration(microseconds: 300),
                      ),
                      header: Text(
                        LocaleKeys.question.tr(),
                        textAlign: TextAlign.left,
                        style: TextStyle(color: ThemeColors.primaryColor),
                      ),
                      collapsed: Text(
                        question,
                        softWrap: true,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      expanded: Text(
                        question,
                        softWrap: true,
                      ),
                    ),
                    Divider(
                      color: ThemeColors.dividerColor,
                      endIndent: 100,
                      indent: 1,
                      thickness: 2,
                    ),
                    answered
                        ? Column(
                            children: <Widget>[
                              Text(
                                LocaleKeys.answer.tr(),
                                textAlign: TextAlign.left,
                                style:
                                    TextStyle(color: ThemeColors.primaryColor),
                              ),
                              ExpandablePanel(
                                theme: ExpandableThemeData(
                                    animationDuration:
                                        const Duration(microseconds: 300)),
                                header: Text(
                                    '${LocaleKeys.from.tr()} $whoAnswered'),

                                // header: Text("${LocaleKeys.from.tr()} Иван Иванов"),
                                collapsed: Text(
                                  answerText,
                                  softWrap: true,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                expanded: Text(
                                  answerText,
                                  softWrap: true,
                                ),
                              )
                            ],
                          )
                        : SizedBox.shrink()
                  ]),
            ),
          ),
        ),
      ],
    );
  }
}

class ModalFit extends StatefulWidget {
  final ScrollController scrollController;

  const ModalFit({Key key, this.scrollController}) : super(key: key);

  @override
  _ModalFitState createState() => _ModalFitState();
}

Widget singIn(context) {
  return Material(
      child: SafeArea(
    top: false,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        FlatButton(
          onPressed: () => nextScreen(
              context,
              SignInPage(
                firstSingIn: false,
              )),
          child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: 50,
            child: Text(
              LocaleKeys.signIn.tr(),
              style: TextStyle(color: ThemeColors.primaryColor),
            ),
          ),
        )
      ],
    ),
  ));
}

var formKey = GlobalKey<FormState>();

Widget ask(sc, context) {
  final questionBloc = Provider.of<QuestionBloc>(context);
  return Material(
    child: CupertinoPageScaffold(
      child: SafeArea(
        bottom: false,
        child: ListView(
            padding: const EdgeInsets.all(10),
            shrinkWrap: true,
            controller: sc,
            physics: NeverScrollableScrollPhysics(),
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Form(
                    key: formKey,
                    child: TextFormField(
                      onChanged: (value) {
                        questionBloc.setMessage(value);
                      },
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Задайте вопрос';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          hintText: 'Задайте свой вопрос',
                          alignLabelWithHint: true,
                 
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                         
                             
                            ),
                          ),
       
             
                          contentPadding: const EdgeInsets.all(10)),
                      maxLines: 4,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    child: FilePickerDemo(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: ThemeColors.primaryColor,
                      ),
                      child: Material(
                        child: InkWell(
                          onTap: () {
                            handleSubmit(context, questionBloc);
                          },
                          child: Container(
                            height: 50,
                            alignment: Alignment.center,
                            child: Text(
                              LocaleKeys.ask.tr(),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              )
            ]),
      ),
    ),
  );
}

handleSubmit(context, questionBloc) {
  if (formKey.currentState.validate()) {
    questionBloc.sendQuestion();
    Navigator.pop(context);
  }
}

class _ModalFitState extends State<ModalFit> {
  @override
  Widget build(BuildContext context) {
    final sb = Provider.of<SignInBloc>(context);

    return sb.isSignedIn
        ? ask(widget.scrollController, context)
        : singIn(context);
  }
}
