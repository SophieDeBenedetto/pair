// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//

import {Socket} from "phoenix"
import LiveSocket from "phoenix_live_view"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");
var editors = []
let Hooks = {}
Hooks.CodeEditor = {
  mounted() {
    setupCodeEditor(this)
  },
  updated() {
    // don't reinitialize editor here bc it will reset to default theme and mess up cursor placement
    updateCodeEditor(this)
  }
}


let liveSocket = new LiveSocket("/live", Socket, {hooks: Hooks, params: {_csrf_token: csrfToken}});

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)
window.liveSocket = liveSocket
import "phoenix_html"

function setupCodeEditor(that) {
  createCodeEditor(that);
  changeThemeListener();
  changeLanguageListener(that);
  changeBodyListener(that);
  editorBlurListener(that);
}

function createCodeEditor(that) {
  let challengeId = that.el.dataset.id;
  let mode = that.el.dataset.language;
  let value = that.el.dataset.body;
  window.Editor = new CodeMirror.fromTextArea(document.getElementById("editor" + challengeId), {
    lineNumbers: true,
    mode: "javascript",
    theme: "3024-day",
    lineWrapping: false
  });
  window.Editor.setOption("mode", mode);
  window.Editor.setValue(value);
}

function changeThemeListener() {
  document.getElementById('theme').addEventListener("change", function() {
    let theme = document.getElementById('theme').value;
    window.Editor.setOption("theme", theme);
  });
}

function changeLanguageListener(that) {
  let target = that.el.dataset.phoenixTarget;
  document.getElementById('language').addEventListener("change", function() {
    let language = document.getElementById('language').value;
    window.Editor.setOption("mode", language);
    that.pushEventTo(target, "update", { language: language })
  });
}

function changeBodyListener(that) {
  let target = that.el.dataset.phoenixTarget;
  window.Editor.on("change", e => {
    let body = window.Editor.getValue();
    that.pushEventTo(target, "update", { body: body })
  })
}

function editorBlurListener(that) {
  let target = that.el.dataset.phoenixTarget;
  window.Editor.on("blur", e => {
    let body = window.Editor.getValue();
    that.pushEventTo(target, "stop_typing", { })
  })
}

function updateCodeEditor(that) {
  let mode = that.el.dataset.language;
  let value = that.el.dataset.body;
  let currentPosition = window.Editor.getCursor();
  window.Editor.setOption("mode", mode);
  window.Editor.setValue(value);
  window.Editor.setCursor(currentPosition);
}
