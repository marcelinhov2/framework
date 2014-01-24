Router = require '../app/router'

module.exports = class App

  init: ->
    $.ajax
      url: "/config/config.json"
      success: (config) ->
        router = new Router
        router.init config

$(document).ready ->
  window.app = new App
  window.app.init()