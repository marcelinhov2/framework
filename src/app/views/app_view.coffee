ways = require("ways")
browser = require("ways-browser")

module.exports = class View
  constructor: ->

  init: (@options, @data) ->
    do @set_container
    do @render

  set_container: ->
    @container = @options.config.container

  render: ->
    @el = $(@container).append(@options.template(@data))
    
    setTimeout (=>
      @after_render?()
      $(window).trigger 'view_rendered', [@options.config.route]
    ), 100

  after_render: ->
    do @internalNavigation

  internalNavigation: ->
    @el.find( 'a[href^="/"]' ).each ( index, item ) =>
      @navigate item

  navigate: (item) ->
    $( item ).click ( event ) =>
      ways.go $( event.delegateTarget ).attr('href')
      return off