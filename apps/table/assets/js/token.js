import Konva from 'konva';

const block = 60;
let active = false;
export const shadow = new Konva.Rect({
    x: 0,
    y: 0,
    width: 60,
    height: 60,
    fill: '#BBACC1',
    opacity: 0.6,
    dash: [20, 2]
});


let arc_token_health = new Konva.Arc({
    x: block * 3.65,
    y: block * 3.50,
    innerRadius: 40,
    outerRadius: 50,
    angle: 90,
    fill: '#ff7675',
    rotation: -45
})

let arc_token_mana = new Konva.Arc({
    x: block * 3.40,
    y: block * 3.50,
    innerRadius: 40,
    outerRadius: 50,
    angle: 90,
    fill: '#a29bfe',
    rotation: 135
})
export function drawToken(stage, info) {
    let group = new Konva.Group({
        x: info.x,
        y: info.y,
        draggable: true,
        id: info.id
    })
    let token = new Konva.Rect({
        x: block * 3,
        y: block * 3,
        width: 60,
        height: 60,
        fill: '#80727B',
        shadowColor: 'black',
        shadowBlur: 2,
        shadowOffset: {x: 1, y: 1},
        shadowOpacity: 0.4,
        cornerRadius: 10,
    });

    let text_name = new Konva.Text({
        x: token.x(),
        y: token.y(),
        text: info.name,
        fontSize: 15,
        fill: 'white',
        align: 'center',
        padding: 4
    });

    let name_token = new Konva.Rect({
        x: token.x(),
        y: token.y(),
        width: text_name.width(),
        height: text_name.height(),
        name: info.id,
        fill: '#AB2346',
        cornerRadius: 5,
    });


    arc_token_health.hide();
    arc_token_mana.hide();

    group.add(token);
    if (info.avatar) {
        Konva.Image.fromURL(info.avatar, (node) => {
            node.setAttrs({
                x: token.x(),
                y: token.y(),
                width: token.width(),
                height: token.height(),
                cornerRadius: 10,
            });
            group.add(node);
            group.add(name_token);
            group.add(text_name);
            group.add(arc_token_health);
            group.add(arc_token_mana);
            stage.batchDraw();
        });
    } else {
        group.add(name_token);
        group.add(text_name);
        group.add(arc_token_health);
        group.add(arc_token_mana);
    }


    group.on('dragstart', () => {
        shadow.show();
        shadow.moveToTop();
        group.moveToTop();
    });
    group.on('dragend', () => {
        group.position({
            x: Math.round(group.x() / block) * block,
            y: Math.round(group.y() / block) * block,
        });
        stage.batchDraw();
        shadow.hide();
    });
    group.on('dragmove', () => {
        shadow.position({
            x: Math.round(group.x() / block)* block,
            y: Math.round(group.y() / block) * block,
        })
        stage.batchDraw();
    });

    return group;
}

export function toggle_arcs(event, id) {
    if(active) {
        arc_token_health.hide();
        arc_token_mana.hide();
        active = false;
    } else {
        arc_token_health.show();
        arc_token_mana.show();
        active = true;
    }
}
