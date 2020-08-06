import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mipusec2/model_classes/examination.dart';
import 'package:mipusec2/utils/constants.dart';
import 'package:path_provider/path_provider.dart';

class FileService {
  List file = new List();
  var preConcat = Constants.preConcat;

  Future downloadFile(String mUrl, String fileName) async {
    var dio = new Dio();
    var fUrl = Constants.rootUrl + mUrl;
    var dir = await getExternalStorageDirectory();
    var knockDir = new Directory('${dir.path}/Examination/');
    await dio.download(fUrl, '${knockDir.path}/$fileName.${'pdf'}',
        onReceiveProgress: (rec, total) {
      print("Received: $rec , Total Size : $total");
      return true;
      /* if (mounted) {
        setState(() {
          downloading = true;
          progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
        });
      } */
    });
    // _listofFiles();
    /* if (mounted) {
      setState(() {
        downloading = false;
        progressString = "Completed";
       
      });
    } */
    return false;
  }

  Future<List<dynamic>> _listofFiles() async {
    var directory = (await getExternalStorageDirectory()).path;
    String folderName = 'Examination';
    final Directory mDirectory = Directory('$directory/$folderName/');
    if (await mDirectory.exists()) {
      file = Directory("$directory/Examination/").listSync();
      return file;
    } else {
      await mDirectory.create(recursive: true);
      return null;
    }
  }

  Future<List<ExamSubModel>> compare(
      List<ExamSubModel> filteredExamList) async {
    var file = await _listofFiles();
    if (file != null) {
      if (0 != filteredExamList.length && 0 != file.length) {
        int loop = 0;
        while (loop < filteredExamList.length) {
          int indx = 0;
          while (indx < file.length) {
            if (preConcat + filteredExamList[loop].title + ".pdf" ==
                file[indx].path) {
              filteredExamList[loop].downloaded = true;
              filteredExamList[loop].localLink = file[indx].path;
            }
            indx++;
          }
          indx = 0;
          loop++;
        }
      }
    }
    return filteredExamList;
  }
}
