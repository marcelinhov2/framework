_ = require("lodash")

module.exports = class Model
  constructor: ->

  configure: (@config, @params, @data) ->
    if @config.dependency_service
      do @mount_request

      # do @mount_service_url
    else
      do @done

  mount_request: ->
    @service = _.find app.services, {"name" : @config.dependency_service}
    @config.service = @service

    switch @config.service.type
      when 'REST'
        do @REST
      when 'JSON'
        do @JSON

  REST: ->
    service_url = ''

    for key, value of @config.service.vars

      if (value.indexOf(':') >= 0)
        value = @replace(value)

      if service_url.length
        @config.service.url = service_url

      service_url = @config.service.url.replace("{#{key}}", value)
      
    @request_REST service_url

  JSON: ->
    @request_JSON @config.service.url

  replace: (param) ->
    param = param.replace(':', '')
    param = @params.params[param]

    return param

  request_JSON: (url) ->
    req = $.ajax
      url: url
      type: @config.service.method
      data: @config.service.vars

    req.done (response, textStatus, jqXHR) =>
      @done response, textStatus, jqXHR

    req.fail (jqXHR, textStatus, errorThrown) =>
      @fail jqXHR, textStatus, errorThrown

  request_REST: (url) ->
    req = $.ajax
      url: url
      type: @config.service.method

    req.done (response, textStatus, jqXHR) =>
      @done response, textStatus, jqXHR

    req.fail (jqXHR, textStatus, errorThrown) =>
      @fail jqXHR, textStatus, errorThrown

  done: (response, textStatus, jqXHR) ->
    $(window).trigger 'modelDone', [response, textStatus, jqXHR]
  
  fail: (jqXHR, textStatus, errorThrown) ->
    $(window).trigger 'modelFail', [jqXHR, textStatus, errorThrown]