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
      child: const MaterialApp(
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
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Image(
              image: AssetImage('assets/medicLogo.jpg'),
              width: 60.0,
              height: 60.0,
            ),
              //Image.asset('assets/logo.jpg', fit: BoxFit.fitWidth), // Replace with your image path
              Text(
                'MEDIC',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                const Text(
                  'Welcome to\nMEDIC',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 20),
                const Text('Let your voice assist you...!'),
                const SizedBox(height: 20),
                const Text('Let\'s Get Started....'),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context)=>RegistrationPage()
                              ));
                        },
                        child: const Text('Register'),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context)=>LoginPage()
                            ),
                          );
                        },
                        child: const Text('Login'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                //Mic button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context)=>const VoiceLoginPage()
                            ));
                      },
                      child: const Icon(Icons.mic),
                    ),
                    const Text('Say "Hello" to start voice assistance'),
                  ],
                ),
                // Already have an account text and Login button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    const SizedBox(width: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context)=>LoginPage()
                            ));
                      },
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ],
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
