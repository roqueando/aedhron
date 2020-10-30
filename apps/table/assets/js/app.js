// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/table.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html"
import {Socket} from "phoenix"
import LiveSocket from "phoenix_live_view"
import {extractData, initGrid, updateStageAndLayer, variables} from "./grid";
import {drawToken, shadow, toggle_arcs} from './token'
//import {initGrid, extractData, drawToken} from './grid';

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");

let Hooks = {
    GridLive: {
        mounted() {
            const { stage, gridLayer,  layer} = initGrid();
            shadow.hide();

            stage.add(gridLayer);
            stage.add(layer);

            updateStageAndLayer(stage, gridLayer, layer)
        }
    },
    DraggableToken: {
        mounted() {
            const { stage, gridLayer, layer } = variables;
            const info = extractData(this.el);
            console.log(`mounted ${info.id}`);
            const token = drawToken(stage, info) 

            //layer.add(shadow);
            gridLayer.add(token);
            //token.on('click', event => toggle_arcs(event, info.id));
            token.on('dragend', () => {
                this.pushEvent('move_token', {
                    id: info.id,
                    position: {
                        x: token.x(),
                        y: token.y()
                    }
                })
            })
            stage.batchDraw();
        },
        updated() {
            const info = extractData(this.el);
            const { stage } = variables;
            const token = stage.findOne(`#${info.id}`);
            token.x(info.x);
            token.y(info.y);
            stage.batchDraw();
        }
    },
    DiceResult: {
        updated() {
            setTimeout(() => {
                $(".dice-result").css({display: 'none'});
            }, 4000)
        }
    }
}
let liveSocket = new LiveSocket("/live", Socket, {hooks: Hooks, params: {_csrf_token: csrfToken}})
liveSocket.connect()
