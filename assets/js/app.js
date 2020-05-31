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
import Ace from "ace-builds"
// import "ace-builds/webpack-resolver";

import {Socket} from "phoenix"
import LiveSocket from "phoenix_live_view"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");

let Hooks = {}
Hooks.AceEditor = {
  mounted() {
    debugger;
    let node = this;
    let language = node.el.dataset.language ? node.el.dataset.language : "elixir"
    let challengeId = node.el.dataset.editor
    let editor = Ace.edit(`editor${challengeId}`, {
      maxLines: 50,
      minLines: 10,
      mode: `ace/mode/${language}`,
      theme: "ace/theme/solarized_light"
    })
    editor.getSession().setTabSize(2)
    document.getElementById(`editor${challengeId}`).style.fontSize='18px';
    document.getElementById('theme').addEventListener("change", function() {
      let theme = document.getElementById('theme').value;
      editor.setTheme(`ace/theme/${theme}`);
    });
    var that = this;
    document.getElementById('language').addEventListener("change", function() {
      let language = document.getElementById('language').value;
      editor.session.setMode(`ace/mode/${language}`);
      that.pushEventTo(`#editor-${challengeId}`, "update_language", { language: language })
    });
  },
  updated() {
    let node = this;
    let language = node.el.dataset.language ? node.el.dataset.language : "elixir"
    let challengeId = node.el.dataset.editor
    let editor = Ace.edit(`editor${challengeId}`, {
      maxLines: 50,
      minLines: 10,
      mode: `ace/mode/${language}`,
      theme: "ace/theme/solarized_light"
    })
    editor.getSession().setTabSize(2)
    document.getElementById(`editor${challengeId}`).style.fontSize='18px';
    document.getElementById('theme').addEventListener("change", function() {
      let theme = document.getElementById('theme').value;
      editor.setTheme(`ace/theme/${theme}`);
    });
    var that = this;
    document.getElementById('language').addEventListener("change", function() {
      let language = document.getElementById('language').value;
      editor.session.setMode(`ace/mode/${language}`);
      that.pushEventTo(`#editor-${challengeId}`, "update_language", { language: language })
    });
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
