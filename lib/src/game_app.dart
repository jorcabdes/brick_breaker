import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'brick_breaker.dart';
import 'config.dart';
import 'overlay_screen.dart'; // Add this import
import 'score_card.dart'; 
class GameApp extends StatefulWidget {
  const GameApp({super.key});

  @override 
  State<GameApp> createState() => _GameAppState();
}

class _GameAppState extends State<GameApp> {
  late final BrickBreaker game;

  @override
  void initState() {
    super.initState();
    game = BrickBreaker();
  } 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.pressStart2pTextTheme().apply(
          bodyColor: const Color(0xff184e77),
          displayColor: const Color(0xff184e77),
        ),
      ),
      home: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 169, 229, 177),
                    Color.fromARGB(255, 117, 155, 122),
                    Color.fromARGB(255, 0, 0, 0),
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Column(
                      children: [
                        ScoreCard(score: game.score),
                        Expanded(
                          child: FittedBox(
                            child: SizedBox(
                              width: gameWidth,
                              height: gameHeight,
                              child: GameWidget(
                                game: game,
                                overlayBuilderMap: {
                                  PlayState.welcome.name: (context, game) =>
                                    const OverlayScreen(
                                      title: 'TAP TO PLAY',
                                      subtitle: 'Use arrow keys or swipe',
                                    ),
                                  PlayState.gameOver.name: (context, game) =>
                                    const OverlayScreen(
                                      title: 'G A M E O V E R',
                                      subtitle: 'Tap to Play Again',
                                    ),
                                  PlayState.won.name: (context, game) =>
                                    const OverlayScreen(
                                      title: 'Y O U W O N ! ! !',
                                      subtitle: 'Tap to Play Again',
                                    ),//Creamos la vista que se mostrará con el boton de reanudar el juego
                                  'pause': (context, game) => Center(
                                    child: Container(
                                      color: Colors.black54,
                                      width: gameWidth,
                                      height: gameHeight,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'PAUSED',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 30,
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () => this.game.togglePause(),
                                            child: const Text('Resume'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            //Ponemos un boton en la parte superior derecha para poder pausar el juego
            Positioned(
              top: 20,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.pause, size: 30, color: Colors.white),
                onPressed: () => game.togglePause(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

