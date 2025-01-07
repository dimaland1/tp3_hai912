import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SoundService {
  static final player = AudioPlayer();

  static Future<void> playSound(bool isVictory) async {
    try {
      final ref = FirebaseStorage.instance.ref().child(
          'sounds/${isVictory ? 'victory.mp3' : 'defeat.mp3'}'
      );
      final url = await ref.getDownloadURL();
      await player.play(UrlSource(url));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }
}