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

  # Properties
  layout: null
  raf: null



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
    return

  initialise: () =>
    super

    # Initialise the GUI
    GUI.initialise width: 320

    # Add classes.
    @addClasses()
    @getVideo()

    # Add event listeners.
    @addEventListeners()
    return

  addClasses: () =>
    @layout = new Layout
    @layout.initialise()
    return

  getVideo: () =>
    options = video:true
    navigator.getUserMedia options, @onMediaStreamSuccess, @onMediaStreamError
    return

  addEventListeners: () =>
    return

  animate: () =>

    # Call the animate method using the requestAnimationFrame callback.
    @raf = requestAnimationFrame @animate
    return



  ###
  #========================================
  # Callbacks
  #========================================
  ###

  onMediaStreamSuccess: (stream) =>
    log 'onMediaStreamSuccess:', stream

    video = document.createElement 'video'
    video.autoplay = true
    video.src = window.URL.createObjectURL stream
    document.body.appendChild video

    pc1 = new webkitPeerConnection00 null, iceCallback1
    pc1.addStream stream
    offer = pc1.createOffer null
    pc1.setLocalDescription pc1.SDP_OFFER, offer
    pc1.startIce()
    return

  onMediaStreamError: (error) =>
    log error
    return

  iceCallback1: (answer) =>
    log 'iceCallback1:', answer
    pc1.setRemoteDescription pc1.SDP_ANSWER, answer
    return



# Create instance of Main class.
@RTC = RTC = new PROJECT.Main
