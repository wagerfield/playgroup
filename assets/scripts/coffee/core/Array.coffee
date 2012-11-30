###
#============================================================
#
# Array augmentation.
#
# @author Matthew Wagerfield (Fantasy Interactive)
#
#============================================================
###

###
# Removes an element from an array.
# @param {Object} element Element to remove.
###
Array::remove = (element) -> @[t..t] = [] if (t = @indexOf(element)) > -1
