import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:mipusec2/screens/about.dart';
import 'package:mipusec2/screens/advertisements.dart';
import 'package:mipusec2/screens/examination.dart';
import 'package:mipusec2/screens/home.dart';
import 'package:mipusec2/screens/notice.dart';
import 'package:mipusec2/screens/results.dart';
import 'package:mipusec2/screens/syllabus.dart';
import 'package:mipusec2/utils/class_builder.dart';
import 'package:mipusec2/utils/locator.dart';
import 'package:mipusec2/utils/size_config.dart';

void main() {
  setupLocator();
  ClassBuilder.registerClasses();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeConfig().init(constraints, orientation);
        return MaterialApp(
          theme: ThemeData(primarySwatch: Colors.blueGrey),
          home: MainWidget(),
          /* home: SplashScreen.navigate(
        name: 'assets/splash.flr',
        next: (context) => MainWidget(),
        until: () => Future.delayed(Duration(seconds: 3)),
        startAnimation: 'animate',
      ), */
        );
      });
    });
  }
}

class MainWidget extends StatefulWidget {
  MainWidget({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> with TickerProviderStateMixin {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  KFDrawerController _drawerController;
  @override
  void initState() {
    super.initState();
    _fcm.subscribeToTopic('News');
    _drawerController = KFDrawerController(
        initialPage: ClassBuilder.fromString('HomePage'),
        items: [
          KFDrawerItem.initWithPage(
            text: Text('Home',
                style: TextStyle(fontFamily: 'Segoeui', color: Colors.white)),
            icon: Icon(Icons.home, color: Color(0xFFFFBC9C)),
            page: HomePage(),
          ),
          KFDrawerItem.initWithPage(
            text: Text('Examination',
                style: TextStyle(fontFamily: 'Segoeui', color: Colors.white)),
            icon: Icon(Icons.border_color, color: Color(0xFFFFBC9C)),
            page: ExaminationPage(),
          ),
          KFDrawerItem.initWithPage(
            text: Text('Notice Board',
                style: TextStyle(fontFamily: 'Segoeui', color: Colors.white)),
            icon: Icon(Icons.content_paste, color: Color(0xFFFFBC9C)),
            page: NoticePage(),
          ),
          KFDrawerItem.initWithPage(
            text: Text('Results',
                style: TextStyle(fontFamily: 'Segoeui', color: Colors.white)),
            icon: Icon(Icons.import_contacts, color: Color(0xFFFFBC9C)),
            page: ResultsPage(),
          ),
          KFDrawerItem.initWithPage(
            text: Text('Syllabus',
                style: TextStyle(fontFamily: 'Segoeui', color: Colors.white)),
            icon: Icon(Icons.book, color: Color(0xFFFFBC9C)),
            page: SyllabusPage(),
          ),
          KFDrawerItem.initWithPage(
            text: Text('Advertisements',
                style: TextStyle(fontFamily: 'Segoeui', color: Colors.white)),
            icon: Icon(Icons.today, color: Color(0xFFFFBC9C)),
            page: AdvertisementPage(),
          ),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KFDrawer(
        controller: _drawerController,
        header: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            width: MediaQuery.of(context).size.width * 0.6,
            child: Image.asset(
              'assets/one.png',
              alignment: Alignment.centerLeft,
            ),
          ),
        ),
        footer: KFDrawerItem(
          text: Text(
            'About',
            style: TextStyle(fontFamily: 'Segoeui', color: Colors.white),
          ),
		  icon: Icon(Icons.info, color: Color(0xFFFFBC9C)),											   
          onPressed: () {
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => new AboutPage()));
          },
        ),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromRGBO(83, 94, 127, 1.0),
								   
                  Color.fromRGBO(83, 94, 127, 1.0)
                ],
                tileMode: TileMode.repeated)),
      ),
    );
  }
}
