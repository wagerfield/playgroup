###
#============================================================
#
# Playgroup: Model
#
# @author Matthew Wagerfield
#
#============================================================
###

class MODELS.Model extends Class

  ###
  #========================================
  # Class Variables
  #========================================
  ###

  @class = 'MODELS.Model'



  ###
  #========================================
  # Instance Variables
  #========================================
  ###

  url: null
  dataType: null
  data: null



  ###
  #========================================
  # Instance Methods
  #========================================
  ###

  constructor: (@url, @dataType = 'json') ->
    @parsed = new signals.Signal
    return

  initialise: (options = {}) =>
    options = _.extend options, url:@url, dataType:@dataType
    @load = $.ajax options
    @load.done @onLoadDone
    @load.fail @onLoadFail
    return

  parse: (data) =>
    @parsed.dispatch @
    return



  ###
  #========================================
  # Callbacks
  #========================================
  ###

  onLoadDone: (response) =>
    @parse @data = response
    return

  onLoadFail: (response) =>
    warn "#{@class()}:", response.status, response.statusText
    return
