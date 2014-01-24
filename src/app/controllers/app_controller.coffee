module.exports = class Controller
  constructor: (@options) ->
    do @init

  init: ->
    do @configureModel

  configureModel: (data) ->
    @options.model.configure @options.config, @options.params, data
    do @setModelTriggers

  setModelTriggers: ->
    $(window).bind 'modelDone', @modelDone
    $(window).bind 'modelFail', @modelFail
    $(window).bind 'modelAlways', @modelAlways

  modelDone: (e, response, textStatus, jqXHR) =>
    @createView response

  modelFail: (e, jqXHR, textStatus, errorThrown) =>

  createView: (response) ->
    @options.view.init @options, response