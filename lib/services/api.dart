import 'dart:convert';

import 'package:mipusec2/model_classes/examination.dart';
import 'package:http/http.dart' as http;
import 'package:mipusec2/utils/constants.dart';

class Api {
  Future<List<ExamModel>> getMenuExam() async {
    List<ExamModel> examList = [];
    var response = await http.get(Constants.getMenuExam);
    var mdata = json.decode(response.body);
    var menuExamination = mdata['menuexamination'];
    for (var u in menuExamination) {
      ExamModel examModel = ExamModel.fromJson(u);
      if (examModel.subMenu == 1) {
        var _submenu = await _getExamSub(examModel.menuExamId);
        examModel.subModel = _submenu;
      }
      examList.add(examModel);
    }
    return examList;
  }

  Future<List<ExamSubModel>> _getExamSub(int id) async {
    List<ExamSubModel> mSubExam = [];
    var response = await http.get(Constants.getMenuExamSubById + id.toString());
    var mdata = json.decode(response.body);
    var menuExamsub = mdata['menuexaminationsub'];
    for (var u in menuExamsub) {
      ExamSubModel _temp = ExamSubModel.fromJson(u);
      mSubExam.add(_temp);
    }
    return mSubExam;
  }
}
