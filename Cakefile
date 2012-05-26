fs = require 'fs'
fsExt = require 'fs.extra'

{print, log} = require 'util'
{spawn} = require 'child_process'

ws = require 'ws'
http = require 'http'
url = require 'url'
file = require 'file'


{Inotify} = require 'inotify'


partial = (func, a...) ->
  (b...) -> func a..., b...


attach = (proc) ->


getExt = (path) -> path.substring (path.lastIndexOf '.') + 1
getFile = (path) -> path.substring (path.lastIndexOf '/') + 1, path.length
getFileName = (path) -> path.substring (path.lastIndexOf '/') + 1, (path.lastIndexOf '.')


hasExt = (ext, file) -> (getExt file) == ext
anyExt = (exts, file) -> exts.any (ext) -> hasExt ext, file

spawnThen = (exec, args, func) ->

  proc = spawn exec, args
  proc.stderr.on 'data', (data) ->
    process.stderr.write data.toString()
  proc.stdout.on 'data', (data) ->
    print data.toString()

  proc.on 'exit', (code, sig) -> func()


tempExt = "___tmp___"

buildCoffee = (dst, path) ->

  log "coffee: #{getFile path}"
  spawnThen 'coffee', ['-c', '-o', dst, path], ->



buildLess = (dst, path) ->
  log "lessc: #{getFile path}"

  dstFile = "#{dst}/#{getFileName path}.css"
  spawnThen 'lessc', [path, dstFile], ->


clients = {}

notify = (path) ->
  log "notify: #{path}"

  for id, client of clients
    request = JSON.stringify  {
      command: 'reload',
      path: path,
      liveCSS: true
    }

    client.send request


sources =
{
    less : {
      paths : ['app/less'],
      types : ['less']

      build : partial buildLess, 'app/css'
    },

    coffee : {
      paths : ['app/src'],
      types : ['coffee']

      build : partial buildCoffee, 'app/js'
    }

    reload : {
      paths  : ['app'],
      types  : ['css', 'js', "html", 'jpg', 'png']
      build  : notify
    }
}


String::startsWith =  (str) -> @indexOf(str) == 0
Array::any =  (f) -> @some f

inPaths  = (paths, file) ->
  paths.any (path) -> file.startsWith path

getFiles = (dir, f) ->
  log "???"

  files = fs.readdirSync dir
  files.filter f


task 'build', 'Build all', ->
  for name, {types, paths, build} of sources
    for path in paths

      fileDir = -> getFiles path, (name) -> anyExt types, name
      isFile = -> fs.statSync(path).isFile path

      files = if isFile() then [path] else fileDir()

      for file in files
        build "#{path}/#{file}"

task 'watch', 'Watch all', ->
  reloadServer()
  httpServer = staticServer "app", 8000

  monitor ".",  (file) ->
    for name, {types, paths, build} of sources

      if (inPaths paths, file) &&  (anyExt types, file)
        build file


monitor = (dir, update) ->
  watcher = new Inotify();

  file.walk dir, (nulls, dirPath, dirs, files) ->

    watcher.addWatch {
      path: dirPath,
      watch_for: Inotify.IN_CLOSE_WRITE | Inotify.IN_MOVED_FROM
      callback: (event) ->
        update "#{dirPath}/#{event.name}"
    }


staticServer = (path, port) ->
  httpServer = http.createServer (request, response) ->
    log "#{request.method} #{request.url}"

    relPath = url.parse(request.url).pathname
    requestPath = path + relPath

    mimeMap = {
      'txt': 'text/plain',
      'html': 'text/html',
      'css': 'text/css',
      'xml': 'application/xml',
      'json': 'application/json',
      'js': 'application/javascript',
      'jpg': 'image/jpeg',
      'jpeg': 'image/jpeg',
      'gif': 'image/gif',
      'png': 'image/png'
    };

    fileResponse = ->

      data = fs.readFileSync requestPath, data
      contentType =  mimeMap[getExt requestPath] or "text/plain"

      response.writeHeader  200, {"Content-Type": contentType}
      response.write data
      response.end()

    dirResponse = ->

      files = fs.readdirSync requestPath
      response.writeHeader  200, {"Content-Type": "text/html"}

      fileInfo = (file) -> "<li><a href='#{relPath}/#{file}'>#{file}</a></li>"
      html = """
        <doctype !html>
        <html>
        <body> <h1> #{request.url}</h1>
        <ul> #{(files.map fileInfo).join('')} </ul>
        </body>
        </html>
      """
      response.write html
      response.end()

    try
      stat = fs.statSync requestPath

      if stat.isDirectory() then dirResponse()
      if stat.isFile() then fileResponse()

    catch err
      log "#{request.url} - #{err}\n"

      response.writeHeader 404, {"Content-Type": "text/plain"};
      response.write "#{request.url} - #{err}\n"
      response.end()

  httpServer.listen port
  log "http listening on #{port}"

  return httpServer


objectSize = (obj) ->
  size = 0
  for key of obj
    size++
  return size


reloadServer = ->

  port = 35729
  id = 0
  httpServer = staticServer "app/lib/livereload", port

  wsServer = new ws.Server {server : httpServer}, ->
    log "web sockets listening on #{port}"

  wsServer.on 'connection', (socket) ->
    log "connection made"

    socket.id = id++

    socket.on 'close', () ->
      delete clients[socket.id]
      log "close: #{objectSize clients} clients listening"

    socket.on 'message', (message) ->
      log "message: #{message}"

      cmd = JSON.parse(message)
      switch cmd.command
        when "hello"
          response = JSON.stringify {
              command: 'hello',
              protocols: [
                'http://livereload.com/protocols/official-7',
                'http://livereload.com/protocols/official-8',
                'http://livereload.com/protocols/official-9',
                'http://livereload.com/protocols/2.x-origin-version-negotiation',
                'http://livereload.com/protocols/2.x-remote-control'],
              serverName: 'Caffine reload 0.1'
          }

          socket.send response

          clients[socket.id] = socket
          log "#{objectSize clients} clients listening"



