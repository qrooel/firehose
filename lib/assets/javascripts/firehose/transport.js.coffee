class Firehose.Transport
  # Class method to determine whether transport is supported by the current browser. Note that while
  # the transport may be supported by the browser, its possible that the network connection won't 
  # succeed. That should be accounted for during the initial connecting to the server.
  @supported: =>
    false

  constructor: (config={}) ->
    @config = config
    @_retryDelay = 5000 

  # Lets rock'n'roll! Connect to the server.
  connect: (delay = 0) =>
    console?.log "Transport#connect", delay
    setTimeout @_request, delay
    this

  # Hey subclasses:
  stop: ->     # implement this method to stop receiving messages
  _request: -> # implement this method to handle requests

  # Default error handler
  _error: (event) =>
    console?.log "Transport#_error", event
    if @_succeeded
      # Lets try to connect again with delay
      @config.disconnected()
      @connect(@_retryDelay)
    else @config.failed @

  # Default connection established handler
  _open: (event) =>
    @_succeeded = true
    @config.connected(@)

  # Default connection closed handler
  _close: (event) =>
    @config.disconnected()