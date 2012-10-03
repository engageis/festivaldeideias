App.Ideas.Map = ->
	pins = new App.Models.IdeasMap
	gMaps = new App.Ideas.GoogleMaps collection: pins
	gMaps.render()


App.Ideas.GoogleMaps = Backbone.View.extend
	initialize: ->
		_.bindAll this
		@collection.on 'reset', @addAll
		@map = $('#map_canvas')

	addAll: ->
		@addOne idea for idea in @collection.models
		@map.gmap('set', 'MarkerClusterer', new MarkerClusterer(@mapEl, @map.gmap('get', 'markers')))

	addOne: (idea) ->
		pin = new App.Ideas.Pin model: idea
		pin.render()

	render: ->
		brazilLatLong = new google.maps.LatLng -10.0, -55.0
		@map.gmap
			center: brazilLatLong
			zoom: 4
		.bind 'init', (ev, map) =>
			@collection.fetch()
		@mapEl = @map.gmap 'get', 'map'


App.Ideas.Pin = Backbone.View.extend
	initialize: ->
		_.bindAll this
		@map = $('#map_canvas')
		@model.on 'change', @render
		@model.on 'destroy', @remove
		
	render: ->
		that = this
		country = @model.get 'country'
		latitude = @spreadPin(@model.get 'latitude')
		longitude = @spreadPin(@model.get 'longitude')
		markerImg = @model.get("category").badge.replace /\/badges\//g, "\/pins\/"

		if longitude and latitude and country is "Brazil"
			that.map.gmap 'addMarker'
					position: "#{latitude},#{longitude}"
					bounds: 	true
					icon:			markerImg
			.click ->	that.openInfo this

	openInfo: (el) ->
		 @map.gmap 'openInfoWindow', content:	@infowindowContent(), el

	infowindowContent: ->
		$.ajax
		  url: "/pin_show/#{@model.get('id')}"
		  success: (data) ->
		    $('#pinContent').html data

		"<div id=\"pinContent\" class=\"infoWindow\">Loading...</div>"

	spreadPin: (n) ->
		if n? then n + (Math.random()*-.05) else null

	remove: ->
		# console.log "Pin removed!"