import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:http/http.dart' as http;
import 'package:mipusec2/screens/pdf.dart';
import 'package:path_provider/path_provider.dart';

String url =
    "http://mpsc.jesdamizoram.com/HeroApi/v1/Api.php?apicall=getmenuexamination";
String url2 =
    "http://mpsc.jesdamizoram.com/HeroApi/v1/Api.php?apicall=getmenuexaminationsub&id=";
int i = 0;

bool downloading = false;
String progressString = "";
String directory;
List file = new List();
String fileName = "";
String rootUrl = "http://mpsc.jesdamizoram.com/";
String preConcat =
    "/storage/emulated/0/Android/data/com.example.mipusec2/files/Examination/";

List<ExamModel> mExams = [];
List<ExamSubModel> mySubExam = [];
List<ExamSubModel> filteredExamList = [];

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

class ExaminationPage extends KFDrawerContent {
  @override
  _ExaminationPageState createState() => _ExaminationPageState();
}

class _ExaminationPageState extends State<ExaminationPage> {
  bool isSearching = false;
  bool expanded = false;
  bool isLoading = true;

  getExams() async {
    List<ExamModel> mAds = [];
    var response = await http.get(url);
    var mdata = json.decode(response.body);
    var menuAds = mdata['menuexamination'];
    for (var u in menuAds) {
      ExamModel menuAdsItem =
          ExamModel(u['id'], u['name'], u['submenu'], u['publish'], u['link']);
      mAds.add(menuAdsItem);
    }
    return mAds;
  }

  getExamSub(int indx) async {
    List<ExamSubModel> mSubAds = [];
    var response = await http.get(url2 + indx.toString());
    var mdata = json.decode(response.body);
    var menuAdssub = mdata['menuexaminationsub'];
    for (var u in menuAdssub) {
      ExamSubModel menuAdsSubItem = ExamSubModel(u['id'], u['menu_examination'],
          u['title'], u['link'], u['submenu'], u['publish'], false);
      mSubAds.add(menuAdsSubItem);
    }
    return mSubAds;
  }

  void _filterAds(value) {
    setState(() {
      filteredExamList = mySubExam
          .where((mySubExam) =>
              mySubExam.title.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  Future<void> callData() async {
    mExams = await getExams();
    setState(() {});
    if (mExams.length >= 2) {
      var mExm = await getExamSub(mExams[1].menuExamId);
      setState(() {
        mySubExam = filteredExamList = mExm;
      });
    }
    isLoading = !isLoading;
    _listofFiles();
  }

  Future<void> downloadFile(String mUrl, String fileName) async {
    var dio = new Dio();
    var fUrl = rootUrl + mUrl;
    var dir = await getExternalStorageDirectory();
    var knockDir = new Directory('${dir.path}/Examination/');
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
    String folderName = 'Examination';
    final Directory mDirectory = Directory('$directory/$folderName/');
    if (await mDirectory.exists()) {
      setState(() {
        file = Directory("$directory/Examination/")
            .listSync(); //use your folder name instead of resume.
        compare();
      });
    } else {
      await mDirectory.create(recursive: true);
    }
  }

  void compare() {
    if (0 != filteredExamList.length && 0 != file.length) {
      int loop = 0;
      while (loop < filteredExamList.length) {
        int indx = 0;
        while (indx < file.length) {
          if (preConcat + filteredExamList[loop].title + ".pdf" ==
              file[indx].path) {
            setState(() {
              filteredExamList[loop].downloaded = true;
              filteredExamList[loop].localLink = file[indx].path;
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
                  ? Text('Examinations')
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
                            filteredExamList = mySubExam;
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
                      topLeft: Radius.elliptical(460, 150)),
                  color: Color(0xFF7A9BEE)),
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    backgroundColor: Color(0xFF333366),
                    elevation: 0,
                    floating: true,
                    pinned: false,
                    leading: !isSearching
                        ? IconButton(
                            icon: Icon(Icons.menu),
                            color: Colors.white,
                            onPressed: widget.onMenuPressed)
                        : null,
                    titleSpacing: 0.0,
                    title: !isSearching
                        ? Text('Examinations')
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
                                  filteredExamList = mySubExam;
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
                    myItems(context, mExams, filteredExamList, mExams[1].name),
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
            if (title
                .toUpperCase()
                .contains('TENTATIVE SCHEDULE OF EXAMINATION')) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("Download not available for this file"),
              ));
            } else {
              downloading = true;
              downloadFile(link, title);
            }
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
      margin: new EdgeInsets.fromLTRB(15, 15, 15, 0),
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

  Widget myItems(BuildContext ctx, List<ExamModel> exam,
      List<ExamSubModel> iSubExams, String headr) {
    return Column(
      children: <Widget>[
        GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new PDFPage(exam[0].link, false)));
            },
            child: singleItem(ctx, exam[0].name, exam[0].link, false)),
        Padding(
          padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              headr,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  decoration: TextDecoration.underline),
            ),
          ),
        ),
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: iSubExams.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int indx) {
              return GestureDetector(
                  onTap: () {
                    if (iSubExams[indx].downloaded) {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new PDFPage(
                                  iSubExams[indx].localLink,
                                  iSubExams[indx].downloaded)));
                    } else {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) =>
                                  new PDFPage(iSubExams[indx].link, false)));
                    }
                  },
                  child: singleItem(ctx, iSubExams[indx].title,
                      iSubExams[indx].link, iSubExams[indx].downloaded)
                  /* ListTile(
                title: Text(iSubExams[indx].title),
                subtitle: Divider(color: Colors.grey[400]),
              ), */
                  );
            })
      ],
    );
  }
}
