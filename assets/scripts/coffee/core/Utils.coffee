###
#============================================================
#
# Generic Utilities
#
# @author Matthew Wagerfield
#
#============================================================
###

class Utils

  ###
  # Generates a GUID.
  # @param {number} length The length of the guid.
  # @param {string} prefix String to prefix the GUID with.
  # @return {string} The generated GUID.
  ###
  @guid = (length = 8, prefix = 'mw') ->
    guid = ((Math.random().toFixed 1).substr 2 for i in [0...length])
    guid = "#{prefix}#{guid.join ''}"
    return guid

  ###
  # Prefixes a given method.
  # @param {object} object The object to add the method to.
  # @param {string} method The method to add to the object.
  # @param {string} prefixes Array of prefixes.
  # @return {object} The object.
  ###
  @prefix = (object, method, prefixes = ['webkit', 'moz', 'ms']) ->
    return object
