import 'package:flutter/material.dart';
import 'package:study_partner/speech_controller.dart';
// import 'ocr_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key key,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String textValue;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff514B4B),
      ),
      body: Container(
        height: size.height,
        color: Color(0xff514B4B),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height * .09,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Study Partner',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Container(
              //   height: size.height * 0.5,
              //   margin:
              //       EdgeInsets.only(top: 25, left: 25, right: 25, bottom: 10),
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(8),
              //   ),
              //   child: TextField(
              //     onChanged: (String value) {
              //       _onChange(value);
              //     },
              //     decoration: InputDecoration(
              //       hintText: "Tap to Enter text or use Camera",
              //     ),
              //     maxLines: 1000,
              //   ),
              // ),
              // InkWell(
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) {
              //           // return Container();
              //           return OcrScreen();
              //         },
              //       ),
              //     );
              //   },
              //   child: Icon(
              //     Icons.camera,
              //     size: 36,
              //     color: Colors.white,
              //   ),
              // ),
              Container(
                margin: EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SpeechController(text: textValue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
