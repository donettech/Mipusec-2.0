class ExamModel {
  int menuExamId;
  String name;
  int subMenu;
  int publish;
  String link;
  List<ExamSubModel> subModel;
  ExamModel({
    this.menuExamId,
    this.name,
    this.subMenu,
    this.publish,
    this.link,
    this.subModel,
  });

  ExamModel.fromJson(Map<String, dynamic> json) {
    menuExamId = json['id'];
    name = json['name'];
    subMenu = json['submenu'];
    publish = json['publish'];
    link = json['link'];
  }
}

class ExamSubModel {
  int id;
  int menuExamination;
  String title;
  String link;
  int subMenu;
  int publish;
  bool downloaded;
  String localLink;

  ExamSubModel(this.id, this.menuExamination, this.title, this.link,
      this.subMenu, this.publish, this.downloaded,
      [this.localLink]);

  ExamSubModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    menuExamination = json['menu_examination'];
    title = json['title'];
    link = json['link'];
    subMenu = json['submenu'];
    publish = json['publish'];
    downloaded = false;
  }
}
