import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:http/http.dart' as http;
import 'package:mipusec2/model_classes/syllabus.dart';
import 'package:mipusec2/screens/pdf.dart';
import 'package:mipusec2/utils/size_config.dart';
import 'package:path_provider/path_provider.dart';

// ignore: must_be_immutable
class SyllabusPage extends KFDrawerContent {
  @override
  _SyllabusPageState createState() => _SyllabusPageState();
}

class _SyllabusPageState extends State<SyllabusPage> {
  bool downloading = false;
  String progressString = "";
  String directory;
  List file = new List();
  String fileName = "";
  String rootUrl = "http://mpsc.jesdamizoram.com/";
  String preConcat =
      "/storage/emulated/0/Android/data/com.example.mipusec2/files/Syllabus/";

  String url =
      "http://mpsc.jesdamizoram.com/HeroApi/v1/Api.php?apicall=getmenusyllabus";

  List<SyllabusModel> mSyllabus = [];
  List<SyllabusModel> filteredSyllabusList = [];
  bool isSearching = false;
  bool isLoading = true;

  getSyllabus() async {
    List<SyllabusModel> mData = [];
    var response = await http.get(url);
    var mdata = json.decode(response.body);
    var notifications = mdata['menusyllabus'];
    for (var u in notifications) {
      SyllabusModel notiItem = SyllabusModel(u['syllabus_id'].toString(),
          u['name'], u['publish'], u['link'], false);
      mData.add(notiItem);
    }
    return mData;
  }

  void _filterSyllabus(value) {
    setState(() {
      filteredSyllabusList = mSyllabus
          .where((syllabi) =>
              syllabi.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  Future<void> getData() async {
    var iSyllabus = await getSyllabus();
    setState(() {
      mSyllabus = filteredSyllabusList = iSyllabus;
      isLoading = !isLoading;
      _listofFiles();
    });
  }

  Future<void> downloadFile(String mUrl, String fileName) async {
    var dio = new Dio();
    var fUrl = rootUrl + mUrl;
    var dir = await getExternalStorageDirectory();
    var knockDir = new Directory('${dir.path}/Syllabus');
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
    String folderName = 'Syllabus';
    final Directory mDirectory = Directory('$directory/$folderName/');
    if (await mDirectory.exists()) {
      setState(() {
        file = Directory("$directory/Syllabus/")
            .listSync(); //use your folder name instead of Syllabus.
        compare();
      });
    } else {
      await mDirectory.create(recursive: true);
    }
  }

  void compare() {
    if (0 != filteredSyllabusList.length && 0 != file.length) {
      int loop = 0;
      while (loop < filteredSyllabusList.length) {
        int indx = 0;
        while (indx < file.length) {
          if (preConcat + filteredSyllabusList[loop].name + ".pdf" ==
              file[indx].path) {
            setState(() {
              filteredSyllabusList[loop].downloaded = true;
              filteredSyllabusList[loop].localLink = file[indx].path;
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
    getData();
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
                  ? Text('Syllabus')
                  : TextField(
                      onChanged: (value) {
                        _filterSyllabus(value);
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
                            filteredSyllabusList = mSyllabus;
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
                ),
              ),
            ),
          )
        : Container(
            color: Color(0xFF333366),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: new BorderRadius.only(
                      topLeft: Radius.elliptical(200, 125)),
                  color: Colors.blue[500]),
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
                        ? Text('Syllabus')
                        : TextField(
                            onChanged: (value) {
                              _filterSyllabus(value);
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
                                if (mounted) {
                                  setState(() {
                                    this.isSearching = !this.isSearching;
                                    filteredSyllabusList = mSyllabus;
                                  });
                                }
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
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext ctx, int indx) {
                      return GestureDetector(
                          onTap: () {
                            if (filteredSyllabusList[indx].downloaded) {
                              print('Open from external storage');
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new PDFPage(
                                          filteredSyllabusList[indx].localLink,
                                          filteredSyllabusList[indx]
                                              .downloaded)));
                            } else {
                              /* downloadFile(filteredSyllabusList[indx].link,
                                filteredSyllabusList[indx].name); */
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new PDFPage(
                                          filteredSyllabusList[indx].link,
                                          filteredSyllabusList[indx]
                                              .downloaded)));
                            }
                          },
                          child: singleItem(
                              ctx,
                              filteredSyllabusList[indx].name,
                              filteredSyllabusList[indx].link,
                              filteredSyllabusList[indx].downloaded));
                    }, childCount: filteredSyllabusList.length),
                  ),
                ],
              ),
            ),
          );
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
                            color: Colors.grey[300],
                            fontSize: SizeConfig.textMultiplier * 1.69,
                          )),
                      new Container(width: 5.0),
                      downloaded
                          ? Icon(
                              Icons.check,
                              color: Colors.green,
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

  Widget singleItem(BuildContext contxt, String title, String link,
      [bool kDownloaded]) {
    bool isLocal = false;
    if (kDownloaded) {
      isLocal = true;
    }
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
}
