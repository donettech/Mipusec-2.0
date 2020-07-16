
class ExamModel {
  int menuExamId;
  String name;
  int subMenu;
  int publish;
  String link;
  ExamModel(this.menuExamId, this.name, this.subMenu, this.publish, this.link);
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
}