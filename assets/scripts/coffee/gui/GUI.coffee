###
#============================================================
#
# DAT GUI Wrapper
#
# @author Matthew Wagerfield
#
#============================================================
###

class GUI

  ###
  #========================================
  # Constants
  #========================================
  ###

  ID = 'datgui'



  ###
  #========================================
  # Class Variables
  #========================================
  ###

  @gui = null



  ###
  #========================================
  # Class Methods
  #========================================
  ###

  @initialise = (@options) ->

    # Setup the GUI options.
    @options.autoPlace = false
    @options.resizable = false

    # Create the GUI and set its id attribute.
    @gui = new dat.GUI @options
    @gui.domElement.setAttribute 'id', 'datgui'

    # Add the GUI DOM element to the document body.
    document.body.appendChild @gui.domElement

    # Add key event listener.
    window.addEventListener 'keydown', @onKeyDown
    return

  @addController = (id, object, property, parameters...) ->
    controller = @gui.add object, property, parameters...
    return controller

  @addControllerToFolder = (folder, object, property, parameters...) ->
    controller = folder.add object, property, parameters...
    return controller

  @addColor = (id, object, property) ->
    controller = @gui.addColor object, property
    return controller

  @addColorToFolder = (folder, object, property) ->
    controller = folder.addColor object, property
    return controller

  @addGraph = (id, gui, object, property) ->
    controller = new GraphController gui, object, property
    return controller

  @addGraphToFolder = (folder, object, property) ->
    controller = new GraphController object, property, folder
    return controller

  @addFolder = (id) ->
    folder = @gui.addFolder id
    return folder

  @open = () ->
    @gui?.open()
    return

  @close = () ->
    @gui?.close()
    return



  ###
  #========================================
  # Callbacks
  #========================================
  ###

  @onKeyDown = (event) =>
    @gui.closed = not @gui.closed if event.ctrlKey and event.keyCode is 72
    return
