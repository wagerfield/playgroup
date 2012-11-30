###
#============================================================
#
# DAT GUI Graph Controller
#
# @author Matthew Wagerfield
#
#============================================================
###

class GraphController

  ###
  #========================================
  # Constants
  #========================================
  ###

  COLOR = 0xFFDD66
  DEFAULT = [
    {x:0.0, y:0.0}
    {x:0.2, y:0.8}
    {x:1.0, y:1.0}
  ]



  ###
  #========================================
  # Instance Variables
  #========================================
  ###

  gui: null
  object: null
  property: null
  initialValue: null
  value: null

  width: null
  height: null

  domElement: null
  container: null
  wrapper: null
  title: null
  canvas: null
  context: null

  controlPoints: null
  bezierPoints: null
  activePoint: null

  onChangeCallback: null



  ###
  #========================================
  # Instance Methods
  #========================================
  ###

  constructor: (@object, @property, @gui) ->

    # Set the initial value.
    value = if @validate @object[@property] then @object[@property] else DEFAULT
    @value = @initialValue = value

    # Create title element.
    @title = document.createElement 'span'
    @title.className = 'property-name'
    @title.textContent = property

    # Create canvas element.
    @canvas = document.createElement 'canvas'

    # Cache the canvas context.
    @context = @canvas.getContext '2d'

    # Create wrapper element.
    @wrapper = document.createElement 'div'
    @wrapper.className = 'graph-wrapper'
    @wrapper.appendChild @canvas

    # Create container element.
    @container = document.createElement 'div'
    @container.appendChild @title
    @container.appendChild @wrapper

    # Create parent list element.
    @domElement = document.createElement 'li'
    @domElement.className = 'cr graph'
    @domElement.appendChild @container

    # Append the DOM element to the GUI list element.
    @gui?.__ul.appendChild @domElement

    # Cache the width and height properties.
    @width = @domElement.offsetWidth
    @height = @domElement.offsetHeight

    # Set the canvas width and height.
    @canvas.width = @container.offsetWidth - 1
    @canvas.height = @height - @title.offsetHeight - 5

    # Create the points array.
    @controlPoints = []

    # Set the graph values.
    @setValue value
    return

  clamp: (value, min, max) =>
    value = Math.max value, min
    value = Math.min value, max
    return value

  interpolate: (p0, p1, ratio) =>
    ratio = @clamp ratio, 0, 1
    point =
      x: p0.x + (p1.x - p0.x) * ratio
      y: p0.y + (p1.y - p0.y) * ratio
    return point

  addControlPoint: (x, y) =>

    controlPoint =
      x: x
      y: y
      index: @controlPoints.length
      handle: document.createElement 'div'

    coordinate = @getCoordinate x, y

    controlPoint.handle.addEventListener 'mousedown', @onHandleMouseDown
    controlPoint.handle.style.left = "#{coordinate.x}px"
    controlPoint.handle.style.top = "#{coordinate.y}px"
    controlPoint.handle.className = 'graph-handle'

    @wrapper.appendChild controlPoint.handle
    @controlPoints.push controlPoint
    @validateControlPoints()
    return controlPoint

  removeControlPoint: (controlPoint) =>
    return unless controlPoint?
    controlPoint.handle.removeEventListener 'mousedown', @onHandleMouseDown
    @wrapper.removeChild controlPoint.handle
    controlPoint.handle = null
    controlPoint = null
    return

  setControlPointPosition: (point, x, y, original = true, boundary = true) =>

    # Set and clamp the point position.
    point.x  = @clamp x, point.boundary.x0, point.boundary.x1 if original
    point.y  = @clamp y, point.boundary.y0, point.boundary.y1 if original

    # Set and clamp the point boundary position.
    point.bx = @clamp x, point.boundary.x0, point.boundary.x1 if boundary
    point.by = @clamp y, point.boundary.y0, point.boundary.y1 if boundary

    # Get the coordinate of the point.
    coordinate = @getCoordinate point.bx, point.by

    # Position the point handle.
    point.handle.style.left = "#{coordinate.x}px"
    point.handle.style.top = "#{coordinate.y}px"

    # Update the bezier points.
    @updateBezierPoints()

    # Update the value object.
    @value[point.index].x = point.bx
    @value[point.index].y = point.by

    # Return the modified point.
    return point

  validateControlPoints: () =>

    # Iterate through and update all the stored control points.
    for controlPoint, index in @controlPoints

      # Derive if the point is an anchor.
      isAnchor0 = index is 0
      isAnchor1 = index is @controlPoints.length - 1

      # Set the anchor property accordingly.
      controlPoint.anchor = isAnchor0 or isAnchor1

      # Set the initial boundaries of the point.
      controlPoint.boundary = x0:0, y0:0, x1:1, y1:1

      # Clamp the boundary if the point is an anchor.
      controlPoint.boundary.x1 = 0 if isAnchor0
      controlPoint.boundary.x0 = 1 if isAnchor1

      # Update the position of the point based on its boundaries.
      @setControlPointPosition controlPoint, controlPoint.x, controlPoint.y, false

    return

  updateBezierPoints: () =>

    # Caclculate the number of bezier points.
    MIDPOINTS = Math.max 0, @controlPoints.length - 3
    BEZIER_POINTS = @controlPoints.length + MIDPOINTS

    # Reset the bezier point array.
    @bezierPoints = []

    # Create a clone of the control points array.
    clone = @controlPoints.concat()
    point = null

    # Iterate through the number of bezier points.
    for index in [0...BEZIER_POINTS]

      # Derive whether or not the point should use a a control point position.
      control = index < 2 or index > BEZIER_POINTS - 3 or index % 2
      point = if control then clone.shift() else @interpolate point, clone[0], 0.5

      # Add the point data to the bezier points array.
      @bezierPoints.push x: point.x, y: point.y

    return

  getOffset: (element) =>
    offset =
      x: element.offsetLeft
      y: element.offsetTop
    while element = element.offsetParent
      offset.x += element.offsetLeft unless isNaN element.offsetLeft
      offset.y += element.offsetTop unless isNaN element.offsetTop
    return offset

  getCoordinate: (x, y, floor = true, offset = 0) =>
    coordinate =
      x: @canvas.width * x
      y: @canvas.height - @canvas.height * y
    coordinate.x = Math.floor coordinate.x if floor
    coordinate.y = Math.floor coordinate.y if floor
    coordinate.x += offset
    coordinate.y += offset
    return coordinate

  getPoint: (ratio) =>

    point = x:0, y:0

    return point unless @bezierPoints.length

    n = @bezierPoints.length - 1
    f = @getFactoral n

    for i in [0..n]

      b = f / ((@getFactoral i) * (@getFactoral n - i))
      k = Math.pow(1 - ratio, n - i) * (Math.pow ratio, i)
      point.x += b * k * @bezierPoints[i].x
      point.y += b * k * @bezierPoints[i].y

    return point

  getFactoral: (value) =>
    return 1 if value is 0
    factoral = 1
    factoral *= i for i in [value...1]
    return factoral

  draw: (notify = true) =>

    # Clear context.
    @context.clearRect 0, 0, @canvas.width, @canvas.height

    # Draw the grid.
    @drawGrid 16, 1, 1

    # Begin a path.
    @context.beginPath()

    # Draw the handle lines.
    for controlPoint, index in @controlPoints
      coordinate = @getCoordinate controlPoint.x, controlPoint.y, true, 0.5
      method = if index is 0 then 'moveTo' else 'lineTo'
      @context[method] coordinate.x, coordinate.y

    # Set the stroke values and draw.
    @context.strokeStyle = "#666"
    @context.lineWidth = 1
    @context.stroke()

    # Begin a path.
    @context.beginPath()

    # Draw the bezier.
    for ratio in [0..1] by 0.01
      point = @getPoint ratio
      coordinate = @getCoordinate point.x, point.y, false
      method = if ratio is 0 then 'moveTo' else 'lineTo'
      @context[method] coordinate.x, coordinate.y

    # Set the stroke values and draw.
    @context.strokeStyle = "##{COLOR.toString 16}"
    @context.lineWidth = 0.5
    @context.stroke()
    return

  drawGrid: (size, xOffset = 0, yOffset = 0) =>

    @context.beginPath()

    h = Math.round @canvas.width / size
    v = Math.round @canvas.height / size

    for c in [1...h]
      @context.moveTo xOffset + c * size - 0.5, 0
      @context.lineTo xOffset + c * size - 0.5, @canvas.height

    for r in [1...v]
      @context.moveTo 0, yOffset + r * size - 0.5
      @context.lineTo @canvas.width, yOffset + r * size - 0.5

    # Set the stroke values and draw.
    @context.strokeStyle = '#3A3A3A'
    @context.lineWidth = 1
    @context.stroke()
    return

  drawPoint: (ratio, radius = 5) =>
    p = @getPoint ratio
    h = COLOR.toString 16
    r = parseInt h.substring(0, 2), 16
    g = parseInt h.substring(2, 4), 16
    b = parseInt h.substring(4, 6), 16
    c = @getCoordinate p.x, p.y, false
    @context.beginPath()
    @context.arc c.x, c.y, radius, 0, Math.PI * 2
    @context.fillStyle = "rgba(#{r},#{g},#{b},0.2)"
    @context.fill()
    return

  validate: (value) =>
    isArray = Array.isArray value || (value) ->
      Object.prototype.toString.call value is '[object Array]'
    unless isArray
      console.warn 'GraphController: value must be an array of point objects: {x:0, y:0}'
      return false
    unless value.length > 1
      console.warn 'GraphController: value must have atleast 2 point objects'
      return false
    for p in value
      hasX = p.x?
      hasY = p.y?
      unless hasX and hasY
        console.warn 'GraphController: value objects must have both an x and y property with a values ranging from 0 to 1'
        return false
    return true

  setValue: (value) =>
    return unless @validate value
    @value = value
    @removeControlPoint p for p in @controlPoints
    @controlPoints = []
    @addControlPoint p.x, p.y, false for p in value
    @onChangeCallback? @value
    @draw()
    return

  getValue: () =>
    return @value



  ###
  #========================================
  # Callbacks
  #========================================
  ###

  onChange: (callback) =>
    @onChangeCallback = callback
    return

  onHandleMouseDown: (event, controlPoint) =>
    event.preventDefault()

    # Retrieve the active point.
    @activePoint = cp for cp in @controlPoints when cp.handle is event.target

    # Set the unselectable class on the body.
    document.body.classList.add 'unselectable'

    # Add mouse move and up events on the window.
    window.addEventListener 'mouseup', @onWindowMouseUp
    window.addEventListener 'mousemove', @onWindowMouseMove
    return

  onWindowMouseMove: (event) =>

    # Calculate the position of the point.
    wrapperOffset = @getOffset @wrapper
    mouseX = event.clientX or event.pageX
    mouseY = event.clientY or event.pageY
    graphX = mouseX - wrapperOffset.x
    graphY = mouseY - wrapperOffset.y
    pointX = graphX / @canvas.width
    pointY = 1 - graphY / @canvas.height

    # Set the position of the active point.
    @setControlPointPosition @activePoint, pointX, pointY

    # Get the coordinate of the active point.
    coordinate = @getCoordinate @activePoint.x, @activePoint.y

    # Position the handle.
    @activePoint.handle.style.left = "#{coordinate.x}px"
    @activePoint.handle.style.top = "#{coordinate.y}px"

    # Call the onChange callback.
    @onChangeCallback? @value

    # Draw!
    @draw()
    return

  onWindowMouseUp: (event) =>

    # Remove the mouse move and up events from the window.
    window.removeEventListener 'mousemove', @onWindowMouseMove
    window.removeEventListener 'mouseup', @onWindowMouseUp

    # Remove the selectable class.
    document.body.classList.remove 'unselectable'

    # Nullify the active point.
    @activePoint = null
    return
