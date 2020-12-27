import 'package:flutter/material.dart';
import 'package:study_partner/speech_controller.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
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
  void initState(){
    super.initState();
    DefaultCacheManager().emptyCache();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title:Text("Study Partner",style:TextStyle(color:Colors.black)),
        centerTitle:true
      ),
      body: Container(
        height: size.height,
        color: Color(0xffF6F6F6),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal:5, vertical:15),
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
