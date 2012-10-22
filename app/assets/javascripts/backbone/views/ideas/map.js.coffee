App.Ideas.Map = ->
  pins = new App.Models.IdeasMap
  gMaps = new App.Ideas.GoogleMaps collection: pins


App.Ideas.GoogleMaps = Backbone.View.extend
  el: '#map_wrapper'
  events:
    "click .map_actions .map_control": "mapControlClicked"

  initialize: ->
    _.bindAll this
    @already_used_latlng = []
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
    pin = new App.Ideas.Pin model: idea, bounds: @bounds, already_used_latlng: @already_used_latlng
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
      @geolocation_message = "Seu navegador não possui geolocalização :("

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
    @setUserLocation()

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
    # $('#map_wrapper .map_actions').hide()

  setUserLocation: ->
    if @latitude? and @longitude?
      that = @
      @clientPosition = new google.maps.LatLng @latitude, @longitude
      @map.gmap('addShape', 'Circle', { strokeColor: "#008595", strokeOpacity: 0.2, strokeWeight: 2, fillColor: "#008595", fillOpacity: 0.15, center: @clientPosition, radius: 2100 })
      @bounds = false
      
      @map.gmap 'addMarker'
        position: "#{@latitude},#{@longitude}"
        bounds:   @bounds
      .click ->
        that.map.gmap 'openInfoWindow', {content: "<strong>Você está aqui</strong>"}, this

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
    @already_used_latlng = options.already_used_latlng
    @map = $('#map_canvas')
    @model.on 'change', @render
    # @model.on 'destroy', @remove
    
  render: ->
    that = this
    latitude = @model.get 'latitude'
    longitude = @model.get 'longitude'
    country = @model.get 'country'
    markerImg = @model.get("category").badge.replace /\/badges\//g, "\/pins\/"

    if longitude and latitude and country is "Brazil"
      
      if _.contains(@already_used_latlng, "#{latitude},#{longitude}")
        latitude = @spreadPin(@model.get 'latitude')
        longitude = @spreadPin(@model.get 'longitude')
      else
        @already_used_latlng.push "#{latitude},#{longitude}"

      that.map.gmap 'addMarker'
          position: "#{latitude},#{longitude}"
          bounds:   that.bounds
          icon:     markerImg
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