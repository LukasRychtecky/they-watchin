mongodb = require 'mongodb'

class WatchController

  constructor: (@db, @req) ->

  store: ->
    spot = @req.body

    spots = new mongodb.Collection @db, 'spot'
    spots.insert spot, safe: true, (err, inserted) ->

module.exports = WatchController
