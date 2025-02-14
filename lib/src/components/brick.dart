import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../brick_breaker.dart';
import '../config.dart';
import 'ball.dart';
import 'bat.dart';
class Brick extends RectangleComponent
 with CollisionCallbacks, HasGameReference<BrickBreaker> {
  //Cambios a la hora de pasar el color para después poder cambiarle el color dependiendo de la vida
 Brick({required super.position, required Color color, this.doblegolpe = false //si es true necesita dos golpes
 }):vidabloque = doblegolpe ? 2 : 1,//le asignamos a la variable uno o dos vidas
  super(
    size: Vector2(brickWidth, brickHeight),
    anchor: Anchor.center,
    paint: Paint()
      ..color = color
      ..style = PaintingStyle.fill,
    children: [RectangleHitbox()],
  );
  final bool doblegolpe;  //para saber si es doble o no
  int vidabloque; // Almacena cuanta vida queda
 @override
 void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
  super.onCollisionStart(intersectionPoints, other);

  if (other is Ball) {
      vidabloque--; // Reducir la vida del bloque en 1

      if (vidabloque <= 0) {
        removeFromParent(); // Elimina el bloque si la vida es 0
        game.score.value++;

        // Ver si quedan más bloques
        if (game.world.children.query<Brick>().length == 1) {
          game.playState = PlayState.won;
          game.world.removeAll(game.world.children.query<Ball>());
          game.world.removeAll(game.world.children.query<Bat>());
        }
      } else {
        // Si le queda vida le cambiamos el color
        paint = Paint()
          ..color = Colors.grey.shade700 //Le cambiamos el color para que se vea dañado
          ..style = PaintingStyle.fill; // Lo hacemos más claro
      }
  }
 }
}