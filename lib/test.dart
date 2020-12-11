// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'dart:io' show Platform;
// import 'package:flutter/foundation.dart' show kIsWeb;

// import 'ocr_screen.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: HomeScreen(),
//     );
//   }
// }

// enum TtsState { playing, stopped, paused, continued }

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({
//     Key key,
//   }) : super(key: key);

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   FlutterTts flutterTts;
//   dynamic languages;
//   String language;
//   double volume = 0.5;
//   double pitch = 1.0;
//   double rate = 0.5;
//   bool isCurrentLanguageInstalled = false;

//   String _newVoiceText;
//   TtsState ttsState = TtsState.stopped;

//   get isPlaying => ttsState == TtsState.playing;
//   get isStopped => ttsState == TtsState.stopped;
//   get isPaused => ttsState == TtsState.paused;
//   get isContinued => ttsState == TtsState.continued;

//   bool get isIOS => !kIsWeb && Platform.isIOS;
//   bool get isAndroid => !kIsWeb && Platform.isAndroid;
//   bool get isWeb => kIsWeb;

//   @override
//   initState() {
//     super.initState();
//     initTts();
//   }

//   initTts() {
//     flutterTts = FlutterTts();

//     _getLanguages();

//     if (isAndroid) {
//       _getEngines();
//     }

//     flutterTts.setStartHandler(() {
//       setState(() {
//         print("Playing");
//         ttsState = TtsState.playing;
//       });
//     });

//     flutterTts.setCompletionHandler(() {
//       setState(() {
//         print("Complete");
//         ttsState = TtsState.stopped;
//       });
//     });

//     flutterTts.setCancelHandler(() {
//       setState(() {
//         print("Cancel");
//         ttsState = TtsState.stopped;
//       });
//     });

//     if (isWeb || isIOS) {
//       flutterTts.setPauseHandler(() {
//         setState(() {
//           print("Paused");
//           ttsState = TtsState.paused;
//         });
//       });

//       flutterTts.setContinueHandler(() {
//         setState(() {
//           print("Continued");
//           ttsState = TtsState.continued;
//         });
//       });
//     }

//     flutterTts.setErrorHandler((msg) {
//       setState(() {
//         print("error: $msg");
//         ttsState = TtsState.stopped;
//       });
//     });
//   }

//   Future _getLanguages() async {
//     languages = await flutterTts.getLanguages;
//     if (languages != null) setState(() => languages);
//   }

//   Future _getEngines() async {
//     var engines = await flutterTts.getEngines;
//     if (engines != null) {
//       for (dynamic engine in engines) {
//         print(engine);
//       }
//     }
//   }

//   Future _speak() async {
//     await flutterTts.setVolume(volume);
//     await flutterTts.setSpeechRate(rate);
//     await flutterTts.setPitch(pitch);

//     if (_newVoiceText != null) {
//       if (_newVoiceText.isNotEmpty) {
//         await flutterTts.awaitSpeakCompletion(true);
//         await flutterTts.speak(_newVoiceText);
//       }
//     }
//   }

//   Future _stop() async {
//     var result = await flutterTts.stop();
//     if (result == 1) setState(() => ttsState = TtsState.stopped);
//   }

//   Future _pause() async {
//     var result = await flutterTts.pause();
//     if (result == 1) setState(() => ttsState = TtsState.paused);
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     flutterTts.stop();
//   }

//   List<DropdownMenuItem<String>> getLanguageDropDownMenuItems() {
//     var items = List<DropdownMenuItem<String>>();
//     for (dynamic type in languages) {
//       items.add(
//           DropdownMenuItem(value: type as String, child: Text(type as String)));
//     }
//     return items;
//   }

//   void changedLanguageDropDownItem(String selectedType) {
//     print('_______ $selectedType');
//     setState(() {
//       language = selectedType;
//       flutterTts.setLanguage(language);
//       if (isAndroid) {
//         flutterTts
//             .isLanguageInstalled(language)
//             .then((value) => isCurrentLanguageInstalled = (value as bool));
//       }
//     });
//   }

//   void _onChange(String text) {
//     setState(() {
//       _newVoiceText = text;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xff514B4B),
//       ),
//       body: Container(
//         height: size.height,
//         color: Color(0xff514B4B),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               SizedBox(
//                 height: size.height * .09,
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Text(
//                     'Study Partner',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 36,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//               Container(
//                 height: size.height * 0.5,
//                 margin:
//                     EdgeInsets.only(top: 25, left: 25, right: 25, bottom: 10),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: TextField(
//                   onChanged: (String value) {
//                     _onChange(value);
//                   },
//                   decoration: InputDecoration(
//                     hintText: "Tap to Enter text or use Camera",
//                   ),
//                   maxLines: 1000,
//                 ),
//               ),
//               InkWell(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) {
//                         return OcrScreen();
//                       },
//                     ),
//                   );
//                 },
//                 child: Icon(
//                   Icons.camera,
//                   size: 36,
//                   color: Colors.white,
//                 ),
//               ),
//               languages != null ? _languageDropDownSection() : Text(""),
//               Container(
//                 height: 50,
//                 margin: EdgeInsets.all(25),
//                 decoration: BoxDecoration(
//                   color: Colors.black,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     buildAudioActions(
//                         Icons.volume_up_sharp, Colors.white, () {}),
//                     buildAudioActions(Icons.play_arrow, Colors.green, _speak),
//                     buildAudioActions(Icons.pause, Colors.yellow, _pause),
//                     buildAudioActions(Icons.stop, Colors.red, _stop),
//                   ],
//                 ),
//               ),
//               _buildSliders()
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   IconButton buildAudioActions(IconData icon, Color iColor, Function onTap) {
//     return IconButton(
//       icon: Icon(icon),
//       color: iColor,
//       iconSize: 25,
//       splashColor: Colors.green,
//       onPressed: () => onTap(),
//     );
//   }

//   Widget _languageDropDownSection() => Container(
//         padding: EdgeInsets.only(top: 50.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             DropdownButton(
//               value: language,
//               items: getLanguageDropDownMenuItems(),
//               onChanged: changedLanguageDropDownItem,
//             ),
//             Visibility(
//               visible: isAndroid,
//               child: Text("Is installed: $isCurrentLanguageInstalled"),
//             ),
//           ],
//         ),
//       );

//   Widget _buildSliders() {
//     return Column(
//       children: [_volume(), _pitch(), _rate()],
//     );
//   }

//   Widget _volume() {
//     return Slider(
//         value: volume,
//         onChanged: (newVolume) {
//           setState(() => volume = newVolume);
//         },
//         min: 0.0,
//         max: 1.0,
//         divisions: 10,
//         label: "Volume: $volume");
//   }

//   Widget _pitch() {
//     return Slider(
//       value: pitch,
//       onChanged: (newPitch) {
//         setState(() => pitch = newPitch);
//       },
//       min: 0.5,
//       max: 2.0,
//       divisions: 15,
//       label: "Pitch: $pitch",
//       activeColor: Colors.red,
//     );
//   }

//   Widget _rate() {
//     return Slider(
//       value: rate,
//       onChanged: (newRate) {
//         setState(() => rate = newRate);
//       },
//       min: 0.0,
//       max: 1.0,
//       divisions: 10,
//       label: "Rate: $rate",
//       activeColor: Colors.green,
//     );
//   }
// }
