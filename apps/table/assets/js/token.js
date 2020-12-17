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

    let token_health = new Konva.Rect({
        x: block * 3.10,
        y: block * 4.10,
        stroke: '#ff7675',
        strokeWidth: 8,
        width: 49,
        height: .5,
    })

    let token_mana = new Konva.Rect({
        x: token_health.x(),
        y: block * 4.20,
        stroke: '#a29bfe',
        strokeWidth: 8,
        width: token_health.width(),
        height: token_health.height()
    })
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

    token_health.id(`token_health_${info.id}`);
    token_mana.id(`token_mana_${info.id}`);

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
            group.add(token_health);
            group.add(token_mana);
            stage.batchDraw();
        });
    } else {
        group.add(name_token);
        group.add(text_name);
        group.add(token_health);
        group.add(token_mana);
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
