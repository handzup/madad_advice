import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:madad_advice/blocs/download_bloc.dart';
import 'package:madad_advice/generated/locale_keys.g.dart';
import 'package:provider/provider.dart';

class DataUsage extends StatelessWidget {
  remove(context) async {
    final dataBase = Provider.of<DownloadBloc>(context);
    if (dataBase.size != '0.0') await dataBase.removeAllFiles();
  }

  @override
  Widget build(BuildContext context) {
    final dataBase = Provider.of<DownloadBloc>(context);
    dataBase.getSize();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.memoryUsage.tr(),//datausage
        ),
        elevation: 1,
      ),
      body: Container(
        color: Colors.white10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 60,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    LocaleKeys.dmAndOthers.tr())
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0.1,
                      blurRadius: 0.1,
                      offset: Offset(0, 0.5),
                    )
                  ],
                  border: Border(
                      top: BorderSide(width: 1, color: Colors.grey[300]),
                      bottom: BorderSide(width: 1, color: Colors.grey[300]))),
              child: ListTile(
                dense: true,
                contentPadding: const EdgeInsets.all(0),
                title: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Text(LocaleKeys.clearDb.tr(),
                      style: TextStyle(color: Colors.black, fontSize: 14)),
                ),
                trailing: Padding(
                  padding: const EdgeInsets.only(right: 22.0),
                  child: Text(
                    '${dataBase.size ?? 0} MB',
                    style: TextStyle(color: Colors.blueAccent, fontSize: 16),
                  ),
                ),
                onTap: () {
                  handleLogout(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  handleLogout(context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          final isIos = Theme.of(context).platform == TargetPlatform.iOS;

          if (isIos) {
            return CupertinoAlertDialog(
              title: Text(
                LocaleKeys.clearDb.tr(),
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              content: Text(
                '${LocaleKeys.rlyClearDb.tr()}?',
                style: TextStyle(fontSize: 12),
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text(LocaleKeys.yes.tr()),
                  onPressed: () async {
                    remove(context);
                    Navigator.pop(context);
                  },
                ),
                CupertinoDialogAction(
                  child: Text(LocaleKeys.no.tr()),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          } else {
            return AlertDialog(
              title: Text(
                LocaleKeys.clearDb.tr(),
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              content: Text(
                 '${LocaleKeys.rlyClearDb.tr()}?',
                style: TextStyle(fontSize: 14),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(LocaleKeys.yes.tr()),
                  onPressed: () {
                    remove(context);
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text(LocaleKeys.no.tr()),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          }
        });
  }
}
