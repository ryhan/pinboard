# pinboard.coffee

class Pinboard

  MIN_WIDTH = 300
  MIN_HEIGHT = 250
  ZOOM_COUNT = 2
  
  constructor: (pins) ->
    @pins = pins
    @html = $ "<div class='pinboard' />"
    @set_grid_size()
    $.map @pins, (pin) => @html.append pin.html

  update: () ->
    has_changed = @set_grid_size()
    @fit_blocks() if has_changed
    @lay_blocks()
    $(window).resize () => @update()

  # Find the base unit sizes for each pin
  set_grid_size: () ->
    old_x = @x_count
    old_y = @y_count

    width = @html.width()
    height = @html.height()
    
    @x_count = Math.floor width / MIN_WIDTH
    @y_count = Math.floor height / MIN_HEIGHT
    @x_unit = parseInt width / @x_count
    @y_unit = parseInt height / @y_count
    
    # Rreturn true if the grid size has changed
    return old_x != @x_count or old_y != @y_count

  # Figure out the relative placement and sizing of each pin
  fit_blocks: () ->
    @_create_empty_grid()
    for pin in @pins
      pin.zoom = false
      pin.row = -1
      pin.column = -1
    
    # Place a pin a picked location
    place = (pin, picked) =>
      @_fill_block picked.row, picked.column, size
      pin.row = picked.row
      pin.column = picked.column

    # Pick and handle zoomed pins
    size = 2
    @pins = _.shuffle @pins
    for i in [0 .. ZOOM_COUNT]
      pin = @pins[i]
      pin.zoom = true
      options = @_find_empty_blocks size
      unless options.length < 1
        place pin, options[Math.floor(Math.random()*options.length)]

    # handle remaining pins
    size = 1
    options = @_find_empty_blocks size
    for pin in @pins
      unless pin.zoom or options.length < 1
        place pin, options.shift()

  # Apply css to pins to set height, width, and position
  lay_blocks: () =>
    for pin in @pins
      @_set_zoom_css pin
      @_set_position_css pin

  # Sets height + width
  _set_zoom_css: (pin) ->
    if pin.zoom
      height = 2*@y_unit + "px"
      width = 2*@x_unit + "px"
    else
      height = @y_unit + "px"
      width = @x_unit + "px"
    pin.html.css {height, width}

  # Sets position (top, left)
  _set_position_css: (pin) ->
    opacity = 1
    opacity = 0 if pin.row < 0 or pin.column < 0
    top = pin.row*@y_unit + "px"
    left = pin.column*@x_unit + "px"
    pin.html.css {opacity, top, left}

  # Sets @grid to be an empty matrix of size @x_count by @y_count
  _create_empty_grid: () ->
    @grid = [ ]
    for r in [1 .. @y_count]
      row = [ ]
      for c in [1 .. @x_count]
        row.push 0
      @grid.push row

  # Records that a pin of [size] was placed at @grid[row, column]
  _fill_block: (row, column, size) ->
    for r in [0 .. size - 1]
      for c in [0 .. size - 1]
        @grid[row + r][column + c] = 1

  # finds empty blocks in [grid] of [size]
  _find_empty_blocks: (size) ->
    return false if size < 0
    options = [ ]

    # Returns true if block at grid[r][c] of [size] is empty
    isEmpty = (r, c) =>
      for y in [0 .. size - 1]
        for x in [0 .. size - 1]
          return false if @grid[r+y][c+x]
      return true

    for row in [0 .. @y_count - size]
      for column in [0 .. @x_count - size]
        options.push {row, column} if isEmpty(row, column)

    return options