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

import { drawToken, shadow, updateHealth, updateMana } from "./token";

import { extractDataDice } from "./dice";
import { toast } from "bulma-toast";
//import {initGrid, extractData, drawToken} from './grid';

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");

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
      updateHealth(token, info.health, info.full_h);
      updateMana(token, info.mana, info.full_m);
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
  DamageButton: {
    mounted() {
      $(this.el).click(() => {
        const damage_value = $("#damage_value").val();
        this.pushEvent("status_token", {
          token_id: window.token_id,
          value: damage_value,
          type: "damage",
        });
        $("#damage_value").val("");
      });
    },
  },
  HealButton: {
    mounted() {
      $(this.el).click(() => {
        const heal_value = $("#heal_value").val();
        this.pushEvent("status_token", {
          token_id: window.token_id,
          value: heal_value,
          type: "heal",
        });
        $("#heal_value").val("");
      });
    },
  },
  ConsumeButton: {
    mounted() {
      $(this.el).click(() => {
        const consume_value = $("#consume_value").val();
        this.pushEvent("status_token", {
          token_id: window.token_id,
          value: consume_value,
          type: "consume_mana",
        });
        $("#consume_value").val("");
      });
    },
  },
  RestoreButton: {
    mounted() {
      $(this.el).click(() => {
        const restore_value = $("#restore_value").val();
        this.pushEvent("status_token", {
          token_id: window.token_id,
          value: restore_value,
          type: "restore_mana",
        });
        $("#restore_value").val("");
      });
    },
  },
};
let liveSocket = new LiveSocket("/live", Socket, {
  hooks: Hooks,
  params: { _csrf_token: csrfToken },
});
liveSocket.connect();
