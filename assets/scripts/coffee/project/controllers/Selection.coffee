###
#============================================================
#
# Playgroup: Selection
#
# @author Matthew Wagerfield
#
#============================================================
###

class CONTROLLERS.Selection extends CONTROLLERS.Controller

  ###
  #========================================
  # Class Variables
  #========================================
  ###

  @class = 'CONTROLLERS.Selection'



  ###
  #========================================
  # Instance Variables
  #========================================
  ###

  $profiles: null



  ###
  #========================================
  # Instance Methods
  #========================================
  ###

  initialise: () =>
    @$profiles = @$context.find '#profiles'
    return

  addEventListeners: () =>
    return



  ###
  #========================================
  # Callbacks
  #========================================
  ###
