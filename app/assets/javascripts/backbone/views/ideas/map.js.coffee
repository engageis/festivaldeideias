App.Ideas.Map = App.BaseView.extend
	
	initialize: ->
		_.bindAll this
		@map = $('#map_canvas')
		@initializeMap()

	addMarkers: (ideas) ->
		that = this
		ideas.map (idea) ->
			title = idea.get('title')
			latitude = idea.get('latitude')
			longitude = idea.get('longitude')
			if longitude and latitude
				that.map.gmap 'addMarker', 
					{'position': latitude+','+longitude, 'bounds': true}
				.click ->
					that.map.gmap('openInfoWindow', {'content': title}, this)

	initializeMap: ->
		that = this
		@map.gmap().bind('init', (ev, map) ->
			ideas = new App.Models.IdeasMap()
			ideas.fetch().complete ->
				that.addMarkers(ideas)
		)