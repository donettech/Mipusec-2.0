import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:http/http.dart' as http;
import 'package:mipusec2/model_classes/advertisement.dart';
import 'package:mipusec2/screens/pdf.dart';
import 'package:mipusec2/utils/size_config.dart';
import 'package:path_provider/path_provider.dart';

// ignore: must_be_immutable
class AdvertisementPage extends KFDrawerContent {
  @override
  _AdvertisementPageState createState() => _AdvertisementPageState();
}

class _AdvertisementPageState extends State<AdvertisementPage> {
  String url =
      "http://mpsc.jesdamizoram.com/HeroApi/v1/Api.php?apicall=getmenuadvertisement";
  String url2 =
      "http://mpsc.jesdamizoram.com/HeroApi/v1/Api.php?apicall=getmenuadvertisementsub&id=";
  int i = 0;

  bool downloading = false;
  String progressString = "";
  String directory;
  List file = new List();
  String fileName = "";
  String rootUrl = "http://mpsc.jesdamizoram.com/";
  String preConcat =
      "/storage/emulated/0/Android/data/com.jesda.mpsc.mpsc/files/Advertisements/";

  List<AdvertisementModel> myAds = [];
  List<AdvertisementSubModel> mySubAds1 = [];
  List<AdvertisementSubModel> mySubAds2 = [];
  List<AdvertisementSubModel> filteredAdsList1 = [];
  List<AdvertisementSubModel> filteredAdsList2 = [];

  bool isSearching = false;
  bool expanded = false;
  bool isLoading = true;
   getAds() async {
    List<AdvertisementModel> mAds = [];
    var response = await http.get(url);
    var mdata = json.decode(response.body);
    var menuAds = mdata['menuadvertisement'];
    for (var u in menuAds) {
      AdvertisementModel menuAdsItem = AdvertisementModel(
          u['menu_advertisement_id'],
          u['name'],
          u['submenu'],
          u['publish'],
          u['link']);
      mAds.add(menuAdsItem);
    }
    return mAds;
  }

  getAdsSub(int indx) async {
    List<AdvertisementSubModel> mSubAds = [];
    var response = await http.get(url2 + indx.toString());
    var mdata = json.decode(response.body);
    var menuAdssub = mdata['menuadvertisementsub'];
    for (var u in menuAdssub) {
      AdvertisementSubModel menuAdsSubItem = AdvertisementSubModel(
          u['id'],
          u['menu_advertisement_id'],
          u['name'],
          u['publish'],
          u['link'],
          false);
      mSubAds.add(menuAdsSubItem);
    }
    return mSubAds;
  }

