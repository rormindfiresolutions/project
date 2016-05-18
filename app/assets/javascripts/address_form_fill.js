/* Auto-fill of fields address_1, city, state, pincode using Google Maps API */
var placeSearch, address_address_1;
var address=[];
var componentForm = {
  sublocality_level_2: 'address_address_1',
  sublocality_level_1: 'address_address_2',
  locality: 'address_city',
  administrative_area_level_1: 'address_state',
  postal_code: 'address_pincode'
};

function initAutocomplete() {
  address_address_1 = new google.maps.places.Autocomplete(
																						(document.getElementById('address_address_1')),
      {types: ['geocode']});

  address_address_1.addListener('place_changed', fillInAddress);
}

function fillInAddress() {
	address=[];
  var place = address_address_1.getPlace();
  for (var i = 0; i < place.address_components.length; i++) {
    var addressType = place.address_components[i].types[0];
    if (componentForm[addressType]) {
      var val = place.address_components[i]['long_name'];
      document.getElementById(componentForm[addressType]).value = val;
    }
  }
}

function geolocate() {
  if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(function(position) {
      var geolocation = {
        lat: position.coords.latitude,
        lng: position.coords.longitude
      };
      var circle = new google.maps.Circle({
        center: geolocation,
        radius: position.coords.accuracy
      });
      address_address_1.setBounds(circle.getBounds());
    });
  }
}



