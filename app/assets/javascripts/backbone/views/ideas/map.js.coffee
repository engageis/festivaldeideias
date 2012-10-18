App.Ideas.Map = ->
  pins = new App.Models.IdeasMap
  gMaps = new App.Ideas.GoogleMaps collection: pins


App.Ideas.GoogleMaps = Backbone.View.extend
  el: '#map_wrapper'
  events:
    "click .map_actions .map_control": "mapControlClicked"

  initialize: ->
    _.bindAll this
    @collection.on 'reset', @addAll
    @geolocation_message = "Você precisa permitir que saibamos sua localização para usar esse botão."
    @map = $('#map_canvas')
    @render()

  # Inserts the map into the HTML and fetches the ideas JSON
  render: ->
    @initLatLong = new google.maps.LatLng -15.5, -55.0
    @geocoder = new google.maps.Geocoder()
    @bounds = true
    @map.gmap
      center: @initLatLong
      zoom: 4
    .bind 'init', (ev, map) =>
      @collection.fetch()

  # Activated when collection is fetched.
  addAll: ->
    @addOne idea for idea in @collection.models
    @mapEl = @map.gmap 'get', 'map'
    @setClusters()
    @getUserLocation()

  # Adds a Pin view to each idea in the Map
  addOne: (idea) ->
    pin = new App.Ideas.Pin model: idea, bounds: @bounds
    pin.render()

  mapControlClicked:(e)->
    $el = $(e.target)
    $('.map_actions .map_control').removeClass "active"
    $el.addClass "active"
    if $el.hasClass "city_control" then @panMapToCity()
    else if $el.hasClass "state_control" then @panMapToState()
    else if $el.hasClass "country_control" then @panMapToCountry()
    false

  panMapToCity: ->
    if @user_city and @user_state and @user_country
      @panMapToPoint "#{@user_city}, #{@user_state}, #{@user_country}"
    else
      @panMapToState()

  panMapToState: ->
    if @user_state and @user_country
      @panMapToPoint "#{@user_state}, #{@user_country}"
    else
      alert @geolocation_message

  panMapToCountry: ->
    @mapEl.panTo @initLatLong
    @mapEl.setZoom 4

  # Queries a location with geocoder a pans the map to it
  panMapToPoint: (query) ->
    that = this
    $('#map_canvas').gmap 'search', { address: query }, (results, isFound) ->
      if isFound
        that.mapEl.panTo results[0].geometry.location
        that.mapEl.fitBounds results[0].geometry.bounds

  getUserLocation: ->
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition(@locationFound, @noLocation)
    else
      @geolocation_message = "Seu browser não possui geolocalização :("

  # Stores some user variables
  locationFound: (position) ->
    @latitude = position.coords.latitude
    @longitude = position.coords.longitude
    @geocodeUserCity(new google.maps.LatLng(@latitude, @longitude))
    
    $.post "/users/store_location",
      {
        latitude: @latitude
        longitude: @longitude
      }
    @centerMapOnUser()

  # Geocode users latitude and longitude to get its address
  geocodeUserCity: (latLng) ->
    @geocoder.geocode({latLng: latLng}, (results, status) =>
      for component in results[0].address_components
        switch component.types[0]
          when "locality" then @user_city = component.long_name
          when "administrative_area_level_1" then @user_state = component.long_name
          when "country" then @user_country = component.long_name
    )

  # If user reject to show its location, then the Map controls disappear
  noLocation: ->
    $('#map_wrapper .map_actions').hide()

  centerMapOnUser: ->
    if @latitude? and @longitude?
      @clientPosition = new google.maps.LatLng @latitude, @longitude
      # @mapEl.panTo(@clientPosition)
      # @mapEl.setZoom(5)
      @map.gmap('addShape', 'Circle', { strokeColor: "#008595", strokeOpacity: 0.3, strokeWeight: 2, fillColor: "#008595", fillOpacity: 0.25, center: @clientPosition, radius: 2100 })
      @map.gmap('addShape', 'Circle', { strokeColor: "#F6A032", strokeOpacity: 0.8, strokeWeight: 2, fillColor: "#F6A032", fillOpacity: 0.4, center: @clientPosition, radius: 80 })
      @bounds = false

  setClusters: ->
    @map.gmap('set', 'MarkerClusterer',
      new MarkerClusterer(@mapEl, @map.gmap('get', 'markers'), 
        gridSize: 60
        maxZoom: 12
        styles:
          [
            {url: 'assets/pins/small_pin_group.png', width: 34, height: 49, anchor: [9,0], textColor: '#333', textSize: 14},
            {url: 'assets/pins/medium_pin_group.png', width: 34, height: 49, anchor: [9,0], textColor: '#cc7732', textSize: 14},
            {url: 'assets/pins/big_pin_group.png', width: 34, height: 49, anchor: [9,0], textColor: '#bc3f43', textSize: 14}
          ]
      ))

App.Ideas.Pin = Backbone.View.extend
  initialize: (options) ->
    _.bindAll this
    @bounds = options.bounds
    @map = $('#map_canvas')
    @model.on 'change', @render
    # @model.on 'destroy', @remove
    
  render: ->
    that = this
    city = @model.get 'city'
    state = @model.get 'state'
    country = @model.get 'country'
    latitude = @spreadPin(@model.get 'latitude')
    longitude = @spreadPin(@model.get 'longitude')
    markerImg = @model.get("category").badge.replace /\/badges\//g, "\/pins\/"

    if longitude and latitude and country is "Brazil"
      that.map.gmap 'addMarker'
          position: "#{latitude},#{longitude}"
          bounds:   that.bounds
          icon:     markerImg
          city: city
          state: state
      .click -> that.openInfo this

  openInfo: (el) ->
     @map.gmap 'openInfoWindow', content: @infowindowContent(), el

  infowindowContent: ->
    $.ajax
      url: "/ideas/#{@model.get('id')}/pin_show"
      success: (data) ->
        $('#pinContent').html data

    "<div id=\"pinContent\" class=\"infoWindow\">Loading...</div>"

  # Spreads the pins around the map, cause they were located by IP, so their location would be almost the same
  spreadPin: (n) ->
    if n?
      n + (Math.random()*-.05)
    else
      n

  # remove: ->