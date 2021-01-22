// We need to import the CSSso that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/table.scss";

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html";
import { Socket } from "phoenix";
import LiveSocket from "phoenix_live_view";
import { extractData, initGrid, updateStageAndLayer, variables } from "./grid";

import { drawToken, shadow } from "./token";

import { extractDataDice } from "./dice";
import { toast } from "bulma-toast";
//import {initGrid, extractData, drawToken} from './grid';

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");

function isRightClick(event) {
  if ("which" in event.evt) {
    return event.evt.which === 3;
  }
  if ("button" in event.evt) {
    return event.evt.button === 3;
  }
}
let Hooks = {
  GridLive: {
    mounted() {
      const { stage, gridLayer, layer } = initGrid();
      shadow.hide();

      stage.add(gridLayer);
      stage.add(layer);

      updateStageAndLayer(stage, gridLayer, layer);
    },
  },
  DraggableToken: {
    mounted() {
      const { stage, gridLayer, layer } = variables;
      const info = extractData(this.el);
      const token = drawToken(stage, info);

      //layer.add(shadow);
      let selected;
      gridLayer.add(token);
      token.on("dragend", () => {
        this.pushEvent("move_token", {
          id: info.id,
          position: {
            x: token.x(),
            y: token.y(),
          },
        });
      });
      layer.batchDraw();
      stage.batchDraw();
    },
    updated() {
      const info = extractData(this.el);
      const { stage } = variables;
      const token = stage.findOne(`#${info.id}`);
      token.x(info.x);
      token.y(info.y);
      stage.batchDraw();
    },
  },
  DiceResult: {
    updated() {
      const { dice, result } = extractDataDice(this.el);
      toast({
        message: `rolled d${dice} and result ${result}!`,
        type: result == 1 ? "is-danger" : "is-warning",
      });
    },
  },

  AvatarPreviewUrl: {
    mounted() {
      $(this.el).keyup(function ({ target: { value } }) {
        try {
          const url = new URL(value);
          $("#avatar_preview").attr("src", url.href);
        } catch (error) {
          console.error(error.message);
        }
      });
    },
  },
};
let liveSocket = new LiveSocket("/live", Socket, {
  hooks: Hooks,
  params: { _csrf_token: csrfToken },
});
liveSocket.connect();
