import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MusicApp());
}

class MusicApp extends StatelessWidget {
  const MusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AudioPlayerPage(),
    );
  }
}

class AudioPlayerPage extends StatefulWidget {
  const AudioPlayerPage({super.key});

  @override
  _AudioPlayerPageState createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage> with WidgetsBindingObserver {
  final AudioPlayer soundController = AudioPlayer();
  bool isAudioPlaying = false;
  bool isFirstPlay = true; 

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      soundController.pause();
    } else if (state == AppLifecycleState.resumed && isAudioPlaying) {
      soundController.resume();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    soundController.dispose();
    super.dispose();
  }

  void _togglePlayback() async {
    if (isAudioPlaying) {
      await soundController.pause();
    } else {
      if (isFirstPlay) {
        await soundController.setSource(AssetSource("audio/I'll Make a Man Out of You.mp3"));
        isFirstPlay = false;
      }
      await soundController.resume();
    }
    setState(() {
      isAudioPlaying = !isAudioPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[900], 
      appBar: AppBar(
        title: const Text("Audio Player"),
        backgroundColor: Colors.deepPurple[900], 
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // "Now Playing" text
            const Text(
              "Now Playing",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white70,
              ),
            ),

            const SizedBox(height: 8),

            // Song Title
            const Text(
              "I'll Make A Man Out Of You",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 40),

            // Play/Pause Button
            GestureDetector(
              onTap: _togglePlayback,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.amber[600], // Different button color
                ),
                padding: const EdgeInsets.all(25),
                child: Icon(
                  isAudioPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                  size: 90,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
