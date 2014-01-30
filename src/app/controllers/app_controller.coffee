module.exports = class Controller
  constructor: (@options) ->
    do @init

  init: ->
    $(window).trigger 'show_loader'
    do @configureModel

  configureModel: (data) ->
    do @setModelTriggers
    @options.model.configure @options.config, @options.params, data
    
  setModelTriggers: ->
    $(window).unbind('modelDone').bind 'modelDone', @modelDone
    $(window).unbind('modelFail').bind 'modelFail', @modelFail
    $(window).unbind('modelAlways').bind 'modelAlways', @modelAlways

  modelDone: (e, response, textStatus, jqXHR) =>
    @createView response

  modelFail: (e, jqXHR, textStatus, errorThrown) =>

  createView: (response) ->
    @options.view.init @options, response

  destroyView: (callback) ->
    @options.view.out callback