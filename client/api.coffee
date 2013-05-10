goog.provide 'tw.start'

goog.require 'goog.events'
goog.require 'goog.events.EventType'
goog.require 'goog.Uri.QueryData'
goog.require 'goog.structs.Map'

###*
  @param {Document} dom
  @param {string=} host
###
tw.start = (dom, host) ->
  url = "#{host || 'http://they-watchin.herokuapp.com'}/store"

  goog.events.listen dom.body, goog.events.EventType.CLICK, (e) ->

    spot =
      baseURI: e.target.baseURI
      tagName: e.target.tagName
      className: e.target.className
      targetId: e.target.id


    for key in ['clientX', 'clientY', 'offsetX', 'offsetY', 'screenX', 'screenY', 'type']
      spot[key] = e[key]

    data = goog.Uri.QueryData.createFromMap new goog.structs.Map(spot)
    dom.createElement('img').src = "#{url}?#{data}"



goog.exportSymbol 'tw.start', tw.start
