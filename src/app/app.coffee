Router = require '../app/router'

# template = require '../templates/main'

$(document).ready ->
  $.ajax
    url: "/config/config.json"
    success: (config) ->
      router = new Router
      router.init config

  # $('body').html template name: 'Bender'

