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

var active = false
var currentX = null
var currentY = null
var initialX = null
var initialY = null
var xOffset = 0
var yOffset = 0

let Hooks = {
    DraggableToken: {
        mounted() {
            this.element = this.el;
            this.el.addEventListener("mousedown", this.dragStart, false);
            this.el.addEventListener("mouseup", this.dragEnd, false);
            this.el.addEventListener("mousemove", e => {
                if(active) {
                    e.preventDefault();
                    currentX = e.clientX - initialX;
                    currentY = e.clientY - initialY;
                    xOffset = currentX;
                    yOffset = currentY;
                    this.el.style.transform = `translate3d(${currentX}px, ${currentY}px, 0)`
                }
            });
        },
        dragStart(e) {
            initialX = e.clientX - xOffset;
            initialY = e.clientY - yOffset;
            active = true;
        },
        dragEnd() {
            initialX = currentX;
            initialY = currentY;
            active = false;
        }
    }
}
let liveSocket = new LiveSocket("/live", Socket, {hooks: Hooks, params: {_csrf_token: csrfToken}})
liveSocket.connect()
