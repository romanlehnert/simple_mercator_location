class SimpleMercatorLocation

    attr_accessor :lat_deg, :lon_deg, :zoom

    def initialize(*args)
        @zoom = 2
        @lat_deg = 0
        @lon_deg = 0

        if args.first.is_a?(Hash)
            @lat_deg = args.first[:lat] if args.first.has_key?(:lat)
            @lon_deg = args.first[:lon] if args.first.has_key?(:lon)
            @zoom = args.first[:zoom] if args.first.has_key?(:zoom)
        end
    end 


    # latitude in radiants
    def lat_rad
      shift_to_rad * lat_deg
    end


    # longitude in radiants
    def lon_rad
      shift_to_rad * lon_deg
    end


    # factor for scaling to radiants
    def shift_to_rad
      Rational(Math::PI, 180)
    end


    # factor for scaling to degrees
    def shift_to_deg
      Rational(180.0, Math::PI)
    end


    # size of our tiles
    def tile_size
      256
    end


    # earth radius in meters
    def earth_radius 
      6378137
    end


    # set the zoom-level and returns self
    def zoom_at(scale)
        @zoom = scale
        self
    end


    # origin of google map lieves on top-left. For getting pixels,
    # we assume displaying the earh an zoomm-level 0 and a square tile
    # of tile_size * tile_size pixels. The origin of our wsg84 system
    # (lat, lon = (0,0) sits and (128,128)px. 
    def origin_px
      [tile_size / 2, tile_size / 2]
    end


    # return the pixels per degree
    def pixel_per_degree
      Rational(tile_size, 360)
    end


    # return the pixels per radiant
    def pixel_per_rad
      tile_size / (2 * Math::PI) # tile_size / (360 * shift_to_rad)
    end

    
    # scale the latitude via mercator projections
    # see http://en.wikipedia.org/wiki/Mercator_projection#Derivation_of_the_Mercator_projection
    # return the scaled latitude as radiant
    def lat_scaled_rad
      Math.log( Math.tan( Rational(Math::PI,4) + Rational(lat_rad,2) )) 
    end


    # returns the scaled latitude as degrees
    def lat_scaled_deg
      lat_scaled_rad * shift_to_deg
    end


    # returns the mercotors meters count for the location
    def to_m
        mx = earth_radius * lon_rad
        my = earth_radius * lat_scaled_rad

        my = (my.round(8) == 0)? 0 : my

        [mx.to_f, my.to_f]
    end


    # calculates the google world-coordinates as described here:
    # https://developers.google.com/maps/documentation/javascript/examples/map-coordinates
    def to_w
      px = origin_px.first +  pixel_per_rad * lon_rad
      py = origin_px.last  -  pixel_per_rad * lat_scaled_rad

      return [px, py]
    end


    # returns the pixel coordinates at the given zoom level
    def to_px
      tiles_count = 2**zoom
      wx,wy = self.to_w
      px = wx * tiles_count
      py = wy * tiles_count
      return [px.to_i, py.to_i]
    end


    # calculates the tile numbers for google maps at the given zoom level
    def to_tile
      px,py = self.to_px

      tx = Rational(px, tile_size).to_i
      ty = Rational(py, tile_size).to_i

      return [tx,ty]
    end

end
