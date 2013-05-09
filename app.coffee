express = require 'express'

app = express.createServer express.logger()

app.get '/', (req, res) ->
  res.send 'They watchin!'


port = process.env.PORT || 5000
app.listen port, ->
  console.log "Listening on #{port}"
