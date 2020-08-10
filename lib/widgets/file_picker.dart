import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:madad_advice/styles.dart';
import 'package:madad_advice/utils/fa_icon.dart';

class FilePickerDemo extends StatefulWidget {
  @override
  _FilePickerDemoState createState() => _FilePickerDemoState();
}

class _FilePickerDemoState extends State<FilePickerDemo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _fileName;
  String _path;
  Map<String, String> _paths;
  String _extension;
  bool _loadingPath = false;
  bool _multiPick = true;
  final _pickingType = FileType.custom;
  final _controller = TextEditingController();
  bool error = false;
  @override
  void initState() {
    super.initState();
    _controller.addListener(() => _extension = _controller.text);
  }

  void _openFileExplorer() async {
    setState(() {
      _loadingPath = true;
      error = false;
    });
    try {
      var tempPath = await FilePicker.getMultiFilePath(
        type: _pickingType,
        allowedExtensions: ['jpg', 'pdf', 'doc', 'txt', 'xlsx', 'docx', 'xls'],
      );
      if (_paths != null) {
        if (_paths.length == 3) {
          setState(() {
            error = true;
          });
        }
      }
      if (tempPath != null &&
          _paths != null &&
          _paths.length < 3 &&
          tempPath.length < 3) {
        _paths.addAll(tempPath);
      } else {}
      if (tempPath != null) {
        if (tempPath.length > 3) {
          setState(() {
            error = true;
          });
        }
        if (tempPath.length < 3) _paths == null ? _paths = tempPath : null;
      }
    } on PlatformException catch (e) {
      print('Unsupported operation' + e.toString());
    }
    if (!mounted) return;
    setState(() {
      _loadingPath = false;
      _fileName = _path != null
          ? _path.split('/').last
          : _paths != null ? _paths.keys.toString() : '...';
    });
  }

  delete(String key) {
    _paths.remove(key);
    setState(() {});
    print(_paths);
  }

  @override
  Widget build(BuildContext context) {
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
                  onTap: () => _openFileExplorer(),
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
                  style: TextStyle(color: error ? Colors.red : Colors.black),
                )
              ],
            ),
          ),
          _paths != null
              ? Container(
                  height: MediaQuery.of(context).size.height * 0.30,
                  child: ListView.builder(
                    physics: ClampingScrollPhysics(),
                    itemCount:
                        _paths != null && _paths.isNotEmpty ? _paths.length : 0,
                    itemBuilder: (BuildContext context, int index) {
                      final isMultiPath = _paths != null && _paths.isNotEmpty;
                      final name = (isMultiPath
                          ? _paths.keys.toList()[index]
                          : _fileName ?? '...');
                      return Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Colors.grey[300], width: 1))),
                        child: ListTile(
                          dense: true,
                          contentPadding: const EdgeInsets.all(0),
                          title: Text(
                            name,
                          ),
                          trailing: InkWell(
                            child: FaIcons(
                              'fad fa-times-circle',
                              primaryColor: ThemeColors.primaryColor,
                              secondaryColor: Colors.white,
                              size: 20,
                            ),
                            onTap: () => delete(name),
                          ),
                        ),
                      );
                    },
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
