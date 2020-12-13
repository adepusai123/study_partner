import 'package:flutter/material.dart';
import 'package:flutter_mobile_vision/flutter_mobile_vision.dart';
import 'package:flutter_tts/flutter_tts.dart';

enum TtsState { playing, stopped, paused, continued }

class SpeechController extends StatefulWidget {
  final String text;
  SpeechController({
    Key key,
    @required this.text,
  }) : super(key: key);
  @override
  _SpeechControllerState createState() => _SpeechControllerState();
}

class _SpeechControllerState extends State<SpeechController> {
  int _ocrCamera = FlutterMobileVision.CAMERA_BACK;

  FlutterTts flutterTts;
  dynamic languages;
  String language;
  double volume = 1.0; // max 1.0
  double pitch = 1.0; // max 2.0
  double rate = 0.5; // max 1.0
  String textValue;
  TtsState ttsState = TtsState.stopped;

  bool volumeSlider = false;
  bool pitchSlider = false;
  bool rateSlider = false;
  bool showEqualize = false;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isPaused => ttsState == TtsState.paused;
  get isContinued => ttsState == TtsState.continued;

  @override
  void initState() {
    super.initState();
    volume = 1.0; // max 1.0
    pitch = 1.0; // max 2.0
    rate = 0.8; //
    initTts();
  }

  initTts() {
    flutterTts = FlutterTts();
    _getLanguages();
    setState(() {
      language = "en-IN";
      flutterTts.setLanguage(language);
    });
    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        print("Cancel");
        ttsState = TtsState.stopped;
      });
    });

    // pause code not handled here
    flutterTts.setErrorHandler((message) {
      setState(() {
        print("Error : $message");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future _getLanguages() async {
    languages = await flutterTts.getLanguages;
    if (languages != null) setState(() => languages);
  }

  Future _speak() async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);
    if (textValue != null) {
      if (textValue.isNotEmpty) {
        await flutterTts.awaitSpeakCompletion(true);
        await flutterTts.speak(textValue);
      }
    }
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1)
      setState(() {
        ttsState = TtsState.stopped;
      });
  }

  // Future _pause() async {
  //   var result = await flutterTts.pause();
  //   if (result == 1)
  //     setState(() {
  //       ttsState = TtsState.paused;
  //     });
  // }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  TextEditingController _controller = new TextEditingController();

  Future<Null> _read() async {
    List<OcrText> texts = [];
    try {
      texts = await FlutterMobileVision.read(
        camera: _ocrCamera,
        waitTap: true,
      );
      setState(() {
        _controller.text = '';
        for (int i = 0; i < texts.length; i++) {
          _controller.text += texts[i].value;
        }
      });
    } on Exception {
      texts.add(OcrText('Failed to recognize text'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => _read(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.camera,
                  color: Colors.white,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  _controller.clear();
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.clear,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
        Container(
          height: 300,
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: "Enter text here",
              border: InputBorder.none,
              filled: true,
            ),
            maxLines: 1000,
            onChanged: (String value) {
              textValue = value;
            },
          ),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            isPlaying
                ? buildAudioActions(Icons.stop, Colors.red, _stop)
                : buildAudioActions(Icons.play_arrow, Colors.green, _speak),
            buildAudioActions(
                Icons.equalizer, showEqualize ? Colors.yellow : Colors.white,
                () {
              setState(() {
                showEqualize = !showEqualize;
              });
            }),
          ],
        ),
        showEqualize
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, top: 8, bottom: 10),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              volumeSlider = !volumeSlider;
                            });
                          },
                          child: Icon(
                            Icons.volume_up,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      volumeSlider
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 4,
                              ),
                              child: Slider(
                                value: volume,
                                onChanged: (newVolume) {
                                  setState(() => volume = newVolume);
                                },
                                min: 0.0,
                                max: 1.0,
                                divisions: 10,
                                label: "Volume: $volume",
                              ),
                            )
                          : Text(""),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, top: 8, bottom: 10),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              pitchSlider = !pitchSlider;
                            });
                          },
                          child: Icon(
                            Icons.speed,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      pitchSlider
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 4,
                              ),
                              child: Slider(
                                value: pitch,
                                onChanged: (val) {
                                  setState(() => pitch = val);
                                },
                                min: 0.0,
                                max: 2.0,
                                divisions: 10,
                                label: "Pitch: $pitch",
                              ),
                            )
                          : Text("")
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, top: 8, bottom: 10),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              rateSlider = !rateSlider;
                            });
                          },
                          child: Icon(
                            Icons.call_made,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      rateSlider
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 4,
                              ),
                              child: Slider(
                                value: rate,
                                onChanged: (val) {
                                  setState(() {
                                    rate = val;
                                  });
                                },
                                min: 0.0,
                                max: 1.0,
                                divisions: 10,
                                label: "Rate: $rate",
                              ),
                            )
                          : Text("")
                    ],
                  )
                ],
              )
            : SizedBox(
                height: 10,
              ),
      ],
    );
  }

  IconButton buildAudioActions(IconData icon, Color iColor, Function onTap) {
    return IconButton(
      icon: Icon(icon),
      color: iColor,
      iconSize: 25,
      splashColor: Colors.green,
      onPressed: () => onTap(),
    );
  }
}
