#============================================================
#
# CoffeeScript Imports
#
# Lists the source files to be concatenated and compiled into
# ../js/scripts.js using CodeKit's import directives.
#
# @see http://incident57.com/codekit/help.php
# @author Matthew Wagerfield
#
#============================================================

#------------------------------
# Core
#------------------------------
# @codekit-prepend "core/Array.coffee"
# @codekit-prepend "core/Math.coffee"
# @codekit-prepend "core/Ease.coffee"
# @codekit-prepend "core/Color.coffee"
# @codekit-prepend "core/WebRTC.coffee"
# @codekit-prepend "core/Utils.coffee"
# @codekit-prepend "core/Class.coffee"
# @codekit-prepend "core/Base.coffee"
# @codekit-prepend "core/Layout.coffee"

#------------------------------
# GUI
#------------------------------
# @codekit-prepend "gui/GraphController.coffee"
# @codekit-prepend "gui/GUI.coffee"

#------------------------------
# Project
#------------------------------
# @codekit-prepend "project/Main.coffee"



# Initialise the project.
$ -> RTC.initialise()
