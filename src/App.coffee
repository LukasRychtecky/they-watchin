WatchController = require './WatchController'
express = require 'express'

class App

  constructor: (@server, @db) ->

  start: ->

    db = @db

    @server.get '/', (req, res) ->
      res.send 'They watchin!'

    @server.post '/store', (req, res) ->
      ctrl = new WatchController db, req
      ctrl.store()
      res.send 201

module.exports = App
