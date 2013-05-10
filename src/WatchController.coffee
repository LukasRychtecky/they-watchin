mongodb = require 'mongodb'
urlParser = require 'url'

class WatchController

  constructor: (@db, @req) ->

  store: (url) ->
    parsed = urlParser.parse url, true
    spot = parsed.query

    spots = new mongodb.Collection @db, 'spot'
    spots.insert spot, safe: true, (err, inserted) ->

module.exports = WatchController
