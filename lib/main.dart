import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:just_audio/just_audio.dart';


void main() {
  runApp(const HalloweenGame());
}

class HalloweenGame extends StatefulWidget {
  const HalloweenGame({super.key});

  @override
  _HalloweenGameState createState() => _HalloweenGameState();
}

class _HalloweenGameState extends State<HalloweenGame> {
  late AudioPlayer backgroundPlayer;
  Random random = Random();

  
  double pumpkinTop = 0;
  double pumpkinLeft = 0;
  double ghostTop = 0;
  double ghostLeft = 0;

  @override
  void initState() {
    super.initState();
    
   
    backgroundPlayer = AudioPlayer();

    
    _playBackgroundMusic();

    
    Timer.periodic(Duration(seconds: 1), (Timer timer) {
      _moveSpookyObjects();
    });
  }

  Future<void> _playBackgroundMusic() async {
    try {
      await backgroundPlayer.setAsset('assets/sounds/spooky_music.mp3');
      backgroundPlayer.setVolume(0.5);
      backgroundPlayer.play();
    } catch (e) {
      print("Error playing background music: $e");
    }
  }

  @override
  void dispose() {
    backgroundPlayer.dispose();
    super.dispose();
  }

  
  void _moveSpookyObjects() {
    setState(() {
      
      pumpkinTop = random.nextDouble() * (MediaQuery.of(context).size.height - 100);
      pumpkinLeft = random.nextDouble() * (MediaQuery.of(context).size.width - 100);
      
      ghostTop = random.nextDouble() * (MediaQuery.of(context).size.height - 100);
      ghostLeft = random.nextDouble() * (MediaQuery.of(context).size.width - 100);
    });
  }

  void _onItemTap(bool isTrap) async {
    final player = AudioPlayer();
    if (isTrap) {
      await player.setAsset('assets/sounds/jumpscare.mp3');
    } else {
      await player.setAsset('assets/sounds/success.mp3');
      
    }
    player.play();
  }

  void _showWinMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('You Found It!'),
          content: const Text('Happy Halloween!'),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Halloween Hunt Game'),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.png'), 
              fit: BoxFit.cover, 
            ),
          ),
          child: Stack(
            children: [
              
              AnimatedPositioned(
                duration: Duration(seconds: 1),
                top: pumpkinTop,
                left: pumpkinLeft,
                child: GestureDetector(
                  onTap: () => _onItemTap(false), 
                  child: Image.asset('assets/pumpkin.png', width: 80, height: 80),
                ),
              ),
              
              AnimatedPositioned(
                duration: Duration(seconds: 1),
                top: ghostTop,
                left: ghostLeft,
                child: GestureDetector(
                  onTap: () => _onItemTap(true), 
                  child: Image.asset('assets/ghost.png', width: 80, height: 80),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
