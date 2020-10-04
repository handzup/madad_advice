import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:madad_advice/blocs/category_bloc.dart';
import 'package:madad_advice/blocs/drawer_menu_bloc.dart';
import 'package:madad_advice/blocs/section_bloc.dart';
import 'package:madad_advice/generated/locale_keys.g.dart';
import 'package:madad_advice/models/langs.dart';
import 'package:madad_advice/styles.dart';
import 'package:madad_advice/utils/locator.dart';
import 'package:provider/provider.dart';

class HorizontalLangView extends StatefulWidget {
  @override
  _HorizontalLangViewState createState() => _HorizontalLangViewState();
}

class _HorizontalLangViewState extends State<HorizontalLangView> {
  final lang = locator<Langs>();
  bool disabled =
      true; // Language panel если true доступен только узбексий язык
  @override
  Widget build(BuildContext context) {
    return Container(
        child: IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
            color: context.locale ==
                    EasyLocalization.of(context).supportedLocales[2]
                ? ThemeColors.primaryColor
                : Colors.transparent,
            child: Text('UZ'),
            onPressed: () =>
                changeLocale(EasyLocalization.of(context).supportedLocales[2]),
          ),
          VerticalDivider(
            indent: 10,
            endIndent: 10,
            color: Colors.grey,
          ),
          FlatButton(
            color: context.locale ==
                    EasyLocalization.of(context).supportedLocales[1]
                ? ThemeColors.primaryColor
                : Colors.transparent,
            child: Text('RU'),
            onPressed: disabled
                ? null
                : () => changeLocale(
                    EasyLocalization.of(context).supportedLocales[1]),
          ),
          VerticalDivider(
            indent: 8,
            endIndent: 8,
            color: Colors.grey,
          ),
          FlatButton(
            color: context.locale ==
                    EasyLocalization.of(context).supportedLocales[0]
                ? ThemeColors.primaryColor
                : Colors.transparent,
            child: Text('EN'),
            onPressed: disabled
                ? null
                : () => changeLocale(
                    EasyLocalization.of(context).supportedLocales[0]),
          ),
        ],
      ),
    ));
  }

  changeLocale(Locale locale) {
    context.locale = locale; //BuildContext extension method
    lang.setLang(locale.languageCode);
    Provider.of<CategoryBloc>(context).getCategoryData(force: true);
    Provider.of<DrawerMenuBloc>(context).getMenuData();
    Provider.of<SectionBloc>(context, listen: false)
        .getSectionData(force: true);
  }
}

class LanguageView extends StatelessWidget {
  final lang = locator<Langs>();
   // Language panel если true доступен только узбексий язык
  @override
  Widget build(BuildContext context) {
    print(context.locale.countryCode);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.lang.tr(),
        ),
        elevation: 1,
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 10),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSwitchListTileMenuItem(
                enabled: false,// Language panel если true для включения этого языка
                context: context,
                title: 'English',
                subtitle: 'English',
                locale: EasyLocalization.of(context).supportedLocales[0]),
            buildSwitchListTileMenuItem(
                 enabled: false,// Language panel если true для включения этого языка
                context: context,
                title: 'Русский',
                subtitle: 'Русский',
                locale: EasyLocalization.of(context).supportedLocales[1]),
            buildSwitchListTileMenuItem(
                enabled: true, // Language panel если true для включения этого языка
                context: context,
                title: 'Ўзбекча',
                subtitle: 'Ўзбекча',
                locale: EasyLocalization.of(context).supportedLocales[2]),
          ],
        ),
      ),
    );
  }

  Container buildDivider() => Container(
        child: Divider(
          color: Colors.grey,
        ),
      );

  Container buildSwitchListTileMenuItem(
      {BuildContext context,
      String title,
      String subtitle,
      Locale locale,
      bool enabled}) {
    return Container(
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 1, color: Colors.grey[300]))),
      child: ListTile(
          enabled: enabled,
          dense: true,
          contentPadding: const EdgeInsets.all(0),
          title: Text(
            title,
          ),
          subtitle: Text(
            subtitle,
          ),
          trailing: context.locale == locale
              ? Padding(
                  padding: const EdgeInsets.only(right: 22.0),
                  child: Icon(
                    Icons.check,
                    color: ThemeColors.primaryColor,
                  ),
                )
              : null,
          onTap: () {
            context.locale = locale; //BuildContext extension method
            lang.setLang(locale.languageCode);
            Provider.of<CategoryBloc>(context).getCategoryData(force: true);
            Provider.of<DrawerMenuBloc>(context, listen: false).getMenuData();
            Provider.of<SectionBloc>(context, listen: false)
                .getSectionData(force: true);
            Navigator.pop(context);
            // nextScreenCloseOthers(context, HomePage());
          }),
    );
  }
}
