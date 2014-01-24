Router = require '../app/router'

$(document).ready ->
  $.ajax
    url: "/config/config.json"
    success: (config) ->
      router = new Router
      router.init config