import 'package:flutter/material.dart';
import 'package:medic/provider.dart';
import 'package:provider/provider.dart';
import 'registration_page.dart';
import 'voice_login_page.dart';
import 'login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserData>(create: (_) => UserData()),
        ChangeNotifierProvider<DoctorsProvider>(create: (_)=> DoctorsProvider(),),
        ChangeNotifierProvider<AppointmentsProvider>(create: (_)=> AppointmentsProvider(),),
      ],
      child: MaterialApp(
        title: "Medic",
        home: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final _questionController = TextEditingController();
  final _answerController = TextEditingController();
  final _speechToText = stt.SpeechToText();
  final _flutterTts = FlutterTts();
  bool _isSpeaking = false;
  Timer? _stopListeningTimer; // Timer to stop listening after silence
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speechToText.initialize();
    _flutterTts.setLanguage('en-US'); // Set appropriate language
  }

  @override
  void dispose() {
    _stopListeningTimer?.cancel(); // Cancel timer when leaving the page
    _speechToText.cancel();
    _flutterTts.stop();
    super.dispose();
    _pageNavigated = false;
  }

  void _startListening() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => _handleSpeechResult(val.recognizedWords),
        );
        //silence
        _stopListeningTimer = Timer(const Duration(seconds: 4), _stopListening); // Adjust the duration as needed
      }
    }
  }

  void _stopListening() async {
    _stopListeningTimer?.cancel(); // Cancel any pending timer
    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
    }
  }

  bool _pageNavigated = false;


  void _handleSpeechResult(String text) {
    // Handle voice commands here
    if (text.toLowerCase().contains('registration')) {
      _navigateToRegistration();
    } else if (text.toLowerCase().contains('login')) {
      _navigateToLogin();
    } else if (text.toLowerCase().contains('hello')) {
      _navigateToVoiceLogin();
    }
  }

  void _speakQuestion(String question) async {
    if (!_isSpeaking) {
      await _flutterTts.speak(question);
      setState(() => _isSpeaking = true);
    }
  }

  void _stopSpeaking() async {
    if (_isSpeaking) {
      await _flutterTts.stop();
      setState(() => _isSpeaking = false);
    }
  }

  void _navigateToRegistration() {
    if (!_pageNavigated) {
      _pageNavigated = true; // Set the flag

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RegistrationPage()),
      ).then((value) {
        // Reset the flag after navigation is complete
        _pageNavigated = false;
      });
    }
  }

  void _navigateToVoiceLogin() {
    if (!_pageNavigated) {
      _pageNavigated = true; // Set the flag

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => VoiceLoginPage()),
      ).then((value) {
        // Reset the flag after navigation is complete
        _pageNavigated = false;
      });
    }
  }

  void _navigateToLogin() {
    if (!_pageNavigated) {
      _pageNavigated = true; // Set the flag

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      ).then((value) {
        // Reset the flag after navigation is complete
        _pageNavigated = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bg_color.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo with rounded corners and transparency
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25.0),
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(Colors.transparent, BlendMode.multiply),
                      child: Image.asset(
                        'assets/parthaLogo.png',
                        width: 120.0,
                        height: 120.0,
                      ),
                    ),
                  ),
                  //const SizedBox(height: 10),
                  // Rest of the content...

                  // const Text(
                  //   'WELCOME TO',
                  //   //style: TextStyle(fontFamily: 'PlayfairDisplay-VariableFont_wght', fontSize: 27),
                  //   style: TextStyle(fontFamily: 'Quicksand-VariableFont_wght', fontSize: 27),
                  //   textAlign: TextAlign.center,
                  // ),
                  // const SizedBox(height: 10),
                  // const Text(
                  //   'MEDIC',
                  //   style: TextStyle(fontSize: 27, fontFamily: 'Merriweather'),
                  //   //style: TextStyle(fontFamily: 'AlfaSlabOne', fontSize: 28),
                  //   textAlign: TextAlign.center,
                  // ),
                  const SizedBox(height: 40),
                  Text(
                    'Let your voice assist you..!',
                    style: TextStyle(fontFamily: 'OldStandardTT',
                        fontSize: 15,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  const Text('Let\'s Get Started..!',
                      style: TextStyle(fontFamily: 'Merriweather-Italic', fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w300,
                      )
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context)=>LoginPage()
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15), // Adjust the value as needed
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 100), // Adjust the padding as needed
                        minimumSize: Size(200, 0), // Adjust the minimum size as needed
                      ),
                      child: Text(
                        'Login',
                          style: TextStyle(fontFamily: 'Merriweather-Italic', fontSize: 14)
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  //Mic button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 0.0), // Adjust the value as needed
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context)=>const VoiceLoginPage()
                              ),
                            );
                          },
                          child: const Icon(Icons.mic),
                        ),
                      ),
                      const Text('Say ',
                          style: TextStyle(fontFamily: 'Merriweather-Italic', fontSize: 13.5,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500)
                      ),
                      const Text('"Hello" ',
                          style: TextStyle(fontFamily: 'ProtestRiot', fontSize: 13.5,
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.w500)
                      ),
                      const Text('to start voice assistance',
                          style: TextStyle(fontFamily: 'Merriweather-Italic', fontSize: 13.5,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500)
                      ),
                    ],
                  ),

                  const SizedBox(height: 5),
                  // Already have an account text and Register button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Create new account?',
                          style: TextStyle(fontFamily: 'Merriweather-Italic', fontSize: 14,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500)
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context)=>RegistrationPage()
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15), // Adjust the radius as needed
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24), // Adjust the padding as needed
                        ),
                        child: Text(
                          'Register',
                          style: TextStyle(
                            fontFamily: 'Merriweather-Italic',
                            fontSize: 14, // Adjust the font size as needed
                          ),
                        ),
                      ),

                    ],
                  ),

                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _startListening,
          child: Icon(_isListening ? Icons.stop : Icons.mic),
        ),
      ),
    );
  }
}
