express = require 'express'
mongodb = require 'mongodb'
connect = require 'connect'

App = require './src/App'

server = express()
mongoUri = process.env.MONGOLAB_URI || process.env.MONGOHQ_URL || 'mongodb://localhost/they-watchin'

mongodb.Db.connect mongoUri, (err, db) ->
  throw err if (err)

  app = new App server, db
  app.start()

port = process.env.PORT || 5000
server.use '/pub', express.static(__dirname + '/pub')
server.listen port
server.use connect.bodyParser()
