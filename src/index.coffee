fs = require 'fs'
sysPath = require 'path'

String::endsWith = (str) ->
  if @match(new RegExp "#{str}$") then true else false

module.exports = class HtmlCompiler
  brunchPlugin: yes
  type: 'stylesheet' # To prevent AMD wrapping
  extension: 'html'

  constructor: (@config) ->
    null

  wrapTemplate: (id, data) ->
    """
    <script type="text/template" id="#{id}">
      #{data}
    </script>
    """

  compile: (data, path, callback) ->
    try
      app = path.split(sysPath.sep)[1]
      name = sysPath.basename path, "." + @extension
      id = "#{app}-#{name}-template"
      template = @wrapTemplate id, data
    catch err
      error = err
    finally
      callback error, template

  onCompile: (generatedFiles) ->
    path = sysPath.join @config.paths.public, "tpl"
    for file in fs.readdirSync path
      curPath = sysPath.join path, file
      fs.unlinkSync curPath if file.endsWith ".map"
