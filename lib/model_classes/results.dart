
class ResultsModel {
  int menuResultId;
  String name;
  int subMenu;
  int publish;
  String link;
  List<ResultsSubModel> subModel;
  ResultsModel(this.menuResultId, this.name, this.subMenu, this.publish,
      this.link, this.subModel);
}

class ResultsSubModel {
  int menuResultSubId;
  int menuResultId;
  String title;
  String link;
  bool downloaded;
  String localLink;
  ResultsSubModel(this.menuResultSubId, this.menuResultId, this.title,
      this.link, this.downloaded,
      [this.localLink]);
}
