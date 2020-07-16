
class AdvertisementModel {
  int menuAdvertisementId;
  String name;
  String subMenu;
  int publish;
  String link;
  AdvertisementModel(this.menuAdvertisementId, this.name, this.subMenu,
      this.publish, this.link);
}

class AdvertisementSubModel {
  int id;
  int menuAdvertisementId;
  String name;
  int publish;
  String link;
  bool downloaded;
  String localLink;
  AdvertisementSubModel(this.id, this.menuAdvertisementId, this.name,
      this.publish, this.link, this.downloaded,
      [this.localLink]);
}