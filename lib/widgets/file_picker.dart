import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:madad_advice/blocs/question_bloc.dart';
import 'package:madad_advice/styles.dart';
import 'package:madad_advice/utils/fa_icon.dart';
import 'package:provider/provider.dart';

class FilePickerDemo extends StatefulWidget {
  @override
  _FilePickerDemoState createState() => _FilePickerDemoState();
}

class _FilePickerDemoState extends State<FilePickerDemo> {
  @override
  Widget build(BuildContext context) {
    final files = Provider.of<QuestionBloc>(context);
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: <Widget>[
                InkWell(
                  onTap: () => files.openFileExplorer(),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[300].withOpacity(0.5),
                            offset: Offset(0, 2),
                            spreadRadius: 1,
                            blurRadius: .5,
                          )
                        ],
                        border: Border.all(
                            color: Colors.black12,
                            style: BorderStyle.solid,
                            width: 1)),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: FaIcons(
                            'fas fa-paperclip',
                            size: 15,
                          ),
                        ),
                        Text('Прикрепить файлы'),
                      ],
                    ),
                  ),
                ),
                Spacer(),
                Text(
                  "Макс. 3",
                  style:
                      TextStyle(color: files.error ? Colors.red : Colors.black),
                )
              ],
            ),
          ),
          files.files != null
              ? (files.files.isNotEmpty
                  ? _buildList(files.files, context, files)
                  : SizedBox.shrink())
              : SizedBox.shrink()
        ],
      ),
    );
  }
}

Widget _buildList(data, context, files) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.30,
    child: ListView.builder(
      physics: ClampingScrollPhysics(),
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Colors.grey[300], width: 1))),
          child: ListTile(
            dense: true,
            contentPadding: const EdgeInsets.all(0),
            title: Text(
              data[index].name,
            ),
            trailing: InkWell(
              child: FaIcons(
                'fad fa-times-circle',
                primaryColor: ThemeColors.primaryColor,
                secondaryColor: Colors.white,
                size: 20,
              ),
              onTap: () => files.delete(data[index].name),
            ),
          ),
        );
      },
    ),
  );
}
