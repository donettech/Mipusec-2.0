import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kf_drawer/kf_drawer.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:mipusec2/animations/FadeAnimation.dart';
import 'package:mipusec2/model_classes/notification_model.dart';
import 'package:mipusec2/model_classes/pinned_notice_model.dart';
import 'package:mipusec2/screens/pdf.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mipusec2/screens/pinned.dart';
import 'package:mipusec2/utils/size_config.dart';
import 'package:path_provider/path_provider.dart';

// ignore: must_be_immutable
class HomePage extends KFDrawerContent {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool downloading = false;
  String progressString = "";
  String directory;
  List file = new List();
  String fileName = "";
  String rootUrl = "http://mpsc.jesdamizoram.com/";
  String preConcat =
      "/storage/emulated/0/Android/data/com.example.mipusec2/files/Noticfications/";

  String pinnedItem = '';

  List<NotificationModel> mData = [];
  PinnedNotice mPinned = PinnedNotice();
  double screenW = 0;
  double screenH = 0;

  Future<List<NotificationModel>> getData() async {
    var response = await http.get(
        "http://mpsc.jesdamizoram.com/HeroApi/v1/Api.php?apicall=getnotification");
    String _body = response.body.toString();
    var mdata = json.decode(_body);
    var notifications = mdata['notification'];
    for (var u in notifications) {
      NotificationModel notiItem = NotificationModel(
          u['id'].toString(), u['title'], u['content'], u['link'], false);
      mData.add(notiItem);
    }
    _listofFiles();
    return mData;
  }

  void getPinnedNotice() async {
    var response = await http.get(
        "http://mpsc.jesdamizoram.com/HeroApi/v1/Api.php?apicall=getpinnednotification");
    var mdata = json.decode(response.body);
    var notifications = mdata['notification'];
    try {
      mPinned = PinnedNotice(
          id: notifications[0]['id'],
          title: notifications[0]['title'],
          contents: notifications[0]['contents']);
      setState(() {
        pinnedItem = mPinned.title;
      });
    } catch (e) {
      print('Error reading pinned notice: $e');
    }
  }

