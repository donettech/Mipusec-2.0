import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';

String preLink = "http://mpsc.jesdamizoram.com/";

class PDFPage extends StatefulWidget {
  final String link;
  final bool downloaded;
  const PDFPage(this.link, this.downloaded);
  @override
  _PDFPageState createState() => _PDFPageState();
}

class _PDFPageState extends State<PDFPage> {
  bool _isLoading = true;
  PDFDocument document;

  @override
  void initState() {
    super.initState();
    loadDocument();
  }

  loadDocument() async {
    try {
      if (widget.downloaded) {
        File file = File(widget.link);
        document = await PDFDocument.fromFile(file);
        print('Opening PDF from file');
      } else {
        document = await PDFDocument.fromURL(preLink + widget.link);
        print('Opening PDF from net');
      }
    } catch (e) {
      print('Error opening pdf: $e');
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF333366),
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            Center(
                child: _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : PDFViewer(
                        document: document,
                        showPicker: false,
                        showNavigation: false,
                      )),
          ],
        ),
      ),
    );
  }
}
