import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Preliminary Medical Assessment',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyChatPage(),
    );
  }
}

class MyChatPage extends StatefulWidget {
  const MyChatPage({Key? key}) : super(key: key);

  @override
  _MyChatPageState createState() => _MyChatPageState();
}

class _MyChatPageState extends State<MyChatPage> {
  stt.SpeechToText _speech = stt.SpeechToText();
  FlutterTts flutterTts = FlutterTts();

  TextEditingController inputController = TextEditingController();
  List<ChatMessage> messages = [];
  bool isListening = false;

  Future<void> _speak(String text) async {
    await flutterTts.speak(text);
  }

  Future<void> _listen() async {
    if (await _speech.initialize()) {
      if (_speech.isAvailable) {
        setState(() {
          isListening = true;
        });
        _speech.listen(
          onResult: (result) {
            setState(() {
              //print(result.recognizedWords);
              inputController.text = result.recognizedWords;
            });
          },
          listenFor: Duration(seconds: 15),
          pauseFor: Duration(seconds: 5),  // Allow pausing after speaking
          partialResults: true,  // Show partial results as user speaks
          //onSoundLevelChange: (level) => print('Sound level: $level'),
          cancelOnError: true,  // Cancel listening on errors
          listenMode: stt.ListenMode.dictation,  // Optimize for dictation
        ).then((_) {
          setState(() {
            isListening = false;
          });
          //_addBotMessage(inputController.text);
          // Send the transcribed text only when listening is complete
          _makePrediction(inputController.text);
        });
      } else {
        print('Speech recognition not available');
      }
    } else {
      print('Speech recognition not initialized');
    }
  }

  Future<void> _makePrediction(String transcribedText) async {
    print(transcribedText);
    final String apiUrl = 'http://10.55.17.231:8000';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'sentence': transcribedText},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          String output = data['prediction'];
          String output2 = data['prediction2'];
          String output3 = data['prediction3'];
          // String desc = data['description'];
          // String speciality = data['speciality'];
          // String p1 = data['Precaution1'];
          // String p2 = data['Precaution1'];
          // String p3 = data['Precaution1'];
          // String p4 = data['Precaution1'];
          String? desc = data['description'];
          String? speciality = data['speciality'];
          String? p1 = data['precaution1'];
          String? p2 = data['precaution2'];
          String? p3 = data['precaution3'];
          String? p4 = data['precaution4'];
          String? d = data['max_c'];

          desc ??= "";
          speciality ??= "";
          p1 ??= "";
          p2 ??= "";
          p3 ??= "";
          p4 ??= "";
          d ??= "";

          messages.add(ChatMessage(
            message: transcribedText,
            type: ChatMessageType.user,
          ));
          messages.add(ChatMessage(
            message: 'Possible diseases are $output, $output2, $output3',
            type: ChatMessageType.bot,
          ));
          _speak('Possible disease are $output/$output2/$output3');
          inputController.clear(); // Clear the input after sending
          if(desc.isEmpty){
            messages.add(ChatMessage(
              message: 'Please consult a doctor, or rerun the assessment with more symptoms for suggestions!',
              type: ChatMessageType.bot,
            ));
            _speak('Please consult a doctor, or rerun the assessment with more symptoms for suggestions!');
          }
          else{
            messages.add(ChatMessage(
              message: 'Having greater chances of $d. $desc',
              type: ChatMessageType.bot,
            ));
            _speak('Having greater chances of $d. $desc');
            messages.add(ChatMessage(
              message: 'Recommended specialist: $speciality',
              type: ChatMessageType.bot,
            ));
            _speak('Recommended specialist: $speciality');
            messages.add(ChatMessage(
              message: 'Here are some precaution measures for this disease:\n1.$p1\n2.$p2\n3.$p3\n4.$p4',
              type: ChatMessageType.bot,
            ));
            _speak('Here are some precaution measures for this disease:\n1.$p1\n2.$p2\n3.$p3\n4.$p4');
          }
        });
      } else {
        print('Failed to make prediction. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    flutterTts.setLanguage("en-US");
    Future.delayed(const Duration(seconds: 1), () {
      _speak("Hi, welcome to preliminary medical assessment.");
      Future.delayed(const Duration(seconds: 5), () {
        _addBotMessage("Please describe how you are feeling today.");
      });
    });
    messages.add(ChatMessage(
      message: 'Hi, welcome to preliminary medical assessment.',
      type: ChatMessageType.bot,
    ));
  }

  void _addBotMessage(String message) {
    setState(() {
      messages.add(ChatMessage(
        message: message,
        type: ChatMessageType.bot,
      ));
      _speak(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preliminary Assessment'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ChatMessageWidget(
                    message: messages[index],
                    speak: _speak,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: inputController,
                    decoration: const InputDecoration(
                      hintText: 'Your response',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    // Initiate listening only when not already listening
                    if (!isListening) {
                      _listen();
                    }
                  },
                  icon: Icon(
                    isListening ? Icons.mic_off : Icons.mic,  // Update icon
                    color: Colors.white,
                  ),
                  label: const Text(''),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    elevation: 5,
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    _makePrediction(inputController.text); // Send text to API
                  },
                  child: const Text('Send'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String message;
  final ChatMessageType type;

  ChatMessage({required this.message, required this.type});
}

class ChatMessageWidget extends StatelessWidget {
  final ChatMessage message;
  final void Function(String) speak;

  const ChatMessageWidget({required this.message, required this.speak});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: message.type == ChatMessageType.user
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: message.type == ChatMessageType.user
              ? Colors.blue
              : Colors.green,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.message,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            if (message.type == ChatMessageType.bot)
              ElevatedButton(
                onPressed: () {
                  speak(message.message);
                },
                child: const Text('Speak'),
              ),
          ],
        ),
      ),
    );
  }
}

enum ChatMessageType {
  user,
  bot,
}