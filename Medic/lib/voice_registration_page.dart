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
      routes: {
        '/voice_registration': (context) => VoiceRegistration(),
        // other routes...
      },
      title: 'Voice Registration',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const VoiceRegistration(),
    );
  }
}

class VoiceRegistration extends StatefulWidget {
  const VoiceRegistration({Key? key}) : super(key: key);

  @override
  _VoiceRegistrationState createState() => _VoiceRegistrationState();
}

class _VoiceRegistrationState extends State<VoiceRegistration> {
  stt.SpeechToText _speech = stt.SpeechToText();
  FlutterTts flutterTts = FlutterTts();

  TextEditingController inputController = TextEditingController();
  List<ChatMessage> messages = [];
  bool isListening = false;
  bool isVerifying = false;
  int verificationAttempts = 0;

  // TextEditingController nameController = TextEditingController();
  // TextEditingController ageController = TextEditingController();
  // TextEditingController emailController = TextEditingController();
  // TextEditingController phoneNumberController = TextEditingController();
  // TextEditingController otpController = TextEditingController();
  String verificationId = '';

  String name = "";
  String age = "";
  String gender = "";
  String phone = "";
  String otp = "";

  List<String> questions = [
    "What is your name?",
    "What is your age?",
    "What is your gender (M/F)?",
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

            // Update variables based on user responses to specific questions
            //_updateVariables(result.recognizedWords);
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

          // Complete the listening completer to signal the end of listening
          _listeningCompleter.complete();
        });

        // Wait for the user to complete their response before proceeding
        await _listeningCompleter.future;
      } else {
        print('Speech recognition not available');
      }
    } else {
      print('Speech recognition not initialized');
    }
  }

  // void _updateVariables(String response) {
  //   // Check for keywords in the response and update corresponding variables
  //   if (currentQuestionIndex == 0) {
  //     name = inputController.text.trim();
  //     print('Name: $name');
  //   }
  //   if (currentQuestionIndex == 1) {
  //     age = inputController.text.trim();
  //     print('Age: $age');
  //   }
  //   if (currentQuestionIndex == 2) {
  //     gender = inputController.text.trim();
  //     print('Gender: $gender');
  //   }
  //   if (currentQuestionIndex == 3) {
  //     phone = inputController.text.trim();
  //     print('Phone Number: $phone');
  //   }
  // }

  void _handleUserResponse() async {
    // Perform any additional logic or validations after the user has responded
    // This is the place where you can use the collected variables (name, age, gender, phone)
    messages.add(ChatMessage(
      message: inputController.text.trim(),
      type: ChatMessageType.user,
    ));

    if (currentQuestionIndex == 0) {
      name = inputController.text.trim();
      print('Name: $name');
      inputController.clear();
    }
    if (currentQuestionIndex == 1) {
      age = inputController.text.trim();
      print('Age: $age');
      inputController.clear();
    }
    if (currentQuestionIndex == 2) {
      gender = inputController.text.trim();
      print('Gender: $gender');
      inputController.clear();
    }
    if (currentQuestionIndex == 3) {
      phone = inputController.text.trim();
      print('Phone Number: $phone');
      inputController.clear();
      await verifyPhoneNumber(context, "+91"+phone);
      snackBar("Otp sent",context);
      isVerifying = true;
    }
    if (currentQuestionIndex == 4) {
      otp = inputController.text.trim();
      print('otp: $otp');
      inputController.clear();
    }
    if (currentQuestionIndex == 5) {
      otp = inputController.text.trim();
      print('otp: $otp');
      inputController.clear();
    }
    if (currentQuestionIndex == 6) {
      otp = inputController.text.trim();
      print('otp: $otp');
      inputController.clear();
    }
    // Ask the next question or finish the conversation
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
      _speak("Hi, Welcome to Voice Registration");
      Future.delayed(const Duration(seconds: 5), () {
        _addBotMessage(questions[currentQuestionIndex]);
      });
    });
    messages.add(ChatMessage(
      message: 'Hi, Welcome to Voice Registration',
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
      appBar: AppBar(
        title: const Text('Voice Registration'),
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
                        userData.setUserName(name);
                        userData.setAge(age);
                        userData.setGender(gender);
                        //userData.setEmail(emailController.text);
                        userData.setPhoneNumber(phone);
                        userData.setType("Patient");
                        //userData.setDoctorType(_doctorType!);
                        await verifyOTPCodeForRegistration(context, userData.verfID, otp);
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
void snackBar(String text,BuildContext context){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(text)),
  );
}

enum ChatMessageType {
  user,
  bot,
}
