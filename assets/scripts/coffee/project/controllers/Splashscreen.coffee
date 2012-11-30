###
#============================================================
#
# Playgroup: Splashscreen
#
# @author Matthew Wagerfield
#
#============================================================
###

class CONTROLLERS.Splashscreen extends CONTROLLERS.Controller

  ###
  #========================================
  # Class Variables
  #========================================
  ###

  @class = 'CONTROLLERS.Splashscreen'



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
