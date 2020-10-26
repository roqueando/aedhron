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

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");

var movementable = false;

let Hooks = {
    DraggableToken: {
        mounted() {
            const position = this.el.getAttribute('data-position');
            const field = $(`td[data-position='${position}']`)[0]
            field.appendChild(this.el);
            $("td").click(e => {
                if(movementable) {
                    e.target.appendChild(this.el);
                    console.log(e.target.getAttribute('data-position'))
                }
            })

            $(this.el).click(() => {
                movementable = !movementable;
                if(movementable) {
                    $(".draggable-token").css({ backgroundColor: "orange" })
                } else {
                    $(".draggable-token").css({ backgroundColor: "#f73b7c" })
                }
            });

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
