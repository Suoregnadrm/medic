/*import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class VoiceLoginPage extends StatefulWidget {
  const VoiceLoginPage({Key? key}) : super(key: key);

  @override
  State<VoiceLoginPage> createState() => _VoiceLoginPageState();
}

class _VoiceLoginPageState extends State<VoiceLoginPage> {
  SpeechToText speechToText = SpeechToText();
  bool isListening = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image(
              image: AssetImage('assets/logo.jpg'),
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
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        margin: const EdgeInsets.only(bottom: 150),
        child: const Text(
          'text',
          style: TextStyle(
            fontSize: 24,
            color: Colors.black54,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: const AvatarGlow(
        animate: isListening,
        duration: Duration(milliseconds: 2000),
        glowColor: Colors.grey,
        repeat: true,
        //repeatPauseDuration: Duration(milliseconds: 100),
        //showTwoGlows: true,
        child: GestureDetector(
          onTapDown: (details) async {
            if(isListening){
              var available = await speechToText.initialize();
              if(available){
                setState((){
                  isListening = true;
                  speechToText.listen(
                    onResult: (result){
                      setState((){
                        var text = result.recognizedWords;
                      });
                    },

                  );
                });
              }
            }
          },
          onTapUp: (details){
            setState((){
              isListening = false;
            });
            speechToText.stop();
          },
          child: CircleAvatar(
            backgroundColor: Colors.blueGrey,
            radius: 35,
            child: Icon(
              Icons.mic,
              color: Colors.white,
              ),
            ),
          ),
        ),
    );
  }
}
*/



import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class VoiceLoginPage extends StatefulWidget {
  const VoiceLoginPage({Key? key}) : super(key: key);

  @override
  State<VoiceLoginPage> createState() => _VoiceLoginPageState();
}

class _VoiceLoginPageState extends State<VoiceLoginPage> {
  SpeechToText speechToText = SpeechToText();
  bool isListening = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row( // Removed const for Row
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/logo.jpg', width: 60.0, height: 60.0), // Corrected image usage
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
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        margin: const EdgeInsets.only(bottom: 150),
        child: const Text(
          'text',
          style: TextStyle(
            fontSize: 24,
            color: Colors.black54,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: isListening, // Removed const for AvatarGlow
        duration: const Duration(milliseconds: 2000), // Added const for Duration
        glowColor: Colors.grey,
        repeat: true,
        child: GestureDetector(
          onTapDown: (details) async {
            if(isListening){
              var available = await speechToText.initialize();
              if(available){
                setState((){
                  isListening = true;
                  speechToText.listen(
                    onResult: (result){
                      setState((){
                        var text = result.recognizedWords;
                      });
                    },

                  );
                });
              }
            }
          },
          onTapUp: (details){
            setState((){
              isListening = false;
            });
            speechToText.stop();
          },
          child: CircleAvatar(
            backgroundColor: Colors.blueGrey,
            radius: 35,
            child: Icon(
              Icons.mic,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
