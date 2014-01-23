module.exports = class Controller
  constructor: (options) ->
    @view = options.view
    @model = options.model

    do @init

  init: ->
    console.log 'init controller'