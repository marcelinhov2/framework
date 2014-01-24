module.exports = class Controller
  constructor: (options) ->
    @view = options.view
    @model = options.model
    @config = options.config
    @params = options.params

    do @init

  init: ->
    do @configureModel

  configureModel: (data) ->
    @model.configure @config, @params, data
    do @setModelTriggers

  setModelTriggers: ->
    $(window).bind 'modelDone', @modelDone
    $(window).bind 'modelFail', @modelFail
    $(window).bind 'modelAlways', @modelAlways

  modelDone: (e, response, textStatus, jqXHR) ->
    console.log 'view'
    console.log response

  modelFail: (e, jqXHR, textStatus, errorThrown) ->