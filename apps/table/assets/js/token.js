import Konva from "konva";

const block = 60;
let active = false;
export const shadow = new Konva.Rect({
  x: 0,
  y: 0,
  width: 60,
  height: 60,
  fill: "#BBACC1",
  opacity: 0.6,
  dash: [20, 2],
});

export function drawToken(stage, info) {
  let group = new Konva.Group({
    x: info.x,
    y: info.y,
    draggable: true,
    id: info.id,
  });

  const token = konva_token();
  const { token_health, token_mana } = status_bars(
    info.health,
    info.mana,
    info.full
  );
  const { name_token, text_name } = token_name(token, info);

  set_status_bars_id(token_health, token_mana, info.id);

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

  group.on("dragstart", () => {
    shadow.show();
    shadow.moveToTop();
    group.moveToTop();
  });
  group.on("dragend", () => {
    group.position({
      x: Math.round(group.x() / block) * block,
      y: Math.round(group.y() / block) * block,
    });
    stage.batchDraw();
    shadow.hide();
  });
  group.on("dragmove", () => {
    shadow.position({
      x: Math.round(group.x() / block) * block,
      y: Math.round(group.y() / block) * block,
    });
    stage.batchDraw();
  });

  group.on("contextmenu", (event) => {
    const {
      attrs: { id },
    } = event.target.parent;

    window.token_id = id;
  });

  return group;
}

function konva_token() {
  return new Konva.Rect({
    x: block * 3,
    y: block * 3,
    width: 60,
    height: 60,
    fill: "#80727B",
    shadowColor: "black",
    shadowBlur: 2,
    shadowOffset: { x: 1, y: 1 },
    shadowOpacity: 0.4,
    cornerRadius: 10,
  });
}

function status_bars(health, mana, full) {
  const token_health = new Konva.Rect({
    x: block * 3.1,
    y: block * 4.1,
    stroke: "#ff7675",
    strokeWidth: 8,
    width: 49,
    height: 0.5,
  });

  return {
    token_health,
    token_mana: new Konva.Rect({
      x: token_health.x(),
      y: block * 4.25,
      stroke: "#a29bfe",
      strokeWidth: token_health.strokeWidth(),
      width: token_health.width(),
      height: token_health.height(),
    }),
  };
}

function token_name(token, info) {
  const text_name = new Konva.Text({
    x: token.x(),
    y: token.y(),
    text: info.name,
    fontSize: 15,
    fill: "white",
    align: "center",
    padding: 4,
  });
  return {
    text_name,
    name_token: new Konva.Rect({
      x: token.x(),
      y: token.y(),
      width: text_name.width(),
      height: text_name.height(),
      name: info.id,
      fill: "#AB2346",
      cornerRadius: 5,
    }),
  };
}

function set_status_bars_id(health, mana, id) {
  health.id(`token_health_${id}`);
  mana.id(`token_mana_${id}`);
}

export function updateHealth(token, health, full) {
  const full_percent = 49;
  const current_health = health / full;
  const percent_bar = current_health * full_percent;
  const id = token.attrs.id;

  const token_health = token.findOne(`#token_health_${id}`);
  token_health.to({
    width: percent_bar,
    duration: 0.3,
    easing: Konva.Easings.EaseInOut,
  });
}

export function updateMana(token, mana, full) {
  const full_percent = 49;
  const current_mana = mana / full;
  const percent_bar = current_mana * full_percent;
  const id = token.attrs.id;

  const token_mana = token.findOne(`#token_mana_${id}`);
  token_mana.to({
    width: percent_bar,
    duration: 0.3,
    easing: Konva.Easings.EaseInOut,
  });
}
