module.exports = class Model
  constructor: ->

  configure: (@config, @params, @data) ->
    do @mount_service_url

  mount_service_url: ->
    for key, value of @params.params
      key = ":#{key}"
      
      @config.service.url = @config.service.url.replace(key, value)

    do @request

  request: ->
    req = $.ajax
      url: @config.service.url
      type: @config.service.type

    req.done (response, textStatus, jqXHR) =>
      @done response, textStatus, jqXHR

    req.fail (jqXHR, textStatus, errorThrown) =>
      @fail jqXHR, textStatus, errorThrown

  done: (response, textStatus, jqXHR) ->
    $(window).trigger 'modelDone', [response, textStatus, jqXHR]
  
  fail: (jqXHR, textStatus, errorThrown) ->
    $(window).trigger 'modelFail', [jqXHR, textStatus, errorThrown]