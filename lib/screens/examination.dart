import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:mipusec2/model_classes/examination.dart';
import 'package:mipusec2/screens/pdf.dart';
import 'package:mipusec2/services/api.dart';
import 'package:mipusec2/services/file_service.dart';
import 'package:mipusec2/utils/locator.dart';
import 'package:mipusec2/utils/size_config.dart';

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

// ignore: must_be_immutable
class ExaminationPage extends KFDrawerContent {
  @override
  _ExaminationPageState createState() => _ExaminationPageState();
}

class _ExaminationPageState extends State<ExaminationPage> {
  bool isSearching = false;
  bool expanded = false;
  bool isLoading = true;

  var _api = locator<Api>();
  var _fileService = locator<FileService>();

  void _filterAds(value) {
    setState(() {
      filteredExamList = mySubExam
          .where((mySubExam) =>
              mySubExam.title.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  Future callData() async {
    List<ExamModel> examModel = await _api.getMenuExam();
    mExams = examModel;
    for (var exam in examModel) {
      if (exam.subMenu == 1) {
        List<ExamSubModel> tempExam;
        tempExam = await _fileService.compare(exam.subModel);
        exam.subModel = tempExam;
        setState(
          () {
            mySubExam = filteredExamList = exam.subModel;
            isLoading = !isLoading;
          },
        );
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
                  ? Text('Examinations')
                  : TextField(
                      onChanged: (value) {
                        _filterAds(value);
                      },
                      style:
                          TextStyle(fontFamily: 'Segoeui', color: Colors.white),
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
                      topLeft: Radius.elliptical(460, 150)),
                  color: Color(0xff3D496A)),
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    backgroundColor: Color.fromRGBO(83, 94, 127, 1.0),
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
                            decoration: InputDecoration(
                                icon: Icon(
                                  Icons.search,
                                  color: Colors.white,
                                ),
                                enabled: true,
                                hintText: " Search Here",
                                hintStyle: TextStyle(color: Colors.white)),
                            style: TextStyle(
                              fontFamily: 'Segoeui',
                            ),
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
                  if (mExams.length == 3 && mExams[0].subMenu == 0)
                    SliverToBoxAdapter(
                      child: singleItem(mExams[0].name, mExams[0].link, false),
                    ),
                  if (mExams.length == 3 && mExams[1].subMenu == 0)
                    SliverToBoxAdapter(
                      child: singleItem(mExams[1].name, mExams[1].link, false),
                    ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 5,
                    ),
                  ),
                  if (mExams.length == 3 && mExams[2].subMenu == 1)
                    SliverToBoxAdapter(
                      child: interviewList(mExams[2]),
                    ),
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
                .contains('ADMIT CARD NOTIFICATION / HRIATTIRNA')) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("Download not available for this file"),
              ));
            } else if (title
                .toUpperCase()
                .contains('TENTATIVE SCHEDULE OF EXAMINATION')) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("Download not available for this file"),
              ));
            } else {
              setState(() {
                downloading = true;
              });
              _fileService.downloadFile(link, title).then(
                (value) async {
                  if (value != null) {
                    List<ExamSubModel> _newSubExam =
                        await _fileService.compare(filteredExamList);
                    if (mounted) {
                      setState(() {
                        downloading = false;
                        progressString = "Completed";
                        mySubExam = filteredExamList = _newSubExam;
                      });
                    }
                  }
                },
              );
            }
          },
          child: new Image.asset("assets/ic_download.png", height: 14.0));
    }
  }

  Widget cardContent(String title, String link, bool downloaded) {
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
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget singleItem(String title, String link, bool downloaded) {
    bool isLocal = downloaded;
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new PDFPage(link, false)));
      },
      child: Container(
        child: cardContent(title, link, isLocal),
        height: 100.0,
        margin: new EdgeInsets.fromLTRB(15, 15, 15, 0),
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
      ),
    );
  }

  Widget myItems(
      List<ExamModel> exam, List<ExamSubModel> iSubExams, String headr) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              headr,
              style: TextStyle(
                  fontFamily: 'Segoeui',
                  fontSize: SizeConfig.textMultiplier * 3.37,
                  color: Colors.amberAccent,
                  decoration: TextDecoration.none),
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
                              builder: (context) =>
                                  new PDFPage(iSubExams[indx].link, false)));
                    } else {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) =>
                                  new PDFPage(iSubExams[indx].link, false)));
                    }
                  },
                  child: singleItem(iSubExams[indx].title, iSubExams[indx].link,
                      iSubExams[indx].downloaded ?? false));
            })
      ],
    );
  }

  Widget interviewList(
    ExamModel examModel,
  ) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              examModel.name.toUpperCase(),
              style: TextStyle(
                  fontSize: SizeConfig.textMultiplier * 3.37,
                  color: Colors.black,
                  decoration: TextDecoration.underline),
            ),
          ),
        ),
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: examModel.subModel.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int indx) {
              return GestureDetector(
                  onTap: () {
                    if (examModel.subModel[indx].downloaded) {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new PDFPage(
                                  examModel.subModel[indx].link, false)));
                    } else {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new PDFPage(
                                  examModel.subModel[indx].link, false)));
                    }
                  },
                  child: singleItem(
                      examModel.subModel[indx].title,
                      examModel.subModel[indx].link,
                      examModel.subModel[indx].downloaded ?? false));
            })
      ],
    );
  }
}
