import 'package:flutter/material.dart';

class PinnedPage extends StatefulWidget {
  String message;
  PinnedPage(this.message);
  @override
  _PinnedPageState createState() => _PinnedPageState();
}

class _PinnedPageState extends State<PinnedPage> {
  String mMessage = '';
  @override
  void initState() {
    if (widget.message != null) {
      mMessage = widget.message;
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
          child: Text(mMessage),
        ),
      ),
    );
  }
}
