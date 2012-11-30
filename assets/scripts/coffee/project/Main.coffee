###
#============================================================
#
# Crustation: Main Class
#
# @author Matthew Wagerfield
#
#============================================================
###

class PROJECT.Main extends Class

  ###
  #========================================
  # Class Variables
  #========================================
  ###

  @class = 'PROJECT.Main'



  ###
  #========================================
  # Instance Variables
  #========================================
  ###

  $html: null
  $body: null
  $content: null
  $splashscreen: null
  $selection: null
  $story: null

  layout: null

  # Models
  storyModel: null

  # Controllers
  storyController: null



  ###
  #========================================
  # Instance Methods
  #========================================
  ###

  constructor: () ->

    # Cache selections.
    @$html = $ 'html'
    @$body = $ 'body'
    @$content = @$body.find '#content'
    @$splashscreen = @$content.find '#splashscreen'
    @$selection = @$content.find '#selection'
    @$story = @$content.find '#story'
    return

  initialise: () =>
    super

    # Initialise the GUI
    # GUI.initialise width: 320

    # Add classes.
    @addClasses()

    # Add event listeners.
    @addEventListeners()
    return

  addClasses: () =>
    @layout = new Layout
    @layout.initialise()

    # @splashscreen = new CONTROLLERS.Splashscreen @$splashscreen
    # @splashscreen.initialise()

    # @selection = new CONTROLLERS.Selection @$selection
    # @selection.initialise()

    @storyModel = new MODELS.Story '/assets/data/story.json'
    @storyModel.initialise()

    @storyController = new CONTROLLERS.Story @$story
    @storyController.initialise()
    return

  addEventListeners: () =>
    @storyModel.parsed.add @onStoryParsed
    return



  ###
  #========================================
  # Callbacks
  #========================================
  ###

  onStoryParsed: (model) =>
    @storyController.setUserId 0
    @storyController.setStory model
    return



# Create instance of Main class.
@PG = PG = new PROJECT.Main
