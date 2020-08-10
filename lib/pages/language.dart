import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:madad_advice/generated/locale_keys.g.dart';
import 'package:madad_advice/pages/home.dart';
import 'package:madad_advice/styles.dart';
import 'package:madad_advice/utils/next_screen.dart';

class LanguageView extends StatelessWidget {
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
                context: context,
                title: 'English',
                subtitle: 'English',
                locale: EasyLocalization.of(context).supportedLocales[0]),
            buildSwitchListTileMenuItem(
                context: context,
                title: 'Русский',
                subtitle: 'Русский',
                locale: EasyLocalization.of(context).supportedLocales[1]),
            buildSwitchListTileMenuItem(
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
      {BuildContext context, String title, String subtitle, Locale locale}) {
    return Container(
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 1, color: Colors.grey[300]))),
      child: ListTile(
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
            //EasyLocalization.of(context).locale = locale;
            nextScreenCloseOthers(context, HomePage());
          }),
    );
  }
}
