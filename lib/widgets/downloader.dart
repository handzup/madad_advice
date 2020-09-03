import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:madad_advice/blocs/download_bloc.dart';
import 'package:madad_advice/models/pinned_file.dart';
import 'package:madad_advice/utils/fa_icon.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:madad_advice/generated/locale_keys.g.dart';

class Downloader extends StatefulWidget {
  final fileUrl;
  final filesDirectory;
  final fileName;
  final filetype;
  final String size;
  final fullPath;
  const Downloader(
      {Key key,
      this.fileUrl,
      this.filesDirectory,
      this.fileName,
      this.filetype,
      this.fullPath,
      this.size})
      : super(key: key);
  @override
  _DownloaderState createState() => _DownloaderState(
      this.fileUrl,
      this.filesDirectory,
      this.fileName,
      this.filetype,
      this.fullPath,
      this.size);
}

const fileTypes = {
  'rtf': 'fad fa-file-alt',
  'txt': 'fal fa-file-alt',
  'html': 'fad fa-file-code',
  'htm': 'fal fa-file-code',
  'xml': 'fad fa-file',
  'jpg': 'fad fa-file-image',
  'jpeg': 'fad fa-file-image',
  'png': 'fad fa-file-image',
  'gif': 'fad fa-file-image',
  'bmp': 'fad fa-file-image',
  'doc': 'fad fa-file-word',
  'docx': 'fad fa-file-word',
  'xls': 'fad fa-file-spreadsheet',
  'xlsx': 'fad fa-file-spreadsheet',
  'ppt': 'fad fa-file-powerpoint',
  'pdf': 'fad fa-file-pdf',
  'default': 'fad fa-file'
};

class _DownloaderState extends State<Downloader> {
  final fileUrl;
  var filesDirectory;
  final fileName;
  final filetype;
  String fullPath;
  String size;
  var dio = Dio();
  bool complete = false;
  bool inProgress = false;
  double percent = 0.0;
  _DownloaderState(this.fileUrl, this.filesDirectory, this.fileName,
      this.filetype, this.fullPath, this.size);

  @override
  initState() {
    getPath();

    super.initState();
  }

  Future<void> getPath() async {
    filesDirectory = await getApplicationDocumentsDirectory();
    fullPath = filesDirectory.path + '/$fileName';
  }

  Widget progres(cn) {
    return LinearPercentIndicator(
      width: cn.maxWidth - 70,
      animation: true,
      padding: EdgeInsets.all(0),
      percent: percent <= 1 ? percent : 1,
      animateFromLastPercent: true,
      linearStrokeCap: LinearStrokeCap.roundAll,
      progressColor: Colors.green,
    );
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      var a = (received / total * 100) / 100;
      if (a == 1.0) {
        setState(() {
          complete = true;
          percent = a;
          inProgress = false;
        });
      } else {
        if (mounted) {
          setState(() {
            percent = a;
          });
        }
      }
    }
  }

  Future<void> openFile(path) async {
    final DownloadBloc downloadBloc = Provider.of<DownloadBloc>(context);
    if (await downloadBloc.isExists(fileName)) {
      final path = await downloadBloc.readBox(fileName);
      print(path.size);
      print(path.type);

      await OpenFile.open(path.path);
    } else {
      if (complete) {
        await OpenFile.open(path);
      } else {
        download(fileUrl, path);
      }
    }
  }

  Future download(String url, String savePath) async {
    final DownloadBloc downloadBloc = Provider.of<DownloadBloc>(context);
    setState(() {
      inProgress = true;
    });
    try {
      Response response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            }),
      );
      File file = File(savePath);

      var raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
      var item = PinnedFile(path: savePath, type: filetype, size: size);
      downloadBloc.writeFile(fileName, item);
    } catch (e) {
      print(e);
    }
  }

  show() async {
    final DownloadBloc downloadBloc = Provider.of<DownloadBloc>(context);
    bool a = await downloadBloc.isExists(fileName);
    setState(() {
      complete = a;
    });
  }

  @override
  Widget build(BuildContext context) {
    show();
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
          child: ListTile(
        onTap: () {
          openFile(fullPath);
        },
        subtitle: inProgress
            ? progres(constraints)
            : (complete
                ? Text(LocaleKeys.open.tr())
                : Text(LocaleKeys.download.tr())),
        title: Container(
          child: Text(
            fileName,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: GestureDetector(
          onTap: () {
            setState(() {
              percent += 0.005;
            });
          },
          child: FaIcons(
            fileTypes[filetype.toString()] != null
                ? fileTypes[filetype.toString()]
                : fileTypes['default'],
          ),
        ),
      ));
    });
  }
}
