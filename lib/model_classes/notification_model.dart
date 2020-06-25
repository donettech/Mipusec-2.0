class NotificationModel {
  String id;
  String title;
  String content;
  String link;
  bool downloaded;
  String localLink;
  NotificationModel(
      this.id, this.title, this.content, this.link, this.downloaded,
      [this.localLink]);
}