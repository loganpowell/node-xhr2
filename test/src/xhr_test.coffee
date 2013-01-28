describe 'XMLHttpRequest', ->
  beforeEach ->
    @xhr = new XMLHttpRequest

  describe 'constructor', ->
    it 'sets readyState to UNSENT', ->
      expect(@xhr.readyState).to.equal XMLHttpRequest.UNSENT

    it 'sets timeout to 0', ->
      expect(@xhr.timeout).to.equal 0

    it 'sets responseType to ""', ->
      expect(@xhr.responseType).to.equal ''

    it 'sets status to 0', ->
      expect(@xhr.status).to.equal 0

    it 'sets statusText to ""', ->
      expect(@xhr.statusText).to.equal ''

  describe '#open', ->
    it 'rejects non-HTTP URL schemes', ->

    it 'throws SecurityError on CONNECT', ->
      expect(=> @xhr.open 'CONNECT', 'https://localhost:8911/test').to.
          throw(SecurityError)

    describe 'with a GET for a local https request', ->
      beforeEach ->
        @xhr.open 'GET', 'https://localhost:8911/test/fixtures/hello.txt'

      it 'sets readyState to OPENED', ->
        expect(@xhr.readyState).to.equal XMLHttpRequest.OPENED

  describe '#send', ->
    describe 'on a local https GET', ->
      beforeEach ->
        @xhr.open 'GET', 'https://localhost:8911/test/fixtures/hello.txt'

      it 'kicks off the request', (done) ->
        @xhr.onload = (event) =>
          expect(@xhr.status).to.equal 200
          expect(@xhr.responseText).to.equal 'Hello world!\n'
          done()
        @xhr.send()

  describe 'on a local gopher GET', ->
    describe '#open + #send', ->
      it 'throw a NetworkError', ->
        expect(=>
          @xhr.open 'GET', 'gopher:localhost:8911'
          @xhr.send()
        ).to.throw(NetworkError)

