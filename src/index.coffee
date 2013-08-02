sysPath = require 'path'
mkdirp = require 'mkdirp'
fs = require 'fs'

String::endsWith = (str) ->
  if @match(new RegExp "#{str}$") then true else false

rmdirRecursiveSync = (path) ->
  if fs.existsSync path
    for file in fs.readdirSync path
      curPath = sysPath.join path, file
      if fs.statSync(curPath).isDirectory()
        rmdirRecursiveSync curPath
      else
        fs.unlinkSync curPath
    fs.rmdirSync path

module.exports = class HtmlCompiler
  brunchPlugin: yes
  type: 'template'
  extension: 'html'

  constructor: (@config) ->
    null

  wrapTemplate: (id, data) ->
    """
    <script type="text/template" id="#{id}">
      #{data}
    </script>
    """

  getAssetsDir: ->
    "app/assets"

  getTemplatesDir: ->
    if @config.files.templates.joinTo.endsWith sysPath.sep
      tpl = @config.files.templates.joinTo
    else
      tpl = sysPath.dirname @config.files.templates.joinTo

    sysPath.join @getAssetsDir(), tpl


  compile: (data, path, callback) ->
    try
      app = path.split(sysPath.sep)[1]
      name = sysPath.basename path, "." + @extension
      id = "#{app}-#{name}-template"
      template = @wrapTemplate id, data
      fname = sysPath.join @getTemplatesDir(), "#{app}.#{@extension}"
      mkdirp.sync sysPath.dirname fname
      fs.appendFileSync(fname, template)
    catch err
      error = err
    finally
      # Return null because we're not going to join templates into one file
      callback error, null

  onCompile: (generatedFiles) ->
    rmdirRecursiveSync @getTemplatesDir()
