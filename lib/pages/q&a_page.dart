import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:madad_advice/blocs/sign_in_bloc.dart';
import 'package:madad_advice/pages/sign_in.dart';
import 'package:madad_advice/styles.dart';
import 'package:madad_advice/utils/next_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:madad_advice/generated/locale_keys.g.dart';
import 'package:madad_advice/widgets/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

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
      new ScrollController(); // set controller on scrolling
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
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(LocaleKeys.answersOnQuestions.tr()),
          elevation: 1,
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
      physics: AlwaysScrollableScrollPhysics(),
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return QandACard();
          }, childCount: 10),
        )
      ],
    );
  }
}

class QandACard extends StatelessWidget {
  const QandACard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey[300], blurRadius: 10, offset: Offset(3, 3))
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
                    'ExpandablePanel has a number of properties to customize its behavior, but its restricted by having a title at the top and an expand icon shown as a down arrow (on the right or on the left). If that s not enough, you can implement custom expandable widgets by using a combination of Expandable, ExpandableNotifier, and ExpandableButton',
                    softWrap: true,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  expanded: Text(
                    'ExpandablePanel has a number of properties to customize its behavior, but its restricted by having a title at the top and an expand icon shown as a down arrow (on the right or on the left). If that s not enough, you can implement custom expandable widgets by using a combination of Expandable, ExpandableNotifier, and ExpandableButton',
                    softWrap: true,
                  ),
                ),
                Divider(
                  color: ThemeColors.dividerColor,
                  endIndent: 100,
                  indent: 1,
                  thickness: 2,
                ),
                Text(
                  LocaleKeys.answer.tr(),
                  textAlign: TextAlign.left,
                  style: TextStyle(color: ThemeColors.primaryColor),
                ),
                ExpandablePanel(
                  theme: ExpandableThemeData(
                      animationDuration: const Duration(microseconds: 300)),
                  header: Text('${LocaleKeys.from.tr()} Иван Иванов'),

                  // header: Text("${LocaleKeys.from.tr()} Иван Иванов"),
                  collapsed: Text(
                    'ExpandablePanel has a number of properties to customize its behavior, but its restricted by having a title at the top and an expand icon shown as a down arrow (on the right or on the left). If that s not enough, you can implement custom expandable widgets by using a combination of Expandable, ExpandableNotifier, and ExpandableButton',
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  expanded: Text(
                    'ExpandablePanel has a number of properties to customize its behavior, but its restricted by having a title at the top and an expand icon shown as a down arrow (on the right or on the left). If that s not enough, you can implement custom expandable widgets by using a combination of Expandable, ExpandableNotifier, and ExpandableButton',
                    softWrap: true,
                  ),
                ),
              ]),
        ),
      ),
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

Widget ask(sc, context) {
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
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey[300])),
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: 'Задайте свой вопрос',
                            alignLabelWithHint: true,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(10)),
                        maxLines: 4,
                      )),
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
                            print('tapped');
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

class _ModalFitState extends State<ModalFit> {
  @override
  Widget build(BuildContext context) {
    final sb = Provider.of<SignInBloc>(context);

    return sb.isSignedIn
        ? ask(widget.scrollController, context)
        : singIn(context);
  }
}
