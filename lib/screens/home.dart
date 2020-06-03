import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kf_drawer/kf_drawer.dart';
import 'package:mipusec2/animations/FadeAnimation.dart';
import 'package:mipusec2/screens/pdf.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mipusec2/screens/pinned.dart';
import 'package:path_provider/path_provider.dart';

bool downloading = false;
String progressString = "";
String directory;
List file = new List();
String fileName = "";
String rootUrl = "http://mpsc.jesdamizoram.com/";
String preConcat =
    "/storage/emulated/0/Android/data/com.example.mipusec2/files/Noticfications/";

String pinnedItem = '';

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

class HomePage extends KFDrawerContent {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<NotificationModel> mData = [];
  void getData() async {
    var response = await http.get(
        "http://mpsc.jesdamizoram.com/HeroApi/v1/Api.php?apicall=getnotification");
    var mdata = json.decode(response.body);
    var notifications = mdata['notification'];
    for (var u in notifications) {
      NotificationModel notiItem = NotificationModel(
          u['id'].toString(), u['title'], u['content'], u['link'], false);
      mData.add(notiItem);
    }
    _listofFiles();
    //return mData;
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> _listofFiles() async {
    directory = (await getExternalStorageDirectory()).path;
    String folderName = 'Notifications';
    final Directory mDirectory = Directory('$directory/$folderName/');
    if (await mDirectory.exists()) {
      if (this.mounted) {
        setState(() {
          file = Directory("$directory/Notifications/")
              .listSync(); //use your folder name instead of resume.
          compare();
        });
      }
    } else {
      await mDirectory.create(recursive: true);
    }
  }

  void compare() {
    if (0 != mData.length && 0 != file.length) {
      int loop = 0;
      while (loop < mData.length) {
        int indx = 0;
        while (indx < file.length) {
          if (preConcat + mData[loop].title + ".pdf" == file[indx].path) {
            setState(() {
              mData[loop].downloaded = true;
              mData[loop].localLink = file[indx].path;
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
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF7A9BEE),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.ac_unit),
            onPressed: () {
              if (pinnedItem == "") {
                setState(() {
                  pinnedItem =
                      "This is the text for pinned item let it be a long one to see what happens when it overflows the text widget width";
                });
              } else {
                setState(() {
                  pinnedItem = "";
                });
              }
            }),
        body: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          alignment: Alignment.bottomRight,
                          image: AssetImage('assets/offce.png'),
                          fit: BoxFit.scaleDown)),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                          left: -5,
                          width: 50,
                          top: 20,
                          height: 50,
                          child: IconButton(
                              icon: Icon(Icons.menu),
                              color: Colors.blue[900],
                              onPressed: widget.onMenuPressed)),
                      Positioned(
                          top: 35,
                          left: 135,
                          width: 93,
                          height: 93,
                          child: FadeAnimation(
                              1,
                              Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/mpsc_icon_round.png'))),
                              ))),
                      Positioned(
                        left: 139,
                        top: 130,
                        child: FadeAnimation(
                            1.5,
                            Container(
                              child: Center(
                                child: Text(
                                  "MIPUSEC",
                                  style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                          color: Color(0xFF333366),
                                          fontSize: 22,
                                          fontWeight: FontWeight.normal)),
                                ),
                              ),
                            )),
                      ),
                      Positioned(
                        left: 80,
                        top: 160,
                        child: FadeAnimation(
                            1.8,
                            Container(
                              child: Center(
                                  child: RichText(
                                text: new TextSpan(
                                  // Note: Styles for TextSpans must be explicitly defined.
                                  // Child text spans will inherit styles from parent
                                  style: new TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.black,
                                  ),
                                  children: <TextSpan>[
                                    new TextSpan(
                                        text: 'M',
                                        style: TextStyle(
                                            fontFamily: 'Segoe',
                                            fontSize: 16,
                                            color: Color(0xFF333366))),
                                    new TextSpan(
                                        text: 'izoram ',
                                        style: GoogleFonts.ebGaramond(
                                            textStyle: TextStyle(
                                                fontSize: 16,
                                                color: Color(0xFF333366)))),
                                    new TextSpan(
                                        text: 'P',
                                        style: TextStyle(
                                            fontFamily: 'Segoe',
                                            fontSize: 16,
                                            color: Color(0xFF333366))),
                                    new TextSpan(
                                        text: 'ublic ',
                                        style: GoogleFonts.ebGaramond(
                                            textStyle: TextStyle(
                                                fontSize: 16,
                                                color: Color(0xFF333366)))),
                                    new TextSpan(
                                        text: 'S',
                                        style: TextStyle(
                                            color: Color(0xFF333366),
                                            fontFamily: 'Segoe',
                                            fontSize: 16)),
                                    new TextSpan(
                                        text: 'ervice ',
                                        style: GoogleFonts.ebGaramond(
                                            textStyle: TextStyle(
                                                fontSize: 16,
                                                color: Color(0xFF333366)))),
                                    new TextSpan(
                                        text: 'C',
                                        style: TextStyle(
                                            fontFamily: 'Segoe',
                                            fontSize: 16,
                                            color: Color(0xFF333366))),
                                    new TextSpan(
                                        text: 'ommission ',
                                        style: GoogleFonts.ebGaramond(
                                            textStyle: TextStyle(
                                                fontSize: 16,
                                                color: Color(0xFF333366)))),
                                  ],
                                ),
                              )),
                            )),
                      ),
                    ],
                  ),
                ),
                flex: 5,
              ),
              pinnedItem != ''
                  ? Expanded(
                      flex: pinnedItem != '' ? 1 : 0,
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Container(
                          decoration: pinnedItem != ''
                              ? BoxDecoration(
                                  color: Colors.blue[800],
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(5),
                                      bottomLeft: Radius.circular(5),
                                      bottomRight: Radius.circular(5)),
                                )
                              : BoxDecoration(),
                          child: Column(
                            children: <Widget>[
                              Text(
                                'Pinned Notification',
                                style: TextStyle(color: Color(0xFF333366)),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 5, right: 5),
                                child: Container(
                                  height: 0.5,
                                  color: Colors.black54,
                                ),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) =>
                                              new PinnedPage(pinnedItem)));
                                },
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5),
                                    child: Text(
                                      pinnedItem,
                                      style: TextStyle(color: Colors.white),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                    ),
                                  ),
                                ),
                              ),
                              Spacer()
                            ],
                          ),
                        ),
                      ))
                  : Container(),
              Expanded(
                  flex: pinnedItem != '' ? 4 : 5,
                  child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF333366),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                      ),
                      child: mData.length == 0
                          ? Container(
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : ListView.builder(
                              itemCount: mData.length,
                              // shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                    onTap: () {
                                      if (mData[index].downloaded) {
                                        Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                                builder: (context) =>
                                                    new PDFPage(
                                                        mData[index].localLink,
                                                        mData[index]
                                                            .downloaded)));
                                      } else {
                                        Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                                builder: (context) =>
                                                    new PDFPage(
                                                        mData[index].link,
                                                        mData[index]
                                                            .downloaded)));
                                      }
                                    },
                                    child: Container(
                                      height: 40,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            child: Text(
                                              mData[index].title,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            ),
                                          ),
                                          Divider(color: Colors.grey)
                                        ],
                                      ),
                                    )

                                    /* ListTile(
                                      title: Text(
                                        snapshot.data[index].title,
                                        style: TextStyle(color: Colors.white,fontSize: 12),
                                      ),
                                     // subtitle: Divider(color: Colors.grey),
                                    ), */
                                    );
                              })))
            ],
          ),
        ));
  }
}
