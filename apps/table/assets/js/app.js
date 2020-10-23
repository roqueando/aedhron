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

var active = false;
var initialX = null;
var initialY = null;
var actions_active = false;

let Hooks = {
    DraggableToken: {
        mounted() {
            this.el.addEventListener("mousedown", this.dragStart, false);
            $(this.el).mouseover(() => {
                $(".actions").show();
            });

            $(this.el).click(() => actions_active = !actions_active);
            $(this.el).mouseleave(() => {
                if(!actions_active) {
                    $(".actions").hide();
                }
            });

            $(this.el).mousemove(e => {
                if(active) {
                    let deltaX = e.pageX - initialX;
                    let deltaY = e.pageY - initialY;

                    console.log(this.el.getAttribute('id'))
                    let current_offset = $(this.el).offset();
                    $(this.el).offset({
                        left: (current_offset.left + deltaX),
                        top: (current_offset.top + deltaY)
                    });

                    initialX = e.pageX;
                    initialY = e.pageY;
                }
            });
            $(document).mouseup(() => {
                if(active) {
                    $(".draggable-token").css({backgroundColor: "#f73b7c"})
                    active = false
                }
            });
        },
        dragStart(e) {
            initialX = e.pageX;
            initialY = e.pageY;
            active = true;
            $(".draggable-token").css({backgroundColor: "blue"})
        }
    }
}
let liveSocket = new LiveSocket("/live", Socket, {hooks: Hooks, params: {_csrf_token: csrfToken}})
liveSocket.connect()
