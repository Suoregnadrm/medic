import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:medic/voice_registration_page.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'registration_page.dart';
import 'login_page.dart';
import 'voice_login.dart';


class VoiceLoginPage extends StatefulWidget {
  const VoiceLoginPage({Key? key}) : super(key: key);

  @override
  State<VoiceLoginPage> createState() => _MyAppState();
}

class _MyAppState extends State<VoiceLoginPage> {
  final _speechToText = stt.SpeechToText();
  final _flutterTts = FlutterTts();
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
        // silence
        _stopListeningTimer = Timer(const Duration(seconds: 4), _stopListening);
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
    }
  }

  void _navigateToRegistration() {
    if (!_pageNavigated) {
      _pageNavigated = true; // Set the flag

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => VoiceRegistration()),
      ).then((value) {
        _pageNavigated = false;
      });
    }
  }

  void _navigateToLogin() {
    if (!_pageNavigated) {
      _pageNavigated = true; // Set the flag

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => VoiceLogin()),
      ).then((value) {
        // Reset the flag after navigation is complete
        _pageNavigated = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Select Language',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0), // Adjust margin as needed
              child: DropdownButton<String>(
                value: 'English',
                items: const [
                  DropdownMenuItem(value: 'English', child: Text('English')),
                  DropdownMenuItem(value: 'Assamese', child: Text('Assamese')),
                  DropdownMenuItem(value: 'Hindi', child: Text('Hindi')),
                ],
                onChanged: (value) {},
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                _navigateToRegistration();
              }, // Handle voice registration logic
              child: const Text('Voice Registration'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: ()  {
                _navigateToLogin();
              }, // Handle voice login logic
              child: const Text('Voice Login'),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startListening,
        child: Icon(_isListening ? Icons.stop : Icons.mic),
      ),
    );
  }
}