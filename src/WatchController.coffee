mongodb = require 'mongodb'

class WatchController

  constructor: (@db, @req) ->

  store: ->
    spot = @req.body
    spot.host = @req.headers.host
    spot.origin = @req.headers.origin

    spots = new mongodb.Collection @db, 'spot'
    spots.insert spot, safe: true, (err, inserted) ->
      console.log inserted

module.exports = WatchController
