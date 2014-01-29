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
      when 'URL_VARS'
        do @URL_VARS

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
    data = Object.create(@config.service.vars)

    for key, value of data

      if (value.indexOf(':') >= 0)
        data.value = @replace(value)

    @request_JSON data

  URL_VARS: ->
    data = Object.create(@config.service.vars)

    for key, value of data

      if (value.indexOf(':') >= 0)
        data.value = @replace(value)

    url_data = ''
    i = 0

    for key, value of data
      url_data += "#{key}=#{value}"

      if i < ( Object.keys(@config.service.vars).length - 1 )
        url_data += "&"

      i++

    @request_URL_VARS url_data

  request_REST: (url) ->
    req = $.ajax
      url: url
      type: @config.service.method

    req.done (response, textStatus, jqXHR) =>
      @done response, textStatus, jqXHR

    req.fail (jqXHR, textStatus, errorThrown) =>
      @fail jqXHR, textStatus, errorThrown

  request_JSON: (data) ->
    req = $.ajax
      url: @config.service.url
      type: @config.service.method
      data: data

    req.done (response, textStatus, jqXHR) =>
      @done response, textStatus, jqXHR

    req.fail (jqXHR, textStatus, errorThrown) =>
      @fail jqXHR, textStatus, errorThrown

  request_URL_VARS: (data) ->
    req = $.ajax
      url: @config.service.url + "?" + data
      type: @config.service.method

    req.done (response, textStatus, jqXHR) =>
      @done response, textStatus, jqXHR

    req.fail (jqXHR, textStatus, errorThrown) =>
      @fail jqXHR, textStatus, errorThrown

  replace: (param) ->
    param = param.replace(':', '')
    param = @params.params[param]

    return param

  done: (response, textStatus, jqXHR) ->
    $(window).trigger 'modelDone', [response, textStatus, jqXHR]
  
  fail: (jqXHR, textStatus, errorThrown) ->
    $(window).trigger 'modelFail', [jqXHR, textStatus, errorThrown]