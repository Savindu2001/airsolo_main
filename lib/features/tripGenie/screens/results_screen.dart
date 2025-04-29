import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:iconsax/iconsax.dart';



class ResultsScreen extends StatefulWidget {
  final String title;
  final String content;

  const ResultsScreen({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  late FlutterTts flutterTts;
  bool isSpeaking = false;
  bool ttsAvailable = false;

  @override
  void initState() {
    super.initState();
    initTts();
  }

  Future<void> initTts() async {
    flutterTts = FlutterTts();
    
    try {
      // First check if TTS is available
      var languages = await flutterTts.getLanguages;
      ttsAvailable = languages != null && languages.isNotEmpty;
      
      if (ttsAvailable) {
        await flutterTts.awaitSpeakCompletion(true);
        await flutterTts.setLanguage("en-US");
        await flutterTts.setSpeechRate(0.5);
        await flutterTts.setVolume(1.0);
        await flutterTts.setPitch(1.0);
        debugPrint("TTS initialized successfully");
      }
    } catch (e) {
      debugPrint("TTS initialization error: $e");
      ttsAvailable = false;
    }
  }

  Future<void> _speak() async {
    if (!ttsAvailable) {
      
      ALoaders.warningSnackBar(title:'Oh no', message: 'Text-to-speech not available in this device');
      return;
    }

    try {
      if (isSpeaking) {
        await flutterTts.stop();
        setState(() => isSpeaking = false);
      } else {
        setState(() => isSpeaking = true);
        await flutterTts.speak(_cleanContent(widget.content));
      }
    } catch (e) {
      debugPrint("TTS error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Speech error: ${e.toString()}")),
      );
      setState(() => isSpeaking = false);
    }
  }

  String _cleanContent(String content) {
    return content
        .replaceAll('*', '')
        .replaceAll('#', '')
        .replaceAll(RegExp(r'-{3,}'), '\n\n');
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: isSpeaking ? const Icon(Iconsax.pause) : const Icon(Iconsax.play),
            onPressed: _speak,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Trip Genie Results',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    MarkdownBody(
                      data: widget.content,
                      styleSheet: MarkdownStyleSheet(
                        p: const TextStyle(fontSize: 16, height: 1.5),
                        h1: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        h2: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        listIndent: 24.0,
                        listBullet: const TextStyle(
                          fontSize: 16,
                          height: 1.5,
                        ),
                        em: const TextStyle(fontStyle: FontStyle.italic),
                        strong: const TextStyle(fontWeight: FontWeight.bold),
                        blockquote: TextStyle(
                          color: Colors.grey[700],
                          fontStyle: FontStyle.italic,
                        ),
                        horizontalRuleDecoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Iconsax.save_2, size: 20),
                label: const Text('Save to My Trips'),
                onPressed: () {
                  // Implement save functionality
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(
                  isSpeaking ? Iconsax.pause : Iconsax.voice_cricle,
                  size: 20,
                  color: isSpeaking ? Colors.red : null,
                ),
                label: Text(
                  isSpeaking ? 'Pause' : 'Listen With Voice TripGenie',
                ),
                onPressed: _speak,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}