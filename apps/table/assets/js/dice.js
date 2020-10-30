import CANNON from 'cannon';
import * as THREE from 'three';
import {DiceD20, DiceManager} from "threejs-dice";

let world = new CANNON.World();
DiceManager.setWorld(world);
let dice = new DiceD20({ backColor: '#f00' });
let renderer = new THREE.WebGLRenderer({ antialias: true });
let scene = new THREE.Scene();
let camera = new THREE.PerspectiveCamera(VIEW_ANGLE, ASPECT, NEAR, FAR)
let SCREEN_WIDTH = window.innerWidth
let SCREEN_HEIGHT = window.innerHeight;
let VIEW_ANGLE = 45;
let ASPECT = SCREEN_WIDTH / SCREEN_HEIGHT;
let NEAR = 0.01;
let FAR = 20000;
// set scene and camera
export function init() {

    scene.add(camera);
    camera.position.set(0, 30, 30);

    renderer.setSize(SCREEN_WIDTH, SCREEN_HEIGHT);
    renderer.shadowMap.enabled = true;
    renderer.shadowMap.type = THREE.PCFSoftShadowMap;

    let container = document.getElementById('ThreeJS');

    container.appendChild(renderer.domElement);

    let ambient = new THREE.AmbientLight("#fff", 0.3)

    scene.add(ambient);
    var floorMaterial = new THREE.MeshPhongMaterial( { color: 'green', side: THREE.DoubleSide } );
    var floorGeometry = new THREE.PlaneGeometry(30, 30, 10, 10);
    var floor = new THREE.Mesh(floorGeometry, floorMaterial);
    floor.receiveShadow  = true;
    floor.rotation.x = Math.PI / 2;
    scene.add(floor);

    world.gravity.set(0, -9.82 * 20, 0);
    world.broadphase = new CANNON.NaiveBroadphase();
    world.solver.iterations = 16;

    let floorBody = new CANNON.Body({mass: 0, shape: new CANNON.Plane(), material: DiceManager.floorBodyMaterial});
    floorBody.quaternion.setFromAxisAngle(new CANNON.Vec3(1, 0, 0), -Math.PI / 2);
    world.add(floorBody);

    scene.add(dice.getObject());

    dice.getObject().position.x = 300;
    dice.getObject().position.y = 100;
    dice.getObject().rotation.x = 20 * Math.PI / 180;
    dice.updateBodyFromMesh();
    DiceManager.prepareValues([{ dice: dice, value: 6 }]);
    requestAnimationFrame( animate );
}


function animate() {
    world.step(1.0 / 60.0)
    dice.updateMeshFromBody()
    renderer.render(scene, camera);
    requestAnimationFrame(animate)
}

