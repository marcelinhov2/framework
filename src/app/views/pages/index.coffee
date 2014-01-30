View = require '../app_view'

module.exports = class Index extends View

  after_render: ->
    super

    $(window).trigger 'hide_loader'