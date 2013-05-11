mongodb = require 'mongodb'
urlParser = require 'url'

class WatchController

  ###*
    @type {Array.<Object>}
  ###
  @spots: null

  constructor: (@db, @req, @res) ->
    @spots = new mongodb.Collection @db, 'spot'

  store: (url) ->
    parsed = urlParser.parse url, true
    spot = parsed.query
    pos = @req.headers.referer.indexOf '://'
    spot.uri = @req.headers.referer.substr(pos + 3) if pos > -1

    @spots.insert spot, safe: true, (err, inserted) ->

  map: (url) ->
    parsed = urlParser.parse url, true
    domain = parsed.query['domain']

    cur = @spots.find uri: domain

    mapData = []
    res = @res
    cur.toArray (err, spots) ->
      for spot in spots
        mapData.push x: spot.offsetX, y: spot.offsetY

      res.jsonp mapData


module.exports = WatchController
