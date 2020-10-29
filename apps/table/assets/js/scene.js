import { Actor, CollisionType, Color, Engine } from 'excalibur'

const game = new Engine({
    width: 800,
    height: 600
});

const paddle = new Actor({
    x: 150,
    y: 40,
    width: 200,
    height: 20
});

paddle.color = Color.Red;

paddle.body.collider.type = CollisionType.Fixed;


export function init() {
    console.log(paddle);
    game.add(paddle);
    game.start();
}
