App.Ideas.Map = ->
  pins = new App.Models.IdeasMap
  gMaps = new App.Ideas.GoogleMaps collection: pins


App.Ideas.GoogleMaps = Backbone.View.extend
  el: '#map_wrapper'
  events:
    "click .map_actions .city_control": "panMapToCity"
    "click .map_actions .state_control": "panMapToState"
    "click .map_actions .country_control": "panMapToCountry"

  initialize: ->
    _.bindAll this
    @collection.on 'reset', @addAll
    @map = $('#map_canvas')
    @render()
    @getUserLocation()

  panMapToCity: ->
    $('.map_actions .map_control').removeClass "active"
    $('.map_actions .city_control').addClass "active"
    if @user_city and @user_state and @user_country
      @panMapToPoint "#{@user_city}, #{@user_state}, #{@user_country}"
    else
      @panMapToState()
    false

  panMapToState: ->
    $('.map_actions .map_control').removeClass "active"
    $('.map_actions .state_control').addClass "active"
    if @user_state and @user_country
      @panMapToPoint "#{@user_state}, #{@user_country}"
    false

  panMapToCountry: ->
    $('.map_actions .map_control').removeClass "active"
    $('.map_actions .country_control').addClass "active"
    @mapEl.panTo @initLatLong
    @mapEl.setZoom 4
    false

  panMapToPoint: (query) ->
    that = this
    $('#map_canvas').gmap 'search', { address: query }, (results, isFound) ->
      if isFound
        that.mapEl.panTo results[0].geometry.location
        that.mapEl.fitBounds results[0].geometry.bounds

  addAll: ->
    @addOne idea for idea in @collection.models
    @setClusters()
    @centerMapOnUser()
  
  addOne: (idea) ->
    pin = new App.Ideas.Pin model: idea, bounds: @bounds
    pin.render()

  getUserLocation: ->
    navigator.geolocation.getCurrentPosition(@locationFound, @noLocation) if navigator.geolocation

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

  geocodeUserCity: (latLng) ->
    @geocoder.geocode({latLng: latLng}, (results, status) =>
      for component in results[0].address_components
        switch component.types[0]
          when "locality" then @user_city = component.long_name
          when "administrative_area_level_1" then @user_state = component.long_name
          when "country" then @user_country = component.long_name
    )

  noLocation: ->
    $('#map_wrapper .map_actions').hide()

  centerMapOnUser: ->
    if @latitude? and @longitude?
      @mapEl.panTo(new google.maps.LatLng @latitude, @longitude)
      @mapEl.setZoom(5)
      @bounds = false

  render: ->
    @initLatLong = new google.maps.LatLng -15.5, -55.0
    @geocoder = new google.maps.Geocoder()
    @bounds = true
    @map.gmap
      center: @initLatLong
      zoom: 4
    .bind 'init', (ev, map) =>
      @collection.fetch()
    @mapEl = @map.gmap 'get', 'map'

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

  spreadPin: (n) ->
    if n?
      n + (Math.random()*-.05)
    else
      n

  # remove: ->