ways = require("ways")
browser = require("ways-browser")

module.exports = class View
  constructor: ->

  init: (@options, @data) ->
    do @set_container
    do @render

  set_triggers: ->
    $(window).unbind('show_loader').bind 'show_loader', @show_loader
    $(window).unbind('hide_loader').bind 'hide_loader', @hide_loader

    @el.find( 'a[href^="/"]' ).each ( index, item ) =>
      @navigate item

  set_container: ->
    @container = $(@options.config.container)

  navigate: (item) ->
    $( item ).click ( event ) =>
      ways.go $( event.delegateTarget ).attr('href')
      return off

  before_render: ->
    # console.log 'before_render'

  render: ->
    @before_render?()

    @el = $(@options.template(@data)).appendTo(@container)

    setTimeout (=>
      @after_render?()
    ), 100

  after_render: () ->
    do @set_triggers
    do @in

  before_in: ->
    # console.log 'before_in'

  in: ->
    @before_in?()

    $(@el).fadeIn( => 
      @after_in?()
    )

  after_in: ->
    # console.log 'after_in'
    # console.log '*********************'
    $(window).trigger 'view_rendered', [@options.config.route]

  before_out: ->
    # console.log 'before_out'
  
  out: (callback) ->
    @before_out?()

    $(@el).fadeOut( => 
      @after_out?()

      @destroy callback
    )

  after_out: ->
    # console.log 'after_out'

  before_destroy: ->
    # console.log 'before_destroy'
  
  destroy: (callback) ->
    @before_detroy?()

    $(@el).remove()
    
    @after_destroy?()

    callback?()

  after_destroy: ->
    # console.log 'after_destroy'

  show_loader: ->
    console.log 'show_loader'

  hide_loader: ->
    console.log 'hide_loader'