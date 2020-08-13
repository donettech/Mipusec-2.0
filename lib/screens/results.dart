import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:http/http.dart' as http;
import 'package:mipusec2/model_classes/results.dart';
import 'package:mipusec2/screens/pdf.dart';
import 'package:mipusec2/utils/size_config.dart';
import 'package:path_provider/path_provider.dart';

// ignore: must_be_immutable
class ResultsPage extends KFDrawerContent {
  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  String url =
      "http://mpsc.jesdamizoram.com/HeroApi/v1/Api.php?apicall=getmenuresult";
  String url2 =
      "http://mpsc.jesdamizoram.com/HeroApi/v1/Api.php?apicall=getmenuresultsub&id=";
  int i = 0;
  List<ResultsSubModel> tempsubModel = [];

  bool downloading = false;
  String progressString = "";
  String directory;
  List file = new List();
  String fileName = "";
  String rootUrl = "http://mpsc.jesdamizoram.com/";
  String preConcat =
      "/storage/emulated/0/Android/data/com.jesda.mpsc.mpsc/files/Results/";

  List<ResultsModel> myResults = [];
  List<ResultsSubModel> mySubResults = [];
  List<ResultsSubModel> mySubResults1 = [];
  List<ResultsSubModel> mySubResults2 = [];
  List<ResultsSubModel> mySubResults3 = [];
  List<ResultsSubModel> filteredResultsSubList = [];
  List<ResultsSubModel> filteredResultsSubList1 = [];
  List<ResultsSubModel> filteredResultsSubList2 = [];
  List<ResultsSubModel> filteredResultsSubList3 = [];
  bool isSearching = false;
  bool expanded = false;
  bool isLoading = true;

  getResult() async {
    List<ResultsModel> mResults = [];
    var response = await http.get(url);
    var mdata = json.decode(response.body);
    var menuresult = mdata['menuresult'];
    for (var u in menuresult) {
      ResultsModel menuresultItem = ResultsModel(u['menu_result_id'], u['name'],
          u['submenu'], u['publish'], u['link'], tempsubModel);
      mResults.add(menuresultItem);
    }
    return mResults;
  }

  getResultSub(int indx) async {
    List<ResultsSubModel> mSubResults = [];
    var response = await http.get(url2 + indx.toString());
    var mdata = json.decode(response.body);
    var menuresultsub = mdata['menuresultsub'];
    for (var u in menuresultsub) {
      ResultsSubModel menuresultsubItem = ResultsSubModel(
          u['menu_result_sub_id'],
          u['menu_result_id'],
          u['title'],
          u['link'],
          false);
      mSubResults.add(menuresultsubItem);
    }

    return mSubResults;
  }

  void _filterResults(value) {
    setState(() {
      filteredResultsSubList1 = mySubResults1
          .where((iResultSub1) =>
              iResultSub1.title.toLowerCase().contains(value.toLowerCase()))
          .toList();
      filteredResultsSubList2 = mySubResults2
          .where((iResultSub2) =>
              iResultSub2.title.toLowerCase().contains(value.toLowerCase()))
          .toList();
      filteredResultsSubList3 = mySubResults3
          .where((iResultSub3) =>
              iResultSub3.title.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  Future<void> callData() async {
    myResults = await getResult();
    setState(() {});
    if (myResults.length >= 3) {
      var mRes1 = await getResultSub(myResults.length - 0);
      var mRes2 = await getResultSub(myResults.length - 1);
      var mRes3 = await getResultSub(myResults.length - 2);
      setState(() {
        mySubResults1 = filteredResultsSubList1 = mRes1;
        mySubResults2 = filteredResultsSubList2 = mRes2;
        mySubResults3 = filteredResultsSubList3 = mRes3;
      });
    }
    _listofFiles();
    isLoading = !isLoading;
  }

  Future<void> downloadFile(String mUrl, String fileName) async {
    var dio = new Dio();
    var fUrl = rootUrl + mUrl;
    var dir = await getExternalStorageDirectory();
    var knockDir = new Directory('${dir.path}/Results');
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
    String folderName = 'Results';
    final Directory mDirectory = Directory('$directory/$folderName/');
    if (await mDirectory.exists()) {
      setState(() {
        file = Directory("$directory/Results/").listSync();
        compare();
      });
    } else {
      await mDirectory.create(recursive: true);
    }
  }

  void compare() {
    if (0 != filteredResultsSubList1.length && 0 != file.length) {
      int loop = 0;
      while (loop < filteredResultsSubList1.length) {
        int indx = 0;
        while (indx < file.length) {
          if (preConcat + filteredResultsSubList1[loop].title + ".pdf" ==
              file[indx].path) {
            setState(() {
              filteredResultsSubList1[loop].downloaded = true;
              filteredResultsSubList1[loop].localLink = file[indx].path;
            });
          }
          indx++;
        }
        indx = 0;
        loop++;
      }
    }
    if (0 != filteredResultsSubList2.length && 0 != file.length) {
      int loop = 0;
      while (loop < filteredResultsSubList2.length) {
        int indx = 0;
        while (indx < file.length) {
          if (preConcat + filteredResultsSubList2[loop].title + ".pdf" ==
              file[indx].path) {
            setState(() {
              filteredResultsSubList2[loop].downloaded = true;
              filteredResultsSubList2[loop].localLink = file[indx].path;
            });
          }
          indx++;
        }
        indx = 0;
        loop++;
      }
    }
    if (0 != filteredResultsSubList3.length && 0 != file.length) {
      int loop = 0;
      while (loop < filteredResultsSubList3.length) {
        int indx = 0;
        while (indx < file.length) {
          if (preConcat + filteredResultsSubList3[loop].title + ".pdf" ==
              file[indx].path) {
            setState(() {
              filteredResultsSubList3[loop].downloaded = true;
              filteredResultsSubList3[loop].localLink = file[indx].path;
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
            backgroundColor: Color(0xff3D496A),
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
                            filteredResultsSubList1 = mySubResults1;
                            filteredResultsSubList2 = mySubResults2;
                            filteredResultsSubList3 = mySubResults3;
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
              )),
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
                        ? Text('Results')
                        : TextField(
                            onChanged: (value) {
                              _filterResults(value);
                            },
                            style: TextStyle(
                                fontFamily: 'Segoeui', color: Colors.white),
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
                                  filteredResultsSubList1 = mySubResults1;
                                  filteredResultsSubList2 = mySubResults2;
                                  filteredResultsSubList3 = mySubResults3;
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
                    myItems(filteredResultsSubList1, myResults[0].name),
                    myItems(filteredResultsSubList2, myResults[1].name),
                    myItems(filteredResultsSubList3, myResults[3].name)
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
          child: new Image.asset("assets/ic_download.png", height: 14.0));
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
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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

  Widget myItems(List<ResultsSubModel> iSubResult, String headr) {
    return Column(
      children: <Widget>[
        Padding(
          padding:
              EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0, bottom: 0),
          child: Text(
            headr,
            style: TextStyle(
                fontFamily: 'Segoeui',
                fontSize: SizeConfig.textMultiplier * 3.37,
                color: Colors.amberAccent,
                decoration: TextDecoration.none),
          ),
        ),
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
                              builder: (context) =>
                                  new PDFPage(iSubResult[indx].link, false)));
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
