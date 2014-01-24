module.exports = class View
  constructor: ->

  init: (@options, @data) ->
    do @set_container
    do @render

  set_container: ->
    @container = @options.config.container

  render: ->
    $(@container).append @options.template @data