###
#============================================================
#
# Playgroup: Story Controller
#
# @author Matthew Wagerfield
#
#============================================================
###

class CONTROLLERS.Story extends CONTROLLERS.Controller

  ###
  #========================================
  # Constants
  #========================================
  ###

  CHARACTER = 'CHARACTER'
  DIRECTION = 'DIRECTION'

  GHOST = 'ghost'
  ACTIVE = 'active'
  ACTIVE_USER = 'active user'
  PENDING = 'pending'
  PENDING_USER = 'pending user'



  ###
  #========================================
  # Class Variables
  #========================================
  ###

  @class = 'CONTROLLERS.Story'



  ###
  #========================================
  # Instance Variables
  #========================================
  ###

  $profiles: null
  $profileNodes: null
  $script: null
  $scriptNodes: null

  story: null
  userId: null
  userVideo: null

  nodeIndex: null



  ###
  #========================================
  # Instance Methods
  #========================================
  ###

  initialise: () =>
    @$profiles = @$context.find '#profiles'
    @$profileNodes = @$profiles.find '.profile'
    @$script = @$context.find '#script'
    @reset()
    # @getVideo()
    return

  reset: () =>
    @$script.empty()
    return

  getVideo: () =>
    options = video:true
    navigator.getUserMedia options, @onMediaStreamSuccess, @onMediaStreamError
    return

  setUserId: (id) =>
    if @userId isnt id
      @userId = id
      log 'setUserId:', id
    return

  setStory: (story) =>
    if @story isnt story
      @story = story
      @reset()
      @parseStory story
    return

  parseStory: (story) =>
    @createNode node for node in story.nodes
    @$scriptNodes = @$script.find 'p'
    @start()
    return

  createNode: (node) =>
    $node = $("<p>#{node.text}</p>")
    $node.data CHARACTER, node.character
    $node.data DIRECTION, node.direction
    @$script.append $node
    return

  setNodeIndex: (index) =>
    if @nodeIndex isnt index
      @nodeIndex = index
      @setNodeState @nodeIndex - 1, GHOST
      @setNodeState @nodeIndex + 0, ACTIVE
      @setNodeState @nodeIndex + 1, PENDING
    return

  setNodeState: (index, state) =>
    log 'setNodeState:', index, state
    $node = @$scriptNodes.eq index
    $node.addClass state
    return

  addEventListeners: () =>
    return

  start: () =>
    @setNodeIndex 0
    return



  ###
  #========================================
  # Callbacks
  #========================================
  ###

  onMediaStreamSuccess: (stream) =>

    @userVideo = document.createElement 'video'
    @userVideo.autoplay = true
    @userVideo.src = window.URL.createObjectURL stream
    document.body.appendChild @userVideo

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
