App.Ideas.Map = ->
	pins = new App.Models.IdeasMap
	gMaps = new App.Ideas.GoogleMaps collection: pins


App.Ideas.GoogleMaps = Backbone.View.extend
	# el: '#map_canvas'
  # events:
  #   "click .comments a.reply": "reply"

	initialize: ->
		_.bindAll this
		@collection.on 'reset', @addAll
		@map = $('#map_canvas')
		@render()
		@getUserLocation()

	getUserLocation: ->
		navigator.geolocation.getCurrentPosition(@locationFound, @noLocation) if navigator.geolocation

	locationFound: (position) ->
		@latitude = position.coords.latitude
		@longitude = position.coords.longitude
		$.post "/users/store_location",
			{
				latitude: @latitude
				longitude: @longitude
			}
		@centerMap()

	noLocation: ->
		# @render()

	centerMap: ->
		if @latitude? and @longitude?
			@el.panTo(new google.maps.LatLng @latitude, @longitude)
			@el.setZoom(5)
			@bounds = false

	addAll: ->
		@addOne idea for idea in @collection.models
		@setClusters()
		@centerMap()

	setClusters: ->
		@map.gmap('set', 'MarkerClusterer',
			new MarkerClusterer(@el, @map.gmap('get', 'markers'), 
				gridSize: 60
				maxZoom: 12
				styles:
					[
						url: 'assets/pins/small_pin_group.png'
						width: 34
						height: 49
						anchor: [9,0]
						textColor: '#333'
						textSize: 14
					,
						url: 'assets/pins/medium_pin_group.png'
						width: 34
						height: 49
						anchor: [9,0]
						textColor: '#cc7732'
						textSize: 14
					,
						url: 'assets/pins/big_pin_group.png'
						width: 34
						height: 49
						anchor: [9,0]
						textColor: '#bc3f43'
						textSize: 14
					]
			))

	addOne: (idea) ->
		pin = new App.Ideas.Pin model: idea, bounds: @bounds
		pin.render()

	render: ->
		initLatLong = new google.maps.LatLng -10.0, -55.0
		@bounds = true
		@map.gmap
			center: initLatLong
			zoom: 4
		.bind 'init', (ev, map) =>
			@collection.fetch()
		@el = @map.gmap 'get', 'map'


App.Ideas.Pin = Backbone.View.extend
	initialize: (options) ->
		_.bindAll this
		@bounds = options.bounds
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
					bounds: 	that.bounds
					icon:			markerImg
			.click ->	that.openInfo this

	openInfo: (el) ->
		 @map.gmap 'openInfoWindow', content:	@infowindowContent(), el

	infowindowContent: ->
		$.ajax
		  url: "/ideas/#{@model.get('id')}/pin_show"
		  success: (data) ->
		    $('#pinContent').html data

		"<div id=\"pinContent\" class=\"infoWindow\">Loading...</div>"

	spreadPin: (n) ->
		if n?
			n + (Math.random()*-.05)
		else
			n

	remove: ->
		# console.log "Pin removed!"