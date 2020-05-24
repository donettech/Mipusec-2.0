import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:http/http.dart' as http;
import 'package:mipusec2/screens/pdf.dart';
import 'package:path_provider/path_provider.dart';

String url =
    "http://mpsc.jesdamizoram.com/HeroApi/v1/Api.php?apicall=getnotification";

int i = 0;
List<NotificationModel> mNotice = [];

bool downloading = false;
String progressString = "";
String directory;
List file = new List();
String fileName = "";
String rootUrl = "http://mpsc.jesdamizoram.com/";
String preConcat =
    "/storage/emulated/0/Android/data/com.example.mipusec2/files/Notifications/";

class NotificationModel {
  int id;
  String title;
  String content;
  String link;
  bool downloaded;
  String localLink;
  NotificationModel(
      this.id, this.title, this.content, this.link, this.downloaded,
      [this.localLink]);
}

class NoticePage extends KFDrawerContent {
  @override
  _NoticePageState createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  List<NotificationModel> myNotice = [];
  List<NotificationModel> filteredNoticeList = [];
  bool isSearching = false;
  bool expanded = false;
  bool isLoading = true;

  getResult() async {
    List<NotificationModel> mResults = [];
    var response = await http.get(url);
    var mdata = json.decode(response.body);
    var menuresult = mdata['notification'];
    for (var u in menuresult) {
      NotificationModel menuresultItem = NotificationModel(
          u['id'], u['title'], u['content'], u['link'], false);
      mResults.add(menuresultItem);
    }
    return mResults;
  }

  void _filterResults(value) {
    setState(() {
      filteredNoticeList = myNotice
          .where((iResultSub1) =>
              iResultSub1.title.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  Future<void> callData() async {
    var oNotice = await getResult();
    setState(() {
      myNotice = filteredNoticeList = oNotice;
    });
    _listofFiles();
    isLoading = !isLoading;
  }

  Future<void> downloadFile(String mUrl, String fileName) async {
    var dio = new Dio();
    var fUrl = rootUrl + mUrl;
    var dir = await getExternalStorageDirectory();
    var knockDir = new Directory('${dir.path}/Notifications/');
    await dio.download(fUrl, '${knockDir.path}/$fileName.${'pdf'}',
        onReceiveProgress: (rec, total) {
      print("Received: $rec , Total Size : $total");

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
    String folderName = 'Notifications';
    final Directory mDirectory = Directory('$directory/$folderName/');
    if (await mDirectory.exists()) {
      setState(() {
        file = Directory("$directory/Notifications/")
            .listSync(); //use your folder name instead of resume.
        compare();
      });
    } else {
      await mDirectory.create(recursive: true);
    }
  }

  void compare() {
    if (0 != filteredNoticeList.length && 0 != file.length) {
      int loop = 0;
      while (loop < filteredNoticeList.length) {
        int indx = 0;
        while (indx < file.length) {
          if (preConcat + filteredNoticeList[loop].title + ".pdf" ==
              file[indx].path) {
            setState(() {
              filteredNoticeList[loop].downloaded = true;
              filteredNoticeList[loop].localLink = file[indx].path;
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
            backgroundColor: Colors.blue[500],
            appBar: AppBar(
              backgroundColor: Color(0xFF333366),
              elevation: 0,
              leading: !isSearching
                  ? IconButton(
                      icon: Icon(Icons.menu),
                      color: Colors.white,
                      onPressed: widget.onMenuPressed)
                  : null,
              titleSpacing: 0.0,
              title: !isSearching
                  ? Text('Results')
                  : TextField(
                      onChanged: (value) {
                        _filterResults(value);
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
                            filteredNoticeList = myNotice;
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
              color: Color(0xFF7A9BEE),
              child: Center(
                  child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              )),
            ),
          )
        : Container(
            color: Color(0xFF333366),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: new BorderRadius.only(
                      topLeft: Radius.elliptical(360, 115)),
                  color: Color(0xFF7A9BEE)),
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    backgroundColor: Color(0xFF333366),
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
                        ? Text('Results')
                        : TextField(
                            onChanged: (value) {
                              _filterResults(value);
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
                                  filteredNoticeList = myNotice;
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
                    myItems(filteredNoticeList),
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
                          fontSize: 13,
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
                          style:
                              TextStyle(color: Colors.grey[300], fontSize: 10)),
                      new Container(width: 5.0),
                      downloaded
                          ? Icon(
                              Icons.check,
                              size: 12,
                            )
                          : downloadingIcon(link, title)
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
        color: new Color(0xFF333366),
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

  Widget myItems(List<NotificationModel> iSubResult) {
    return Column(
      children: <Widget>[
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: iSubResult.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int indx) {
              return GestureDetector(
                  onTap: () {
                    if (iSubResult[indx].downloaded) {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new PDFPage(
                                  iSubResult[indx].localLink,
                                  iSubResult[indx].downloaded)));
                    } else {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) =>
                                  new PDFPage(iSubResult[indx].link, false)));
                    }
                  },
                  child: singleItem(context, iSubResult[indx].title,
                      iSubResult[indx].link, iSubResult[indx].downloaded));
            })
      ],
    );
  }
}
