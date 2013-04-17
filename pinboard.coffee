# pinboard.coffee

class Pinboard

  MIN_WIDTH = 300
  MIN_HEIGHT = 200
  MIN_NUM_ZOOM = 2

  constructor: (pins) ->
    @pins = pins
    @html = $ "<div class='pinboard' />"

  update: () ->
    @_fill()
    $.map @pins, (pin) => @html.append pin.html

  _fill: () ->
    #number_to_show = @pins.length

    # determine grid size, grid unit sizes, zoom count
    grid = @_determine_unit_size() # number_to_show

    # adjust css of pins to fit grid
    @_adjust_pin_sizes grid

    # place pins
    @_allocate grid

  #_determine_unit_size: (number_to_show) ->
  _determine_unit_size: () ->


    number_to_zoom = MIN_NUM_ZOOM
    #
    #while (number_to_show - 3*number_to_zoom)%4 != 0
    #  number_to_zoom += 1

    #unit_fill_count = number_to_show - 3*number_to_zoom

    width = @html.width()
    height = @html.height()

    unit_horiz_count = Math.floor(width / MIN_WIDTH)
    unit_vert_count = Math.floor(height / MIN_HEIGHT)

    unit_width = parseInt(width/unit_horiz_count)
    unit_height = parseInt(height / unit_vert_count)

    {
      number_to_zoom, 
      unit_width, unit_height, 
      unit_horiz_count, unit_vert_count, 
      width, height
    }

  _adjust_pin_sizes: (grid)->
    @pins = _.shuffle(@pins)
    $.map @pins, (pin, i) => 
      if i< grid.number_to_zoom
        pin.zoom = true
        pin.html.css({
          'height': "#{2*grid.unit_height}px",
          'width': "#{2*grid.unit_width}px"
        })
      else
        pin.zoom = false
        pin.html.css({
          'height': "#{grid.unit_height}px",
          'width': "#{grid.unit_width}px"
        })
    @pins = _.shuffle(@pins)

  _allocate: (grid) ->
    #matrix = $.map(new Array(grid.unit_horiz_count*grid.unit_vert_count), () -> 0)

    columns = grid.unit_horiz_count
    rows = grid.unit_vert_count

    matrix = [ ]
    for r in [1 .. rows]
      row = [ ]
      for c in [1 .. columns]
        row.push 0
      matrix.push row

    allocated_units = 0

    place = (pin) ->
      if allocated_units >= columns*rows
        return false
      if not pin.zoom
        point = find_empty_spot()
        if point.y < 0
          pin.html.css('display', 'none')
          return false
        matrix[point.y][point.x] = 1
        allocated_units += 1
        pin.html.css({
          'top': "#{point.y*grid.unit_height}px",
          'left': "#{point.x*grid.unit_width}px"
        })
        return true
      if pin.zoom
        point = find_empty_double()
        if point.y < 0 or point.x < 0
          pin.html.css({'opacity':'0'})
          return false
        matrix[point.y][point.x] = 1
        matrix[point.y+1][point.x] = 1
        matrix[point.y][point.x+1] = 1
        matrix[point.y+1][point.x+1] = 1
        allocated_units += 4
        pin.html.css({
          'top': "#{point.y*grid.unit_height}px",
          'left': "#{point.x*grid.unit_width}px"
        })
        return true

    find_empty_spot = () ->
      for r in [0 .. rows-1]
        for c in [0 .. columns-1]
          if not matrix[r][c]
            return {x:c, y: r}
      return {x: -1, y: -1}

    find_empty_double = () ->
      for r in [0 .. rows-2]
        for c in [0 .. columns-2]
          if not matrix[r][c] and not matrix[r][c+1] and not matrix[r+1][c+1] and not matrix[r+1][c]
            return {x:c, y: r}
      return {x: -1, y: -1}

    $.map @pins, place

