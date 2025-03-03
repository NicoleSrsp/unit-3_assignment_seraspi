import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'lifecycle_handler.dart';

class PlayMusic extends StatefulWidget {
  const PlayMusic({super.key});

  @override
  PlayState createState() => PlayState();
}

class PlayState extends State<PlayMusic> with WidgetsBindingObserver {
  final AudioPlayer musicPlayer = AudioPlayer();
  final TextEditingController urlController = TextEditingController(
    text: "https://files.freemusicarchive.org/storage-freemusicarchive-org/music/ccCommunity/Jahzzar/Tumbling_Dishes_Like_Old-Mans_Wishes/Jahzzar_-_05_-_Siesta.mp3", // Default MP3
  );
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    handleAppLifecycle(state, musicPlayer, isPlaying);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    musicPlayer.dispose();
    super.dispose();
  }

 void _toggleButton() async {
  String url = urlController.text.trim();

  if (url.isEmpty || !url.endsWith(".mp3")) {
    print("Invalid MP3 URL");
    return;
  }

  if (isPlaying) {
    await musicPlayer.pause();
  } else {
    try {
      await musicPlayer.stop();
      
      // Use setSourceUrl() properly
      await musicPlayer.setSourceUrl(url);
      await musicPlayer.resume();
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  setState(() {
    isPlaying = !isPlaying;
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Simple Music Player"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: urlController,
              decoration: const InputDecoration(
                labelText: "Enter MP3 URL",
                hintText: "https://example.com/song.mp3",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              isPlaying ? "Pause" : "Play",
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _toggleButton,
              child: Container(
                padding: const EdgeInsets.all(30),
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: Icon(
                  isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                  size: 100,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
