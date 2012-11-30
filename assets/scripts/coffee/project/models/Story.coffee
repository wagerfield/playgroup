###
#============================================================
#
# Playgroup: Story Model
#
# @author Matthew Wagerfield
#
#============================================================
###

class MODELS.Story extends MODELS.Model

  ###
  #========================================
  # Class Variables
  #========================================
  ###

  @class = 'MODELS.Story'



  ###
  #========================================
  # Instance Variables
  #========================================
  ###

  title: null
  characters: null
  story: null
  nodes: null



  ###
  #========================================
  # Instance Methods
  #========================================
  ###

  parse: (data) =>
    @title = data.title
    @characters = data.characters
    @story = data.story
    @nodes = @story.nodes
    super
    return



  ###
  #========================================
  # Callbacks
  #========================================
  ###
