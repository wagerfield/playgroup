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
  HIDE = 'hide'



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
  $scriptWrapper: null
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
    @$scriptWrapper = @$script.find '.wrapper'
    @reset()
    $(window).on 'keydown', @onKeydown
    # @getVideo()
    return

  onKeydown: (event) =>
    event.preventDefault()
    if event.keyCode is 40
      @setNodeIndex @nodeIndex + 1
    if event.keyCode is 38
      @setNodeIndex @nodeIndex - 1
    return

  reset: () =>
    @$scriptWrapper.empty()
    return

  getVideo: () =>
    options = video:true
    navigator.getUserMedia options, @onMediaStreamSuccess, @onMediaStreamError
    return

  setUserId: (id) =>
    if @userId isnt id
      @userId = id
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
    @$scriptWrapper.append $node
    return

  setNodeIndex: (index) =>
    @$localVideo = $('#local video')
    @$remoteVideo = $('#remote > video')
    @$miniVideo = $('#mini > video')
    log 'LOCAL:', @$localVideo
    log 'REMOTE:', @$remoteVideo
    log 'MINI:', @$miniVideo
    newIndex = Math.clamp index, 0, @story.nodes.length - 1
    if @nodeIndex isnt newIndex
      @$scriptNodes.attr class:'hide'
      @nodeIndex = index
      @setNodeState index - 1, GHOST unless index is 0
      @setNodeState index + 0, ACTIVE
      @setNodeState index + 1, PENDING
      $activeNode = @$script.find '.active'
      log 'USER ID:', window.userid
      $activeNode.addClass 'b' if newIndex % 2
      top = $activeNode.position().top
      @$scriptWrapper.css top:"#{-top}px"
    return

  setNodeState: (index, state) =>
    $node = @$scriptNodes.eq index
    $node.removeClass 'hide'
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