  @override
  void initState() {
    // getData();
    getPinnedNotice();
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

  compare() async {
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
    screenH = SizeConfig.screenHeight;
    screenW = SizeConfig.screenWidth;
    return SafeArea(
      child: Scaffold(
          backgroundColor: Color(0xff3D496A),
          // Color(0xff3c466a),
          body: Container(
            child: Column(
              children: <Widget>[
                Expanded(flex: 4, child: mainTopWidget2()),
                pinnedItem != ''
                    ? Expanded(
                        flex: pinnedItem != '' ? 1 : 0,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 5, 3, 5),
                          child: Container(
                            decoration: pinnedItem != ''
                                ? BoxDecoration(
                                    color: Colors.blue[800],
                                    gradient: LinearGradient(colors: [
                                      Color(0x3894affc),
                                      const Color(0x383d3f72)
                                    ]),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        topRight: Radius.circular(5),
                                        bottomLeft: Radius.circular(5),
                                        bottomRight: Radius.circular(5)),
                                  )
                                : BoxDecoration(),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 2,
                                  color: Color(0xFFde69b8),
                                  height: double.infinity,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (context) =>
                                                      new PinnedPage(mPinned)));
                                        },
                                        child: Container(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5, right: 8),
                                            child: Text(
                                              pinnedItem,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                    SizeConfig.textMultiplier *
                                                        2.53,
                                              ),
                                              maxLines: 2,
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
                              ],
                            ),
                          ),
                        ))
                    : Container(
                        padding: EdgeInsets.only(top: 10),
                      ),
                Expanded(
                  flex: pinnedItem != '' ? 4 : 5,
                  child: Container(
                      padding: EdgeInsets.only(top: 5),
                      margin: EdgeInsets.only(left: 8, right: 5, bottom: 5),
                      decoration: BoxDecoration(
                        // color: Color(0xFF333366),
                        gradient: LinearGradient(colors: [
                          Color(0xFF535E7F),
                          //Color(0xff535e7f)
                          Color(0xff3c466a),
                        ]),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                      ),
                      /* child: mData.length == 0
                        ? Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        :  */
                      child: FutureBuilder(
                          future: getData(),
                          builder: (context, snap) {
                            if (snap.hasData) {
                              return ListView.builder(
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
                                          Row(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 7, right: 5),
                                                child: Icon(
                                                  Icons.picture_as_pdf,
                                                  color: Color(0xFFF686B5),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5),
                                                  child: Text(
                                                    mData[index].title,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: SizeConfig
                                                              .textMultiplier *
                                                          2.53,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 3, right: 3),
                                            child: Divider(
                                                color: Colors.deepOrange
                                                    .withOpacity(.5)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else if (snap.hasError) {
                              return Container(
                                child: Center(
                                  child: Text('Error please try again later'),
                                ),
                              );
                            }
                            return Container(
                              child: Center(
                                  child: LoadingJumpingLine.square(
                                size: 20,
                                backgroundColor: Colors.white,
                                borderColor: Colors.white,
                              )),
                            );
                          })),
                ),
              ],
            ),
          )),
    );
  }

  Widget mipusecLong() {
    return FadeAnimation(
        1.8,
        Container(
          child: Center(
              child: RichText(
            text: new TextSpan(
              // Note: Styles for TextSpans must be explicitly defined.
              // Child text spans will inherit styles from parent
              style: new TextStyle(
                fontSize: SizeConfig.textMultiplier * 3.37,
                color: Colors.black,
              ),
              children: <TextSpan>[
                new TextSpan(
                    text: 'M',
                    style: TextStyle(
                        fontFamily: 'Segoe',
                        fontSize: SizeConfig.textMultiplier * 3.37,
                        color: Colors.white)),
                new TextSpan(
                    text: 'izoram ',
                    style: GoogleFonts.ebGaramond(
                        textStyle: TextStyle(
                            fontSize: SizeConfig.textMultiplier * 3.37,
                            color: Colors.white))),
                new TextSpan(
                    text: 'P',
                    style: TextStyle(
                        fontFamily: 'Segoe',
                        fontSize: SizeConfig.textMultiplier * 3.37,
                        color: Colors.white)),
                new TextSpan(
                    text: 'ublic ',
                    style: GoogleFonts.ebGaramond(
                        textStyle: TextStyle(
                            fontSize: SizeConfig.textMultiplier * 3.37,
                            color: Colors.white))),
                new TextSpan(
                    text: 'S',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Segoe',
                      fontSize: SizeConfig.textMultiplier * 3.37,
                    )),
                new TextSpan(
                    text: 'ervice ',
                    style: GoogleFonts.ebGaramond(
                        textStyle: TextStyle(
                            fontSize: SizeConfig.textMultiplier * 3.37,
                            color: Colors.white))),
                new TextSpan(
                    text: 'C',
                    style: TextStyle(
                        fontFamily: 'Segoe',
                        fontSize: SizeConfig.textMultiplier * 3.37,
                        color: Colors.white)),
                new TextSpan(
                  text: 'ommission ',
                  style: GoogleFonts.ebGaramond(
                    textStyle: TextStyle(
                        fontSize: SizeConfig.textMultiplier * 3.37,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          )),
        ));
  }

  Widget mainTopWidget2() {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 00),
          margin: EdgeInsets.fromLTRB(10, 50, 10, 10),
          width: screenW,
          height: screenH - (screenH * 0.4 + 56),
          decoration: BoxDecoration(
              image: DecorationImage(
                  alignment: Alignment.center,
                  image: AssetImage('assets/background2.png'),
                  fit: BoxFit.fill)),
        ),
        Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/mpsc_icon_round.png',
                  height: screenW * 0.18,
                  width: screenW * 0.18,
                ),
                FadeAnimation(
                    1.5,
                    Container(
                      child: Center(
                        child: Text(
                          "MIPUSEC",
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: SizeConfig.textMultiplier * 4.05,
                                  fontWeight: FontWeight.normal)),
                        ),
                      ),
                    )),
                mipusecLong()
              ],
            )),
        Positioned(
            left: 5,
            top: 5,
            child: IconButton(
                icon: Icon(
                  Icons.menu,
                  size: 20,
                ),
                color: Colors.white,
                onPressed: widget.onMenuPressed)),
      ],
    );
  }
}
