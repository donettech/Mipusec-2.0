import 'package:easy_web_view/easy_web_view.dart';
import 'package:flutter/material.dart';
import 'package:mipusec2/model_classes/pinned_notice_model.dart';
import 'package:mipusec2/utils/size_config.dart';

class PinnedPage extends StatefulWidget {
  final PinnedNotice _notice;
  PinnedPage(this._notice);
  @override
  _PinnedPageState createState() => _PinnedPageState();
}

class _PinnedPageState extends State<PinnedPage> {
  PinnedNotice _pinnedNotice;
  @override
  void initState() {
    if (widget._notice != null) {
      _pinnedNotice = widget._notice;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff3D496A),
      appBar: AppBar(
        title: Text('Notice'),
        backgroundColor: Color.fromRGBO(83, 94, 127, 1.0),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              Text(
                _pinnedNotice.title ?? "",
                style: TextStyle(
                    fontFamily: 'Segoeui',
                    color: Colors.white,
                    fontSize: SizeConfig.textMultiplier * 2.6,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.only(left: 3, right: 3, bottom: 17),
                width: double.infinity,
                height: 1.9,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color.fromRGBO(252, 205, 174, 1.0),
                    Color.fromRGBO(252, 100, 161, 1.0)
                  ],
                )),
              ),
              Expanded(
                child: EasyWebView(
                  src: _pinnedNotice.contents,
                  isHtml: true,
                  onLoaded: () {},
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
