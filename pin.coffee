# pin.coffee

# content = {photo: 'path_to_photo', text: 'some text description'}
# options = {class: 'my_special_css_class', click: function(){ foo(); }}
class Pin

  constructor: (content={}, options={}) ->
    @options = options
    @content = content   
    @_setup()

  _setup: ->
    # Creates a container element
    @html = $ "<div class='pin_container' />"

    # Create pin content
    @pin = $ "<div class='pin' />"
    @html.append @pin
    @pin.addClass @options.class if @options.class
    @pin.click (@options.click || @focus)

    # Adds content to @el
    @_setPhoto (@content.photo || '')
    @_setText (@content.text || '')

  _setPhoto: (photo) ->
    pin_photo = $ "<div class='pin_photo' />"
    pin_photo.css "background", "url(#{photo}) no-repeat center center"
    pin_photo.css "background-size", "cover"
    @pin.append pin_photo

  _setText: (text) ->
    text = $("<div class='pin_text' />").html text
    @pin.append text

  focus: () ->
    console.log "Focused on me"