  void _filterAds(value) {
    setState(() {
      filteredAdsList1 = mySubAds1
          .where((mySubAds1) =>
              mySubAds1.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
      filteredAdsList2 = mySubAds2
          .where((mySubAds2) =>
              mySubAds2.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  Future<void> callData() async {
    myAds = await getAds();
    setState(() {});
    if (myAds.length >= 2) {
      var mAds1 = await getAdsSub(myAds[myAds.length - 2].menuAdvertisementId);
      var mAds2 = await getAdsSub(myAds[myAds.length - 1].menuAdvertisementId);
      setState(() {
        mySubAds1 = filteredAdsList1 = mAds1;
        mySubAds2 = filteredAdsList2 = mAds2;
      });
    }
    _listofFiles();
    isLoading = !isLoading;
  }

  Future<void> downloadFile(String mUrl, String fileName) async {
    var dio = new Dio();
    var fUrl = rootUrl + mUrl;
    var dir = await getExternalStorageDirectory();
    var knockDir = new Directory('${dir.path}/Advertisements');
    await dio.download(fUrl, '${knockDir.path}/$fileName.${'pdf'}',
        onReceiveProgress: (rec, total) {
      print("Rec: $rec , Total: $total");

      if (mounted) {
        setState(() {
          downloading = true;
          progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
        });
      }
    });
    if (mounted) {
      setState(() {
        downloading = false;
        progressString = "Completed";
        _listofFiles();
      });
    }
  }

  Future<void> _listofFiles() async {
    directory = (await getExternalStorageDirectory()).path;
    String folderName = 'Advertisements';
    final Directory mDirectory = Directory('$directory/$folderName/');
    if (await mDirectory.exists()) {
      setState(() {
        file = Directory("$directory/Advertisements/")
            .listSync();  
        compare();
      });
    } else {
      await mDirectory.create(recursive: true);
    }
  }

  void compare() {
    if (0 != filteredAdsList1.length && 0 != file.length) {
      int loop = 0;
      while (loop < filteredAdsList1.length) {
        int indx = 0;
        while (indx < file.length) {
          if (preConcat + filteredAdsList1[loop].name + ".pdf" ==
              file[indx].path) {
            setState(() {
              filteredAdsList1[loop].downloaded = true;
              filteredAdsList1[loop].localLink = file[indx].path;
            });
          }
          indx++;
        }
        indx = 0;
        loop++;
      }
    }
    if (0 != filteredAdsList2.length && 0 != file.length) {
      int loop = 0;
      while (loop < filteredAdsList2.length) {
        int indx = 0;
        while (indx < file.length) {
          if (preConcat + filteredAdsList2[loop].name + ".pdf" ==
              file[indx].path) {
            setState(() {
              filteredAdsList2[loop].downloaded = true;
              filteredAdsList2[loop].localLink = file[indx].path;
            });
          }
          indx++;
        }
        indx = 0;
        loop++;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    callData();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: Color.fromRGBO(83, 94, 127, 1.0),
              elevation: 0,
              leading: !isSearching
                  ? IconButton(
                      icon: Icon(Icons.menu),
                      color: Colors.white,
                      onPressed: widget.onMenuPressed)
                  : null,
              titleSpacing: 0.0,
              title: !isSearching
                  ? Text('Advertisements')
                  : TextField(
                      onChanged: (value) {
                        _filterAds(value);
                      },
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          hintText: "Search Here",
                          hintStyle: TextStyle(color: Colors.white)),
                    ),
              centerTitle: true,
              actions: <Widget>[
                isSearching
                    ? IconButton(
                        icon: Icon(Icons.cancel),
                        onPressed: () {
                          setState(() {
                            this.isSearching = !this.isSearching;
                            filteredAdsList1 = mySubAds1;
                            filteredAdsList2 = mySubAds2;
                          });
                        },
                      )
                    : IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          setState(() {
                            this.isSearching = true;
                          });
                        },
                      )
              ],
            ),
            body: Container(
              color: Color(0xff3D496A),
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
              ),
            ),
          )
        : Container(
            color: Color.fromRGBO(83, 94, 127, 1.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: new BorderRadius.only(
                      topLeft: Radius.elliptical(360, 115)),
                  color: Color(0xff3D496A)),
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    backgroundColor: Color.fromRGBO(83, 94, 127, 1.0),
                    elevation: 0,
                    floating: true,
                    leading: !isSearching
                        ? IconButton(
                            icon: Icon(Icons.menu),
                            color: Colors.white,
                            onPressed: widget.onMenuPressed)
                        : null,
                    titleSpacing: 0.0,
                    title: !isSearching
                        ? Text('Advertisements')
                        : TextField(
                            onChanged: (value) {
                              _filterAds(value);
                            },
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                icon: Icon(
                                  Icons.search,
                                  color: Colors.white,
                                ),
                                hintText: " Search Here",
                                hintStyle: TextStyle(color: Colors.white)),
                          ),
                    centerTitle: true,
                    actions: <Widget>[
                      isSearching
                          ? IconButton(
                              icon: Icon(Icons.cancel),
                              onPressed: () {
                                setState(() {
                                  this.isSearching = !this.isSearching;
                                  filteredAdsList1 = mySubAds1;
                                  filteredAdsList2 = mySubAds2;
                                });
                              },
                            )
                          : IconButton(
                              icon: Icon(Icons.search),
                              onPressed: () {
                                setState(() {
                                  this.isSearching = true;
                                });
                              },
                            )
                    ],
                  ),
                  SliverList(
                      delegate: SliverChildListDelegate([
                    myItems(filteredAdsList1, myAds[0].name),
                    myItems(filteredAdsList2, myAds[1].name),
                  ]))
                ],
              ),
            ),
          );
  }

  Widget downloadingIcon(String link, String title) {
    if (downloading) {
      return Container(
          height: 12.0,
          width: 12.0,
          child: CircularProgressIndicator(
            strokeWidth: 1,
          ));
    } else {
      return GestureDetector(
          onTap: () {
            downloading = true;
            downloadFile(link, title);
          },
          child: new Image.asset("assets/ic_download.png", height: 12.0));
    }
  }

  Widget cardContent(
      BuildContext contx, String title, String link, bool downloaded) {
    return Container(
      margin: new EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
      constraints: new BoxConstraints.expand(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text(title,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          fontFamily: 'Segoeui',
                          fontSize: SizeConfig.textMultiplier * 2.19,
                          color: Colors.white,
                          fontWeight: FontWeight.w600)),
                ],
              )),
          Expanded(
              flex: 1,
              child: new Row(
                children: <Widget>[
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Text('Download: ',
                          style: TextStyle(
                            color: Colors.amberAccent,
                            fontSize: SizeConfig.textMultiplier * 1.69,
                          )),
                      new Container(width: 5.0),
                      downloaded
                          ? Icon(
                              Icons.check,
                              size: 12,
                            )
                          : downloadingIcon(link,
                              title)  
                    ],
                  )),
                ],
              )),
        ],
      ),
    );
  }

  Widget singleItem(
      BuildContext contxt, String title, String link, bool downloaded) {
    bool isLocal = downloaded;
    return Container(
      child: cardContent(contxt, title, link, isLocal),
      height: 100.0,
      margin: new EdgeInsets.fromLTRB(15, 5, 15, 0),
      decoration: new BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(102, 114, 150, 1.0),
            Color.fromRGBO(74, 85, 116, 1.0)
          ],
        ),
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: new Offset(0.0, 10.0),
          ),
        ],
      ),
    );
  }

  Widget myItems(List<AdvertisementSubModel> iSubAds, String headr) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              headr,
              style: TextStyle(
                  fontFamily: 'Segoeui',
                  fontSize: SizeConfig.textMultiplier * 3.37,
                  color: Colors.white,
                  decoration: TextDecoration.none),
            ),
          ),
        ),
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: iSubAds.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int indx) {
              return GestureDetector(
                onTap: () {
                  if (iSubAds[indx].downloaded) {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new PDFPage(
                                iSubAds[indx].localLink,
                                iSubAds[indx].downloaded)));
                  } else {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) =>
                                new PDFPage(iSubAds[indx].link, false)));
                  }
                },
                child: singleItem(context, iSubAds[indx].name,
                    iSubAds[indx].link, iSubAds[indx].downloaded),
              );
            })
      ],
    );
  }
}
