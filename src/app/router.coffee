ways = require("ways")
browser = require("ways-browser")

_ = require("lodash")

module.exports = class Router

  init: (@config) ->
    do @configureWays

  configureWays: ->
    ways.use browser
    ways.mode 'run+destroy'
    
    app.services = @config.services

    do @configureRoutes
    do @initWays
    
  configureRoutes: ->
    for section in @config.sections
      if section.dependency
        ways "#{section.route}", @instantiate, @destroy, "#{section.dependency}"
      else
        ways "#{section.route}", @instantiate, @destroy

    ways '*', @run, @destroy

  initWays: ->
    ways.init()

  instantiate: (params, done) =>
    route_config = _.find @config.sections, { "route" : params.pattern }

    Model = require route_config.model
    Controller = require route_config.controller
    View = require route_config.view
    Template = require route_config.template

    controller = new Controller
      model: new Model
      view: new View
      template: Template
      config: route_config
      params: params
    
  run: (params, done) ->
    do done

  destroy: (params, done) ->
    do done