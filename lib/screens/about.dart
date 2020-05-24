import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/rendering.dart';

class InfoModel {
  int id;
  String title;
  String content;
  InfoModel(this.id, this.title, this.content);
}

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String url =
      "http://mpsc.jesdamizoram.com/HeroApi/v1/Api.php?apicall=getmenuhome";

  List<InfoModel> mInfoList = [];
  bool isLoading = true;

  getInfo() async {
    List<InfoModel> mInfo = [];
    var response = await http.get(url);
    var mdata = json.decode(response.body);
    var menuresult = mdata['menuhome'];
    for (var u in menuresult) {
      InfoModel menuresultItem = InfoModel(u['id'], u['title'], u['content']);
      mInfo.add(menuresultItem);
    }
    return mInfo;
  }

  Future<void> callData() async {
    var eInfo = await getInfo();
    setState(() {
      mInfoList = eInfo;
      print(mInfoList[0].content);
    });

    isLoading = !isLoading;
  }

  @override
  void initState() {
    super.initState();
    callData();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            color: Color(0xFF7A9BEE),
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
            ),
          )
        : Container(
            color: Color(0xFF333366),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  backgroundColor: Color(0xFF333366),
                  iconTheme: IconThemeData(color: Colors.white),
                  /*  title: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: 'Welcome ',
                        style:
                            TextStyle(color: Color(0xFF333366), fontSize: 20),
                      ),
                      /* TextSpan(text: "\n"),
                      TextSpan(
                        text: 'to',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      TextSpan(text: "\n"),
                      TextSpan(
                        text: 'Mizoram Public Service Commission ',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ) */
                    ]),
                    textAlign: TextAlign.center,
                  ), */
                  centerTitle: true,
                  expandedHeight: 200,
                  floating: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: _expandedImage(),
                  ),
                ),
                SliverPadding(padding: EdgeInsets.all(5)),
                SliverKh(
                  child: Material(
                    color: Color(0xFF333366),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        //color: Color(0xFF7A9BEE),
                        decoration: BoxDecoration(
                            color: Color(0xFF7A9BEE),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(mInfoList[0].content,
                              textAlign: TextAlign.justify,
                              style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                      fontSize: 16, color: Colors.black))),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
  }

  Widget _expandedImage() {
    return Image.asset('assets/offceThree.png');
  }
}

class SliverKh extends SingleChildRenderObjectWidget {
  SliverKh({Widget child, Key key}) : super(child: child, key: key);
  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderSliverKh();
  }
}

class RenderSliverKh extends RenderSliverSingleBoxAdapter {
  RenderSliverKh({
    RenderBox child,
  }) : super(child: child);
  @override
  void performLayout() {
    if (child == null) {
      geometry = SliverGeometry.zero;
      return;
    }
    child.layout(constraints.asBoxConstraints(), parentUsesSize: true);
    double childExtent;
    switch (constraints.axis) {
      case Axis.horizontal:
        childExtent = child.size.width;
        break;
      case Axis.vertical:
        childExtent = child.size.height;
        break;
    }
    assert(childExtent != null);
    final double paintedChildSize =
        calculatePaintOffset(constraints, from: 0.0, to: childExtent);
    final double cacheExtent =
        calculateCacheOffset(constraints, from: 0.0, to: childExtent);

    assert(paintedChildSize.isFinite);
    assert(paintedChildSize >= 0.0);
    geometry = SliverGeometry(
      scrollExtent: childExtent,
      paintExtent: paintedChildSize,
      cacheExtent: cacheExtent,
      maxPaintExtent: childExtent,
      hitTestExtent: paintedChildSize,
      hasVisualOverflow: childExtent > constraints.remainingPaintExtent ||
          constraints.scrollOffset > 0.0,
    );
    setChildParentData(child, constraints, geometry);
  }
}
