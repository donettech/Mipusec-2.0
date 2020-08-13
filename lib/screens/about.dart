import 'package:flutter/material.dart';
import 'package:mipusec2/screens/privacyPolicy.dart';

import 'package:mipusec2/utilities/clipper.dart';
import 'package:mipusec2/utils/size_config.dart';
import 'package:package_info/package_info.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String appName;
  String packageName;
  String version;
  String buildNumber;

  @override
  void initState() {
    super.initState();
    getPackage();
  }

  void getPackage() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appName = packageInfo.appName;
    packageName = packageInfo.packageName;
    version = packageInfo.version;
    buildNumber = packageInfo.buildNumber;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Stack(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(
                              flex: 1,
                              child: Stack(
                                children: <Widget>[
                                  ClipPath(
                                    clipper: BottomWaveClipper(),
                                    child: Container(
                                      color: Color(0xff3D496A),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 5,
                                    left: 0,
                                    right: 0,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      maxRadius:
                                          MediaQuery.of(context).size.width *
                                              0.12,
                                      child: Image.asset(
                                        'assets/emblem.png',
                                        color: Colors.red,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                      ),
                                    ),
                                  )
                                ],
                              )),
                          Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      child: Center(
                                        child: Text(
                                            'Mizoram Public Service Commission',
                                            style: TextStyle(
                                                fontSize:
                                                    SizeConfig.textMultiplier *
                                                        2.36,
                                                fontWeight: FontWeight.w600)),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Image.asset(
                                            'assets/web_icon.png',
                                            width: 15,
                                            height: 15,
                                          ),
                                          Text('  www.mpsc.mizoram.com'),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Icon(
                                            Icons.email,
                                            size: 15,
                                          ),
                                          Text('  mizopsc@gmail.com'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                    Positioned(
                        left: 0,
                        top: 5,
                        child: IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.pop(context))),
                  ],
                )),
            Expanded(
                flex: 1,
                child: Stack(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(
                              flex: 1,
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: <Widget>[
                                  Container(),
                                  Positioned(
                                      bottom: 25,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        child: Center(
                                          child: Card(
                                            elevation: 5,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(45)),
                                            child: Image.asset(
                                              'assets/jesda.png',
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.15,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.15,
                                            ),
                                          ),
                                        ),
                                      )),
                                  Positioned(
                                      top: 15, left: 5, child: Text('From')),
                                  Text('Jekonia Skill Development Association',
                                      style: TextStyle(
                                          fontSize:
                                              SizeConfig.textMultiplier * 2.36,
                                          fontWeight: FontWeight.w600)),
                                ],
                              )),
                          Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(),
                                    Container(),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Image.asset(
                                            'assets/web_icon.png',
                                            width: 15,
                                            height: 15,
                                          ),
                                          Text('  www.jesdamizoram.com'),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Icon(
                                            Icons.email,
                                            size: 15,
                                          ),
                                          Text('  jesdakhatlaaizawl@gmail.com'),
                                        ],
                                      ),
                                    ),
                                    Container(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        FlatButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          PrivacyPolicyPage()));
                                            },
                                            child: Text('Privacy Policy',
                                                style: TextStyle(
                                                  fontFamily: 'Segoeui',
                                                  fontSize: 15,
                                                  color: Colors.blue,
                                                ))),
                                      ],
                                    )
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    ));
  }
}
