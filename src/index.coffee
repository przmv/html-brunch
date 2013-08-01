module.exports = class HtmlCompiler
  brunchPlugin: yes
  type: 'template'
  extension: 'html'

  constructor: (@config) ->
    null

  compile: (data, path, callback) ->
    try
      # Do stuff here:
      #   Wrap templates,
      #   Join templates on per sub-app basis
      #   Save joined files to assets/tpl (so brunch could count them on copy)
    catch err
      error = err
    finally
      # Return null because we're not going to join templates into one file
      callback error, null

  onCompile: (generatedFiles) ->
    # remove assets/tpl
