WatchController = require './WatchController'
express = require 'express'

class App

  constructor: (@server, @db) ->

  start: ->

    db = @db

    @server.get '/', (req, res) ->
      res.send 'They watchin!'

    @server.get '/store', (req, res) ->
      ctrl = new WatchController db, req
      ctrl.store(req.url)
      res.send 200

module.exports = App
