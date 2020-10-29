import Konva from 'konva';

const block = 60;
export const variables = {
  stage: null,
  gridLayer: null,
  layer: null
}

export function initGrid() {

  const stage = new Konva.Stage({ 
    container: 'grid',
    width: window.innerWidth,
    height: window.innerHeight
  });
  const gridLayer = new Konva.Layer();

  drawVerticalLine(gridLayer);
  gridLayer.add(new Konva.Line({ points: [0,0,10,10] }));
  drawHorizontalLine(gridLayer);

  let layer = new Konva.Layer();
  variables.stage = stage;
  variables.gridLayer = gridLayer;
  variables.layer = layer;

  return {
    stage,
    gridLayer,
    layer
  }
}

function drawVerticalLine(layer) {
  for(var i = 0; i < window.innerWidth / block; i++) {
    layer.add(new Konva.Line({
      points: [Math.round(i * block) + 0.5, 0, Math.round(i * block) + 0.5, window.innerHeight],
      stroke: '#ddd',
      strokeWidth: 1
    }));
  }
}

function drawHorizontalLine(layer) {
  for(var j = 0; j < window.innerHeight / block; j++) {
    layer.add(new Konva.Line({
      points: [0, Math.round(j * block), window.innerWidth, Math.round(j * block)],
      stroke: '#ddd',
      strokeWidth: 1
    }))
  }
}

export function updateStageAndLayer(stage, gridLayer, layer) {
  variables.stage = stage;
  variables.gridLayer = gridLayer;
  variables.layer = layer;
}

export function extractData(Element) {
  const element = $(Element)[0];
  return {
    id: element.getAttribute('data-token-id'),
    name: element.getAttribute('data-token-name'),
    health: element.getAttribute('data-token-status-health'),
    mana: element.getAttribute('data-token-status-mana'),
    type: element.getAttribute('data-token-type'),
    x: parseInt(element.getAttribute('data-token-position-x')),
    y: parseInt(element.getAttribute('data-token-position-y')),
  }
}

export function drawToken(obj) {
  const context = $("canvas")[0].getContext('2d');
  context.fillStyle = "#FF9FE5";
}
