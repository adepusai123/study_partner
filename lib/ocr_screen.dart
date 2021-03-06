import 'package:flutter/material.dart';
import 'package:flutter_mobile_vision/flutter_mobile_vision.dart';

class OcrScreen extends StatefulWidget {
  const OcrScreen({
    Key key,
  }) : super(key: key);

  @override
  _OcrScreenState createState() => _OcrScreenState();
}

class _OcrScreenState extends State<OcrScreen> {
  int _ocrCamera = FlutterMobileVision.CAMERA_BACK;
  String _text = "TEXT";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('OCR'),
          centerTitle: true,
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                _text,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Center(
                child: RaisedButton(
                  onPressed: _read,
                  child: Text(
                    'Scanning',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Future<Null> _read() async {
    List<OcrText> texts = [];
    try {
      texts = await FlutterMobileVision.read(
        camera: _ocrCamera,
        waitTap: true,
      );
      setState(() {
        _text = texts[0].value;
      });
    } on Exception {
      texts.add(OcrText('Failed to recognize text'));
    }
  }
}
