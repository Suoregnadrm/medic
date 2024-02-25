import 'dart:async';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'firebase_function.dart';
import 'package:medic/provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice Registration',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const VoiceLogin(),
    );
  }
}

class VoiceLogin extends StatefulWidget {
  const VoiceLogin({Key? key}) : super(key: key);

  @override
  _VoiceRegistrationState createState() => _VoiceRegistrationState();
}

class _VoiceRegistrationState extends State<VoiceLogin> {
  stt.SpeechToText _speech = stt.SpeechToText();
  FlutterTts flutterTts = FlutterTts();

  TextEditingController inputController = TextEditingController();
  List<ChatMessage> messages = [];
  bool isListening = false;
  bool isVerifying = false;
  int verificationAttempts = 0;

  String verificationId = '';

  String phone = "";
  String otp = "";

  List<String> questions = [
    "What is your phone number?",
    "Please verify your OTP (Type or Speak)!",
    "Please verify your OTP (Type or Speak)!",
    "Please verify your OTP (Type or Speak)!",
  ];

  int currentQuestionIndex = 0;

  late Completer<void> _listeningCompleter;

  Future<void> _speak(String text) async {
    await flutterTts.speak(text);
  }

  Future<void> _listen() async {
    if (await _speech.initialize()) {
      if (_speech.isAvailable) {
        setState(() {
          isListening = true;
        });

        _listeningCompleter = Completer<void>();

        _speech.listen(
          onResult: (result) {
            setState(() {
              inputController.text = result.recognizedWords;
            });

          },
          listenFor: Duration(seconds: 25),
          pauseFor: Duration(seconds: 5),
          partialResults: true,
          cancelOnError: true,
          listenMode: stt.ListenMode.dictation,
        ).then((_) {
          setState(() {
            isListening = false;
          });
          _listeningCompleter.complete();
        });

        await _listeningCompleter.future;
      } else {
        print('Speech recognition not available');
      }
    } else {
      print('Speech recognition not initialized');
    }
  }

  void _handleUserResponse() async {
    messages.add(ChatMessage(
      message: inputController.text.trim(),
      type: ChatMessageType.user,
    ));

    if (currentQuestionIndex == 0) {
      phone = inputController.text.trim();
      print('Phone Number: $phone');
      inputController.clear();
      await verifyPhoneNumber(context, "+91"+phone);
      snackBar("OTP sent",context);
      isVerifying = true;
    }
    if (currentQuestionIndex == 1) {
      otp = inputController.text.trim();
      print('otp: $otp');
      inputController.clear();
    }
    if (currentQuestionIndex == 2) {
      otp = inputController.text.trim();
      print('otp: $otp');
      inputController.clear();
    }
    if (currentQuestionIndex == 3) {
      otp = inputController.text.trim();
      print('otp: $otp');
      inputController.clear();
    }

    if (currentQuestionIndex < questions.length - 1) {
      currentQuestionIndex++;
      _addBotMessage(questions[currentQuestionIndex]);
    } else {
      isVerifying = true;
    }
  }

  @override
  void initState() {
    super.initState();
    flutterTts.setLanguage("en-US");
    Future.delayed(const Duration(seconds: 1), () {
      _speak("Hi, Welcome to Voice Login");
      Future.delayed(const Duration(seconds: 5), () {
        _addBotMessage(questions[currentQuestionIndex]);
      });
    });
    messages.add(ChatMessage(
      message: 'Hi, Welcome to Voice Login',
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
    final userData = Provider.of<UserData>(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background Image Container
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg_color.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 25, left: 25, top: 50),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    color: Colors.blue,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.menu, color: Colors.white),
                          onPressed: () {
                            // Handle hamburger button press
                          },
                        ),
                        Text(
                          'Voice Login',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontFamily: 'ProtestRiot',
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.settings, color: Colors.white),
                          onPressed: () {
                            // Handle settings button press
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
                        if (!isListening) {
                          _listen();
                        }
                      },
                      icon: Icon(
                        isListening ? Icons.mic_off : Icons.mic,
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
                        print(isVerifying);
                        _handleUserResponse();
                        if(isVerifying){
                          setState(() async {
                            print("OTP is: "+otp);
                            await verifyOTPCodeForLogin(context, userData.verfID, otp);
                          });
                        }
                      },
                      child: Text(isVerifying ? 'Verify OTP' : 'Send'),
                    ),
                  ],
                ),
              ),
            ],
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
              ? Colors.green.withOpacity(0.5) // Adjust the opacity as needed (from 0.0 to 1.0)
              : Colors.purple.withOpacity(0.4),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.message,
              style: TextStyle(
                color: Colors.black87,
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

void snackBar(String text,BuildContext context){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(text)),
  );
}

enum ChatMessageType {
  user,
  bot,
}
