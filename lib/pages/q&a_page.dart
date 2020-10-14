import 'package:easy_localization/easy_localization.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../blocs/question_bloc.dart';
import '../blocs/sign_in_bloc.dart';
import '../blocs/sing_up_bloc.dart';
import '../generated/locale_keys.g.dart';
import '../models/question.dart';
import '../styles.dart';
import '../utils/empty.dart';
import '../utils/next_screen.dart';
import '../utils/toast.dart';
import '../widgets/file_picker.dart';
import '../widgets/service_error_snackbar.dart';
import 'sign_in.dart';

class QandAPage extends StatefulWidget {
  QandAPage({Key key}) : super(key: key);

  @override
  _QandAPageState createState() => _QandAPageState();
}

class _QandAPageState extends State<QandAPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    handleScroll();
    Future.delayed(Duration(milliseconds: 0)).then((value) => _handleRefresh());
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

  Future<bool> blockBtn() async {
    final progress = Provider.of<QuestionBloc>(context);
    if (!progress.inProgress) {
      Navigator.pop(context);
    }
    return false;
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

  Future<Null> _handleRefresh() async {
    final articleBlock = Provider.of<QuestionBloc>(context);
    final signed = Provider.of<SignUpBloc>(context);
    await signed.checkSignIn();
    if (signed.isSignedIn) {
      await articleBlock.getQuestions();

      if (articleBlock.questions.error) {
        articleBlock.questions.errorMessage == 'internet'
            ? scaffoldKey.currentState.showSnackBar(snackBar(_handleRefresh))
            : scaffoldKey.currentState.showSnackBar(serviceError());
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: blockBtn,
      child: Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            centerTitle: true,
            title: Text(LocaleKeys.answersOnQuestions.tr()),
            elevation: 1,
            actions: <Widget>[
              Consumer<QuestionBloc>(
                builder: (context, data, child) {
                  if (data.response.error) {
                    WidgetsBinding.instance
                        .addPostFrameCallback((_) => openToastRed(
                              context,
                              LocaleKeys.errorWhenSend.tr(),
                            ));
                  } else if (data.response.data != -1) {
                    WidgetsBinding.instance
                        .addPostFrameCallback((_) => openToast(
                              context,
                              LocaleKeys.successSend.tr(),
                            ));
                  }
                  data.setDefault();
                  if (!data.inProgress) return SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CupertinoActivityIndicator(
                      animating: true,
                      radius: 12,
                    ),
                  );
                },
              ),
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
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          body: LiquidPullToRefresh(
              showChildOpacityTransition: false,
              height: 50,
              color: ThemeColors.primaryColor.withOpacity(0.8),
              animSpeedFactor: 2,
              borderWidth: 1,
              springAnimationDurationInMilliseconds: 100,
              onRefresh: _handleRefresh,
              child: Provider.of<SignInBloc>(context).isSignedIn
                  ? Consumer<QuestionBloc>(
                      builder: (context, data, child) {
                        if (data.questions.data == null &&
                            data.questions.data.isEmpty) return child;
                        return _buildList(data.questions.data);
                      },
                      child: EmptyPage(
                        icon: Icons.hourglass_empty,
                        message: LocaleKeys.emptyPage.tr(),
                        animate: true,
                      ),
                    )
                  : EmptyPage(
                      icon: Icons.hourglass_empty,
                      message: ' Чтобы задать вопрос необходимо войти  ',
                      animate: true,
                    ))),
    );
  }

  Widget _buildList(List<Question> data) {
    return CustomScrollView(
      controller: _scrollController,
      physics: AlwaysScrollableScrollPhysics(),
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return QandACard(
              answerText: data[index].answer,
              answeredTime: data[index].answeredTime,
              whoAnswered: data[index].answerer,
              question: data[index].question,
              answered: data[index].isAnswered,
            );
          }, childCount: data.length),
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
  final String answeredTime;
  final bool answered;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.grey[100],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  LocaleKeys.status.tr(),
                  style: TextStyle(
                      fontWeight: FontWeight.w900, color: Colors.grey[500]),
                ),
                Text(
                    answered
                        ? LocaleKeys.answerReceived.tr()
                        : LocaleKeys.waitForAnswer.tr(),
                    style: TextStyle(
                        fontWeight: FontWeight.w900, color: Colors.grey[500]))
              ],
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(1),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              LocaleKeys.answer.tr(),
                              textAlign: TextAlign.left,
                              style: TextStyle(color: ThemeColors.primaryColor),
                            ),
                            ExpandablePanel(
                              theme: ExpandableThemeData(
                                  animationDuration:
                                      const Duration(microseconds: 300)),
                              header:
                                  Text('${LocaleKeys.from.tr()} $whoAnswered'),

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
                          return LocaleKeys.writeSmth.tr();
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          hintText: LocaleKeys.askUrQuestion.tr(),
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(),
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
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: DropdownButton<String>(
                        underline: Container(
                          height: 2,
                          color: questionBloc.drDownItem != null
                              ? Colors.grey
                              : Colors.red,
                        ),
                        isExpanded: true,
                        hint: Text('Choose'),
                        value: questionBloc.drDownItem,
                        onChanged: (String newValue) {
                          questionBloc.onChanged(newValue);
                        },
                        items: questionBloc.drDownItems
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
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

handleSubmit(context, QuestionBloc questionBloc) {
  if (formKey.currentState.validate() && questionBloc.drDownItem != null) {
    questionBloc.sendQuestion();
    Navigator.pop(context);
  } else {
    if (questionBloc.drDownItem == null) {
      openToastRed(
        context,
        LocaleKeys.chooseQuestionCategory.tr(),
      );
    }
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
