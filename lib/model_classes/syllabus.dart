
class SyllabusModel {
  String syllabusId;
  String name;
  int publish;
  String link;
  bool downloaded;
  String localLink;
  SyllabusModel(
      this.syllabusId, this.name, this.publish, this.link, this.downloaded,
      [this.localLink]);
}
