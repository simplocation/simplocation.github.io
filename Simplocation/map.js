/**
 * Moves the map to display over Boston using viewBounds
 *
 * @param  {H.Map} map      A HERE Map instance within the application
 */
var platform = new H.service.Platform({
  'app_id': 'M12YLplVuPLMhsBT20pP',
  'app_code': 't2UvEvgElHMbSSgZ58iZvw',
  useCIT: true,
  useHTTPS: true
});

var defaultLayers = platform.createDefaultLayers();

// Instantiate the map:
mapInit();


function mapInit() {
	var map = new H.Map(
	document.getElementById('map'),
	defaultLayers.normal.map,
	{
  		zoom: 10,
  		center: { lat: -41.27, lng: 174.77  }
	});
	var ui = H.ui.UI.createDefault(map, defaultLayers);

	// leafletMap();
	jsonMap(map);
}

function leafletMap(){
var map = L.map('map').setView([-41.27, 174.77], 10);
L.tileLayer('http://{s}.{base}.maps.cit.api.here.com/maptile/2.1/{type}/{mapID}/{scheme}/{z}/{x}/{y}/{size}/{format}?app_id={app_id}&app_code={app_code}&lg={language}', {
  attribution: 'Map &copy; 2016 <a href="http://developer.here.com">HERE</a>',
  subdomains: '1234',
  base: 'base',
  type: 'maptile',
  scheme: 'normal.day',
  app_id: 'M12YLplVuPLMhsBT20pP',
  app_code: 't2UvEvgElHMbSSgZ58iZvw',
  mapID: 'newest',
  maxZoom: 20,
  language: 'eng',
  format: 'png8',
  size: '256'
}).addTo(map);
// var marker = L.marker([52.53, 13.38]).addTo(map);


L.tileLayer('http://tiles-a.data-cdn.linz.govt.nz/services;key=459d12e9005c421492794e95c9c7e746/tiles/v4/set=69/EPSG:3857/{z}/{x}/{y}.png', {
  attribution: 'Map &copy; 2016 <a href="http://developer.here.com">HERE</a>',
  subdomains: '1234',
  base: 'base',
  type: 'maptile',
  scheme: 'normal.day',
  app_id: 'M12YLplVuPLMhsBT20pP',
  app_code: 't2UvEvgElHMbSSgZ58iZvw',
  mapID: 'newest',
  maxZoom: 20,
  language: 'eng',
  format: 'png8',
  size: '256'
}).addTo(map);
}

function jsonMap(map) {
	// Fetch the geojson file
	var map = map;
  	$.ajax({
    	url: "http://api.data.linz.govt.nz/api/vectorQuery.json?key=459d12e9005c421492794e95c9c7e746&layer=772&x=175.1235847969818&y=-40.738920713622406&max_results=100&radius=10000&geometry=true&with_field_names=true",
    	
    	success:  function(dataFromServer){
      	var layers = dataFromServer.vectorQuery.layers;
      	for (i in layers) {
			     for(var i=0; i < layers.length; i++){
            console.log(layers);
           }
      console.log(layers[i]);
			var layer = layers[i];
			console.log(layer.features);
			layers.forEach(console.log('hello'));
      	};

      	jsonToMap(dataFromServer,map);

    	},
    	error: function(){
      	console.log('cannot connect to users');
    	}
  	});
}

function addPolygonToMap(map) {
	
	var geoStrip = new H.geo.Strip(
	[-41.27, 174.77, 100, -41.23, 174.76, 100, -41.23, 174.78, 100, -41.27, 174.77, 100]
	// '-41.27, 174.77'
	);
	// console.log(geoStrip);
	map.addObject(
	new H.map.Polygon(geoStrip, {
		style: {
			fillColor: 'rgba(0,0,0,0.25)',
			strokeColor: '#323232',
			lineWidth: 1
				}
		})
	);
}

function jsonToMap(data,map){
  		
  	var behavior = new H.mapevents.Behavior(new H.mapevents.MapEvents(map));
	addPolygonToMap(map);
}  




// // Create the default UI:
// var ui = H.ui.UI.createDefault(map, defaultLayers);


// // Create reader object initializing it with a document:
// var reader = new H.data.kml.Reader('/mapdata/nz-parcels.kml'),

// // Parse the document:
// reader.parse();

// // Get KML layer from the reader object and add it to the map:
// layer = reader.getLayer();
// map.addLayer(layer);

// // KML objects receive regular map events, so add an event listener to the 
// // KML layer:
// layer.getProvider().addEventListener('tap', function(ev) {
// // Log map object data. They contain name, description (if present in 
// // KML) and the KML node itself.
// console.log(ev.target.getData());
// });


// function setMapViewBounds(map){
//   var bbox = new H.geo.Rect(42.3736,-71.0751,42.3472,-71.0408);
//   map.setViewBounds(bbox);
// }