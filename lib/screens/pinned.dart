import 'package:flutter/material.dart';
import 'package:mipusec2/model_classes/pinned_notice_model.dart';

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
      appBar: AppBar(
        title: Text('Notification Details'),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(
                _pinnedNotice.title ?? "",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
              Container(
                margin: EdgeInsets.only(left: 3, right: 3),
                width: double.infinity,
                height: 0.5,
                color: Colors.blueGrey,
              ),
              Text(
                _pinnedNotice.contents ?? "",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
