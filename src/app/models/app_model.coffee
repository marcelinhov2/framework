_ = require("lodash")

module.exports = class Model
  constructor: ->

  configure: (@config, @params, @data) ->
    if @config.dependency_service
      do @mount_service_url
    else
      do @done

  mount_service_url: ->
    @service = _.find app.services, {"name" : @config.dependency_service}
    @config.service = @service

    for key, value of @params.params
      key = ":#{key}"

      service_url = @config.service.url.replace(key, value)

    @request service_url

  request: (url) ->
    req = $.ajax
      url: url
      type: @config.service.type

    req.done (response, textStatus, jqXHR) =>
      @done response, textStatus, jqXHR

    req.fail (jqXHR, textStatus, errorThrown) =>
      @fail jqXHR, textStatus, errorThrown

  done: (response, textStatus, jqXHR) ->
    $(window).trigger 'modelDone', [response, textStatus, jqXHR]
  
  fail: (jqXHR, textStatus, errorThrown) ->
    $(window).trigger 'modelFail', [jqXHR, textStatus, errorThrown]