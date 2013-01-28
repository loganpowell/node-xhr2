# http://www.w3.org/TR/XMLHttpRequest/#xmlhttprequestupload
class XMLHttpRequestUpload extends XMLHttpRequestEventTarget
  # @param {XMLHttpRequest} the XMLHttpRequest that this upload object is
  #   associated with
  constructor: (request) ->
    super()
    @_request = request
    @_reset()

  # Sets up this Upload to handle a new request.
  #
  # @private
  # @return {undefined} undefined
  _reset: ->
    @_contentType = null
    @_body = null
    undefined

  # Implements the upload-related part of the send() XHR specification.
  #
  # @private
  # @param {?String, ?Buffer, ?ArrayBufferView} data the argument passed to
  #   XMLHttpRequest#send()
  # @return {undefined} undefined
  _setData: (data) ->
    if typeof data is 'undefined' or data is null
      return

    if typeof data is 'string'
      # DOMString
      @_contentType = 'text/plain; charset=UTF-8'
      @_body = new Buffer data, 'utf-8'
    else if Buffer.isBuffer body
      # node.js Buffer
      @_contentType = 'application/octet-stream'
      @_body = data
    else if data.buffer and data.buffer instanceof ArrayBuffer
      # ArrayBufferView
      @_contentType = 'application/octet-stream'
      body = new Buffer data.byteLength
      offset = data.byteOffset
      dataBuffer = data.buffer
      body[i] = dataBuffer[i] - offset for i in [0...data.byteLength]
      @_body = body
    else
      # NOTE: diverging from the XHR specification of coercing everything else
      #       to Strings via toString() because that behavior masks bugs and is
      #       rarely useful
      throw new Error "Unsupported send() data #{data}"

    undefined

  # Updates the HTTP headers right before the request is sent.
  #
  # This is used to set data-dependent headers such as Content-Length and
  # Content-Type.
  #
  # @private
  # @param {Object<String, String>} headers the HTTP headers to be sent
  # @param {Object<String, String>} loweredHeaders maps lowercased HTTP header
  #   names (e.g., 'content-type') to the actual names used in the headers
  #   parameter (e.g., 'Content-Type')
  # @return {undefined} undefined
  _finalizeHeaders: (headers, loweredHeaders) ->
    if @_body
      # Restricted headers can't be set by the user, no need to check
      # loweredHeaders.
      headers['Content-Length'] = @_body.length.toString()

    if @_contentType
      unless loweredHeaders['content-type']
        headers['Content-Type'] = @_contentType

    undefined

  # Starts sending the HTTP request data.
  #
  # @private
  # @param {http.ClientRequest} request the HTTP request
  # @return {undefined} undefined
  _startUpload: (request) ->
    request.write @_body if @_body
    request.end()

    undefined

# Export the XMLHttpRequestUpload constructor.
XMLHttpRequest.XMLHttpRequestUpload = XMLHttpRequestUpload
