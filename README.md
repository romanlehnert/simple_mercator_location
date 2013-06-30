# Simple Mercator Location

A Ruby lib that uses the [Mercator Projection](https://en.wikipedia.org/wiki/Mercator_projection) to convert WSG84 coordinates (latitude, longitude) to meters, pixels and tiles. 

## Usage

Just add it to your Gemfile:

```ruby
gem "simple_mercator_location"
```


### Calculating the googe maps tile numbers for a given lat/lon at a specified zoom level
```ruby
place = {lat: 40.689359, lon: -74.045197}
SimpleMercatorLocation.new(place).zoom_at(11).to_tile # <= [602,770]
```
You can use these data to get a tile for a given location via google map url: 
```
https://khms0.google.com/kh/v=131&src=app&x=602&y=770&z=11&s=Gal
```


### Convert lat/lon to pixels at a given zoom level for google maps
At its first zoom level (0), google assumes the world tile to display the whole world. At a higher zoom level n (>2), google uses 2^n tiles to display the whole world. Every tile has 256x256 pixels. #to_px retuns the pixels on the whole map for a given zoom level.
```ruby
place = {lat: 49.38237278700955, lon: 8.61328125}
SimpleMercatorLocation.new(place).at_zoom(11).to_px  # <= [274688, 179200]
```


### Convert lat/lon to Google World coordinates
Google assumes his "world tile" to show the whole wold in one tile with the size of 256x256px. 
So the [world coordinates](https://developers.google.com/maps/documentation/javascript/examples/map-coordinates) 
are the latitude and longitude coordinates mapped to this world tile. Whereby the origin of googles world coordinate system resides in the center. 
```ruby
place = {lon: -87.65005229999997, lat: 41.850033}
SimpleMercatorLocation.new(place).to_w  # <= [65.67107392000001, 95.1748950436046]
```


### Convert lat/lon to meters
```ruby
place = {lon: 12.12890625, lat: 48.22467264956519}
SimpleMercatorLocation.new(place).to_m  # <= [1350183.66762935, 6144314.08167561]
```

