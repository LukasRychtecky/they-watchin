goog.provide 'tw.start'

goog.require 'goog.events'
goog.require 'goog.events.EventType'
goog.require 'goog.Uri.QueryData'
goog.require 'goog.structs.Map'
goog.require 'heatmap'
goog.require 'goog.style'
goog.require 'goog.net.Jsonp'
goog.require 'goog.ui.KeyboardShortcutHandler'
goog.require 'goog.date.DateTime'

###*
  @param {Window} win
  @param {string=} host
###
tw.start = (win, host) ->
  url = "#{host || 'http://they-watchin.herokuapp.com'}/store"

  goog.events.listen win.document.body, goog.events.EventType.CLICK, (e) ->

    spot =
      "tagName": e.target.tagName
      "className": e.target.className
      "targetId": e.target.id
      "bodyOffsetHeight": win.document.body.offsetHeight
      "bodyOffsetWidth": win.document.body.offsetWidth
      "bodyOffsetLeft": goog.style.getPageOffsetLeft win.document.body
      "bodyOffsetTop": goog.style.getPageOffsetTop win.document.body
      "created": new goog.date.DateTime().toIsoString()

    for key in ['clientX', 'clientY', 'offsetX', 'offsetY', 'screenX', 'screenY', 'type']
      spot[key] = e[key]

    data = goog.Uri.QueryData.createFromMap new goog.structs.Map(spot)
    win.document.createElement('img').src = "#{url}?#{data}"

goog.exportSymbol 'tw.start', tw.start

###*
  @param {Window} win
  @param {string=} host
###
tw.map = (win, host) ->

  url = "#{host || 'http://they-watchin.herokuapp.com'}/map/"

  loc = win.location
  domain = goog.Uri.QueryData.createFromMap new goog.structs.Map(domain: loc.host + loc.pathname + loc.search)

  jsonp = new goog.net.Jsonp "#{url}?#{domain}"
  jsonp.send {}, (res) ->

    el = win.document.createElement 'div'
    el.id = 'heatmap'
    win.document.body.appendChild el

    config =
      element: el
      radius: 15
      opacity: 100

    mapStyles =
      width: win.document.body.offsetWidth + 'px'
      height: win.document.body.offsetWidth + 'px'
      position: 'absolute'
      top: 0
      left: 0
      display: 'none'

    goog.style.setStyle el, mapStyles

    map = heatmap.create config
    data =
      max: 20
      data: res
    map.store.setDataSet data

    shortcutHandler = new goog.ui.KeyboardShortcutHandler document
    shortcutHandler.registerShortcut 'META_J', 'meta+j'
    goog.events.listen shortcutHandler, goog.ui.KeyboardShortcutHandler.EventType.SHORTCUT_TRIGGERED, (e) ->
      goog.style.setElementShown el, !goog.style.isElementShown(el)

goog.exportSymbol 'tw.map', tw.map

