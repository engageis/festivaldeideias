App.Ideas.Map = ->
	pins = new App.Models.IdeasMap
	gMaps = new App.Ideas.GoogleMaps({collection: pins})
	gMaps.render()


App.Ideas.GoogleMaps = Backbone.View.extend
	initialize: ->
		_.bindAll this
		@collection.on('reset', @addAll)
		@map = $('#map_canvas')

	addAll: ->
		@collection.models.forEach (@addOne)

	addOne: (idea) ->
		pin = new App.Ideas.Pin({model: idea})
		pin.render()

	render: ->
		that = this
		@map.gmap().bind('init', (ev, map) -> that.collection.fetch())


App.Ideas.Pin = Backbone.View.extend	
	initialize: ->
		_.bindAll this
		@map = $('#map_canvas')
		@model.on('change', @render)
		@model.on('destroy', @remove)
		
	render: ->
		that = this
		latitude = @model.get('latitude')
		longitude = @model.get('longitude')
		if longitude and latitude
			that.map.gmap 'addMarker', 
				{'position': "#{latitude},#{longitude}", 'bounds': true}
			.click ->
				that.map.gmap('openInfoWindow', {'content': that.infowindowContent()}, this)

	infowindowContent: ->
		$.ajax
		  url: "/pin_show/#{@model.get('id')}"
		  success: (data) ->
		    $('#pinContent').html(data)

		'<div id="pinContent" class="infoWindow">Loading...</div>'

	remove: ->
		# console.log "Pin removed!"